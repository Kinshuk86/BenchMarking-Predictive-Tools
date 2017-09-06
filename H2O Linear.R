#H2O
install.packages("devtools")
library(devtools)
if ("package:h2o" %in% search()) { detach("package:h2o", unload=TRUE) }
if ("h2o" %in% rownames(installed.packages())) { remove.packages("h2o") }

# Next, we download packages that H2O depends on.
if (! ("methods" %in% rownames(installed.packages()))) { install.packages("methods") }
if (! ("statmod" %in% rownames(installed.packages()))) { install.packages("statmod") }
if (! ("stats" %in% rownames(installed.packages()))) { install.packages("stats") }
if (! ("graphics" %in% rownames(installed.packages()))) { install.packages("graphics") }
if (! ("RCurl" %in% rownames(installed.packages()))) { install.packages("RCurl") }
if (! ("jsonlite" %in% rownames(installed.packages()))) { install.packages("jsonlite") }
if (! ("tools" %in% rownames(installed.packages()))) { install.packages("tools") }
if (! ("utils" %in% rownames(installed.packages()))) { install.packages("utils") }

# Now we download, install and initialize the H2O package for R.
install.packages("h2o", type="source", repos=(c("http://h2o-release.s3.amazonaws.com/h2o/rel-tverberg/4/R")))
install.packages("h2o", type="source", repos=(c("http://h2o-release.s3.amazonaws.com/h2o/rel-ueno/8/R")))
library(h2o)
localH2O = h2o.init(nthreads=-1)

localH2O = h2o.init(ip = "datanoded01.dev.bigdata.jcpcloud2.net", port = 54321)
localH2O = h2o.init(ip = "10.248.7.179", port = 54321)

dx_train <- as.data.frame("train-10m.csv")
dx_test <- as.data.frame("test.csv")


Xnames <- names(dx_train)[which(names(dx_train)!="dep_delayed_15min")]

system.time({
  md <- h2o.glm(x = Xnames, y = "dep_delayed_15min", training_frame = dx_train, 
                family = "binomial", alpha = 1, lambda = 0)
})


h2o.auc(h2o.performance(md, dx_test))


pathToData = "hdfs://masternoded01.dev.bigdata.jcpcloud2.net:8020/user/h2o/train-1m.csv"
normal.hex = h2o.importFile(path = pathToData)
summary(normal.hex)


pathToData = "hdfs://masternoded01.dev.bigdata.jcpcloud2.net:8020/user/h2o/train-1m.csv"
normal.hex = h2o.importFile(path = pathToData)



