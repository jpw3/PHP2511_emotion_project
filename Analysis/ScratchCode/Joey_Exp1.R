#### Internal functions ####

## Graph aesthetics
pnas_theme = theme_bw(base_size = 16) +
  theme(text = element_text(size = 16), # Increase the font size
        panel.grid = element_blank(), 
        axis.ticks = element_blank()) # remove x & y ticks


## Histogram function 
emotion_hist <- function(df, colName) {
  
  df <- df %>% select(colName)
  
  # Histogram plot
  emotion_hist_plot <- ggplot(df, aes_string(x = names(df))) + #aes_string() necessary here
    geom_histogram(fill = "white", color = "black", binwidth = .2) + 
    coord_cartesian(ylim = c(0, 30), xlim = c(-3, 3), expand = FALSE) +
    pnas_theme
  
  return(emotion_hist_plot)
}


## Scatter plot function 
emotion_scatter <- function(df, xName, yName) {
  
  df <- df %>% select(xName, yName)
  
  # Correlation number and significance
  cor_value <- sprintf("%.2f", round(cor(df[,1], df[,2], method="spearman"), 2))
  cor_test <- cor.test(df[,1], df[,2], method="spearman")$p.value
  cor_test_text <- if_else(cor_test < 0.005, "**",
                           if_else(cor_test < 0.05, "*", ", n.s."))
  displaySig <- paste0(cor_value, cor_test_text)
  
  # Histogram plot
  emotion_scatter_plot <- ggplot(df) + 
    aes_string(x = names(df)[1], y = names(df)[2]) + #aes_string() necessary here
    geom_point(size = 2) +
    geom_smooth(method = "lm", se = FALSE, linetype = "dashed", color = "red", size = 2) +
    coord_cartesian(ylim = c(-3, 3), xlim = c(-3, 3), expand = FALSE) +
    annotate("text", x = -1.5, y = 2.5, label = displaySig, size = 7) +
    pnas_theme
  
  return(emotion_scatter_plot)
}



#### Experiment 1 Replication ####

# Initialize environment
libraryBooks <- c("knitr", "tidyverse", "cowplot")
invisible(lapply(libraryBooks, require, character.only = TRUE)); rm(libraryBooks)
# library(psych)
# dataPath <- "C:/Users/jheffner/Documents/Classes/PHP2511_emotion_project/CleanedData/Exp1TestData.csv"
scriptPath <- dirname(rstudioapi::getSourceEditorContext()$path)
setwd(scriptPath)
setwd("../")
dataPath <- paste0(getwd(), "/CleanedData")

# Load data
d0 <- read.csv(paste0(dataPath, "/Exp1MeanData.csv"), header = TRUE) %>%
  select(BodilySensationStrength_medianZ:LastTime_medianZ) %>%
  rename(Bodily_Saliency = BodilySensationStrength_medianZ,
         Mind_Saliency = MindSensationStrength_medianZ,
         Emotion = EmotionIntensity_medianZ,
         Controllability = Controllability_medianZ,
         Lapse = LastTime_medianZ)

# Plot correlation
cor1_plot <- emotion_scatter(d0, "Bodily_Saliency", "Mind_Saliency")
cor1_plot

# Plot histogram
hist1_plot <- emotion_hist(d0, "Bodily_Saliency")
hist1_plot






















#names(d0)
# 
# d1 <- d0 %>%
#   select(BodilySensationStrength_medianZ:LastTime_medianZ)
# names(d1)
# 
# # Rough rename
# d2 <- d1 %>%
#   mutate(Bodily_Saliency = (BodilySensationStrength_medianZ), 
#          Mind_Saliency = (MindSensationStrength_medianZ), 
#          Emotion = (EmotionIntensity_medianZ), 
#          Controllability = (Controllability_medianZ), 
#          Lapse = (LastTime_medianZ))
# 
# # Histograms
# d3 <- d2 %>%
#   select(Bodily_Saliency:Lapse)
# 
# ## Bodily saliency & Mental saliency
# # names(d3)
# # cor1 <- d3 %>% select(Bodily_Saliency, Mind_Saliency)
# cor1_plot <- emotion_scatter(d3, "Bodily_Saliency", "Mind_Saliency")
# cor1_plot
# 
## Bodily saliency
# 
# bod_sen <- d3 %>%
#   select(Bodily_Saliency)
# 
# range(bod_sen$Bodily_Saliency)
# 
# ggplot(bod_sen, aes(x = Bodily_Saliency)) + #aes_string() necessary here
#   geom_histogram(fill = "white", color = "black", binwidth = .2) + 
#   coord_cartesian(ylim = c(0, 30), xlim = c(-3, 3))
# 
# 
# test <- emotion_hist(d3, "Bodily_Saliency")
# test
# 
# 
# 
# 
# 
# 
# 
# # Control - emotion 
# test <- d3 %>%
#   select(Controllability, Emotion)
# 
# cor(test$Controllability, test$Emotion)
# cor.test(test$Controllability, test$Emotion)
# 
# ggplot(test, aes(x = Emotion, y = Controllability)) + 
#   geom_point(size = 2) + 
#   geom_smooth(method = "lm", se = FALSE) + 
#   scale_x_continuous(limits = c(-3, 3)) + 
#   scale_y_continuous(limits = c(-3, 3)) +
#   pnas_theme
# 
# 
# pairs.panels(d3)
# 
# bod_sen <- d3 %>%
#   select(Bodily_Saliency)


