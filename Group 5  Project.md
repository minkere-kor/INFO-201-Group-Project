Minkyu Kim, Amanda Tang, Eugene Cheung

## Data Set Link
https://archive.ics.uci.edu/ml/datasets/Absenteeism+at+work#

## Target Audience
The target audience is the **company’s HR department**. Our data relates to employee statistics such as *absenteeism*, *transportation expenses*, and *number of hours worked*.


## What does your audience want to learn from your data?
Our audience wants to learn who are the *most productive employees* and *employees that are least costly.*
1) Do **higher** transportation costs/distance from work **increase** likelihood of absenteeism?
2)  Do social and personal factors such as **education**, having **children**, or having a **pet** contribute to the amount of **absences** that an employee has?
3) Do certain excuses of absences/personal factors (**education**, **children**, **social habits**) correlate with disciplinary action?
4) Do **health factors** contribute to the type of and amount of absences that an employee has?


## Data Wrangling
A lot of values are numerical, corresponding to some qualitative meaning. For example, reason for absence is numbered from 1–28, with different reasons for each value. We may need to link the numerical to their qualitative meaning if necessary.
What (major/new) libraries will be using in this project (no need to list common libraries that are used in many projects such as dplyr)
We will be using the tidyverse library.

## Questions to be Answered via Analysis
Which of the listed variables contribute the most to absenteeism in the workplace, or if any of the variables influence absenteeism.