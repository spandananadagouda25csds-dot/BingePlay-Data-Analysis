USE bingeplay;

SELECT 'users' AS table_name, COUNT(*) AS total_records
FROM users

UNION ALL

SELECT 'subscriptions', COUNT(*)
FROM subscriptions

UNION ALL

SELECT 'shows', COUNT(*)
FROM shows

UNION ALL

SELECT 'watch_sessions', COUNT(*)
FROM watch_sessions

UNION ALL

SELECT 'ratings', COUNT(*)
FROM ratings;
USE bingeplay;

-- =====================================================
-- Q1: ACTIVE REVENUE
-- Objective: Calculate active subscriptions and total
-- monthly recurring revenue as of 30 June 2024.
-- =====================================================

SELECT
    COUNT(*) AS active_subscriptions,
    SUM(monthly_price_inr) AS total_monthly_revenue
FROM subscriptions
WHERE status = 'active'
  AND (
        end_date IS NULL
        OR end_date > '2024-06-30'
      );
      -- =====================================================
-- Q2: SIGNUP MOMENTUM
-- Objective: Calculate the number of new user signups
-- for each calendar month from January to June 2024.
-- Also identify the month with the highest signups.
-- =====================================================

USE bingeplay;

SELECT
    MONTHNAME(signup_date) AS month,
    COUNT(*) AS signup_count
FROM users
WHERE signup_date >= '2024-01-01'
  AND signup_date < '2024-07-01'
GROUP BY
    MONTH(signup_date),
    MONTHNAME(signup_date)
ORDER BY
    MONTH(signup_date);
-- =========================================================
-- Q3: DEVICE ANALYTICS
-- Objective: Analyse streaming activity across different
-- device types used by BingePlay subscribers.
--
-- Metrics:
-- 1. Total number of sessions.
-- 2. Total watch minutes across all sessions.
-- 3. Average watch minutes per session.
-- 4. Completion rate (percentage of completed sessions).
--
-- Note: Exclude sessions with NULL user_id.
-- Completion rate must be rounded to 2 decimal places.
-- =========================================================

SELECT
    device_type,
    COUNT(*) AS total_sessions,
    SUM(watch_minutes) AS total_watch_minutes,
    AVG(watch_minutes) AS avg_watch_minutes,
    ROUND(
        SUM(CASE
                WHEN completed = 1 THEN 1
                ELSE 0
            END) * 100.0 / COUNT(*),
        2
    ) AS completion_rate
FROM watch_sessions
WHERE user_id IS NOT NULL
GROUP BY device_type
ORDER BY device_type;
-- =========================================================
-- Q4: RATING DISTRIBUTION
-- Objective: Analyse the distribution of user ratings
-- across all five star values.
--
-- Metrics:
-- 1. Count of ratings for each star value (1 to 5).
-- 2. Percentage of ratings for each star value.
-- 3. Overall percentage of 4-star and 5-star ratings.
--
-- All percentages are rounded to 2 decimal places.
-- =========================================================

WITH rating_distribution AS
(
    SELECT
        stars,
        COUNT(*) AS rating_count
    FROM ratings
    GROUP BY stars
),

rating_summary AS
(
    SELECT
        COUNT(*) AS total_ratings,
        SUM(
            CASE
                WHEN stars IN (4, 5) THEN 1
                ELSE 0
            END
        ) AS high_ratings
    FROM ratings
)

SELECT
    rd.stars,
    rd.rating_count,

    ROUND(
        rd.rating_count * 100.0 / rs.total_ratings,
        2
    ) AS rating_percentage,

    ROUND(
        rs.high_ratings * 100.0 / rs.total_ratings,
        2
    ) AS four_or_five_star_percentage

FROM rating_distribution rd
CROSS JOIN rating_summary rs

ORDER BY rd.stars;
-- =========================================================
-- Q5: ORIGINALS VS ACQUIRED CONTENT
-- Objective: Compare BingePlay Originals with acquired
-- content based on show count, IMDb ratings and release year.
--
-- Metrics:
-- 1. Number of shows in each content group.
-- 2. Average IMDb rating (rounded to 2 decimal places).
-- 3. Average release year.
--
-- Business Goal:
-- Identify which content category performs better
-- in terms of audience ratings.
-- =========================================================

USE bingeplay;

SELECT
    CASE
        WHEN is_original = 1 THEN 'BingePlay Originals'
        WHEN is_original = 0 THEN 'Acquired Content'
    END AS content_type,

    COUNT(*) AS total_shows,

    ROUND(AVG(imdb_rating), 2) AS avg_imdb_rating,

    ROUND(AVG(release_year), 2) AS avg_release_year

FROM shows

GROUP BY is_original

ORDER BY is_original DESC;
USE bingeplay;

-- =====================================================
-- Q6: BINGE DAY DETECTION
-- =====================================================

-- Step 1: Identify binge days for each user and show.
-- A binge day requires 5 or more sessions of the
-- same show by the same user on the same date.

WITH binge_days AS
(
    SELECT
        user_id,
        show_id,
        session_date,
        COUNT(*) AS session_count

    FROM watch_sessions

    WHERE user_id IS NOT NULL
      AND session_date >= '2024-04-01'
      AND session_date < '2024-07-01'

    GROUP BY
        user_id,
        show_id,
        session_date

    HAVING COUNT(*) >= 5
),

-- Step 2: Count binge days for each user.

user_binge_counts AS
(
    SELECT
        user_id,
        COUNT(*) AS binge_day_count

    FROM binge_days

    GROUP BY user_id
),

-- Step 3: Rank users based on their binge days.

ranked_users AS
(
    SELECT
        user_id,
        binge_day_count,

        ROW_NUMBER() OVER (
            ORDER BY binge_day_count DESC, user_id
        ) AS user_rank

    FROM user_binge_counts
)

-- Step 4: Display total binge days and the top user.

SELECT
    (SELECT COUNT(*) FROM binge_days)
        AS total_binge_days,

    user_id AS top_user_id,

    binge_day_count AS highest_binge_days

FROM ranked_users

WHERE user_rank = 1;
USE bingeplay;

-- =====================================================
-- Q7: Q1 SIGNUPS WHO NEVER WATCHED (THE NULL TRAP)
-- =====================================================

-- Identify users who signed up in Q1 2024
-- and determine how many never watched anything.

SELECT
    COUNT(*) AS total_q1_signups,

    SUM(
        CASE
            WHEN NOT EXISTS
            (
                SELECT 1
                FROM watch_sessions ws
                WHERE ws.user_id = u.user_id
            )
            THEN 1
            ELSE 0
        END
    ) AS never_watched_users

FROM users u

WHERE u.signup_date >= '2024-01-01'
  AND u.signup_date < '2024-04-01';
  -- =====================================================
-- Q8: THE OVER-PAYING PREMIUM/FAMILY USERS
-- =====================================================

-- Step 1: Identify each user's most recent active
-- subscription as of 30 June 2024.

WITH ranked_subscriptions AS
(
    SELECT
        user_id,
        `plan`,
        start_date,

        ROW_NUMBER() OVER (
            PARTITION BY user_id
            ORDER BY start_date DESC, subscription_id DESC
        ) AS rn

    FROM subscriptions

    WHERE status = 'active'
      AND start_date <= '2024-06-30'
      AND (
            end_date IS NULL
            OR end_date > '2024-06-30'
          )
),

-- Step 2: Select users whose current plan is
-- Premium or Family.

premium_family_users AS
(
    SELECT
        user_id,
        `plan` AS current_plan

    FROM ranked_subscriptions

    WHERE rn = 1
      AND `plan` IN ('Premium', 'Family')
)

-- Step 3: Find users who have watched at least one show
-- but have never watched a Premium/Family-tier show.

SELECT
    COUNT(*) AS overpaying_users

FROM premium_family_users p

WHERE EXISTS
(
    SELECT 1
    FROM watch_sessions ws
    WHERE ws.user_id = p.user_id
)

AND NOT EXISTS
(
    SELECT 1
    FROM watch_sessions ws

    JOIN shows sh
        ON ws.show_id = sh.show_id

    WHERE ws.user_id = p.user_id
      AND sh.min_plan IN ('Premium', 'Family')
);
-- =====================================================
-- Q9: UPGRADE SUCCESS COHORT
-- =====================================================

-- Step 1: Identify the earliest subscription of
-- each user.

WITH ranked_subscriptions AS
(
    SELECT
        user_id,
        `plan`,
        start_date,

        ROW_NUMBER() OVER (
            PARTITION BY user_id
            ORDER BY start_date, subscription_id
        ) AS rn

    FROM subscriptions
),

-- Step 2: Identify users who started with Basic.

basic_users AS
(
    SELECT
        user_id,
        start_date AS first_subscription_date

    FROM ranked_subscriptions

    WHERE rn = 1
      AND `plan` = 'Basic'
),

-- Step 3: Find each user's first subsequent
-- upgrade to Premium or Family.

first_upgrades AS
(
    SELECT
        b.user_id,
        MIN(s.start_date) AS first_upgrade_date

    FROM basic_users b

    JOIN subscriptions s
        ON b.user_id = s.user_id

    WHERE s.`plan` IN ('Premium', 'Family')
      AND s.start_date > b.first_subscription_date

    GROUP BY b.user_id
),

-- Step 4: Identify users who are still active
-- as of 30 June 2024.

active_users AS
(
    SELECT DISTINCT
        user_id

    FROM subscriptions

    WHERE status = 'active'
      AND start_date <= '2024-06-30'
      AND (
            end_date IS NULL
            OR end_date > '2024-06-30'
          )
)

-- Step 5: Calculate the upgrade success metrics.

SELECT
    COUNT(*) AS upgraded_users,

    ROUND(
        AVG(
            DATEDIFF(
                f.first_upgrade_date,
                u.signup_date
            )
        ),
        2
    ) AS avg_days_to_upgrade

FROM users u

JOIN basic_users b
    ON u.user_id = b.user_id

JOIN first_upgrades f
    ON u.user_id = f.user_id

JOIN active_users a
    ON u.user_id = a.user_id

WHERE YEAR(u.signup_date) = 2024
  AND MONTH(u.signup_date) = 1;
  

/* =========================================================
   Q10 - CLIFFHANGER COMEBACKS
   Objective:
   Identify users who return to watch the same show
   within 1 to 7 days after an incomplete session.
   ========================================================= */

-- Step 1: Identify unique cliffhanger comeback events

WITH comeback_events AS
(
    SELECT DISTINCT
        ws1.user_id,
        ws1.show_id,
        ws1.session_date AS incomplete_date

    FROM watch_sessions ws1

    WHERE ws1.completed = 0
      AND ws1.user_id IS NOT NULL

      -- Check whether the same user watches
      -- the same show again within 1 to 7 days

      AND EXISTS
      (
          SELECT 1
          FROM watch_sessions ws2

          WHERE ws2.user_id = ws1.user_id
            AND ws2.show_id = ws1.show_id

            AND ws2.session_date BETWEEN
                DATE_ADD(ws1.session_date, INTERVAL 1 DAY)
                AND DATE_ADD(ws1.session_date, INTERVAL 7 DAY)
      )
),

-- Step 2: Count comeback events for each show

show_comebacks AS
(
    SELECT
        show_id,
        COUNT(*) AS comeback_events

    FROM comeback_events

    GROUP BY show_id
),

-- Step 3: Calculate the total number of comeback events

total_comebacks AS
(
    SELECT
        COUNT(*) AS total_events

    FROM comeback_events
)

-- Step 4: Display the total events and
-- the show generating the maximum comebacks

SELECT
    tc.total_events,
    sc.show_id,
    s.title,
    sc.comeback_events

FROM show_comebacks sc

JOIN shows s
    ON sc.show_id = s.show_id

CROSS JOIN total_comebacks tc

WHERE sc.comeback_events =
(
    SELECT MAX(comeback_events)
    FROM show_comebacks
);
/* ============================================================
   Q11 - CONSECUTIVE-WEEK ENGAGEMENT

   Objective:
   Find users who watched at least one session in
   FOUR or more consecutive calendar weeks.

   Deliverables:
   1. Number of users with 4+ consecutive weeks.
   2. Longest streak in weeks.
   3. One user_id with the longest streak.

   Technique:
   Gaps and Islands using ROW_NUMBER().
   ISO weeks begin on Monday.
   ============================================================ */

-- Step 1: Identify distinct weekly activity for each user
WITH weekly_activity AS
(
    SELECT DISTINCT
        user_id,

        DATE_SUB(
            session_date,
            INTERVAL WEEKDAY(session_date) DAY
        ) AS week_start

    FROM watch_sessions

    WHERE user_id IS NOT NULL
),

-- Step 2: Assign row numbers to weekly activity
numbered_weeks AS
(
    SELECT
        user_id,
        week_start,

        ROW_NUMBER() OVER (
            PARTITION BY user_id
            ORDER BY week_start
        ) AS week_row_number,

        TO_DAYS(week_start) DIV 7 AS week_ordinal

    FROM weekly_activity
),

-- Step 3: Identify consecutive-week groups
streak_groups AS
(
    SELECT
        user_id,

        week_ordinal - week_row_number AS streak_group,

        COUNT(*) AS streak_length

    FROM numbered_weeks

    GROUP BY
        user_id,
        week_ordinal - week_row_number
),

-- Step 4: Count users with at least four consecutive weeks
qualifying_users AS
(
    SELECT
        COUNT(DISTINCT user_id) AS users_with_4_plus_weeks

    FROM streak_groups

    WHERE streak_length >= 4
),

-- Step 5: Identify the longest streak across all users
top_streak AS
(
    SELECT
        user_id,
        streak_length

    FROM streak_groups

    ORDER BY
        streak_length DESC,
        user_id

    LIMIT 1
)

-- Step 6: Display final results
SELECT
    qu.users_with_4_plus_weeks,

    ts.streak_length AS longest_streak_weeks,

    ts.user_id AS user_with_longest_streak

FROM qualifying_users qu

LEFT JOIN top_streak ts
    ON 1 = 1;
/* ============================================================
   Q12 - CHURN SIGNAL DETECTION

   Objective:
   Identify users whose June 2024 watch time decreased
   by 50% or more compared with May 2024.

   Deliverables:
   1. User ID
   2. User Name
   3. May 2024 watch minutes
   4. June 2024 watch minutes
   5. Percentage drop
   6. Total number of churn-signal users

   ============================================================ */

-- Step 1: Calculate monthly watch minutes for each user

WITH monthly_watch AS
(
    SELECT
        user_id,

        SUM(
            CASE
                WHEN session_date >= '2024-05-01'
                 AND session_date < '2024-06-01'
                THEN watch_minutes
                ELSE 0
            END
        ) AS may_watch_minutes,

        SUM(
            CASE
                WHEN session_date >= '2024-06-01'
                 AND session_date < '2024-07-01'
                THEN watch_minutes
                ELSE 0
            END
        ) AS june_watch_minutes

    FROM watch_sessions

    WHERE session_date >= '2024-05-01'
      AND session_date < '2024-07-01'
      AND user_id IS NOT NULL

    GROUP BY user_id
),

-- Step 2: Identify users with a 50% or greater decrease

churn_signals AS
(
    SELECT
        user_id,
        may_watch_minutes,
        june_watch_minutes,

        ROUND(
            (
                (may_watch_minutes - june_watch_minutes)
                / may_watch_minutes
            ) * 100,
            2
        ) AS drop_percentage

    FROM monthly_watch

    WHERE may_watch_minutes > 0
      AND june_watch_minutes <= may_watch_minutes * 0.50
)

-- Step 3: Retrieve user details and calculate total users

SELECT
    cs.user_id,
    u.name AS user_name,
    cs.may_watch_minutes,
    cs.june_watch_minutes,
    cs.drop_percentage,

    COUNT(*) OVER() AS total_churn_signal_users

FROM churn_signals cs

INNER JOIN users u
    ON cs.user_id = u.user_id

ORDER BY
    cs.drop_percentage DESC;