# assig7.py
# Replicate Oreopoulos (2006) for Great Britain:
# - Table 1: First stage & reduced form (effect of drop15)
# - Table 2: OLS and RD-IV returns to schooling

import pandas as pd
import statsmodels.formula.api as smf
from linearmodels.iv import IV2SLS

# ---------------------------------------------------------
# 1. Load data
# ---------------------------------------------------------

df = pd.read_stata("assignment7.dta")
print("Full data shape:", df.shape)

# cluster id at cohort × region level (as in paper)
df["cluster"] = (
    df["yearat14"].astype(int).astype(str) + "_" +
    df["nireland"].astype(int).astype(str)
)

# ---------------------------------------------------------
# 2. Great Britain sample (nireland == 0), ages 25–64,
#    yearat14 coded 35–65 (1935–1965)
# ---------------------------------------------------------

gb = df.query(
    "nireland == 0 and 25 <= age <= 64 and 35 <= yearat14 <= 65"
).copy()

print("GB sample shape:", gb.shape)
print(gb[["nireland", "age", "yearat14"]].head())

# treatment dummy: faced minimum school-leaving age 15 at 14
gb["treat"] = gb["drop15"]

# for Table 2
gb["educ"]   = gb["agelfted"]
gb["y_earn"] = gb["learn"]

# weighted sample size
N_weighted = gb["wght"].sum()

# ---------------------------------------------------------
# Helper: run one WLS regression with explicit variable list
# ---------------------------------------------------------

def run_wls(dep, rhs, needed_vars, label):
    formula = f"{dep} ~ {rhs}"
    data = gb[needed_vars].dropna()
    print(f"{label}: using {data.shape[0]} cells after dropna()")
    model = smf.wls(formula, data=data, weights=data["wght"])
    res = model.fit(cov_type="cluster", cov_kwds={"groups": data["cluster"]})
    return res

# ---------------------------------------------------------
# 3. TABLE 1 – First stage (agelfted) & reduced form (learn)
# ---------------------------------------------------------

cohort_terms = "yearat14 + yearat14_2 + yearat14_3 + yearat14_4"
age_poly     = "age + age2 + age3 + age4"

# ---- First stage: dep = agelfted ----
# (1) no age controls
fs1 = run_wls(
    dep="agelfted",
    rhs=f"treat + {cohort_terms}",
    needed_vars=["agelfted", "treat", "yearat14", "yearat14_2",
                 "yearat14_3", "yearat14_4", "wght", "cluster"],
    label="FS col 1"
)

# (2) add age quartic
fs2 = run_wls(
    dep="agelfted",
    rhs=f"treat + {cohort_terms} + {age_poly}",
    needed_vars=["agelfted", "treat", "yearat14", "yearat14_2",
                 "yearat14_3", "yearat14_4",
                 "age", "age2", "age3", "age4",
                 "wght", "cluster"],
    label="FS col 2"
)

# (3) add age dummies
fs3 = run_wls(
    dep="agelfted",
    rhs=f"treat + {cohort_terms} + C(age)",
    needed_vars=["agelfted", "treat", "yearat14", "yearat14_2",
                 "yearat14_3", "yearat14_4",
                 "age", "wght", "cluster"],
    label="FS col 3"
)

# ---- Reduced form: dep = learn ----
rf4 = run_wls(
    dep="learn",
    rhs=f"treat + {cohort_terms}",
    needed_vars=["learn", "treat", "yearat14", "yearat14_2",
                 "yearat14_3", "yearat14_4", "wght", "cluster"],
    label="RF col 4"
)

rf5 = run_wls(
    dep="learn",
    rhs=f"treat + {cohort_terms} + {age_poly}",
    needed_vars=["learn", "treat", "yearat14", "yearat14_2",
                 "yearat14_3", "yearat14_4",
                 "age", "age2", "age3", "age4",
                 "wght", "cluster"],
    label="RF col 5"
)

rf6 = run_wls(
    dep="learn",
    rhs=f"treat + {cohort_terms} + C(age)",
    needed_vars=["learn", "treat", "yearat14", "yearat14_2",
                 "yearat14_3", "yearat14_4",
                 "age", "wght", "cluster"],
    label="RF col 6"
)

def cell_treat(res):
    b  = res.params["treat"]
    se = res.bse["treat"]
    return f"{b:.3f}\n[{se:.3f}]"

table1 = pd.DataFrame(index=["Great Britain"],
                      columns=["(1)", "(2)", "(3)", "(4)", "(5)", "(6)", "(7)"])
table1.loc["Great Britain", "(1)"] = cell_treat(fs1)
table1.loc["Great Britain", "(2)"] = cell_treat(fs2)
table1.loc["Great Britain", "(3)"] = cell_treat(fs3)
table1.loc["Great Britain", "(4)"] = cell_treat(rf4)
table1.loc["Great Britain", "(5)"] = cell_treat(rf5)
table1.loc["Great Britain", "(6)"] = cell_treat(rf6)
table1.loc["Great Britain", "(7)"] = f"{N_weighted:.0f}"

print("\n========================================")
print("TABLE 1 — Effect of Minimum School-Leaving Age")
print("(Great Britain row; coefficients on 'treat')\n")
print(table1.to_string())
print("========================================\n")

# ---------------------------------------------------------
# 4. TABLE 2 – OLS & RD-IV returns to schooling (GB row)
# ---------------------------------------------------------

# ---- OLS: y_earn on educ ----

def run_ols_t2(col):
    if col == 1:
        rhs = f"educ + {cohort_terms}"
        needed = ["y_earn", "educ",
                  "yearat14", "yearat14_2", "yearat14_3", "yearat14_4",
                  "wght", "cluster"]
    elif col == 2:
        rhs = f"educ + {cohort_terms} + {age_poly}"
        needed = ["y_earn", "educ",
                  "yearat14", "yearat14_2", "yearat14_3", "yearat14_4",
                  "age", "age2", "age3", "age4",
                  "wght", "cluster"]
    elif col == 3:
        rhs = f"educ + {cohort_terms} + C(age)"
        needed = ["y_earn", "educ",
                  "yearat14", "yearat14_2", "yearat14_3", "yearat14_4",
                  "age", "wght", "cluster"]
    else:
        raise ValueError("col must be 1–3")

    formula = f"y_earn ~ {rhs}"
    data = gb[needed].dropna()
    print(f"OLS col {col}: using {data.shape[0]} cells after dropna()")
    model = smf.wls(formula, data=data, weights=data["wght"])
    res = model.fit(cov_type="cluster", cov_kwds={"groups": data["cluster"]})
    return res

ols1 = run_ols_t2(1)
ols2 = run_ols_t2(2)
ols3 = run_ols_t2(3)

# ---- IV: educ instrumented by treat ----

def run_iv_t2(col):
    gb_iv = gb.copy()
    gb_iv["const"] = 1.0

    exog_vars = ["const", "yearat14", "yearat14_2", "yearat14_3", "yearat14_4"]

    if col == 5:
        exog_vars += ["age", "age2", "age3", "age4"]
    if col == 6:
        dums = pd.get_dummies(gb_iv["age"].astype(int), prefix="age_d", drop_first=True)
        gb_iv = pd.concat([gb_iv, dums], axis=1)
        age_dummy_cols = [c for c in gb_iv.columns if c.startswith("age_d_")]
        exog_vars += age_dummy_cols

    needed = ["y_earn", "educ", "treat", "wght", "cluster"] + exog_vars
    data = gb_iv[needed].dropna()
    print(f"IV col {col}: using {data.shape[0]} cells after dropna()")

    exog   = data[exog_vars]
    endog  = data["y_earn"]
    endogx = data["educ"]
    instr  = data[["treat"]]

    iv_model = IV2SLS(endog, exog, endogx, instr, weights=data["wght"])
    res = iv_model.fit(cov_type="clustered", clusters=data["cluster"])
    return res

iv4 = run_iv_t2(4)
iv5 = run_iv_t2(5)
iv6 = run_iv_t2(6)

def cell_educ(res, iv=False):
    if iv:
        b  = res.params["educ"]
        se = res.std_errors["educ"]
    else:
        b  = res.params["educ"]
        se = res.bse["educ"]
    return f"{b:.3f}\n[{se:.3f}]"

table2 = pd.DataFrame(index=["Great Britain"],
                      columns=["(1)", "(2)", "(3)", "(4)", "(5)", "(6)"])
table2.loc["Great Britain", "(1)"] = cell_educ(ols1)
table2.loc["Great Britain", "(2)"] = cell_educ(ols2)
table2.loc["Great Britain", "(3)"] = cell_educ(ols3)
table2.loc["Great Britain", "(4)"] = cell_educ(iv4, iv=True)
table2.loc["Great Britain", "(5)"] = cell_educ(iv5, iv=True)
table2.loc["Great Britain", "(6)"] = cell_educ(iv6, iv=True)

print("========================================")
print("TABLE 2 — Returns to Schooling (OLS & RD-IV)")
print("(Great Britain row; coefficients on 'educ')\n")
print(table2.to_string())
print("========================================\n")

print("Weighted GB sample size:", f"{N_weighted:.0f}")
