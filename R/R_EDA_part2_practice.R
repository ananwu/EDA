library(ggplot2)
library(tidyr)
library(dplyr)

# two datasets for practice
# ?anscombe
head(anscombe)
head(mpg)

##--------------------------------------------------##
##case1_anscombe data
summary(tbl_df(anscombe))

#transform data
Xmatrix = gather(anscombe[,1:4])
colnames(Xmatrix) = c("x","value_x")
Ymatrix = gather(anscombe[,5:8])
colnames(Ymatrix) = c("y","value_y")
anscombe1 = bind_cols(Xmatrix ,Ymatrix)

#draw one by one
ggplot(data = anscombe) +
  geom_point(mapping = aes(x = x1, y=y1)) +
  geom_smooth(mapping = aes(x = x1, y=y1) , method = "lm", se=FALSE, formula = y ~ x)

ggplot(data = anscombe, aes(x = x2, y=y2)) +
  geom_point() +
  geom_smooth(method="lm", se=FALSE)

#draw together
#point distribution_wrap
ggplot(data = anscombe1, aes(x = value_x, y=value_y)) +
  geom_point() +
  geom_smooth(method="lm", se=FALSE) +
  facet_wrap(~x)

#point distribution_grid
ggplot(data = anscombe1, aes(x = value_x, y=value_y)) +
  geom_point() +
  geom_smooth(method="lm", se=FALSE) +
  facet_grid(~x)

#boxplot distribution_grid
anscombe1 %>% group_by(value_x) %>% 
  ggplot(aes(x = value_x, y=value_y)) +
  geom_boxplot()+
  facet_grid(~x)

#better way above
ggplot(anscombe1, aes(x = value_x, y=value_y)) +
  geom_boxplot()+
  facet_grid(~x)

#dotplot single value_all   
anscombe1 %>% 
  ggplot(aes(x = value_x)) +
  geom_dotplot()

#histogram single value_all   
anscombe1 %>% 
  ggplot(aes(x = value_x)) +
  geom_histogram()

#histogram single value_grid   
anscombe1 %>% group_by(value_x) %>% 
  ggplot(aes(x = value_x)) +
  geom_histogram()+
  facet_grid(~x)

##--------------------------------------------------##
##case2_mpg data
View(mpg)
str(mpg)

distinct(mpg, manufacturer) %>% View()
distinct(mpg, manufacturer, class)  %>% View()
distinct(mpg, manufacturer, model)  %>% View()

## single variable
# counts of every class?
ggplot(mpg)+
  geom_bar(aes(x=class))

# distribution of displ?
ggplot(mpg)+
  geom_dotplot(aes(x=displ, color = manufacturer))

## two variable
# mean hwy of every class
mpg %>% group_by(class) %>% 
  summarise(mean_hwy = mean(hwy)) %>% 
  ggplot() + 
  geom_bar(aes(x=reorder(class,-mean_hwy) , y=mean_hwy), stat="identity") #must add"identity"

# mean hwy of every manufacturer, model 
mpg %>% group_by(manufacturer, model) %>% 
  summarise(mean_hwy = mean(hwy)) %>%
  mutate(manufacturer_model = paste(manufacturer,"_",model)) %>% 
  ggplot() + 
  geom_bar(aes(x=reorder(manufacturer_model,-mean_hwy) , y=mean_hwy), stat="identity") + #must add"identity"
  theme(axis.text.x=element_text(angle=90, hjust=1))
  
# dspl vs hwy ?
ggplot(data = mpg) +
  geom_point(aes(x=displ , y=hwy, color=class)) + #alpha=class, shape=class 
  geom_smooth(aes(x=displ , y=hwy),method="lm")

# cyl vs hwy_point ?
ggplot(data = mpg) +
  geom_point(aes(x=cyl , y=hwy))  

# cyl vs hwy_boxplot ?
ggplot(mpg, aes(x=displ, y=hwy)) + geom_boxplot() + facet_grid(.~cyl)

# Displ vs hwy from class, drv, crl?
ggplot(mpg, aes(x=displ, y=hwy, color=drv)) + geom_point() + facet_grid(~class)
ggplot(mpg, aes(x=displ, y=hwy, color=drv)) + geom_point() + facet_grid(.~cyl)
ggplot(mpg, aes(x=displ, y=hwy, color=drv)) + geom_point() + facet_grid(drv~.)
ggplot(mpg, aes(x=displ, y=hwy, color=drv)) + geom_point() + facet_grid(drv~cyl)
  


