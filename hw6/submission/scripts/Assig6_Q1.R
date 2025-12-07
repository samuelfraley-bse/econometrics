# Assignment 6 - Question 1
### Daniel Campos, Èric Gutiérrez & Samuel Fraley

library(tidyverse)
data <- read_csv("../data/ps1_q1.csv")

# -----------------------------
# Question 1.1
# -----------------------------

## Create the baseline subset of the data
baseline <- data %>% filter(time == 1)

## Panel A. Teacher attendance (all baseline schools included)
panel_1a <- baseline %>% group_by(treat) %>%
  summarise(
    mean_teacher_attendance_baseline = mean(teacher_attendance, na.rm = TRUE),
    se_teacher_attendance_baseline = sd(teacher_attendance, na.rm = TRUE) / sqrt(n()),
    n_teachers_baseline = n()
  )
diff_teacher_attendance_baseline <- panel_1a$mean_teacher_attendance_baseline[panel_1a$treat == 1] - 
  panel_1a$mean_teacher_attendance_baseline[panel_1a$treat == 0]
se_diff_teacher_attendance_baseline <- sqrt((panel_1a$se_teacher_attendance_baseline[panel_1a$treat == 0])^2 + 
  (panel_1a$se_teacher_attendance_baseline[panel_1a$treat == 1])^2)

print(panel_1a)
diff_teacher_attendance_baseline
se_diff_teacher_attendance_baseline

### Carry out a t-test to check the significance of the difference
t_teacher_attendance <- t.test(teacher_attendance ~ treat, data = baseline)

t_teacher_attendance

## Panel B. Student participation (only for open schools at baseline, teacher_attendance = 1)
panel_1b <- baseline %>%
  filter(teacher_attendance == 1) %>% 
  group_by(treat) %>%
  summarise(
    mean_students_baseline = mean(students, na.rm = TRUE),
    se_students_baseline = sd(students, na.rm = TRUE) / sqrt(n()),
    n_students_baseline = n()
  )
diff_students_baseline <- panel_1b$mean_students_baseline[panel_1b$treat == 1] - 
  panel_1b$mean_students_baseline[panel_1b$treat == 0]
se_diff_students_baseline <- sqrt((panel_1b$se_students_baseline[panel_1b$treat == 0])^2 + 
  (panel_1b$se_students_baseline[panel_1b$treat == 1])^2)

print(panel_1b)
diff_students_baseline
se_diff_students_baseline

### Carry out a t-test to check the significance of the difference
t_students <- t.test(students ~ treat, data = subset(baseline, teacher_attendance == 1))

t_students

# -----------------------------
# Question 1.2
# -----------------------------

## Create the post program start subset of the data
post <- data %>% filter(time > 1)

## Panel A. All teachers
panel_2a <- post %>% group_by(treat) %>%
  summarise(
    mean_teacher_attendance_post = mean(teacher_attendance, na.rm = TRUE),
    se_teacher_attendance_post = sd(teacher_attendance, na.rm = TRUE) / sqrt(n()),
    n_teachers_post = n()
  )
diff_teacher_attendance_post <- panel_2a$mean_teacher_attendance_post[panel_2a$treat == 1] - 
  panel_2a$mean_teacher_attendance_post[panel_2a$treat == 0]
se_diff_teacher_attendance_post <- sqrt((panel_2a$se_teacher_attendance_post[panel_2a$treat == 0])^2 + 
  (panel_2a$se_teacher_attendance_post[panel_2a$treat == 1])^2)
  
print(panel_2a)
diff_teacher_attendance_post
se_diff_teacher_attendance_post

## Build the model to confirm the estimation the treatment effect
treatment_model <- lm(teacher_attendance ~ treat, data = post)

summary(treatment_model)