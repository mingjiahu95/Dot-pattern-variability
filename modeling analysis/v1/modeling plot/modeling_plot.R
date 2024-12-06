library(data.table)
library(ggplot2)
library(purrr)
library(gridExtra)
library(tidyr)
library(dplyr)
#source('utils.R')
# ---- Load the Data ----
itemtype_data = read.csv("barplot_data.csv");
pattern_resp_data = read.csv("scatterplot_data.csv");
itemtype_data$model = factor(itemtype_data$model,labels = c("coordinate","activation","CNN-MDS"))

#--------barplot-------------------------------------------

obs_data = select(itemtype_data,c('itemtype','obs')) %>%
           distinct()
pred_data = select(itemtype_data,c('model','itemtype','pred')) 

barplot = ggplot(data=NULL, aes(x = itemtype)) +
          geom_bar(data = obs_data,aes(y = obs),stat = "identity",fill = "white",color = "black",width = .7) +
          geom_line(data = pred_data,aes(linetype = model, y = pred, color = model),stat = "identity") +
          geom_point(data = pred_data,aes(y = pred, color = model),stat = "identity",size = 2) +
          scale_x_continuous(breaks = 1:6,labels = c("oldmix","proto","newlow","newmed","newhigh","special")) +
          scale_linetype_manual(name = "Similarity Measure",
                                values = c("dashed","dotted","solid")) +
          scale_color_manual(name = "Similarity Measure",
                             values = c("red","green","blue")) +
          ylim(0,1) +
          xlab("Item Type") +
          ylab("Percent Correct") +
          ggtitle("Mixed training condition") +
          theme_bw() +
          theme(title = element_text(size = 20),
                text =  element_text(size = 15))


#--------scatterplot------------
pattern_resp_data$itemtype = factor(pattern_resp_data$itemtype,labels = c("oldmix","proto","newlow","newmed","newhigh","special"))
pattern_resp_data$corr_values = factor(pattern_resp_data$corr_values,labels = c("Incorrect","Correct"))
pattern_resp_data$category_pat = factor(pattern_resp_data$category_pat,labels = c("A","B","C"))
pattern_resp_data$category_resp = factor(pattern_resp_data$category_resp,labels = c("A","B","C"))

model.labs <- c( "Dot Coordinates","CNN Activation","CNN-MDS")
names(model.labs) <- c("1", "2","3")
scatterplot = ggplot(data = pattern_resp_data, aes(x=pred_val, y=obs_val)) +
              geom_point(aes(color = itemtype,shape = corr_values),size = 1.5) + #check_overlap = TRUE
              geom_abline() +
              facet_grid(. ~ model,labeller = labeller(model = model.labs)) +
              ggtitle(label = "Predicted vs. Observed Categorization Proportions") +
              xlab ("Predicted Categorization Proportions") +
              ylab ("Observed Categorization Proportions") +
              coord_equal(xlim = c(0,1),ylim = c(0,1)) +
              scale_color_manual(name = "Item Type",values = c("orange","black","red","blue","purple","green")) + 
              scale_shape_manual(name = "Response", values = c(1,16)) +
              theme_bw() +
              theme(title = element_text(size = 20),
                    text =  element_text(size = 15))

ggsave(paste0('itemtype accuracy_mix','.jpg'),plot = barplot ,path = paste0("figure"), width = 8, height = 8)
ggsave(paste0('categorization proportions_mix','.jpg'),plot = scatterplot ,path = paste0("figure"), width = 18, height = 6)
