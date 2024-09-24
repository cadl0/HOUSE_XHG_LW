WITH subs_by_month AS (
  SELECT
    country,
    EXTRACT(YEAR FROM subscription_date) AS year,
    EXTRACT(MONTH FROM subscription_date) AS month,
    
    
    COUNT(DISTINCT user_id) AS total_suscripciones,

    COUNT(CASE WHEN payment3x = 1 THEN 1 END) AS pago_payment3x,
    COUNT(CASE WHEN payment3 = 1 AND payment3x = 0 THEN 1 END) AS pago_payment3,
    COUNT(CASE WHEN payment2 = 1 AND payment3 = 0 AND payment3x = 0 THEN 1 END) AS pago_solo_payment2,
    COUNT(CASE WHEN payment2 = 0 AND payment3 = 0 AND payment3x = 0 THEN 1 END) AS sin_pagos_confirmados

  FROM
    `data-analytics-bootcamp-432314.home_exchange.subscriptions_USA_ESP_FRA`
  GROUP BY
    country, year, month
)

SELECT
  country,
  year,
  month,
  total_suscripciones,
  pago_payment3x,
  pago_payment3,
  pago_solo_payment2,
  sin_pagos_confirmados
FROM
  subs_by_month
QUALIFY
  ROW_NUMBER() OVER (PARTITION BY country ORDER BY total_suscripciones DESC) = 1
ORDER BY
  country
