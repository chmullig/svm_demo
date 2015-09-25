library(ggplot2)
library(e1071)

#Read data, from a NYT dataset: https://github.com/TheUpshot/nyt_weddings
nytw <- read.csv("nyt_weddings/nyt_wedding_announcements.csv")


#visualize the (messy) data
qplot(nytw$bride_age, nytw$groom_age, color=nytw$name_status) +
    ggtitle("All Wedding Announcements")

qplot(nytw$bride_age, nytw$groom_age, color=nytw$name_status) +
    ggtitle("All Wedding Announcements")


#Oh look, we can get year from the URL (mostly)
nytw$year <- as.numeric(gsub("https?://(?:www.)?nytimes.com/([0-9]+)/.*", "\\1",
                            nytw$url, fixed=F, perl=T))

#broken out by year!
ggplot(nytw, aes(bride_age, groom_age, color=name_status)) +
    geom_point(size=3) +
    ggtitle("All Wedding Announcements") +
    facet_wrap(~year)


#let's filter to just the valid data in the most recent year
nytw$valid <- complete.cases(nytw) &
    nytw$bride_age > 0 & nytw$groom_age > 0 &
    nytw$year == 2014 &
    nytw$name_status %in% c('taking', 'keeping')

nytwv <- nytw[nytw$valid == T,] #put the valid subset in a new DF

#and now it's a nice visualization
ggplot(nytwv, aes(bride_age, groom_age, color=name_status)) +
    geom_jitter(size=2) +
    ggtitle("Valid Subset of Wedding Announcements")



#ok, and fit a linear SVM
fit <- svm(name_status ~ groom_age + bride_age, data=nytwv,
           kernel='linear', cost=1/500, scale=F)
            #as a general comment, for parameters like cost
            #typically try ad-hoc on a log scale
            #.001, .01, .1, 1, 10, 100, 1000, 10000
yhat <- predict(fit, nytwv)

#visualize with builtin
plot(fit, nytwv, groom_age ~ bride_age)


#ggplot visuals
w <- t(fit$coefs) %*% fit$SV
b <- -fit$rho
p <- fit$SV
ggplot(nytwv, aes(bride_age, groom_age, color=name_status)) +
    geom_abline(intercept=-(b-1)/w[1,1], slope=-w[1,2]/w[1,1], linetype="dashed") +
    geom_abline(intercept=-(b+1)/w[1,1], slope=-w[1,2]/w[1,1], linetype="dashed") +
    geom_abline(intercept=-b/w[1,1], slope=-w[1,2]/w[1,1]) +
    geom_point(data=data.frame(fit$SV), color="black", size=4) +
    geom_point(size=3)