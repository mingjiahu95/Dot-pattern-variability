# tot_train= 14 * 10
# tot_test = 52 * 2
# tot_trial = tot_train + tot_test

library(data.table)
library(ggplot2)
library(dplyr)
library(purrr)
library(gridExtra)
library(tidyr)
source('utils.R')

# ---- Load the Data ----
setwd("../data/v1")
files = dir(pattern = "*.txt")
data = do.call(rbind, lapply(files, read.table))
nrows = sapply(files, function(f) nrow(read.table(f)) )
setwd("../data analysis")

# ---- Structure the data ----
#
data = subset(data,select=1:10)
colnames(data) = c("phase","block","trial","itemtype","category","token","distortion","index","response","correct")

data$ID = rep(1:length(files),nrows)
data$phase = as.integer(data$phase) #1 = "train", 2 = "test"
data$block = as.integer(data$block) #"training": 1-10, "test":1
data$category = as.integer(data$category)#1 - 3: A - C
data$response = as.integer(data$response)#1 - 3: A - C
data$itemtype = as.integer(data$itemtype)# 1: "old", 2: "proto", 3: "newlow", 4:"newmed", 5: "newhigh", 6: "newhigh_hard"
data$pat_index = as.integer(data$index)# unique for each category/distortion level
cond_fileidx = ifelse(grepl("cond1",files),1,ifelse(grepl("cond2",files),2,ifelse(grepl("cond3",files),3,4)))
data$condition = rep(cond_fileidx,nrows) #cond1:low, cond2:med, cond3:high, cond4:mixed
data$trial = as.integer(data$trial)
data$correct = as.integer(data$correct)
data$distortion = as.integer(data$distortion)


#-------------------------------------------------------------
# test accuracy by item types
bar_plot_df = filter(data,phase == 2, condition == 1,itemtype != 6) %>%
              group_by(ID,itemtype) %>%
              summarize(Pr_corr_sub = mean(correct == 1),
                        N_itemtype = n()) %>%
              group_by(ID) %>%
              mutate(Pr_corr = weighted.mean(Pr_corr_sub,N_itemtype)) %>%
              ungroup() %>%
              arrange(desc(Pr_corr)) 
              

subID = sprintf("%s %d (%.3f)","subject",unique(bar_plot_df$ID),bar_plot_df$Pr_corr[bar_plot_df$itemtype == 1])
order_seq = 1:length(subID)
bar_plot_df$itemtype = factor(bar_plot_df$itemtype,labels = c("old","proto","newlow","newmed","newhigh"))
bar_plot_df$subID_ordered = factor(rep(order_seq,each = 5),levels = order_seq,labels = subID)
                      

p = ggplot(aes(y=Pr_corr_sub, x=itemtype, fill=itemtype), data=bar_plot_df) +
    geom_bar(stat="identity", color = "black") +
    ggtitle("test accuracy") +
    xlab("Item types") +
    ylab ("Percent Correct") +
    scale_fill_discrete(name = "Item Types") +
    facet_wrap(~ subID_ordered,nrow = 4, ncol = 7) +
    theme_bw(base_size = 10) +
    theme(aspect.ratio = .5,text = element_text(size = 6),
          strip.background = element_blank(),panel.spacing = unit(.05,"cm"),
          plot.background = element_blank(),
          axis.text.x = element_blank(),axis.ticks.x = element_blank())
ggsave(paste("subject_test_accuracy",".jpg"),plot = p,width = 12, height = 10)

#path = "../figure/v1"

