library(data.table)
library(ggplot2)
library(purrr)
library(gridExtra)
library(tidyr)
library(dplyr)
#source('utils.R')
# ---- Load the Data ----
pattern_resp_data = read.csv("scatterplot_data_med.csv");


#--------scatterplot------------
## four prototype models
pattern_resp_data$itemtype = factor(pattern_resp_data$itemtype,labels = c("Oldmed","Proto","Newlow","Newmed","Newhigh","Special"))
pattern_resp_data$corr_values = factor(pattern_resp_data$corr_values,labels = c("Incorrect","Correct"))
pattern_resp_data$category_pat = factor(pattern_resp_data$category_pat,labels = c("A","B","C"))
pattern_resp_data$category_resp = factor(pattern_resp_data$category_resp,labels = c("A","B","C"))

model.labs <- c("Aggregate","Coords","CNN","CNN-MDS")
names(model.labs) <- c("1", "2","3","4")
scatterplot = ggplot(data = pattern_resp_data, aes(x=pred_val, y=obs_val)) +
              geom_point(aes(color = itemtype,shape = corr_values),size = 1) +
              geom_abline() +
              facet_wrap(vars(model),labeller = labeller(model = model.labs),nrow = 2) +
              xlab ("Predicted Categorization Proportion") +
              ylab ("Observed Categorization Proportion") +
              coord_equal(xlim = c(0,1),ylim = c(0,1)) +
              scale_color_manual(name = "Item Type",values = c("orange","black","red","blue","purple","green")) + 
              scale_shape_manual(name = "Response", values = c(1,19)) +
              theme_bw() +
              theme(title = element_text(size = 18),
                    text =  element_text(size = 12))
              
ggsave(paste0('categorization proportions_med','.jpg'), plot = scatterplot, width = 18, height = 6)

