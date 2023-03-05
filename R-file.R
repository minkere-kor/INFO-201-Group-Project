library(tidyverse)
absent <- read_delim("absenteeism.csv")

## Is there a relationship between distance to work (or transportation expenses) AND total number
## of absences?
total_abs <- absent %>% 
  group_by(ID) %>% 
  count(Reason_for_absence) %>% 
  summarize(total_absences = sum(n)) 

distance <- absent %>% 
  distinct(ID, Distance_from_Residence_to_Work)

absence_distance <- merge(distance, total_abs, by = "ID")

absence_distance %>% 
  ggplot(aes(Distance_from_Residence_to_Work, total_absences, col=factor(ID))) +
  geom_point() +
  labs(title="Distance to Work and Total Absences", x="Distance from Residence to Work", 
       y="Total Absences", col="Employee ID")


expense <- absent %>% 
  distinct(ID, Transportation_expense)

absence_expense <- merge(expense, total_abs)

absence_expense %>% 
  ggplot(aes(Transportation_expense, total_absences, col=factor(ID))) + 
  geom_point() +
  labs(title="Transportation Expenses and Total Absences", x="Transportation Expenses", 
       y="Total Absences", col="Employee ID")


## Do personal factors such as education, having children, or having a pet
## contribute to the amount of absences that an employee has?

absence_educational <- absent %>% 
  select(ID, Education) %>% 
  distinct(ID, Education) %>% 
  merge(total_abs, by = "ID")

absence_children <- absent %>% 
  select(ID, Son) %>% 
  distinct(ID, Son) %>% 
  merge(total_abs, by = "ID")

absence_pet <- absent %>% 
  select(ID, Pet) %>% 
  distinct(ID, Pet) %>% 
  merge(total_abs, by = "ID")

absence_educational %>% 
  ggplot(aes(Education, total_absences, fill=factor(ID))) +
  geom_col(width = 0.5)

absence_children %>% 
  ggplot(aes(Son, total_absences, fill=factor(ID))) +
  geom_col(width = 0.5)

absence_pet %>% 
  ggplot(aes(Pet, total_absences, fill=factor(ID))) +
  geom_col(width = 0.5)
