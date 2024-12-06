library(tidyverse)
library(data.table)
library(gridExtra)
library(grid)
library(ggpubr)
# ---- Load the Data ----
obs_data = read.csv("obs_data.csv");
itemtype = rep(c(1,2,3,4,5),4);
condition = ordered(rep(c(1,2,3,4),each = 5),labels = c("low","med","high","mix"))
obs_val = c(0.860,0.926,0.873,0.771,0.637,
            0.698,0.791,0.745,0.692,0.631,
            0.532,0.636,0.637,0.587,0.512,
            0.697,0.806,0.760,0.696,0.593)

pred_val_base_GCM = c(0.849,0.891,0.846,0.723,0.614,
                      0.690,0.777,0.753,0.677,0.595,
                      0.594,0.665,0.653,0.614,0.563,
                      0.698,0.816,0.779,0.683,0.595)
pred_val_base_PM = c(0.765,0.825,0.763,0.675,0.594,
                     0.677,0.816,0.762,0.674,0.593,
                     0.600,0.805,0.757,0.673,0.594,
                     0.679,0.813,0.760,0.671,0.597)
pred_val_4c_GCM = c(0.876,0.911,0.874,0.760,0.647,
                    0.702,0.784,0.762,0.692,0.611,
                    0.560,0.622,0.613,0.583,0.542,
                    0.695,0.802,0.770,0.685,0.602)
pred_val_4c_PM = c(0.857,0.906,0.855,0.771,0.682,
                   0.683,0.812,0.762,0.683,0.609,
                   0.519,0.664,0.627,0.568,0.518,
                   0.686,0.812,0.763,0.683,0.609)


obs_data <- data.frame(condition = condition,itemtype = itemtype, data_val = obs_val)
dev_1c_GCM <- data.frame(condition = condition,itemtype = itemtype, data_val = pred_val_base_GCM)
dev_1c_PM <- data.frame(condition = condition,itemtype = itemtype, data_val = pred_val_base_PM)
dev_4c_GCM <- data.frame(condition = condition,itemtype = itemtype, data_val = pred_val_4c_GCM)
dev_4c_PM <- data.frame(condition = condition,itemtype = itemtype, data_val = pred_val_4c_PM)

#--------barplot-------------------------------------------
# plot_lines <- function(obs_data,pred_data,title = "",legend = "right",size = 3,xlab = "", ylab = ""){
#       line_data <- filter(pred_data,itemtype != 1)
#         
#       ggplot(data=NULL,aes(x = itemtype, linetype = condition)) +
#       geom_point(data = obs_data,aes(y = data_val,shape = condition),size = size) +
#       geom_point(data = pred_data,aes(y = data_val,shape = condition),size = size - 2) + 
#       geom_line(data = line_data,aes(y = data_val)) +
#       scale_shape_manual(values = c("circle open","triangle open","plus","cross")) +
#       scale_x_continuous(breaks = 1:5,labels = c("old","proto","newlow","newmed","newhigh"),expand = expansion(add = c(.5,.5))) +
#       scale_linetype_manual(values = c("solid","dashed","dotted","dotdash"), labels = c("low","med","high","mix")) +
#       ylim(0.4,1) +
#       xlab(xlab) +
#       ylab(ylab) +
#       ggtitle(title) +
#       labs_pubr() +
#       theme(title = element_text(size = 15),
#             text =  element_text(size = 15),
#             axis.title.x = element_blank(),
#             axis.ticks.x = element_line(),
#             legend.position = legend)
# }
# 
# 
# combine_plots <- function(obs_data,pred_data1,pred_data2,pred_data3,pred_data4){
#   legend_plot <- plot_lines(obs_data,pred_data1,size = 2)
#   pred_plot1 <- plot_lines(obs_data,pred_data1,"Exemplar Model:1c",legend = "none")
#   pred_plot2 <- plot_lines(obs_data,pred_data2,"Prototype Model:1c",legend = "none")
#   pred_plot3 <- plot_lines(obs_data,pred_data3,"Exemplar Model:4c",legend = "none")
#   pred_plot4 <- plot_lines(obs_data,pred_data4,"Prototype Model:4c",legend = "none")
#   plots = list(pred_plot1,pred_plot2,pred_plot3,pred_plot4)
#   bottom_object <- textGrob("Pattern Type", gp = gpar(fontsize = 20))
#   left_object <- textGrob("Proportion Correct", gp = gpar(fontsize = 20),rot = 90)
#   legend_grob <- ggplotGrob(legend_plot)$grobs[[which(ggplotGrob(legend_plot)$layout$name == "guide-box")]]
#   grid.arrange(grobs = plots,nrow = 2,bottom = bottom_object,left = left_object,right = legend_grob)
# }

plot_lines <- function(data,title = "",legend = "right",size = 5,xlab = "", ylab = ""){
  line_data <- filter(data,itemtype != 1)
  
  ggplot(data=NULL,aes(x = itemtype, linetype = condition)) +
    geom_point(data = data,aes(y = data_val,shape = condition),size = size) + 
    geom_line(data = line_data,aes(y = data_val)) +
    scale_shape_manual(values = c("circle open","triangle open","plus","cross")) +
    scale_x_continuous(breaks = 1:5,labels = c("old","proto","low","med","high"),expand = expansion(add = c(.5,.5))) +
    scale_linetype_manual(values = c("solid","dashed","dotted","dotdash"), labels = c("low","med","high","mix")) +
    ylim(0.4,1) +
    xlab(xlab) +
    ylab(ylab) +
    ggtitle(title) +
    labs_pubr() +
    theme(title = element_text(size = 22),
          text =  element_text(size = 22),
          axis.title.x = element_blank(),
          axis.ticks.x = element_line(),
          legend.position = legend,
          legend.key.size = unit(22, "points"),
          plot.margin = margin(0,0,0,0, unit = "points"))
}


combine_plots <- function(obs_data,pred_data1,pred_data2,pred_data3,pred_data4){
  legend_plot <- plot_lines(obs_data,size = 2)
  obs_plot   <- plot_lines(obs_data,"Observed",legend = "none")
  pred_plot1 <- plot_lines(pred_data1,"Exemplar Model:1c",legend = "none")
  pred_plot2 <- plot_lines(pred_data2,"Prototype Model:1c",legend = "none")
  pred_plot3 <- plot_lines(pred_data3,"Exemplar Model:4c",legend = "none")
  pred_plot4 <- plot_lines(pred_data4,"Prototype Model:4c",legend = "none")
  plots = list(obs_plot,pred_plot1,pred_plot2,pred_plot3,pred_plot4)
  bottom_object <- textGrob("Pattern Type", gp = gpar(fontsize = 18))
  left_object <- textGrob("Proportion Correct", gp = gpar(fontsize = 18),rot = 90)
  legend_grob <- ggplotGrob(legend_plot)$grobs[[which(ggplotGrob(legend_plot)$layout$name == "guide-box")]]
  grid.arrange(grobs = plots,nrow = 1,
               bottom = bottom_object,left = left_object,right = legend_grob,
               padding = unit(20,"points"))
}


model_plot <-  combine_plots(obs_data,dev_1c_GCM,dev_1c_PM,dev_4c_GCM,dev_4c_PM)

ggsave(paste0('model_predictions','.jpg'),plot = model_plot, width = 20, height = 5)






