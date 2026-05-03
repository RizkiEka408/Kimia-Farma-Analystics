WITH dashboard AS (
  select 
    ft.transaction_id, 
    ft.date, 
    kc.branch_id, 
    kc.branch_name, 
    kc.kota,
    kc.provinsi, 
    kc.rating as rating_cabang, 
    ft.customer_name,
    p.product_id, 
    p.product_name,
    p.price as actual_price, 
    ft.discount_percentage, 
    ft.rating as rating_transaksi
    from kimia_farma.kf_final_transaction ft
    left join kimia_farma.kf_kantor_cabang kc on ft.branch_id = kc.branch_id
    left join kimia_farma.kf_product p on ft.product_id = p.product_id
),

calculated as(
  select 
    *,
    case 
      when actual_price <= 50000 then 0.10
      when actual_price <= 100000 then 0.15
      when actual_price <= 300000 then 0.20
      when actual_price <= 500000 then 0.25
      else 0.30
      END AS presentase_gross_laba,

    --nett_sales  
    ROUND(actual_price - (actual_price * discount_percentage / 100.0 ),2) AS nett_sales

    FROM dashboard
)

select  *,

  --nett_profit
  ROUND(nett_sales * presentase_gross_laba, 2) AS nett_profit
FROM calculated
