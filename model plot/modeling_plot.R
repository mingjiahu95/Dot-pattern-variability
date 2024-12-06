library(data.table)
library(ggplot2)
library(purrr)
library(gridExtra)
library(tidyr)
library(dplyr)
#source('utils.R')
# ---- Load the Data ----
obs_data = read.csv("obs_data.csv");
pred_data = read.csv("pred_data.csv"); 
#--------barplot-------------------------------------------

pred_data$condition = factor(pred_data$condition);

cond.labs <- c("low","med","high","mix")
names(cond.labs) <- c("1", "2","3","4")
barplot = ggplot(data=NULL, aes(x = itemtype)) +
          geom_bar(data = obs_data,aes(y = obs),stat = "identity",fill = "white",color = "black",width = .7) +
          geom_line(data = pred_data,aes(y = pred),color = "red",stat = "identity") +
          geom_point(data = pred_data,aes(y = pred),color = "red",stat = "identity",size = 2) +
          scale_x_continuous(breaks = 1:6,labels = c("old","proto","newlow","newmed","newhigh","special")) +
          facet_wrap(vars(condition),nrow = 2,labeller = labeller(condition = cond.labs)) +
          ylim(0,1) +
          xlab("Item Type") +
          ylab("Percent Correct") +
          theme_bw() +
          theme(axis.text.x = element_text(angle = 45, hjust = 1),
                title = element_text(size = 20),
                text =  element_text(size = 15))



ggsave(paste0('overall accuracy','.jpg'),plot = barplot ,path = paste0("figure"), width = 12, height = 8)
