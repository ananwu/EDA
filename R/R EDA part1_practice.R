# 來源：R語言翻轉教室
# http://datascienceandr.org/note/02-RDataEngineer-05-Data-Manipulation.html

install.packages("nycflights13")
install.packages("dplyr")
library(nycflights13) 
library(dplyr)

# filter
filter(flights, month == 1, day == 1)    # filter會自動過濾掉結果為NA的條件
filter(flights, month == 1 | month == 2) # & vs |

# filter：請問在2013年共有多少班次的飛機起飛有延誤？
target <- filter(flights, dep_delay > 0)
nrow(target)
## pipeline refactor
flights %>% filter(dep_delay > 0) %>% nrow()

# filter：請找出所有編號為"AA"的飛機？
target <- filter(flights,grepl(pattern="AA",x=tailnum,fixed=TRUE))
distinct(target, tailnum)
## pipeline refactor
flights %>% filter(grepl(pattern="AA",x=tailnum,fixed=TRUE)) %>% distinct(tailnum)

# arrange：請將資料依據year, month, day依據比較排序
flights %>% arrange(year, month, day)

# arrange：2013年到達時間delay最久的是哪一班
flights %>% arrange(desc(dep_delay))

# summarise：平均的delay時間
flights %>% summarise(delay = mean(dep_delay, na.rm = TRUE))

# group_by + summarise：平均每月的delay時間
flights %>% group_by(month) %>% summarise(delay = mean(dep_delay, na.rm = TRUE))

# filter & group_by + summarise
# 請選出dep_time = NA的資料(停飛?)，並找出哪一天停飛最多
flights %>% 
  filter(is.na(dep_time)) %>% 
  group_by(month, day) %>% 
  summarise(rows = n()) %>% 
  arrange(desc(rows))

# mutate：需存下欄位
target <- flights %>% mutate(gain = arr_delay - dep_delay) 

# 用dplyr改寫以下SQL語法 
# select count(*)
# from (
#   select month, day, count(*)
#   from table a
#   where month <'12'
#   group by month, day
#   having count(*)>3
# )
#
# ctrl + shift + c

flights %>% 
  filter(month < 13) %>% 
  group_by(month, day) %>% 
  summarise(rows = n()) %>% 
  filter(rows>3) %>% 
  nrow()
