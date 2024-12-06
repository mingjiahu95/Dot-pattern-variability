

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

#---------------------------------------------------------
# learning curves
learning_curve_df = filter(data,phase == 1) %>%
  group_by(condition,ID,block) %>%
  summarize(Pr_corr_sub = mean(correct == 1)) %>%
  ungroup() %>%
  group_by(condition,block) %>%
  summarize(Pr_corr = mean(Pr_corr_sub),
            SEM = sqrt(var(Pr_corr_sub)/length(Pr_corr_sub)))
learning_curve_df$condition = factor(learning_curve_df$condition,labels = c("low","medium","high","mixed"))

p = ggplot(data = learning_curve_df,
           aes(y=Pr_corr, x=block,colour = condition)) +
  geom_line(size = .7) +
  geom_point() +
  geom_errorbar(aes(ymin = Pr_corr - SEM, ymax = Pr_corr + SEM, colour = condition), width = .1) +
  xlab("Block") +
  ylab ("Proportion Correct") +
  scale_x_continuous(breaks = 1:10) +
  scale_y_continuous(limits = c(0,1)) +
  labs(color = "Training Variability") +
  theme_bw(base_size = 12) +
  theme(panel.grid.minor = element_blank())


ggsave(paste('learning curve',".jpg"),plot = p ,path = "../figure",width = 6, height = 6)
#-------------------------------------------------------------
# test accuracy by conditions and item types
bar_plot_df = filter(data,phase == 2) %>%
  group_by(condition,itemtype,ID) %>%
  summarize(Pr_corr_sub = mean(correct == 1)) %>%
  ungroup() %>%
  group_by(condition,itemtype) %>%
  summarize(Pr_corr = mean(Pr_corr_sub),
            SEM = sqrt(var(Pr_corr_sub)/length(Pr_corr_sub)))
bar_plot_df$condition = factor(bar_plot_df$condition,labels = c("low","medium","high","mixed"))
bar_plot_df$itemtype = factor(bar_plot_df$itemtype,labels = c("old","proto","newlow","newmed","newhigh","newhigh_hard"))


p = ggplot(aes(y=Pr_corr, x=condition, fill=itemtype), data=bar_plot_df) +
  geom_bar(stat="identity", color = "black", position=position_dodge(.9),width=.8)+
  geom_errorbar(aes(ymin=Pr_corr-SEM, ymax=Pr_corr+SEM),
                size=.5,width=.2,position=position_dodge(.9)) +
  ggtitle("test accuracy") +
  xlab("Training Condition") +
  ylab ("Proportion Correct") +
  scale_fill_discrete(name = "Item Types") +
  theme_bw(base_size = 18)
ggsave(paste("test accuracy",".jpg"),plot = p ,path = "../figure",width = 12, height = 6)

#-------------------------------------------------------------
# histogram of training accuracy
hist_df = filter(data,phase == 1 & block %in% c(8,9,10)) %>%
  group_by(condition,ID) %>%
  summarize(Pr_corr_sub = mean(correct == 1))
N_subj1 = length(unique(hist_df$ID[hist_df$condition == 1]))
N_subj2 = length(unique(hist_df$ID[hist_df$condition == 2]))
N_subj3 = length(unique(hist_df$ID[hist_df$condition == 3]))
N_subj4 = length(unique(hist_df$ID[hist_df$condition == 4]))

cond.labs <- c(paste("low \n N =",N_subj1), paste("medium \n N =",N_subj2),paste("high \n N =",N_subj3),paste("mixed \n N =",N_subj4))
names(cond.labs) <- c(1,2,3,4)

p <- ggplot(hist_df, aes(x=Pr_corr_sub)) + 
  geom_histogram(fill="white", color="black",binwidth = .05) + 
  ggtitle("subject training accuracy by conditions",
          subtitle = "last 3 blocks") +
  xlab('Proportion Correct') +
  ylab('Number of subjects') +
  stat_bin(geom='text', color='black', aes(label=..count..),
           vjust = -.5,binwidth = .05) +
  facet_wrap(~condition, labeller=labeller(condition = cond.labs)) +
  ylim(0,7) +
  theme_bw() +
  theme(plot.title = element_text(size=15, hjust = .5),
        strip.text = element_text(size=12, face = "bold"))

ggsave("training accuracy distribution.jpg",plot = p ,path = "../figure",width = 6, height = 6)




