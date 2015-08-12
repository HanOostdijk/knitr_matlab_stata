## @knitr rc_init 
rm(list=ls())
setwd("D:/data/R/knitr_matlab_stata")
paste("workdir:",getwd())

myfun <- function (today) 
{
    paste("today it is",weekdays(today))
}

## @knitr rc_lm
set.seed(3343)
pValues = rep(NA,100)
for (i in 1:100){
    x = rnorm(20)
    y = rnorm(20,mean=0.5*x)
    pValues[i] = summary(lm(y~x))$coef[2,4]
    
}
alpha = 0.1
pValues = sort(pValues)
print(sum(pValues< alpha/100))
print(sum(pValues< (1:100)*alpha/100))

## @knitr rc_versions 
sessionInfo()