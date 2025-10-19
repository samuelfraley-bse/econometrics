
#read Data
df <- read.csv("C:\\Users\\sffra\\Downloads\\USelections.csv")

# build X in the order so B7 is GI and B2 is I
X <- with(df, cbind(
  const = 1,
  I     = I,
  DPER  = DPER,
  DUR   = DUR,
  WAR   = WAR,
  GI    = G * I,
  PI    = P * I,
  ZI    = Z * I
))
y <- as.matrix(df$VP)

# 2) OLS from definitions
XtX   <- t(X) %*% X
XtX_i <- solve(XtX)
beta  <- XtX_i %*% t(X) %*% y
u     <- y - X %*% beta

n <- nrow(X); k <- ncol(X)
sigma2_hat <- as.numeric(t(u) %*% u) / (n - k)              
Vbeta_hat  <- sigma2_hat * XtX_i                             
se         <- sqrt(diag(Vbeta_hat))

#se(B6)
se_beta6 <- se[6]

#t-value for regressor B2
t_I <- as.numeric(beta[2] / se[2])                           

#two-sided p-value for H0
p_I <- 2 * (1 - pt(abs(t_I), df = n - k))

#show results
cat(sprintf("se(beta6 [GI]) = %.6f\n", se_beta6))
cat(sprintf("t-value for I   = %.6f\n", t_I))
cat(sprintf("p-value for I   = %.6f\n", p_I))

# can also check against lm() which should match stata i believe
df$GI <- df$G * df$I; df$PI <- df$P * df$I; df$ZI <- df$Z * df$I
m <- lm(VP ~ I + DPER + DUR + WAR + GI + PI + ZI, data = df)
sm <- summary(m)

cat("vs LM")
cat(sprintf("se(GI) from lm(): %.6f\n", sm$coefficients["GI", "Std. Error"]))
cat(sprintf("t(I)  from lm(): %.6f\n", sm$coefficients["I",  "t value"]))
cat(sprintf("p(I)  from lm(): %.6f\n", sm$coefficients["I",  "Pr(>|t|)"]))

