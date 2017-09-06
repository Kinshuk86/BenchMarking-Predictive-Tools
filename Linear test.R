#==================================================================================
#GLM

install.packages("readr")
install.packages("ROCR")
install.packages("gplots")
library(readr)
library(gplots)
library(ROCR)

d_train <- read_csv("train-0.1m.csv")
d_test <- read_csv("test.csv")

system.time({
  md <- glm( ifelse(dep_delayed_15min == "Y", 1, 0) ~ ., data = d_train, family = binomial())
})

d_test <- d_test[d_test$UniqueCarrier %in% unique(d_train$UniqueCarrier),]
d_test <- d_test[d_test$Origin %in% unique(d_train$Origin),]
d_test <- d_test[d_test$Dest %in% unique(d_train$Dest),]

system.time(
  phat <- predict(md, newdata = d_test, type = "response")
)

rocr_pred <- prediction(phat, d_test$dep_delayed_15min)
performance(rocr_pred, "auc")


#===============================
#GLMNET
install.packages("glmnet")
library(Matrix)
library(foreach)
library(glmnet)

d_train <- read_csv("train-10m.csv")
d_test <- read_csv("test.csv")


system.time({
  X_train_test <- Matrix::sparse.model.matrix(dep_delayed_15min ~ . - 1, data = rbind(d_train, d_test))
  X_train <- X_train_test[1:nrow(d_train),]
  X_test <- X_train_test[(nrow(d_train)+1):(nrow(d_train)+nrow(d_test)),]
})
dim(X_train)


system.time({
  md <- glmnet( X_train, d_train$dep_delayed_15min, family = "binomial", lambda = 0)
})


system.time({
  phat <- predict(md, newx = X_test, type = "response")
})

rocr_pred <- prediction(phat, d_test$dep_delayed_15min)
performance(rocr_pred, "auc")


#=======================================================================
#H2O

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
library(h2o)
localH2O = h2o.init(nthreads=-1)


dx_train <- h2o.importFile(path = "train-1m.csv", destination_frame = "prosPath.hex")
dx_test <- h2o.importFile(path = "test.csv")


Xnames <- names(dx_train)[which(names(dx_train)!="dep_delayed_15min")]

system.time({
  md <- h2o.glm(x = Xnames, y = "dep_delayed_15min", training_frame = dx_train, 
                family = "binomial", alpha = 1, lambda = 0)
})


h2o.auc(h2o.performance(md, dx_test))

#================================================================
#H2O V3

library(h2o)

h2o.init(max_mem_size="60g", nthreads=-1)

dx_train <- h2o.importFile(path = "train-10m.csv")
dx_test <- h2o.importFile(path = "test.csv")


Xnames <- names(dx_train)[which(names(dx_train)!="dep_delayed_15min")]

system.time({
  md <- h2o.glm(x = Xnames, y = "dep_delayed_15min", training_frame = dx_train, 
                family = "binomial", alpha = 1, lambda = 0)
})


h2o.auc(h2o.performance(md, dx_test))


library(ggplot2)
library(readr)

d <- read_csv("x-run.csv")

ggplot(d, aes(x = n, y = Time, color = Tool)) +
  geom_point() + geom_line() + scale_x_log10(breaks = c(0.01,0.1,1,10)) + scale_y_log10()

ggplot(d, aes(x = n, y = AUC, color = Tool)) +
  geom_point() + geom_line() + scale_x_log10(breaks = c(0.01,0.1,1,10))