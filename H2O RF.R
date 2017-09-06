if (! ("methods" %in% rownames(installed.packages()))) { install.packages("methods") }
if (! ("statmod" %in% rownames(installed.packages()))) { install.packages("statmod") }
if (! ("stats" %in% rownames(installed.packages()))) { install.packages("stats") }
if (! ("graphics" %in% rownames(installed.packages()))) { install.packages("graphics") }
if (! ("RCurl" %in% rownames(installed.packages()))) { install.packages("RCurl") }
if (! ("jsonlite" %in% rownames(installed.packages()))) { install.packages("jsonlite") }
if (! ("tools" %in% rownames(installed.packages()))) { install.packages("tools") }
if (! ("utils" %in% rownames(installed.packages()))) { install.packages("utils") }

library(h2o)

h2o.init()

prosPath <- system.file("extdata", "prostate.csv", package="h2o")
# Imports data set
prostate.hex = h2o.importFile(path = prosPath, destination_frame="prostate.hex")

# Converts current data frame (prostate data set) to an R data frame
prostate.R <- as.data.frame(prostate.hex)
# Displays a summary of data frame where the summary was executed in R
summary(prostate.R)

h2o.init(ip = "datanoded01.dev.bigdata.jcpcloud2.net", port = 54321)

#dx_train1 <- h2o.importFolder(path = "datanoded01.dev.bigdata.jcpcloud2.net/tmp", destination_frame = "train-0.01m.csv")
#pathToData <- "datanoded01.dev.bigdata.jcpcloud2.net/tmp/train-0.01m.csv"
#airlines.hex = h2o.importFile(H2OServer, path = pathToData, key = "train-0.01m.csv.hex")
#prosPath = system.file("/tmp/", "train-0.01m.csv", package = "H2OServer")
#dx.hex <- as.data.frame(H2OServer, path = "/tmp/train-0.01m.csv", destination_frame = "dx.hex")
#dx_train <- as.data.frame("/tmp/train-0.01m.csv")
#dx_test1 <- as.data.frame("/tmp/test.csv")

#train.h2o <- as.h2o("/tmp/train-0.01m.csv", header = T, sep = ",")
#Xnames <- names(dx_train)[which(names(dx_train)!="dep_delayed_15min")]

#system.time({
#  md <- h2o.randomForest(x = Xnames, y = "dep_delayed_15min", training_frame = train.h2o, ntrees = 500)
#})


#f <- h2o.uploadFile("train-1m.csv")
#t <- h2o.uploadFile("test.csv")

#Xnames <- names(f)[which(names(f)!="dep_delayed_15min")]

#system.time({
#  md <- h2o.randomForest(x = Xnames, y = "dep_delayed_15min", training_frame = f, ntrees = 500)
#})

#system.time({
#  print(h2o.auc(h2o.performance(md, t)))
#})
install.packages("RPostgreSQL")
install.packages("RJDBC")

library(rJava)
library(RJDBC)
library(RPostgreSQL)
library(dplyr)
library(plyr)
library(ggplot2)

myRedshift <- src_postgres('omnianalyticsproddb01',
                           host = 'analyticstest02.c85v4o6majw1.us-east-1.redshift.amazonaws.com',
                           port = "5439",
                           user = "readonly", 
                           password = "Legacy6501",
                           options="-c search_path=analytics")

orderxml <- tbl(myRedshift, "orderxml")
glimpse(orderxml)


h2o.removeAll()

path = system.file("extdata", "prostate.csv", package
                   = "h2o")
h2o_df = h2o.importFile(path)

gaussian.fit = h2o.glm(y = "VOL", x = c("AGE", "RACE",
                                        "PSA", "GLEASON"), training_frame = h2o_df,
                       family = "gaussian")

m1 = h2o.glm(training_frame = data$Train, validation_frame = data$Valid, x = x, y = y,family='multinomial',solver='L_BFGS')
h2o.confusionMatrix(m1, valid=TRUE)
