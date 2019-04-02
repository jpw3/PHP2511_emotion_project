## Experiment 1 Replication 

library(tidyverse)
library(psych)
dataPath <- "C:/Users/jheffner/Documents/Classes/PHP2511_emotion_project/CleanedData/Exp1TestData.csv"
d0 <- read.csv(dataPath, header = TRUE)
#names(d0)

d1 <- d0 %>%
  select(BodilySensationStrength_medianZ:LastTime_medianZ)
names(d1)

# Rough rename
d2 <- d1 %>%
  mutate(Bodily_Saliency = (BodilySensationStrength_medianZ), 
         Mind_Saliency = (MindSensationStrength_medianZ), 
         Emotion = (EmotionIntensity_medianZ), 
         Controllability = (Controllability_medianZ), 
         Lapse = (LastTime_medianZ))

# Histograms
d3 <- d2 %>%
  select(Bodily_Saliency:Lapse)

## Graph aesthetics
pnas_theme = theme_bw(base_size = 16) +
  theme(text = element_text(size = 16), # Increase the font size
        panel.grid = element_blank(), 
        axis.ticks = element_blank()) # remove x & y ticks

## Histogram function 
emotion_hist <- function(df) { # df can only have *1* columns
  
  # Histogram plot
  emotion_hist_plot <- ggplot(df, aes_string(x = names(df))) + #aes_string() necessary here
    geom_histogram(fill = "white", color = "black", binwidth = .2) + 
    coord_cartesian(ylim = c(0, 30), xlim = c(-3, 3), expand = FALSE) +
    pnas_theme
  
  return(emotion_hist_plot)
}

## Scatter plot function 
emotion_scatter <- function(df) {
  
  # Correlation number and significance
  cor_value <- sprintf("%.2f", round(cor(df[,1], df[,2]), 2))
  cor_test <- cor.test(df[,1], df[,2])
  
  # Histogram plot
  emotion_scatter_plot <- ggplot(df) + 
    aes_string(x = names(df)[1], y = names(df)[2]) + #aes_string() necessary here
    geom_point(size = 2) +
    geom_smooth(method = "lm", se = FALSE, linetype = "dashed", color = "red", size = 2) +
    coord_cartesian(ylim = c(-3, 3), xlim = c(-3, 3), expand = FALSE) +
    annotate("text", x = -2.5, y = 2.5, label = cor_value, size = 7) +
    pnas_theme
  
  return(emotion_scatter_plot)
}

## Bodily saliency & Mental saliency
names(d3)
cor1 <- d3 %>% select(Bodily_Saliency, Mind_Saliency)
cor1_plot <- emotion_scatter(cor1)
cor1_plot

## Bodily saliency

bod_sen <- d3 %>%
  select(Bodily_Saliency)

range(bod_sen$Bodily_Saliency)

ggplot(bod_sen, aes(x = Bodily_Saliency)) + #aes_string() necessary here
  geom_histogram(fill = "white", color = "black", binwidth = .2) + 
  coord_cartesian(ylim = c(0, 30), xlim = c(-3, 3))


test <- emotion_hist(bod_sen)
test







# Control - emotion 
test <- d3 %>%
  select(Controllability, Emotion)

cor(test$Controllability, test$Emotion)
cor.test(test$Controllability, test$Emotion)

ggplot(test, aes(x = Emotion, y = Controllability)) + 
  geom_point(size = 2) + 
  geom_smooth(method = "lm", se = FALSE) + 
  scale_x_continuous(limits = c(-3, 3)) + 
  scale_y_continuous(limits = c(-3, 3)) +
  pnas_theme


pairs.panels(d3)

bod_sen <- d3 %>%
  select(Bodily_Saliency)


