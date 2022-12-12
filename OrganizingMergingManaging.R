#subsetting
set.seed(13435)
X = data.frame("var1" = sample(1:5), "var2" = sample(6:10), "var3" = sample(11:15))
X = X[sample(1:5), ]; X$var2[c(1,3)] = NA
X

X[1,] # by row
X[,1] #subsetting by column
X[,"var1"]
X[1:2,"var2"] # by rows and column

# Logicals ands and ors

X[(X$var1 <= 3 & X$var3 > 11),] # all rows of X where var1 is less than or equal to 3 and var3 greater than 11

X[(X$var1 <= 3 | X$var3 > 11),] # all rows of X where var1 is less than or equal to 3 or var3 is greater than 11

# Dealing with missing values

X[which(X$var2 < 8),] # subsetting on NA will not produce actual rows hence we need to use Which command (does not return NAs)

# Sorting

sort(X$var1)

sort(X$var3, decreasing = TRUE)

sort(X$var2, na.last = TRUE)

# Ordering dataframe

X[order(X$var1),] # ordering dataframe rows by values of variable 1, increasing order

# ordering by multiple variables

X[order(X$var1, X$var3), ]

# Ordering with plyr package
library(plyr)
arrange(X,var1)
arrange(X, desc(var1))

# Adding rows and columns

X$var4 = rnorm(5)
X

Y = cbind(X, rnorm(5)) # column bind on right side of X, binding rows use rbind
Y

# Summarizing Data

# Getting the data from the web
library(jsonlite)
library(tidyr)
if(!file.exists("./data")){dir.create("./data")}
restUrl = "https://opendata.baltimorecity.gov/egis/rest/services/Hosted/Restaurants/FeatureServer/0/query?where=1%3D1&outFields=*&outSR=4326&f=json"
#download.file(fileUrl, destfile = "./data/restaurants.csv",method="curl")
restJson = fromJSON(restUrl)
#restData = read.csv("./data/restaurants.csv")
#restData = as_tibble(restJson$features$attributes)

restData = read.csv("./data/Restaurants.csv")

head(restData, n=3)
tail(restData, n=3)

summary(restData)

str(restData)

# Quantiles of quantitative variables

quantile(restData$stfid_blk, na.rm=TRUE)

quantile(restData$stfid_blk, probs = c(0.5, 0.75, 0.90))


# Making Table

table(restData$zipcode, useNA = 'ifany')

# Making Two dimensional table

table(restData$stfid_blk, restData$zipcode)

# Checking for missing values

sum(is.na(restData$zipcode))
sum(is.na(restData$stfid_blk))

any(is.na(restData$zipcode)) # return if any of the values equals na

all(restData$zipcode < 0) # check and see if all zipcode is less than 0

# Rows and Column Sums

colSums(is.na(restData)) # number of na's in each column (entire dataset)

all(colSums(is.na(restData)) == 0) # all of them equals zero, no missing value? 

# Values with user specific characteristics

table(restData$zipcode %in% c("21212"))

table(restData$zipcode %in% c("21212", "21213"))

restData[restData$zipcode %in% c("21212","21213"), ]


# Cross tabs

data("UCBAdmissions")
DF = as.data.frame(UCBAdmissions)
summary(DF)

xt = xtabs(Freq ~ Gender + Admit, data = DF)
xt

# Flat tables

warpbreaks$replicate = rep(1:9, len = 54)
xt = xtabs(breaks~., data = warpbreaks)
xt

ftable(xt)

# Size of the dataset

fakeData = rnorm(1e5)
object.size(fakeData)
print(object.size(fakeData), units = "MB")


# Creating New Variables

# creating sequences - sometimes needs an index for dataset

s1 = seq(1,10,by=2)
s1
s2 = seq(1,10, length = 3)
s2
x = c(1,3,8,25,100); seq(along=x)

# subsetting vairables

restData$nearme = restData$nghbrhd %in% c("Roland Park", "Homelans")
table(restData$nearme)

# Creating Binary Variables
restData$zipWrong = ifelse(restData$zipcode < 0 , TRUE, FALSE) # if zipcode is less than zero then wrong zipcode
table(restData$zipWrong, restData$zipcode < 0)

# Creating categorical variables
restData$zipgroups = cut(restData$zipcode, breaks=quantile(restData$zipcode))
table(restData$zipgroups)
table(restData$zipgroups, restData$zipcode)
      
# Easier Cutting
library(Hmisc)
restData$zipcode = as.numeric(restData$zipcode)
restData$zipGroups = cut2(restData$zipcode, g=4)
table(restData$zipGroups)

# Creating factor variables
restData$zcf = factor(restData$zipcode)
restData$zcf[1:10]
class(restData$zcf)

# Levels of factor variables

yesno = sample(c("yes","no"), size = 10, replace = TRUE)
yesnofac = factor(yesno, levels = c("yes","no"))
relevel(yesnofac, ref = "yes")
as.numeric(yesnofac)

# Cutting produces factor variables
library(Hmisc)
restData$zipGroups = cut2(restData$zipcode, g = 4)
table(restData$zipGroups)

# Using the mutate function to create new variable and simultaneously add it to dataset from plyr package

library(Hmisc); library(plyr)

restData2 = mutate(restData, zipGroups = cut2(zipcode, g = 4))
table(restData2$zipGroups)

# Common transforms

# abs(x), sqrt(x), ceiling(x), floor(x), round(x, digits = n), signif(x, digits = n),
# cos(x), sin(x), log(x), log2(x), log10(x), exp(x)


# Reshaping Data
library(reshape2)
data(mtcars)
head(mtcars)

# Melting data frames

mtcars$carname = rownames(mtcars)
carMelt = melt(mtcars, id = c("carname", "gear", "cyl"), measure.vars = c("mpg", "hp"))
head(carMelt, n = 3)
tail(carMelt, n  = 3)

# Casting data frames

cylData = dcast(carMelt, cyl~variable)
cylData

cylData = dcast(carMelt, cyl~variable, mean)
cylData

# Averaging Values
head(InsectSprays)

tapply(InsectSprays$count, InsectSprays$spray, sum) # apply the count along the index spray a particular function-sum

# Another Way - Split
spIns = split(InsectSprays$count, InsectSprays$spray)
spIns

# Another Way - Apply
sprCount = lapply(spIns, sum)
sprCount

# Another Way - Combine

unlist(sprCount)
sapply(spIns, sum)

# Another Way - plyr package

ddply(InsectSprays,.(spray),summarise,sum=sum(count))

# Creating a new variable

spraySums = ddply(InsectSprays, .(spray), summarise, sum = ave(count, FUN = sum))
dim(spraySums)
head(spraySums)

# See also functions acast, arrange & mutate


# Managing data frames with dplyr package

library(dplyr)

chicago = readRDS("./data/chicago.rds")
dim(chicago)
str(chicago)
names(chicago)

# select function

head(select(chicago, city:dptp))

head(select(chicago, -(city:dptp)))

i = match("city", names(chicago))
j = match("dptp", names(chicago))
head(chicago[, -(i:j)])

# filter function

chic.f = filter(chicago, pm25tmean2 > 25)
head(chic.f, 10)

chic.f = filter(chicago, pm25tmean2 > 25 & tmpd > 75)
head(chic.f, 5)

# Arrange function
chicago = arrange(chicago, date)
head(chicago, 5)
tail(chicago, 5)

chicago = arrange(chicago , desc(date))
head(chicago, 5)
tail(chicago, 5)

# Rename function
chicago = rename(chicago, pm25 = pm25tmean2, dewpoint = dptp)
names(chicago)

# Mutate function
chicago = mutate(chicago, pm25detrend = pm25 - mean(pm25, na.rm = TRUE))
head(select(chicago, pm25, pm25detrend))

# Group by function
chicago = mutate(chicago, tempcat = factor(1 * (tmpd > 80), labels  = c("cold", "hot")))
hotcold = group_by(chicago, tempcat)                 
hotcold

summarize(hotcold, pm25 = mean(pm25), o3 = max(o3tmean2), no2 = median(no2tmean2))

summarize(hotcold, pm25 = mean(pm25, na.rm = TRUE), o3 = max(o3tmean2), no2 = median(no2tmean2))

chicago = mutate(chicago, year = as.POSIXlt(date)$year + 1900)
years = group_by(chicago, year)
summarize(years, pm25 = mean(pm25, na.rm = TRUE), o3 = max(o3tmean2), no2 = median(no2tmean2))

# pipeline operator
chicago %>% 
  mutate(month = as.POSIXlt(date)$mon + 1) %>% 
  group_by(month) %>% 
  summarize(pm25 = mean(pm25, na.rm = TRUE), o3 = max(o3tmean2), no2 = median(no2tmean2))

# Merging Data


