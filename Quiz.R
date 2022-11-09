library(httr)

# 1. Find OAuth settings for github:
#    http://developer.github.com/v3/oauth/
oauth_endpoints("github")

# 2. To make your own application, register at
#    https://github.com/settings/developers. Use any URL for the homepage URL
#    (http://github.com is fine) and  http://localhost:1410 as the callback url
#
#    Replace your key and secret below.
myapp <- oauth_app("github",
                   key = "56ca14f9e017e9f71d78",
                   secret = "d04239688054f135d5c329ddef7cee40d4cb3eeb"
)

# 3. Get OAuth credentials
github_token <- oauth2.0_token(oauth_endpoints("github"), myapp)

# 4. Use API
gtoken <- config(token = github_token)
req <- GET("https://api.github.com/users/jtleek/repos", gtoken)
stop_for_status(req)
content(req)

# OR:
req <- with_config(gtoken, GET("https://api.github.com/rate_limit"))
stop_for_status(req)
content(req)


# Extract content from a request
json1 = content(req)

# Converting to data frame

gitDF  = jsonlite::fromJSON(jsonlite::toJSON(json1))

# Subsetting data fraome

gitDF[gitDF$full_name == "jtleek/datasharing", "created_at"]



# 2)


install.packages("sqldf")

library(sqldf)
detach("package:RMySQL", unload=TRUE)

url = "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv"

f = file.path(getwd(), "ss06pid.csv")
download.file(url, f)
acs  = data.table::data.table(read.csv(f))

query = sqldf("select pwgtp1 from acs where AGEP  < 50")

query

unique(acs$AGEP)
query2 = sqldf("select distinct AGEP from acs")
query2

# How many characters are in the 10th, 20th, 30th and 100th lines of HTML from this page

# http://biostat.jhsph.edu/~jleek/contact.html

conn = url("http://biostat.jhsph.edu/~jleek/contact.html")

htmlCode = readLines(conn)

close(conn)

c(nchar(htmlCode[10]), nchar(htmlCode[20]), nchar(htmlCode[30]), nchar(htmlCode[100]) )


# Read the data set into R and report the sum of the numbers in the fourth of the nine columns
# fixed-width file format
url = "https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for"
lines = readLines(url, n = 10)
w = c(1, 9, 5, 4, 1, 3, 5, 4, 1, 3, 5, 4, 1, 3, 5, 4, 1, 3)
colNames = c("filler", "week", "filler", "sstNino12", "filler", "sstaNino12", 
              "filler", "sstNino3", "filler", "sstaNino3", "filler", "sstNino34", "filler", 
              "sstaNino34", "filler", "sstNino4", "filler", "sstaNino4")
x = read.fwf(url, w, header = FALSE, skip = 4, col.names = colNames)
x
x = x[, grep("^[^filler]", names(x))]
x
sum(x[, 4])
