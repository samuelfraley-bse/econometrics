library(car)
library(xtable)

#Data for slide3(33)
n<- 35
set.seed(1234)
x2<-runif(n,0,30)
x3<-runif(n,0,30)
x4<-x3+rnorm(n,0,1)
y<-10+0.5*x2+0.5*x3+0.5*x4+rnorm(n,0,4)



# Q1A (i)####
fit <- lm(y ~ x2 + x3 + x4)

#regression output
print(summary(fit))

#95% CI
print(confint(fit, level = 0.95))

#here's a table to copy
cs <- coef(summary(fit))
ci <- confint(fit, level = 0.95)
out <- data.frame(Estimate = cs[, "Estimate"],
                  `Std. Error` = cs[, "Std. Error"],
                  `Lower` = ci[, 1],
                  `Upper` = ci[, 2])
print(round(out, 4))

# Generate LaTeX table
xtable_out <- xtable(out, digits = 4, 
                     caption = "Regression Results with 95\\% CI",
                     label = "tab:regression")

# Print to console
print(xtable_out, type = "latex", 
      caption.placement = "top",
      sanitize.text.function = function(x){x})

# OR save directly to file
sink("regression_table.tex")
print(xtable_out, type = "latex", caption.placement = "top")
sink()

#Q1Aii####
ci <- confint(fit, level = 0.95)
ci_x3 <- ci["x3", ]
ci_x4 <- ci["x4", ]

# Q1A (ii) - Confidence Ellipse
# Create the plot
confidenceEllipse(fit, which.coef = c("x3", "x4"), 
                  levels = 0.95,
                  main = "95% Confidence Region for β3 and β4",
                  xlab = "β3 (x3)",
                  ylab = "β4 (x4)",
                  col = "blue",
                  lwd = 2)

# Add the individual 95% CIs as a rectangle
# Vertical lines for x3 CI
abline(v = ci_x3[1], lty = 2, col = "red", lwd = 2)  # lower bound
abline(v = ci_x3[2], lty = 2, col = "red", lwd = 2)  # upper bound

# Horizontal lines for x4 CI
abline(h = ci_x4[1], lty = 2, col = "red", lwd = 2)  # lower bound
abline(h = ci_x4[2], lty = 2, col = "red", lwd = 2)  # upper bound

# Add point estimate
points(coef(fit)["x3"], coef(fit)["x4"], pch = 19, col = "black", cex = 1.5)

# Add origin (0,0) to show if it's in the confidence region
points(0, 0, pch = 4, col = "darkgreen", cex = 2, lwd = 2)

# Add legend
legend("topright", 
       legend = c("Joint 95% CR", "Individual 95% CIs", "Estimate", "H₀: β₃=β₄=0"),
       col = c("blue", "red", "black", "darkgreen"),
       lty = c(1, 2, NA, NA),
       pch = c(NA, NA, 19, 4),
       lwd = 2)


#Q1B####
n_large <- 3500
# Generate data with same DGP but larger sample
x2_large <- runif(n_large, 0, 30)
x3_large <- runif(n_large, 0, 30)
x4_large <- x3_large + rnorm(n_large, 0, 1)
y_large <- 10 + 0.5*x2_large + 0.5*x3_large + 0.5*x4_large + rnorm(n_large, 0, 4)

# Q1B (i) - Estimate the model
fit_large <- lm(y_large ~ x2_large + x3_large + x4_large)

# Create output table
cs_large <- coef(summary(fit_large))
ci_large <- confint(fit_large, level = 0.95)
out_large <- data.frame(Estimate = cs_large[, "Estimate"],
                        Std.Error = cs_large[, "Std. Error"],
                        Lower = ci_large[, 1],
                        Upper = ci_large[, 2])

cat("\n=== Part (b): Results with n = 3500 ===\n")
print(round(out_large, 4))

# Full summary
print(summary(fit_large))

# Generate LaTeX table for Part B
xtable_out_large <- xtable(out_large, digits = 4, 
                           caption = "Regression Results with 95\\% CI (n=3500)",
                           label = "tab:regression_large")
sink("regression_table_large.tex")
print(xtable_out_large, type = "latex", caption.placement = "top")
sink()

# Q1B (iii) - Confidence Ellipse for large n
confidenceEllipse(fit_large, which.coef = c("x3_large", "x4_large"), 
                  levels = 0.95,
                  main = "95% Confidence Region for β3 and β4 (n=3500)",
                  xlab = "β3 (x3)",
                  ylab = "β4 (x4)",
                  col = "blue",
                  lwd = 2)

# Add individual CIs
ci_x3_large <- ci_large["x3_large", ]
ci_x4_large <- ci_large["x4_large", ]

abline(v = ci_x3_large[1], lty = 2, col = "red", lwd = 2)
abline(v = ci_x3_large[2], lty = 2, col = "red", lwd = 2)
abline(h = ci_x4_large[1], lty = 2, col = "red", lwd = 2)
abline(h = ci_x4_large[2], lty = 2, col = "red", lwd = 2)

points(coef(fit_large)["x3_large"], coef(fit_large)["x4_large"], 
       pch = 19, col = "black", cex = 1.5)
points(0, 0, pch = 4, col = "darkgreen", cex = 2, lwd = 2)

legend("topright", 
       legend = c("Joint 95% CR", "Individual 95% CIs", "Estimate", "H₀: β₃=β₄=0"),
       col = c("blue", "red", "black", "darkgreen"),
       lty = c(1, 2, NA, NA),
       pch = c(NA, NA, 19, 4),
       lwd = 2)



#comparing to first
# Q1B - Side-by-side comparison plot
# Set up 1 row, 2 columns for plots
par(mfrow = c(1, 2))

# LEFT PLOT: n = 35
confidenceEllipse(fit, which.coef = c("x3", "x4"), 
                  levels = 0.95,
                  main = "n = 35",
                  xlab = "β3 (x3)",
                  ylab = "β4 (x4)",
                  col = "blue",
                  lwd = 2,
                  xlim = c(-1, 2),
                  ylim = c(-0.5, 2))

# Add individual CIs for n=35
abline(v = ci_x3[1], lty = 2, col = "red", lwd = 2)
abline(v = ci_x3[2], lty = 2, col = "red", lwd = 2)
abline(h = ci_x4[1], lty = 2, col = "red", lwd = 2)
abline(h = ci_x4[2], lty = 2, col = "red", lwd = 2)

# Add point estimate and origin
points(coef(fit)["x3"], coef(fit)["x4"], pch = 19, col = "black", cex = 1.5)
points(0, 0, pch = 4, col = "darkgreen", cex = 2, lwd = 2)

# Add true values
abline(h = 0.5, lty = 3, col = "purple", lwd = 1.5)
abline(v = 0.5, lty = 3, col = "purple", lwd = 1.5)

legend("topright", 
       legend = c("Joint 95% CR", "Individual CIs", "Estimate", "True β"),
       col = c("blue", "red", "black", "purple"),
       lty = c(1, 2, NA, 3),
       pch = c(NA, NA, 19, NA),
       lwd = c(2, 2, NA, 1.5),
       cex = 0.8)

# RIGHT PLOT: n = 3500
confidenceEllipse(fit_large, which.coef = c("x3_large", "x4_large"), 
                  levels = 0.95,
                  main = "n = 3500",
                  xlab = "β3 (x3)",
                  ylab = "β4 (x4)",
                  col = "blue",
                  lwd = 2,
                  xlim = c(-1, 2),
                  ylim = c(-0.5, 2))

# Add individual CIs for n=3500
abline(v = ci_x3_large[1], lty = 2, col = "red", lwd = 2)
abline(v = ci_x3_large[2], lty = 2, col = "red", lwd = 2)
abline(h = ci_x4_large[1], lty = 2, col = "red", lwd = 2)
abline(h = ci_x4_large[2], lty = 2, col = "red", lwd = 2)

# Add point estimate and origin
points(coef(fit_large)["x3_large"], coef(fit_large)["x4_large"], 
       pch = 19, col = "black", cex = 1.5)
points(0, 0, pch = 4, col = "darkgreen", cex = 2, lwd = 2)

# Add true values
abline(h = 0.5, lty = 3, col = "purple", lwd = 1.5)
abline(v = 0.5, lty = 3, col = "purple", lwd = 1.5)

legend("topright", 
       legend = c("Joint 95% CR", "Individual CIs", "Estimate", "True β"),
       col = c("blue", "red", "black", "purple"),
       lty = c(1, 2, NA, 3),
       pch = c(NA, NA, 19, NA),
       lwd = c(2, 2, NA, 1.5),
       cex = 0.8)

# Reset plotting parameters
par(mfrow = c(1, 1))

# Q1B (iv) - Compare standard errors and variance decomposition
cat("\n=== Comparison: n=35 vs n=3500 ===\n")
cat("\nStandard Errors (n=35):\n")
print(round(cs[, "Std. Error"], 4))
cat("\nStandard Errors (n=3500):\n")
print(round(cs_large[, "Std. Error"], 4))
cat("\nRatio of SE (n=35 / n=3500):\n")
print(round(cs[, "Std. Error"] / cs_large[, "Std. Error"], 2))
cat("\nExpected ratio sqrt(3500/35) =", round(sqrt(3500/35), 2), "\n")

# Compare confidence interval widths
cat("\n=== CI Width Comparison ===\n")
cat("CI width for x3 (n=35):", round(ci_x3[2] - ci_x3[1], 4), "\n")
cat("CI width for x3 (n=3500):", round(ci_x3_large[2] - ci_x3_large[1], 4), "\n")
cat("CI width for x4 (n=35):", round(ci_x4[2] - ci_x4[1], 4), "\n")
cat("CI width for x4 (n=3500):", round(ci_x4_large[2] - ci_x4_large[1], 4), "\n")



#Q1C - Perfect Collinearity########
cat("\n\n=== Part (c): Perfect Collinearity ===\n")
cat("Creating data where x3 + 2*x4 = 0 (i.e., x4 = -x3/2)\n\n")

# Go back to n = 35
n <- 35
set.seed(1234)
x2_c <- runif(n, 0, 30)
x3_c <- runif(n, 0, 30)

# x3 + 2*x4 = 0##
x4_c <- -x3_c / 2

# Generate y with same DGP
y_c <- 10 + 0.5*x2_c + 0.5*x3_c + 0.5*x4_c + rnorm(n, 0, 4)

fit_c <- lm(y_c ~ x2_c + x3_c + x4_c)

# Print regression output
print(summary(fit_c))

# Print confidence intervals
cat("\n=== Confidence Intervals ===\n")
print(confint(fit_c, level = 0.95))

# Create output table INCLUDING the NA row for x4_c
cs_c <- coef(summary(fit_c))
ci_c <- confint(fit_c, level = 0.95)

# Build the full table manually
out_c <- data.frame(
  Estimate = c(cs_c[1, "Estimate"], cs_c[2, "Estimate"], cs_c[3, "Estimate"], NA),
  Std.Error = c(cs_c[1, "Std. Error"], cs_c[2, "Std. Error"], cs_c[3, "Std. Error"], NA),
  Lower = ci_c[, 1],
  Upper = ci_c[, 2]
)
rownames(out_c) <- c("(Intercept)", "x2_c", "x3_c", "x4_c")

cat("\n=== Formatted Output Table (including NA for x4_c) ===\n")
print(round(out_c, 4))

# Generate LaTeX table
xtable_out_c <- xtable(out_c, digits = 4, 
                       caption = "Regression Results with Perfect Collinearity",
                       label = "tab:regression_perfect_collinearity")

# Print to console
print(xtable_out_c, type = "latex", 
      caption.placement = "top",
      sanitize.text.function = function(x){x})

# Save to file
sink("regression_table_1ci.tex")
print(xtable_out_c, type = "latex", caption.placement = "top")
sink()

cat("\n=== Analysis ===\n")
cat("Note: x4_c coefficient is NA due to perfect collinearity (x3 + 2*x4 = 0).\n")
cat("R automatically drops x4_c because the design matrix X is singular.\n")
cat("This results in infinite solutions for (β3, β4).\n")
