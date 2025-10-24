# TP2-Linear-Regression_residual-cloud  
### Linear regression's lab in R

---

## Objective

This lab aims to study **linear and polynomial regression** using the **least squares method**.  
We focus on the Boston dataset (`MASS` package in R), particularly the relationship between:

- **`lstat`** : percentage of adults without a high-school diploma (variable $X$)  
- **`medv`** : median value of owner-occupied homes (variable $Y$)

The goal is to **model $Y$ as a function of $X$**, analyze residuals, and compare polynomial fits.

---

## 1. Mathematical foundations

### Variance

The variance measures how far a set of values is spread out around its mean:

$$
\mathrm{Var}(X) = \frac{1}{n} \sum_{i=1}^{n} (x_i - \bar{x})^2
$$

- $x_i$: observed value  
- $\bar{x}$: sample mean  
- $n$: number of observations  

> Note: In R, the function `var()` uses $\frac{1}{n-1}$ as denominator (unbiased estimator).

---

### Standard Deviation

The standard deviation expresses the average deviation of values from the mean:

$$
\mathrm{SD}(X) = \sqrt{\mathrm{Var}(X)} = \sqrt{\frac{1}{n}\sum_{i=1}^{n}(x_i - \bar{x})^2}
$$

It has the same unit as the variable $X$.

---

### Covariance

Covariance measures how two variables vary together:

$$
\mathrm{Cov}(X,Y) = \frac{1}{n}\sum_{i=1}^{n}(x_i - \bar{x})(y_i - \bar{y})
$$

- $\mathrm{Cov}(X,Y) > 0$: $X$ and $Y$ increase together  
- $\mathrm{Cov}(X,Y) < 0$: $X$ increases while $Y$ decreases  
- $\mathrm{Cov}(X,Y) = 0$: no linear dependence

---

###  Pearson Correlation

The Pearson correlation coefficient standardizes the covariance:

$$
r(X,Y) = \frac{\mathrm{Cov}(X,Y)}{\sqrt{\mathrm{Var}(X)\,\mathrm{Var}(Y)}}
$$

- $r = 1$: perfect positive linear relationship  
- $r = -1$: perfect negative linear relationship  
- $r = 0$: no linear relationship  

---

## 📈 2. Linear regression model

We model $Y$ as a **linear function of $X$**:

$$
y_i = \beta_0 + \beta_1 x_i + \varepsilon_i
$$

where:
- $\beta_0$: intercept (value of $Y$ when $X=0$)  
- $\beta_1$: slope (change in $Y$ per unit increase in $X$)  
- $\varepsilon_i$: random error term (residual)

---

### Least Squares Estimation

We estimate $\beta_0$ and $\beta_1$ by minimizing the **sum of squared residuals**:

$$
S(\beta_0,\beta_1) = \sum_{i=1}^{n} (y_i - \beta_0 - \beta_1 x_i)^2
$$

The optimal parameters satisfy:

$$
\frac{\partial S}{\partial \beta_0} = 0, \quad \frac{\partial S}{\partial \beta_1} = 0
$$

Solving gives:

$$
\hat{\beta}_1 = \frac{\mathrm{Cov}(X,Y)}{\mathrm{Var}(X)}, \qquad
\hat{\beta}_0 = \bar{Y} - \hat{\beta}_1 \bar{X}
$$

---

### 🔹 Fitted model and residuals

The **fitted model** is:

$$
\hat{y}_i = \hat{\beta}_0 + \hat{\beta}_1 x_i
$$

Residuals are the differences between observed and predicted values:

$$
\hat{e}_i = y_i - \hat{y}_i
$$

---

### Residual variance and standard error

The residual variance is:

$$
\mathrm{Var}(\hat{e}) = \frac{1}{n-2}\sum_{i=1}^{n} \hat{e}_i^2
$$

and the **residual standard deviation** is:

$$
\widehat{\sigma}_\varepsilon = \sqrt{\frac{\sum_{i=1}^{n} \hat{e}_i^2}{n-2}}
$$

---

## 3. Coefficient of determination — \( R^2 \)

$R^2$ measures the proportion of variance in $Y$ explained by the regression model.

$$
R^2 = \frac{\mathrm{Var}(\hat{Y})}{\mathrm{Var}(Y)} = 1 - \frac{\mathrm{Var}(\hat{e})}{\mathrm{Var}(Y)}
$$

- $R^2 = 0$: model explains none of the variance in $Y$  
- $R^2 = 1$: perfect fit  

In simple linear regression, we also have:

$$
R^2 = [r(X,Y)]^2
$$

---

## 4. Variance decomposition

The variance of $Y$ can be decomposed as:

$$
\mathrm{Var}(Y) = \mathrm{Var}(\hat{Y}) + \mathrm{Var}(\hat{e})
$$

where:
- $\mathrm{Var}(\hat{Y})$: explained variance  
- $\mathrm{Var}(\hat{e})$: residual (unexplained) variance  

---

## 5. Polynomial regression (general case)

A polynomial regression model of degree $p$ is defined as:

$$
y_i = a_0 + a_1 x_i + a_2 x_i^2 + \dots + a_p x_i^p + \varepsilon_i
$$

The least squares estimate of the coefficients is obtained from:

$$
\hat{\boldsymbol{a}} = (X^\top X)^{-1} X^\top Y
$$

where $X$ is the design matrix:

$$
X =
\begin{bmatrix}
1 & x_1 & x_1^2 & \dots & x_1^p \\
1 & x_2 & x_2^2 & \dots & x_2^p \\
\vdots & \vdots & \vdots & \ddots & \vdots \\
1 & x_n & x_n^2 & \dots & x_n^p
\end{bmatrix}
$$

---

## 📏 6. Model comparison — Akaike Information Criterion (AIC)

The **AIC** balances model accuracy and complexity:

$$
AIC(p) = n \ln(\mathrm{SCR}_p) + 2(p + 1)
$$

where:
- $\mathrm{SCR}_p = \sum_{i=1}^{n} \hat{e}_{i,p}^2$ : sum of squared residuals  
- $p + 1$ : number of parameters in the polynomial model  

A lower AIC indicates a better trade-off between fit quality and model simplicity.

---

## Summary of key formulas

| Concept | Formula | Interpretation |
|----------|----------|----------------|
| Variance | $\mathrm{Var}(X) = \frac{1}{n}\sum(x_i-\bar x)^2$ | Dispersion of $X$ |
| Covariance | $\mathrm{Cov}(X,Y) = \frac{1}{n}\sum(x_i-\bar x)(y_i-\bar y)$ | Joint variation of $X$ and $Y$ |
| Correlation | $r=\frac{\mathrm{Cov}(X,Y)}{\sqrt{\mathrm{Var}(X)\mathrm{Var}(Y)}}$ | Strength of linear relation |
| Regression slope | $\hat\beta_1=\frac{\mathrm{Cov}(X,Y)}{\mathrm{Var}(X)}$ | Change in $Y$ per unit $X$ |
| Intercept | $\hat\beta_0=\bar Y-\hat\beta_1\bar X$ | Predicted $Y$ when $X=0$ |
| Fitted values | $\hat y_i=\hat\beta_0+\hat\beta_1x_i$ | Predicted outputs |
| Residuals | $\hat e_i=y_i-\hat y_i$ | Model errors |
| $R^2$ | $\frac{\mathrm{Var}(\hat Y)}{\mathrm{Var}(Y)}$ | Fraction of variance explained |
| AIC | $AIC(p)=n\ln(\mathrm{SCR}_p)+2(p+1)$ | Model selection criterion |

---

✍️ *Author: [Your Name]*  
📚 *Source: Course “Statistique descriptive 2” — TP2 Régression linéaire et nuage de résidus*
