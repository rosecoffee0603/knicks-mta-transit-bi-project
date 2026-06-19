-- ====================================================================
-- PHASE 2: BUSINESS INTELLIGENCE & INFRASTRUCTURE EVALUATION LAYER
-- ====================================================================

-- Query to evaluate if game blowouts vs close games alter infrastructure delay proxies
SELECT 
    kg.game_result AS game_outcome,
    -- Segment games by point differential intensity
    CASE 
        WHEN ABS(kg.knicks_score - kg.opponent_score) >= 15 THEN 'Blowout Game'
        ELSE 'Close Game'
    END AS game_intensity,
    -- Extract the average platform delay across all matching Penn Station lines
    AVG(mta.avg_additional_platform_time) AS average_commuter_delay_minutes
FROM knicks_games kg
INNER JOIN mta_transit_metrics mta 
    -- Link records by matching the target calendar month of the game
    ON DATE_FORMAT(kg.game_date, '%Y-%m') = mta.month_period
WHERE kg.venue = 'Home'
  -- Filter to aggregate only the specific lines servicing the MSG / Penn Station arena hub
  AND mta.subway_line IN ('1,2,3', 'A,C,E')
GROUP BY kg.game_result, game_intensity;
