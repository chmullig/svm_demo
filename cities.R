library(ggplot2)
library(e1071)

#load data, from a 1991 United Bank of Switzerland study, eg, http://lib.stat.cmu.edu/DASL/Stories/EconomicsofCities.html
cities <- read.csv('cities.csv')


ggplot(cities, aes(Price, Salary, color=Developed)) +
    geom_point(size=3) +
    geom_text(aes(label=City), vjust=-.5, hjust=0)

cities_fit <- svm(Developed ~ Salary + Price, data=cities,
                  kernel='linear', cost=10, scale=F)
cities_yhat <- predict(cities_fit, cities)

w <- t(cities_fit$coefs) %*% cities_fit$SV
b <- -cities_fit$rho
p <- cities_fit$SV

ggplot(cities, aes(Price, Salary, color=Developed)) +
    geom_text(aes(label=City), size=5) +
    geom_abline(intercept=-(b-1)/w[1,1], slope=-w[1,2]/w[1,1], linetype="dashed") +
    geom_abline(intercept=-(b+1)/w[1,1], slope=-w[1,2]/w[1,1], linetype="dashed") +
    geom_abline(intercept=-b/w[1,1], slope=-w[1,2]/w[1,1]) +
    geom_point(data=data.frame(cities_fit$SV), color="black", size=4) +
    geom_point()



#Again, but with the CIA definition
ggplot(cities, aes(Price, Salary, color=CIA)) + geom_point() + geom_text(aes(label=City))

cities_fit <- svm(CIA ~ Salary + Price, data=cities,
                  kernel='linear', cost=10, scale=F)
cities_yhat <- predict(cities_fit, cities)

w <- t(cities_fit$coefs) %*% cities_fit$SV
b <- -cities_fit$rho
p <- cities_fit$SV

ggplot(cities, aes(Price, Salary, color=CIA)) +
    geom_text(aes(label=City), size=5) +
    geom_abline(intercept=-(b-1)/w[1,1], slope=-w[1,2]/w[1,1], linetype="dashed") +
    geom_abline(intercept=-(b+1)/w[1,1], slope=-w[1,2]/w[1,1], linetype="dashed") +
    geom_abline(intercept=-b/w[1,1], slope=-w[1,2]/w[1,1]) +
    geom_point(data=data.frame(cities_fit$SV), color="black", size=4) +
    geom_point()