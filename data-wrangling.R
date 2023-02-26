library(tidyverse)
unclean <- read_delim("data/Absenteeism_at_work.csv") 

colnames(unclean)[2] = "Reason"

absent <- unclean %>% 
  mutate(Reason = as.character(Reason)) %>%
  mutate(Reason = replace(Reason, Reason == "0", "")) %>%
  mutate(Reason = replace(Reason, Reason == "1", "Certain infectious and parasitic diseases")) %>% 
  mutate(Reason = replace(Reason, Reason == "2", "Neoplasms")) %>% 
  mutate(Reason = replace(Reason, Reason == "3", "Diseases of the blood and blood-forming organs and certain disorders involving the immune mechanism")) %>%
  mutate(Reason = replace(Reason, Reason == "4", "Endocrine, nutritional and metabolic diseases")) %>%
  mutate(Reason = replace(Reason, Reason == "5", "Mental and behavioural disorders")) %>%
  mutate(Reason = replace(Reason, Reason == "6", "Diseases of the nervous system")) %>%
  mutate(Reason = replace(Reason, Reason == "7", "Diseases of the eye and adnexa")) %>%
  mutate(Reason = replace(Reason, Reason == "8", "Diseases of the ear and mastoid process")) %>%
  mutate(Reason = replace(Reason, Reason == "9", "Diseases of the circulatory system")) %>%
  mutate(Reason = replace(Reason, Reason == "10", "Diseases of the respiratory system")) %>%
  mutate(Reason = replace(Reason, Reason == "11", "Diseases of the digestive system")) %>%
  mutate(Reason = replace(Reason, Reason == "12", "Diseases of the skin and subcutaneous tissue")) %>%
  mutate(Reason = replace(Reason, Reason == "13", "Diseases of the musculoskeletal system and connective tissue")) %>%
  mutate(Reason = replace(Reason, Reason == "14", "Diseases of the genitourinary system")) %>%
  mutate(Reason = replace(Reason, Reason == "15", "Pregnancy, childbirth and the puerperium")) %>%
  mutate(Reason = replace(Reason, Reason == "16", "Certain conditions originating in the perinatal")) %>%
  mutate(Reason = replace(Reason, Reason == "17", "Congenital malformations, deformations and chromosomal abnormalities")) %>%
  mutate(Reason = replace(Reason, Reason == "18", "Symptoms, signs and abnormal clinical and laboratory findings, not elsewhere classified")) %>%
  mutate(Reason = replace(Reason, Reason == "19", "Injury, poisoning and certain other consequences of external causes")) %>%
  mutate(Reason = replace(Reason, Reason == "20", "External causes of morbidity and mortality")) %>%
  mutate(Reason = replace(Reason, Reason == "21", "Factors infuencing health status and contact with health services")) %>%
  mutate(Reason = replace(Reason, Reason == "22", "patient follow-up")) %>%
  mutate(Reason = replace(Reason, Reason == "23", "medical consultation")) %>%
  mutate(Reason = replace(Reason, Reason == "24", "blood donation")) %>%
  mutate(Reason = replace(Reason, Reason == "25", "laboratory examination")) %>%
  mutate(Reason = replace(Reason, Reason == "26", "unjustified absence")) %>% 
  mutate(Reason = replace(Reason, Reason == "27", "physiotherapy")) %>%
  mutate(Reason = replace(Reason, Reason == "28", "dental consultation")) %>% 
  
  mutate(`Day of the week` = replace(`Day of the week`, `Day of the week` == "2", "Monday")) %>% 
  mutate(`Day of the week` = replace(`Day of the week`, `Day of the week` == "3", "Tuesday")) %>%
  mutate(`Day of the week` = replace(`Day of the week`, `Day of the week` == "4", "Wednesday")) %>%
  mutate(`Day of the week` = replace(`Day of the week`, `Day of the week` == "5", "Thursday")) %>%
  mutate(`Day of the week` = replace(`Day of the week`, `Day of the week` == "6", "Friday")) 

write_csv(absent, "data/absenteeism.csv")