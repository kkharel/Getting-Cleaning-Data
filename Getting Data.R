getwd()

if(!file.exists("NLP")) {
  dir.create("NLP")
}

# download.file gets the data from the internet. input parameters: url, destfile, method

fileURL = "https://data.sfgov.org/resource/5cei-gny5.csv"

download.file(fileURL, destfile ="./NLP/eviction.csv" , method = "curl")

?download.file

list.files("./NLP")

dateDownloaded = date()
dateDownloaded

# Reading local flat file, read.table not good way to load big data

eviction = read.table(file = "./NLP/eviction.csv", sep = ',', header = TRUE, fill = TRUE, nrows = 44030)


evictionDF = as.data.frame(eviction)
dim(evictionDF)


names(evictionDF)

library(dplyr)
evictionDF %>%
  summarise(count = sum(is.na(evictionDF)))

library(tidyverse)
glimpse(evictionDF)

newDF = evictionDF[which(rowMeans(!is.na(evictionDF)) > 0.80), which(colMeans(!is.na(evictionDF)) > 0.80)]

dim(newDF)

newDF %>%
  summarise(count = sum(is.na(newDF)))

sum(is.na(newDF))


# Reading excel files

Sys.setenv(JAVA_HOME='C:\\Program Files\\Java\\jre7') # for 64-bit version
library(xlsx)

# data = read.xlsx("./NLP/eviction.xlsx", sheetIndex = 1, header = TRUE)
# head(data)

# Reading Specific Rows and Specific Columns
colIndex = 2:3
rowIndex = 1:4

datasubset = read.xlsx("./NLP/eviction.xlsx", sheetIndex = 1, header = TRUE,
                       colIndex = colIndex, rowIndex = rowIndex)



# Reading XML files

# extensible markup langugage
# frequently used to store structured data from internet applcations
# Extracting XML is the basis for most web scraping
# Components:
  # Markup - labels that give the text structure
  # Content - the actual text of the document

# Tags, elements and attributes

# tags corresponds to general labels: start tags <section>, end tags </section>, empty tags <line break/ >

# Elements are specific examples of tags
# <Greeting> Hello, World </Greeting>

# Attributes are components of the label

# <img src="kush.jpg" alt = "student"/>
# <step number="3"> Connect A to B. </step>

library(XML)
library(httr)

fileURL = "http://www.w3schools.com/xml/simple.xml"

doc = xmlTreeParse(file = httr::GET(fileURL), useInternalNodes = TRUE)

rootNode = xmlRoot(doc)
xmlName(rootNode)

names(rootNode)

rootNode[[1]] # same as extracting element from List

rootNode [[1]][[1]]

# Programatically extract parts of the file

xmlSApply(rootNode, xmlValue)

# Xpath (read from uc berkeley site)

# /node = top level node

# //node = node at any level

# node[@attr-name] = Node with an attribute name

# node[@attr-name="bob"]

# Get the items on the menu and prices

xpathSApply(rootNode, "//name", xmlValue)
xpathSApply(rootNode, "//price", xmlValue)


giantsURL = "https://www.espn.com/mlb/team/schedule/_/name/sf/san-francisco-giants"

docs = htmlTreeParse(file = httr::GET(giantsURL), useInternalNodes = TRUE)
library(rvest)
html = read_html(giantsURL)

table = html_nodes(html, xpath = ' //*[contains(concat( " ", @class, " " ), concat( " ", "Table__TD", " " ))] | //*[contains(concat( " ", @class, " " ), concat( " ", "Card__Content", " " ))]//*[contains(concat( " ", @class, " " ), concat( " ", "items-center", " " ))]//*[contains(concat( " ", @class, " " ), concat( " ", "dib", " " ))]')

text_data = html_text(table)

df = data.frame(text_data)
View(df)

# Come back to html extraction


# Reading Json files

library(jsonlite)

jsonData = fromJSON("https://api.github.com/users/kkharel/repos")
names(jsonData)

names(jsonData$owner)

jsonData$owner$login

# Writing dataframes to JSON

myjson = toJSON(iris, pretty=TRUE)
cat(myjson)

# Convert back to json

iris3 = fromJSON(myjson)
head(iris3)


# Data.table, written in C so mucch faster than data frames
library(data.table)
DF = data.frame(x = rnorm(9), y = rep(c("a","b","c"), each = 3), z = rnorm(9))
head(DF,3)

DT = data.table(x = rnorm(9), y = rep(c("a", "b", "c"), each = 3), z = rnorm(9))
head(DT,3)

tables()

# Subsetting rows
DT[3,]

DT[DT$y=="a"]

DT[c(2,3)]

DT[,c(2,3)]

# Calculating values for variables with expressions

DT[, list(mean(x), sum(z))]

DT[, table(y)]

DT[, w:=z^2]

DT[, m:= {tmp = (x+z); log2(tmp+5)}]

DT

DT[, a:= x>0]
DT

DT[, b:= mean(x+w), by = a]
DT

# Special Variables .N

set.seed(123)

DT = data.table(x = sample(letters[1:3], 1E5, TRUE))
DT[, .N, by = x]

# Keys

DT = data.table(x = rep(c("a", "b", "c"), each = 100), y = rnorm(300))
setkey(DT, x)
DT['a']

# Joins

DT1 = data.table(x = c("a", "a", "b", "dt1"), y = 1:4)
DT2 = data.table(x = c("a", "b", "dt2"), z = 5:7)

setkey(DT1, x); setkey(DT2, x)
merge(DT1,DT2)

# Fast Reading
big_df = data.frame(x = rnorm(1E6), y = rnorm(1E6))

file = tempfile()

write.table(big_df, file = file, row.names = FALSE, col.names = TRUE, sep = "\t", quote = FALSE)
system.time(fread(file))

system.time(read.table(file, header = TRUE, sep = "\t"))

#quiz
fileURL = "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"

download.file(fileURL, destfile ="./NLP/housing.csv" , method = "curl")

list.files("./NLP")

dateDownloaded = date()
dateDownloaded

# Reading local flat file, read.table not good way to load big data

idaho = read.table(file = "./NLP/housing.csv", sep = ',', header = TRUE, fill = TRUE)
idahohousing = data.table(idaho)
idahohousing[VAL == 24, .N]
