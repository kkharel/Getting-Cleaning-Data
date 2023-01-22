# Editing Text Variables

library(httr)
library(jsonlite)

res = GET("https://egisdata.baltimorecity.gov/egis/rest/services/CityView/CCTV_Locations/MapServer/0/query?where=1%3D1&outFields=*&outSR=4326&f=json")
res
rawToChar(res$content)

data = fromJSON(rawToChar(res$content))
names(data)

head(data$features)

cameradata = data$features$attributes
tolower(names(cameradata))

head(cameradata)

grep("Lombard", cameradata$LOCATION) 

table(grepl("Lombard", cameradata$LOCATION))

cameradata2 = cameradata[!grepl("Lombard", cameradata$LOCATION),]

grep("Lombard", cameradata$LOCATION, value = TRUE)

grep("KushStreet", cameradata$LOCATION)

length(grep("KushStreet", cameradata$LOCATION))

library(stringr)
nchar("ABC XYZ")
substr("ABC XYZ", 1,6)
paste("ABC","XYZ")
paste0("ABC","XYZ")
str_trim("ABC         ")

# Regular Expressions 

# Literals - consists of word that match exactly.

# need a way to explore, whitespace word boundaries, sets of literals, beginning and end of line, alternatives(ying or yang) Metacharacters to rescue!

# ^XYZ, if sentence starts at the beginning of the line
# XYZ$, represents the end of the line

# can list set of characters we will accept at a given point in the match. Try [Kk][Uu][Ss][Hh]

# ^[Kk] is

# specifying range of characters. ^[0-9][a-zA-Z]

# ^ is also a metacharacter. [^?.]$, any line that ends either with ? or .

# . referrs to any character. 9.11 returns 9/11, 9-11, 9:11

# | or intems of regular expressions. Ying|Yang

# ^[Gg]ood[Bb]ad, ^([Gg]ood[BB]ad)
#packages: twitterR, rfigshare, rplos,rOpenSci, RFacebook, RGoogleMaps




