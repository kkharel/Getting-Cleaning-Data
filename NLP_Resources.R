# Importing data

txt = system.file("texts", "txt", package = "tm")
ovid = VCorpus(DirSource(txt, encoding = "UTF-8"),
               readerControl = list(language = "lat"))

doc = c("This is starting of NLP", "for data science capstone project")

VCorpus(VectorSource(doc))


# corpus for some reuters documents

reutersraw = system.file("texts", "crude", package = "tm")
reuters = VCorpus(DirSource(reutersraw, mode = "binary"),
                  readerControl = list(reader = readReut21578XMLasPlain))

#Data Export
writeCorpus(ovid)

#Inspecting corpora

inspect(ovid[1:2])


#Accessing individual documents using position and identifier

meta(ovid[[2]], "id")

identical(ovid[[2]], ovid[["ovid_2.txt"]])

# Character representation of document (sometimes useful to inspect)

inspect(ovid[[2]])

lapply(ovid[1:2], as.character)


# Transformations -- removing stopwords, stemming etc.

# tm_map() function applies (maps) a function to all elements of corpus
# All transformations work on single text document and tm_map just applies them to all documents in a corpus

#striping White space
reuters = tm_map(reuters, stripWhitespace)

# pass a function to content_transformer
reuters = tm_map(reuters, content_transformer(tolower))

reuters = tm_map(reuters, removeWords, stopwords("english"))

#stemming - removing variations

reuters = tm_map(reuters, stemDocument)

#filter out documents satisfying given properties with filter

index = meta(reuters, "id") == '5' & meta(reuters, "heading") ==  'INDONESIA SEEN AT CROSSROADS OVER ECONOMIC CHANGE'

#metadata management
data(crude)

DublinCore(crude[[1]], "creator") = "xyz"
meta(crude[[1]])


#Corpora in tm have two types of metadata: one is
#the metadata on the corpus level (corpus), the other is the metadata related to the individual documents
#(indexed) in form of a data frame.

meta(crude, tag = "test" , type = "corpus") = "test meta"
meta(crude, type = "corpus")

meta(crude, "foo") = letters[1:20]
meta(crude)


# Creating term-document matrices

dtm = DocumentTermMatrix(reuters)
inspect(dtm)

# Operations on matrices
findFreqTerms(dtm, lowfreq = 5)

findAssocs(dtm, "opec", 0.6)

# terms occuring in very few documents - sparsity

inspect(removeSparseTerms(dtm, 0.45))

inspect(DocumentTermMatrix(reuters, list(dictionary = c("crude", "prices", "oil"))))


# tokenizing through phrases than words.
library(openNLP)

openNLP::TermDocMatrix(crude, control = list(tokenize = tokenize))

