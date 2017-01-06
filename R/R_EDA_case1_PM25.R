## R_EDA_part1 dplyr case1 pm2.5 ##
## 20170106                      ##
## 三重站資料                    ##

library(tidyverse)
library(readxl)
library(dplyr)

df = read_excel('104_20160323.xls')
#head(df)
df_long = df %>% gather(attribute, value, `00`:`23.000000`)
#head(df_long)
colnames(df_long) = c('date', 'stop', 'var1', 'var2', 'value')
df_spead = spread(df_long, var1, value)
View(df_spead)

#一年之中PM2.5最高的是哪一天
df_spead %>% 
  group_by(date) %>% 
  summarise(pm2.5mean = mean(as.numeric(PM2.5), na.rm =TRUE)) %>% 
  arrange(desc(pm2.5mean))

#一天之中PM2.5最高的是哪一個小時
df_spead %>% 
  group_by(var2) %>% 
  summarise(pm2.5mean = mean(as.numeric(PM2.5), na.rm =TRUE)) %>% 
  arrange(desc(pm2.5mean)) %>% 
  View()
