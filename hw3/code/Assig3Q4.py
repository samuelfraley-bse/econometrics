import numpy as np
import statsmodels.api as sm
from scipy.stats import t
import matplotlib.pyplot as plt

np.random.seed(1010)

M = 100
lower = np.zeros(M)
upper = np.zeros(M)
x2 = np.random.uniform(0, 20, 50)  

for i in range(M):
    y = 10 + 5 * x2 + np.random.normal(0, 6, 50)
   
    X = sm.add_constant(x2)
   
    model = sm.OLS(y, X).fit()
   
    b2 = model.params[1]
   
    varb2 = model.cov_params()[1, 1]
   
    se2 = np.sqrt(varb2)
   
    t_val = t.ppf(0.975, 48)  
    lower[i] = b2 - t_val * se2
    upper[i] = b2 + t_val * se2

CIs = np.column_stack((lower, upper))

IDg = np.where((lower <= 5) & (upper >= 5))[0]
length_IDg = len(IDg)

IDb = np.where(~((lower <= 5) & (upper >= 5)))[0]
length_IDb = len(IDb)

ratiog = (length_IDg / M) * 100
print("Ratio", ratiog)

plt.figure()
plt.xlim([4, 6])
plt.ylim([0, 100])
plt.xlabel(r'$\beta_2$')
plt.ylabel('Samples')

plt.axvline(x=5, color='black', linestyle='--')

colors = ['gray'] * 100  
colors = np.array(colors)
colors[IDb[IDb < 100]] = 'red' 

for j in range(100):
    plt.plot([CIs[j, 0], CIs[j, 1]], [j, j], color=colors[j], lw=2)

plt.show()
