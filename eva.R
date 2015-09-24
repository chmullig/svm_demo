#data from: https://data.nasa.gov/Raw-Data/Extra-vehicular-Activity-EVA-US-and-Russia/9kcy-zwvn
eva <- read.csv('eva.csv')


#convert date to something usable
eva$Date_raw <- eva$Date #make a backup
eva$Date <- gsub('Sept.', 'Sep.', eva$Date_raw) #non-standard abbreviation
eva$Date <- gsub(' ([0-9]*)-[0-9]*,', ' \\1,', eva$Date2, perl=T, fixed=F) #They have May 21-22, 1904, but we want just a single day, so make that May 21, 1904
eva$Date <- as.Date(parse_date_time(eva$Date, c('%m/%d/%y', '%m %d, %y'))) #And make it an actual date, so it can be used as a number in models

#convert duration from a string to numberic hours
eva$Duration_raw <- eva$Duration
eva$Duration <- sapply(strsplit(as.character(eva$Duration_raw), ':'),
       function(x) {
           x <- as.numeric(x)
           x[1] + x[2]/60
       }
)
eva$Duration[is.na(eva$Duration)] <- 0


#Visualize the data
ggplot(eva, aes(Date, Duration, color=Country))  +
    geom_point(size=3) +
    scale_color_manual(values=c('USA'='blue', 'Russia'='red'))


#fit an SVM and visualize it
#playing with different values of cost and gamma will noticeably affect the plot
eva_fit <- svm(Country ~ Date + Duration, data=eva,
               kernel='radial', cost=1000, gamma=1.5, scale=T)
plot(eva_fit, eva, Duration ~ Date,
     col=c('salmon', 'skyblue'), symbolPalette=c('red3', 'blue'),
     svSymbol=16) #dark circles are support vectors

#
eva_yhat <- predict(eva_fit, eva)

ggplot(eva, aes(Date, Duration, color=Country))  +
    #visualize background
    geom_point(size=3) +
    scale_color_manual(values=c('USA'='blue', 'Russia'='red'))

