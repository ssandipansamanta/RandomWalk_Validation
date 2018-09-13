Checking Random Walk in a Time Series
===================================================

## Description
Multiple tests have beend used to check a time-series is a random walk or not. The following tests are considered for now:
```xml
1. Ljung-Box Q-statistic
2. Kwiatkowski-Phillips-Schmidt-Shin
3. Augmented Dicky Fuller
4. Kim's Bootstrapped Variance Ratio Test
5. Mann Kendall Trend Test
```

## Approach
___Ljung-Box Q-statistic___
```xml
H0: Independently distributed.
Ha: Serial correlation present.
```
___KPSS___
```xml
H0: Time-series is stationary around a deterministic trend .
Ha: Serial correlation present.
```
___ADF___
```xml
H0: Time-series is Non-stationary.
Ha: Time-series is stationary (or trend-stationary).
```
___KimBootStrap___
```xml
H0: Ratio of variances are same(=1) i.e. series is random walk.
Ha: Ratio of variances are not same(<>1).
```
___MKTest___
```xml
H0: No trend in the time-series.
Ha: Negative, non-null, or positive trend is present.
```

## Requirements
All the required packages will install automatically in the presence of internet.
```xml
1. R Software
2. R Studio as an IDE(good to have)
```

  