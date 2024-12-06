library(data.table)
library(ggplot2)
library(purrr)
library(gridExtra)
library(tidyr)
library(dplyr)
library(forcats)
#source('utils.R')
# ---- Load the Data ----
pred_data = read.csv("pred_data_robust.csv"); 
#--------barplot-------------------------------------------
pred_data$condition = factor(pred_data$condition, labels = c("low","med","high","mix"))
pred_data$c = factor(pred_data$c,labels = c("low","moderate","high"))
# pred_data$n_dim = factor(pred_data$n_dim,labels = c("3","6","9"));
pred_data$within = factor(pred_data$within,labels = c("low","moderate","high"))

# names(cond.labs) <- c("1", "2","3","4")
barplot = ggplot(data=NULL, aes(x = itemtype, linetype = condition)) +
          geom_point(data = pred_data,aes(y = pred, shape = condition),size = 4) +
          geom_line(data = filter(pred_data,itemtype != 1),aes(y = pred)) +
          scale_x_continuous(breaks = 1:5,labels = c("old","proto","newlow","newmed","newhigh")) +
          scale_shape_manual(values = c(1,2,3,4)) +
          scale_linetype_manual(values = c("solid","dashed","dotted","dotdash"), labels = c("low","med","high","mix")) +
          # scale_color_manual(values = c("red", "blue", "green", "orange"), labels = cond.labs)+
          facet_grid(vars(within),vars(c),labeller = label_both) +
          ylim(0,1) +
          xlab("Item Type") +
          ylab("Proportion Correct") +
          theme_bw() +
          theme(title = element_text(size = 30),
                text =  element_text(size = 25),
                axis.text.x = element_text(angle = 335,vjust = -.5),
                strip.text = element_text(size = 25),
                legend.text = element_text(size = 30),
                axis.title.y = element_text(margin = margin(r = 30)))



ggsave(paste0('prediction_robust','.jpg'),plot = barplot, width = 20, height = 15)
