# nolint start
inputs_data_sample <- list(
  "age_sex" = tibble::tribble(
    ~provider , ~strategy , ~fyear ,
    "R00"     , "a"       ,      1 ,
    "R00"     , "a"       ,      2 ,
    "R00"     , "b"       ,      1 ,
    "R00"     , "b"       ,      2 ,
    "R01"     , "a"       ,      1 ,
    "R01"     , "a"       ,      2 ,
    "R01"     , "b"       ,      1 ,
    "R01"     , "b"       ,      2 ,
  ),
  "diagnoses" = "diagnoses",
  "procedures" = "procedures",
  "rates" = tibble::tribble(
    ~fyear , ~provider  , ~strategy    , ~crude_rate , ~std_rate ,
    202223 , "a"        , "Strategy A" ,           1 ,         2 ,
    202223 , "b"        , "Strategy A" ,           3 ,         4 ,
    202223 , "national" , "Strategy A" ,           5 ,         6 ,
    202324 , "A"        , "Strategy A" ,           7 ,         8 ,
    202324 , "B"        , "Strategy A" ,           9 ,        10 ,
    202324 , "national" , "Strategy A" ,          10 ,        12 ,

    202223 , "a"        , "Strategy B" ,           2 ,         1 ,
    202223 , "b"        , "Strategy B" ,           4 ,         3 ,
    202223 , "national" , "Strategy B" ,           6 ,         5 ,
    202324 , "A"        , "Strategy B" ,           8 ,         7 ,
    202324 , "B"        , "Strategy B" ,          10 ,         9 ,
    202324 , "national" , "Strategy B" ,          12 ,        11
  )
)
# nolint end
