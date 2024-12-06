library(tidyverse)
library(ggpubr)


itemtype_levels <- c("old","proto","low","med","high")
condition_levels <- c("low","med","high","mix")
accu_bin_levels <- paste("Quartile",1:4)
# preprocess test data for line plots
PrCorr_test_full <- read.csv("accuracy_test.csv") %>%
                    select(!X) %>%
                    mutate(condition = factor(condition,levels = 1:4, labels = condition_levels), 
                           itemtype = factor(itemtype,levels = 1:5, labels = itemtype_levels),
                           ID = as.integer(ID)) 
                          
PrCorr_subj_by_cond_ID <- PrCorr_test_full %>%
                              group_by(condition,ID) %>%
                              summarize(Pr_corr_sub_overall = mean(Pr_corr_sub),
                                        Pr_corr_sub_old = mean(Pr_corr_sub[itemtype == "old"])) %>%
                              ungroup()


PrCorr_test_quartiles <- PrCorr_subj_by_cond_ID %>%
                         group_by(condition) %>%
                         mutate(accu_bin = ntile(Pr_corr_sub_overall,4),
                                accu_bin = factor(accu_bin, levels = 1:4, labels = accu_bin_levels)) %>%
                         select(-c(Pr_corr_sub_old,Pr_corr_sub_overall)) %>%
                         ungroup() %>%
                         right_join(PrCorr_test_full, by = c("condition","ID")) %>%
                         group_by(condition,accu_bin,itemtype) %>%
                         summarize(Pr_corr_quartile = mean(Pr_corr_sub))
                        
                             
# draw the line plots
line_data <- filter(PrCorr_test_quartiles,itemtype != "old")

p <- ggplot(data=NULL,aes(x = itemtype,y = Pr_corr_quartile)) +
     geom_point(data=PrCorr_test_quartiles,aes(shape = condition),size = 3) + 
     geom_line(data=line_data,aes(linetype = condition, group = condition)) + 
     scale_shape_manual(values = c("circle open","triangle open","plus","cross")) +
     scale_x_discrete(expand = expansion(add = c(.5,.5))) +
     scale_linetype_manual(values = c("solid","dashed","dotted","dotdash"), 
                           labels = c("low","med","high","mix")) +
     facet_wrap(.~accu_bin, nrow = 2) +
     ylim(0,1) +
     xlab("Pattern Type") +
     ylab("Proportion Correct") +
     # guides(shape = "none", size = "none") +
     labs_pubr() +
     theme(title = element_text(size = 20),
           text = element_text(size = 15))

ggsave(paste('quartile test accuracy',".jpg"),plot = p ,path = "../figure/v2",width = 8, height = 6)


                    