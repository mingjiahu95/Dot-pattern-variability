library(data.table)
library(ggplot2)
library(purrr)
library(gridExtra)
library(tidyr)
library(dplyr)
library(grid)
# ---- Load the Data ----
obs_data = read.csv("obs_data.csv");
itemtype = rep(c(1,2,3,4,5),4);
condition = ordered(rep(c(1,2,3,4),each = 5),labels = c("low","med","high","mix"))
obs_val_allsubs = c(0.860,0.926,0.873,0.771,0.637,
                0.698,0.791,0.745,0.692,0.631,
                0.532,0.636,0.637,0.587,0.512,
                0.697,0.806,0.760,0.696,0.593)
obs_val_top90 = c(0.899,0.976,0.916,0.809,0.657,
              0.730,0.845,0.789,0.732,0.661,
              0.551,0.676,0.683,0.615,0.538,
              0.739,0.866,0.811,0.739,0.626)
pred_val_base_allsubs = c(0.849,0.891,0.846,0.723,0.614,
                           0.690,0.777,0.753,0.677,0.595,
                           0.594,0.665,0.653,0.614,0.563,
                           0.698,0.816,0.779,0.683,0.595)
pred_val_base_top90 = c(0.889,0.927,0.886,0.757,0.638,
                         0.730,0.825,0.799,0.714,0.621,
                         0.630,0.710,0.696,0.648,0.588,
                         0.739,0.866,0.827,0.721,0.621)
pred_val_lowmedhigh_allsubs = c(0.875,0.890,0.874,0.754,0.609,
                                 0.711,0.777,0.771,0.705,0.594,
                                 0.572,0.639,0.637,0.611,0.554,
                                 0.702,0.806,0.793,0.703,0.589)
pred_val_lowmedhigh_top90 = c(0.914,0.926,0.914,0.787,0.630,
                               0.745,0.817,0.812,0.738,0.616,
                               0.599,0.674,0.672,0.640,0.575,
                               0.739,0.853,0.841,0.739,0.611)
pred_val_base_PM_allsubs = c(0.765,0.825,0.763,0.675,0.594,
                             0.677,0.816,0.762,0.674,0.593,
                             0.600,0.805,0.757,0.673,0.594,
                             0.679,0.813,0.760,0.671,0.597)
pred_val_lowmedhigh_PM_allsubs = c(0.799,0.799,0.799,0.691,0.569,
                                   0.692,0.787,0.787,0.691,0.568,
                                   0.575,0.771,0.771,0.688,0.569,
                                   0.682,0.781,0.781,0.689,0.572)

obs_allsubs <- data.frame(condition = condition,itemtype = itemtype, data_val = obs_val_allsubs)
obs_top90 <- data.frame(condition = condition,itemtype = itemtype, data_val = obs_val_top90)
pred_base_allsubs <- data.frame(condition = condition,itemtype = itemtype, data_val = pred_val_base_allsubs)
pred_base_top90 <- data.frame(condition = condition,itemtype = itemtype, data_val = pred_val_base_top90)
pred_lowmedhigh_allsubs <- data.frame(condition = condition, itemtype = itemtype, data_val = pred_val_lowmedhigh_allsubs)
pred_lowmedhigh_top90 <- data.frame(condition = condition, itemtype = itemtype, data_val = pred_val_lowmedhigh_top90)
pred_base_PM_allsubs <- data.frame(condition = condition,itemtype = itemtype, data_val = pred_val_base_PM_allsubs)
pred_lowmedhigh_PM_allsubs <- data.frame(condition = condition, itemtype = itemtype, data_val = pred_val_lowmedhigh_PM_allsubs)

#--------barplot-------------------------------------------
plot_lines <- function(data,title = "",legend = "right",size = 4){
      ggplot(data=NULL,aes(x = itemtype, linetype = condition)) +
      geom_point(data = data,aes(y = data_val,shape = condition),size = size) +
      geom_line(data = filter(data,itemtype != 1),aes(y = data_val)) +
      scale_shape_manual(values = c(1,2,3,4)) +
      scale_x_continuous(breaks = 1:5,labels = c("old","proto","newlow","newmed","newhigh"),expand = expansion(add = c(.5,.5))) +
      scale_linetype_manual(values = c("solid","dashed","dotted","dotdash"), labels = c("low","med","high","mix")) +
      # scale_color_manual(values = c("red", "blue", "green", "orange"), labels = c("low","med","high","mix")) +
      ylim(0.5,1) +
      xlab("") +
      ylab("") +
      ggtitle(title) +
      theme_bw() +
      theme(title = element_text(size = 20),
            text =  element_text(size = 20),
            legend.position = legend)
}


combine_plots <- function(obs_data,pred_data1,pred_data2){
  legend_plot <- plot_lines(obs_data,size = 2)
  obs_plot <- plot_lines(obs_data,"Observed",legend = "none")
  pred_plot1 <- plot_lines(pred_data1,"Exemplar Model",legend = "none")
  pred_plot2 <- plot_lines(pred_data2,"Prototype Model",legend = "none")
  bottom_object <- textGrob("Pattern Type", gp = gpar(fontsize = 20))
  left_object <- textGrob("Proportion Correct", gp = gpar(fontsize = 20),rot = 90)
  legend_grob <- ggplotGrob(legend_plot)$grobs[[which(ggplotGrob(legend_plot)$layout$name == "guide-box")]]
  grid.arrange(obs_plot,pred_plot1,pred_plot2,nrow = 1,bottom = bottom_object,left = left_object,right = legend_grob)
}



# plot_base_allsubs <-  combine_plots(obs_allsubs,pred_base_allsubs)
# plot_lowmedhigh_allsubs <-   combine_plots(obs_allsubs,pred_lowmedhigh_allsubs)
# plot_base_top90 <-  combine_plots(obs_top90,pred_base_top90)
# plot_lowmedhigh_top90 <-   combine_plots(obs_top90,pred_lowmedhigh_top90)
# plot_base_PM_allsubs <-   combine_plots(obs_allsubs,pred_base_PM_allsubs)
# plot_lowmedhigh_PM_allsubs <-   combine_plots(obs_allsubs,pred_lowmedhigh_PM_allsubs)
plot_base_allsubs <-  combine_plots(obs_allsubs,pred_base_allsubs,pred_base_PM_allsubs)

ggsave(paste0('baseline_all_subs','.jpg'),plot = plot_base_allsubs, width = 18, height = 8)




# ggsave(paste0('baseline_all_subs','.jpg'),plot = plot_base_allsubs, width = 12, height = 8)
# ggsave(paste0('baseline_top90','.jpg'),plot = plot_base_top90, width = 12, height = 8)
# ggsave(paste0('lowmedhigh_all_subs','.jpg'),plot = plot_lowmedhigh_allsubs, width = 12, height = 8)
# ggsave(paste0('lowmedhigh_top90','.jpg'),plot = plot_lowmedhigh_top90, width = 12, height = 8)
# ggsave(paste0('baseline_PM_allsubs','.jpg'),plot = plot_base_PM_allsubs, width = 12, height = 8)
# ggsave(paste0('lowmedhigh_PM_allsubs','.jpg'),plot = plot_lowmedhigh_PM_allsubs, width = 12, height = 8)



