library(rstatix)
library(ggplot2)
library(forcats)


# select certain proportion of subjects for each subject
ID_outliers = read.csv("accuracy_train.csv") %>%
  select(!X) %>%
  filter(block %in% c(8,9,10)) %>%
  group_by(condition,ID) %>%
  summarize(PrCorr_sub = mean(Pr_corr_sub)) %>%
  group_by(condition) %>%
  mutate(outlier_TF = cume_dist(PrCorr_sub) >= .5)

ID_top50 = with(ID_outliers,ID[outlier_TF == TRUE])

# preprocess training data for learning curves
PrCorr_mean_train = read.csv("accuracy_train.csv") %>%
                    select(!X) %>%
                    mutate(condition = factor(condition,labels = c("low","med","high","mixed")),ordered = T) %>%
                    mutate(accu_group = ifelse(ID %in% ID_top50,"high50","low50")) %>%
                    group_by(condition,block,accu_group) %>%
                    summarize(PrCorr = mean(Pr_corr_sub),
                              PrCorr_error = sd(Pr_corr_sub) / sqrt(n()))
# plot the learning curves
# custom_labels <- labeller(accu_group = c(A = "Group A", B = "Group B"))
p <- ggplot(data = PrCorr_mean_train,aes(y= PrCorr, x= block, colour = condition)) +
     geom_line(linewidth = .7) +
     geom_point() +
    # geom_errorbar(aes(ymin = PrCorr - PrCorr_error, ymax = PrCorr + PrCorr_error, colour = condition), width = .1) +
     xlab("Block") +
     ylab ("Proportion Correct") +
     scale_x_continuous(breaks = 1:10) +
     scale_y_continuous(limits = c(0,1)) +
     labs(color = "Training Condition") +
     facet_grid(.~accu_group) +
     theme_bw(base_size = 12) +
     theme(panel.grid.minor = element_blank())


ggsave(paste('learning curve',".jpg"),plot = p ,path = "../figure/v2/median_split",width = 12, height = 6)

# preprocess test data for line plots
PrCorr_mean_test = read.csv("accuracy_test.csv") %>%
                   select(!X) %>%
                   mutate(condition = factor(condition,labels = c("low","med","high","mixed")),ordered = T) %>%
                   # mutate(itemtype = factor(itemtype,labels=c("old","proto","newlow","newmed","newhigh")),ordered = T) %>%
                   mutate(accu_group = ifelse(ID %in% ID_top50,"high50","low50")) %>%
                   group_by(condition,itemtype,accu_group) %>%
                   summarize(PrCorr = mean(Pr_corr_sub),
                             PrCorr_error = sd(Pr_corr_sub) / sqrt(n()))

# draw the line plots
p <- ggplot(data=NULL,aes(x = itemtype, color = condition)) +
     geom_point(data = filter(PrCorr_mean_test,itemtype != 1),aes(y = PrCorr),size = 3, shape = 16) +
     geom_point(data = filter(PrCorr_mean_test,itemtype == 1),aes(y = PrCorr),size = 4,shape = 18) +
     geom_line(data = filter(PrCorr_mean_test,itemtype != 1),aes(y = PrCorr),linetype = "solid") +
     scale_x_continuous(name = "Pattern Type", breaks = 1:5,labels = c("old","proto","newlow","newmed","newhigh")) +
     scale_color_manual(values = c("red", "blue", "green", "orange"), labels = c("low","med","high","mix")) +
     facet_grid(.~accu_group) +
     ylim(0.3,1) +
     xlab("") +
     ylab("") +
     guides(shape = guide_legend(override.aes = list(shape = 18))) +
     theme_bw() +
     theme(title = element_text(size = 20),
           text =  element_text(size = 15))

ggsave(paste('test accuracy',".jpg"),plot = p ,path = "../figure/v2/median_split",width = 12, height = 6)


                    