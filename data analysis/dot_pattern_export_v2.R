
library(data.table)
library(ggplot2)
library(dplyr)
library(purrr)
library(gridExtra)
library(tidyr)
library(stringr)

# ---- Load the Data ----
setwd("../data/v2")
files = dir(pattern = "*.txt")
data = do.call(rbind, lapply(files, read.table))
nrows = sapply(files, function(f) nrow(read.table(f)) )
setwd("../../data analysis")

# ---- Structure the data ----
#
data = subset(data,select=1:28)
colnames(data) = c("phase","block","trial","itemtype","category","token","distortion","response","correct","rt",
                   "dot1x","dot1y","dot2x","dot2y","dot3x","dot3y","dot4x","dot4y","dot5x","dot5y","dot6x","dot6y","dot7x","dot7y","dot8x","dot8y","dot9x","dot9y")

ID_unique = str_extract(files,"(?<=sub)\\d+")
data$ID = rep(ID_unique,nrows)
data$phase = as.integer(data$phase) #1 = "train", 2 = "test"
data$block = as.integer(data$block) #"training": 1-10, "test":1
data$category = as.integer(data$category)#1 - 3: A - C
data$response = as.integer(data$response)#1 - 3: A - C
data$itemtype = as.integer(data$itemtype)# 1: "old", 2: "proto", 3: "newlow", 4:"newmed", 5: "newhigh"
cond_fileidx = ifelse(grepl("cond1",files),1,ifelse(grepl("cond2",files),2,ifelse(grepl("cond3",files),3,4)))
data$condition = rep(cond_fileidx,nrows) #cond1:low, cond2:med, cond3:high, cond4:mixed
data$trial = as.integer(data$trial)
data$correct = as.integer(data$correct)
data$distortion = as.integer(data$distortion)

#-----------------------------------------------------
# export the pattern indices by category and distortion level
pattern_coords_df = select(data,ID,phase,itemtype,category,token,dot1x:dot9y) %>%
                    arrange(ID,phase,itemtype,category,token) %>%
                    distinct()
write.csv(pattern_coords_df,file = "pattern_coords.csv")

#-------------------------------------------------------------
# training accuracy by conditions and item types
train_accu_df = filter(data,phase == 1) %>%
                group_by(condition,ID,block) %>%
                summarize(Pr_corr_sub = mean(correct == 1)) 
write.csv(train_accu_df,file = "train_accuracy.csv")


# test accuracy by conditions and item types
test_accu_df = filter(data,phase == 2) %>%
  group_by(ID,itemtype) %>%
  summarize(Pr_corr_sub = mean(correct == 1)) %>%
  spread(ID,Pr_corr_sub)
#itemtype: c("old","proto","newlow","newmed","newhigh"))
write.csv(test_accu_df,file = "test_accuracy.csv")
#-----------------------------------------------------
# export the pattern coordinates, category and mean accuracy by condition and itemtype
pattern_accu_df = filter(data,phase == 1) %>%
  select(c(condition,block,category,ID,response)) %>%
  arrange(condition,block,category) %>%
  group_by(condition,block,category) %>%
  summarize(N_A = sum(response == 1),
            N_B = sum(response == 2),
            N_C = sum(response == 3),
            N_subj = n_distinct(ID))

# pattern_coords_df = filter(data,phase == 1) %>%
#   select(c(condition,block,category,token) | dot1x:dot9y) %>%
#   arrange(condition,block,category,token) %>%
#   distinct()

# pattern_info_df = inner_join(pattern_accu_df,pattern_coords_df)
write.csv(pattern_accu_df,file = "pattern_info_train.csv")

pattern_accu_df = filter(data,phase == 2) %>%
  select(c(condition,itemtype,response,correct,ID)) %>%
  arrange(condition,ID,itemtype) %>%
  group_by(condition,ID,itemtype) %>%
  summarize(PrCorr = mean(correct))

# pattern_coords_df = filter(data,phase == 2,!ID %in% c(17,10,20,9,15)) %>%
#   select(c(condition,itemtype,category,token) | dot1x:dot9y) %>%
#   arrange(condition,itemtype,category,token) %>%
#   distinct()

# pattern_info_df = inner_join(pattern_accu_df,pattern_coords_df)
write.csv(pattern_accu_df,file = "accuracy_test.csv")
#--------------------------------------------------------------------------------------
