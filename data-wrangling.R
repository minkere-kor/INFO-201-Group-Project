library(tidyverse)
unclean <- read_delim("absenteeism.csv") 

colnames(unclean)[2] = "Reason_for_absence"
colnames(unclean)[3] = "Month_of_absence"
colnames(unclean)[4] = "Day_of_the_week"
colnames(unclean)[6] = "Transportation_expense"
colnames(unclean)[7] = "Distance_from_Residence_to_Work"
colnames(unclean)[8] = "Service_time"
colnames(unclean)[10] = "Work_load_Average/day"
colnames(unclean)[11] = "Hit_target"
colnames(unclean)[12] = "Disciplinary_failure"
colnames(unclean)[20] = "Body_mass_index"
colnames(unclean)[21] = "Absenteeism_time_in_hours"

absent <- unclean %>% 
  mutate(Reason_for_absence = as.character(Reason_for_absence)) %>%
  mutate(Reason_for_absence = replace(Reason_for_absence, Reason_for_absence == "0", "")) %>%
  mutate(Reason_for_absence = replace(Reason_for_absence, Reason_for_absence == "1", "Certain infectious and parasitic diseases")) %>% 
  mutate(Reason_for_absence = replace(Reason_for_absence, Reason_for_absence == "2", "Neoplasms")) %>% 
  mutate(Reason_for_absence = replace(Reason_for_absence, Reason_for_absence == "3", "Diseases of the blood and blood-forming organs and certain disorders involving the immune mechanism")) %>%
  mutate(Reason_for_absence = replace(Reason_for_absence, Reason_for_absence == "4", "Endocrine, nutritional and metabolic diseases")) %>%
  mutate(Reason_for_absence = replace(Reason_for_absence, Reason_for_absence == "5", "Mental and behavioural disorders")) %>%
  mutate(Reason_for_absence = replace(Reason_for_absence, Reason_for_absence == "6", "Diseases of the nervous system")) %>%
  mutate(Reason_for_absence = replace(Reason_for_absence, Reason_for_absence == "7", "Diseases of the eye and adnexa")) %>%
  mutate(Reason_for_absence = replace(Reason_for_absence, Reason_for_absence == "8", "Diseases of the ear and mastoid process")) %>%
  mutate(Reason_for_absence = replace(Reason_for_absence, Reason_for_absence == "9", "Diseases of the circulatory system")) %>%
  mutate(Reason_for_absence = replace(Reason_for_absence, Reason_for_absence == "10", "Diseases of the respiratory system")) %>%
  mutate(Reason_for_absence = replace(Reason_for_absence, Reason_for_absence == "11", "Diseases of the digestive system")) %>%
  mutate(Reason_for_absence = replace(Reason_for_absence, Reason_for_absence == "12", "Diseases of the skin and subcutaneous tissue")) %>%
  mutate(Reason_for_absence = replace(Reason_for_absence, Reason_for_absence == "13", "Diseases of the musculoskeletal system and connective tissue")) %>%
  mutate(Reason_for_absence = replace(Reason_for_absence, Reason_for_absence == "14", "Diseases of the genitourinary system")) %>%
  mutate(Reason_for_absence = replace(Reason_for_absence, Reason_for_absence == "15", "Pregnancy, childbirth and the puerperium")) %>%
  mutate(Reason_for_absence = replace(Reason_for_absence, Reason_for_absence == "16", "Certain conditions originating in the perinatal")) %>%
  mutate(Reason_for_absence = replace(Reason_for_absence, Reason_for_absence == "17", "Congenital malformations, deformations and chromosomal abnormalities")) %>%
  mutate(Reason_for_absence = replace(Reason_for_absence, Reason_for_absence == "18", "Symptoms, signs and abnormal clinical and laboratory findings, not elsewhere classified")) %>%
  mutate(Reason_for_absence = replace(Reason_for_absence, Reason_for_absence == "19", "Injury, poisoning and certain other consequences of external causes")) %>%
  mutate(Reason_for_absence = replace(Reason_for_absence, Reason_for_absence == "20", "External causes of morbidity and mortality")) %>%
  mutate(Reason_for_absence = replace(Reason_for_absence, Reason_for_absence == "21", "Factors infuencing health status and contact with health services")) %>%
  mutate(Reason_for_absence = replace(Reason_for_absence, Reason_for_absence == "22", "patient follow-up")) %>%
  mutate(Reason_for_absence = replace(Reason_for_absence, Reason_for_absence == "23", "medical consultation")) %>%
  mutate(Reason_for_absence = replace(Reason_for_absence, Reason_for_absence == "24", "blood donation")) %>%
  mutate(Reason_for_absence = replace(Reason_for_absence, Reason_for_absence == "25", "laboratory examination")) %>%
  mutate(Reason_for_absence = replace(Reason_for_absence, Reason_for_absence == "26", "unjustified absence")) %>% 
  mutate(Reason_for_absence = replace(Reason_for_absence, Reason_for_absence == "27", "physiotherapy")) %>%
  mutate(Reason_for_absence = replace(Reason_for_absence, Reason_for_absence == "28", "dental consultation")) %>% 
  
  mutate(Day_of_the_week = replace(Day_of_the_week, Day_of_the_week == "2", "Monday")) %>% 
  mutate(Day_of_the_week = replace(Day_of_the_week, Day_of_the_week == "3", "Tuesday")) %>%
  mutate(Day_of_the_week = replace(Day_of_the_week, Day_of_the_week == "4", "Wednesday")) %>%
  mutate(Day_of_the_week = replace(Day_of_the_week, Day_of_the_week == "5", "Thursday")) %>%
  mutate(Day_of_the_week = replace(Day_of_the_week, Day_of_the_week == "6", "Friday")) %>% 
  
  mutate(Education = replace(Education, Education == "1", "Highschool")) %>% 
  mutate(Education = replace(Education, Education == "2", "Graduate")) %>% 
  mutate(Education = replace(Education, Education == "3", "Post-Graduate")) %>% 
  mutate(Education = replace(Education, Education == "4", "Master and Doctor"))

write_csv(absent, "absenteeism.csv")