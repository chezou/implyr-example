# install.packages(c("implyr", "odbc", "DBI", "dplyr", "ggplot2", "ggExtra"))

library(implyr)
library(odbc)
drv <- odbc::odbc()
impala <- src_impala(
  drv = drv,
  dsn = "Impala"
)

library(DBI)
# Change database
dbGetQuery(impala, "use u_ariga")
dbGetQuery(impala, "show tables")
airports <- tbl(impala, "airports_pq")
airports %>% filter(latitude < 35) %>% count()

airports_by_geo <- airports %>% select(longitude, latitude) %>% collect()

library(ggplot2)

p <- ggplot(airports_by_geo, aes(longitude, latitude)) + geom_point() + theme_classic()
ggExtra::ggMarginal(p, type = "histogram")
