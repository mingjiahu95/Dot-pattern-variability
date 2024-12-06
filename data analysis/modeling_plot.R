library(data.table)
library(ggplot2)
library(purrr)
library(gridExtra)
library(tidyr)
library(dplyr)
source('utils.R')
# ---- Load the Data ----
overall_data = read.csv("barplot_data.csv");
pattern_data = read.csv("scatterplot_data.csv");

#--------barplot-------------------------------------------
obs_data = select(overall_data,c(itemtype,obs))
pred_data = select(overall_data,-obs) %>%
gather(key = "model",value = "pred",-itemtype)
barplot = ggplot(data=NULL, aes(x = itemtype)) +
          geom_bar(data = obs_data,aes(y = obs),stat = "identity",fill = "white",color = "black",width = .7) +
          geom_line(data = pred_data,aes(linetype = model, y = pred, color = model),stat = "identity") +
          geom_point(data = pred_data,aes(y = pred, color = model),stat = "identity",size = 2) +
          scale_x_continuous(breaks = 1:6,labels = c("oldlow","proto","newlow","newmed","newhigh","special")) +
          scale_linetype_manual(values = c("solid","dotted","dashed","twodash"),
                                breaks = c("pred_sim","pred_coord","pred_f18","pred_f18_full"),
                                labels = c("similarity","coordinate","feature(low_train)","feature(mixed_train)")) +
          scale_color_manual(values = c("red","green","blue","purple"),
                             labels = c("similarity","coordinate","feature(low_train)","feature(mixed_train)")) +
          ylim(0,1) +
          xlab("Item Type") +
          ylab("Percent Correct") +
          theme_bw() +
          theme(plot.title = element_text(hjust = .5),
                plot.subtitle = element_text(hjust = .5),
                strip.text = element_text(size = 12, face = "bold.italic"))

#--------scatterplot------------
pattern_data$itemtype = factor(pattern_data$itemtype,labels = c("oldlow","proto","newlow","newmed","newhigh","special"))
model.labs <- c("GCM:similarity", "GCM:coordinate","GCM:feature(low_train)","GCM:feature(mixed_train)")
names(model.labs) <- c("1", "2","3","4")
scatterplot = ggplot(data = pattern_data, aes(x=pred_val, y=obs_val)) +
              geom_point(aes(color = itemtype),size = 2,shape = 16) + #check_overlap = TRUE
              geom_abline() +
              facet_grid(. ~ model,labeller = labeller(model = model.labs)) +
              ggtitle(label = "observed vs. theoretical classification accuracy") +
              xlab ("predicted accuracy") +
              ylab ("observed accuracy") +
              coord_equal(xlim = c(0,1),ylim = c(0,1)) +
              scale_color_discrete(name = "Item Type") +
              theme_bw() +
              theme(plot.title = element_text(hjust = .5),
                    plot.subtitle = element_text(hjust = .5),
                    strip.text = element_text(size = 12, face = "bold.italic"))

ggsave(paste0('overall accuracy','.jpg'),plot = barplot ,path = paste0("../modeling analysis/v1/figure"), width = 8, height = 8)
ggsave(paste0('item-level accuracy','.jpg'),plot = scatterplot ,path = paste0("../modeling analysis/v1/figure"), width = 18, height = 6)
