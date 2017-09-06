library(ggplot2)
library(readr)
library(dplyr)
library(reshape2)

d <- read_csv("LinearResult.csv")

ggplot(d, aes(x = n, y = Time, color = Tool)) +
  geom_point() + geom_line() + scale_x_log10(breaks = c(0.01,0.1,1,10)) + scale_y_log10()

ggplot(d, aes(x = n, y = AUC, color = Tool)) +
  geom_point() + geom_line() + scale_x_log10(breaks = c(0.01,0.1,1,10))

rf <- read_csv("RF_Result.csv")

ggplot(rf, aes(x = n, y = Time, color = Tool)) +
  geom_point() + geom_line() + scale_x_log10(breaks = c(0.01,0.1,1,10)) + scale_y_log10()

ggplot(rf, aes(x = n, y = AUC, color = Tool)) +
  geom_point() + geom_line() + scale_x_log10(breaks = c(0.01,0.1,1,10))

h2 <- read_csv("H2O Linear Vs RF.csv")

ggplot(h2, aes(x = n, y = AUC, color = Model)) +
  geom_point() + geom_line() + scale_x_log10(breaks = c(0.01,0.1,1,10))

bo <- read_csv("BoostingResult.csv")

ggplot(bo, aes(x = n, y = AUC, color = Tool)) +
  geom_point() + geom_line() + scale_x_log10(breaks = c(0.01,0.1,1,10))

ggplot(bo, aes(x = n, y = Time, color = Tool)) +
  geom_point() + geom_line() + scale_x_log10(breaks = c(0.01,0.1,1,10)) + scale_y_log10()

bo %>% select(1:4) %>% melt(id.vars=1:2) %>%
  ggplot(aes(x = n, y = value, color = Tool)) +
  geom_point() + geom_line() + 
  facet_wrap(~variable, scales = "free", ncol = 2) +
  scale_x_log10(breaks = c(0.01,0.1,1,10)) + 
  scale_y_log10(breaks = c(1,10,100,1000,10000))
