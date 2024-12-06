
library(data.table)
library(ggplot2)
library(dplyr)
library(purrr)
library(gridExtra)
library(tidyr)

# ---- Load the Data ----
setwd("../data/v1")
files = dir(pattern = "*.txt")
data = do.call(rbind, lapply(files, read.table))
nrows = sapply(files, function(f) nrow(read.table(f)) )
setwd("../../data analysis")

# ---- Structure the data ----
#
data = subset(data,select=1:29)
colnames(data) = c("phase","block","trial","itemtype","category","token","distortion","index","response","correct","rt",
                   "dot1x","dot1y","dot2x","dot2y","dot3x","dot3y","dot4x","dot4y","dot5x","dot5y","dot6x","dot6y","dot7x","dot7y","dot8x","dot8y","dot9x","dot9y")

data$ID = rep(1:length(files),nrows)
data$phase = as.integer(data$phase) #1 = "train", 2 = "test"
data$block = as.integer(data$block) #"training": 1-10, "test":1
data$category = as.integer(data$category)#1 - 3: A - C
data$response = as.integer(data$response)#1 - 3: A - C
data$itemtype = as.integer(data$itemtype)# 1: "old", 2: "proto", 3: "newlow", 4:"newmed", 5: "newhigh", 6: "newhigh_hard"
data$token = as.integer(data$token)
data$pat_index = as.integer(data$index)# unique for each category/distortion level
cond_fileidx = ifelse(grepl("cond1",files),1,ifelse(grepl("cond2",files),2,ifelse(grepl("cond3",files),3,4)))
data$condition = rep(cond_fileidx,nrows) #cond1:low, cond2:med, cond3:high, cond4:mixed
data$trial = as.integer(data$trial)
data$correct = as.integer(data$correct)
data$distortion = as.integer(data$distortion)

#-----------------------------------------------------
# export the pattern indices by category and distortion level
pattern_index_df = select(data,condition,phase,itemtype,token,category,distortion,pat_index) %>%
                   arrange(condition,phase,itemtype,category,token) %>%
                   distinct()
write.csv(pattern_index_df,file = "pattern_index.csv")

#-----------------------------------------------------
# export the pattern coordinates, category and mean accuracy by condition and itemtype
pattern_accu_df = filter(data,phase == 1,!ID %in% c(17,10,20,9,15)) %>%
                  select(c(condition,block,category,token,ID,response)) %>%
                  arrange(condition,block,category,token) %>%
                  group_by(condition,block,category,token) %>%
                  summarize(N_A = sum(response == 1),
                            N_B = sum(response == 2),
                            N_C = sum(response == 3),
                            N_subj = n_distinct(ID))

pattern_coords_df = filter(data,phase == 1,!ID %in% c(17,10,20,9,15)) %>%
                    select(c(condition,block,category,token) | dot1x:dot9y) %>%
                    arrange(condition,block,category,token) %>%
                    distinct()

pattern_info_df = inner_join(pattern_accu_df,pattern_coords_df)
write.csv(pattern_info_df,file = "pattern_info_train.csv")

pattern_accu_df = filter(data,phase == 2,!ID %in% c(17,10,20,9,15)) %>%
  select(c(condition,itemtype,category,token,ID,response,correct)) %>%
  arrange(condition,itemtype,category,token) %>%
  group_by(condition,itemtype,category,token) %>%
  summarize(N_A = sum(response == 1),
            N_B = sum(response == 2),
            N_C = sum(response == 3),
            N_subj = n_distinct(ID),
            PrCorr = mean(correct == 1))

pattern_coords_df = filter(data,phase == 2,!ID %in% c(17,10,20,9,15)) %>%
  select(c(condition,itemtype,category,token) | dot1x:dot9y) %>%
  arrange(condition,itemtype,category,token) %>%
  distinct()

pattern_info_df = inner_join(pattern_accu_df,pattern_coords_df)
write.csv(pattern_info_df,file = "pattern_info_test.csv")


#-------------------------------------------------------------
# test accuracy by conditions and item types
test_accu_df = filter(data,phase == 2) %>%
  select(ID,condition,itemtype,correct) %>%
  group_by(ID,condition,itemtype) %>%
  summarize(Pr_corr_sub = mean(correct == 1)) 

write.csv(test_accu_df,file = "../../data analysis/pub_stats/test_resp_subj.csv")

#--------------------------------------------------------------------------------------
# test accuracy by individual patterns
test_accu_old_df = filter(data,phase == 2,itemtype == 1) %>%
  group_by(condition,category,token) %>%
  summarize(Pr_corr = mean(correct == 1)) %>%
  arrange(condition,category,token) %>%
  spread(condition,Pr_corr) %>%
  ungroup() %>%
  select(`1`:`4`)

names(test_accu_old_df) = c("low","med","high","mix")
write.csv(test_accu_old_df,file = "test_accuracy_old.csv")

test_accu_proto_df = filter(data,phase == 2,itemtype == 2) %>%
  group_by(condition,category) %>%
  summarize(Pr_corr = mean(correct == 1)) %>%
  arrange(condition,category) %>%
  spread(condition,Pr_corr) %>%
  ungroup() %>%
  select(`1`:`4`)

names(test_accu_proto_df) = c("low","med","high","mix")
write.csv(test_accu_proto_df,file = "test_accuracy_proto.csv")

test_accu_newlow_df = filter(data,phase == 2,itemtype == 3) %>%
  group_by(condition,category,token) %>%
  summarize(Pr_corr = mean(correct == 1)) %>%
  arrange(condition,category,token) %>%
  spread(condition,Pr_corr) %>%
  ungroup() %>%
  select(`1`:`4`)

names(test_accu_newlow_df) = c("low","med","high","mix")
write.csv(test_accu_newlow_df,file = "test_accuracy_newlow.csv")

test_accu_newmed_df = filter(data,phase == 2,itemtype == 4) %>%
  group_by(condition,category,token) %>%
  summarize(Pr_corr = mean(correct == 1)) %>%
  arrange(condition,category,token) %>%
  spread(condition,Pr_corr) %>%
  ungroup() %>%
  select(`1`:`4`)

names(test_accu_newmed_df) = c("low","med","high","mix")
write.csv(test_accu_newmed_df,file = "test_accuracy_newmed.csv")

test_accu_newhigh_df = filter(data,phase == 2,itemtype == 5) %>%
  group_by(condition,category,token) %>%
  summarize(Pr_corr = mean(correct == 1)) %>%
  arrange(condition,category,token) %>%
  spread(condition,Pr_corr) %>%
  ungroup() %>%
  select(`1`:`4`)

names(test_accu_newhigh_df) = c("low","med","high","mix")
write.csv(test_accu_newhigh_df,file = "test_accuracy_newhigh.csv")

test_accu_newhigh_hard_df = filter(data,phase == 2,itemtype == 6) %>%
  group_by(condition,category) %>%
  summarize(Pr_corr = mean(correct == 1)) %>%
  arrange(condition,category) %>%
  spread(condition,Pr_corr) %>%
  ungroup() %>%
  select(`1`:`4`)

names(test_accu_newhigh_hard_df) = c("low","med","high","mix")
write.csv(test_accu_newhigh_hard_df,file = "test_accuracy_newhigh_hard.csv")


