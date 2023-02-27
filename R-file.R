library(tidyverse)
absent <- read_delim("absenteeism.csv")

## Do higher transportation costs/distance from work is correlated with absenteeism?
absent %>% 
  group_by(ID) %>% 
  count(Reason_for_absence) %>% 
  summarize(total_absences = sum(n))
