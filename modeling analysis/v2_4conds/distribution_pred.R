library(dplyr)
library(ggplot2)

# preprocess data for distribution plots
test_novel_mean <- read.csv("pred_data_sim.csv") %>%
                   filter(itemtype != 1) %>%
                   mutate(itemtype = factor(itemtype,labels=c("proto","newlow","newmed","newhigh"), ordered = T)) %>%
                   mutate(condition = factor(condition,labels = c("low","med","high","mix"), ordered = T)) %>%
                   rename(PrCorr = pred) 
                   # group_by(condition,simulation) %>%
                   # summarize(PrCorr = mean(PrCorr))
  

p<- ggplot(test_novel_mean, aes(x = PrCorr, color = condition)) +
    geom_freqpoly(binwidth = .05, linewidth = .5) +
    facet_wrap(.~itemtype, nrow = 2) +
    xlab("Percent Correct") +
    ylab("Number of Simulations") +
    xlim (0,1) + 
    theme_bw() +
    theme(title = element_text(size = 20),
          text =  element_text(size = 15))

ggsave(paste('predicted accuracy distribution',".jpg"),plot = p ,path = "prediction figures",width = 10, height = 10)

