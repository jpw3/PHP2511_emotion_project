# Initialize environment
libraryBooks <- c("knitr", "tidyverse", "cowplot")
invisible(lapply(libraryBooks, require, character.only = TRUE)); rm(libraryBooks)

# scriptPath <- getwd()
scriptPath <- "~/Documents/GitHub/PHP2511_emotion_project/Analysis"

# Graph aesthetics
pnas_theme = theme_bw(base_size = 10) +
  theme(text = element_text(size = 10), # Increase the font size
        panel.grid = element_blank(), 
        axis.ticks = element_blank()) # remove x & y ticks

# Read in data
d1 <- read.csv(paste0(scriptPath, "/Data/Exp2Classifications.csv"),
               header = TRUE, stringsAsFactors=F) %>%
  select(-DBSCAN_type) %>%
  mutate(sensations = replace(sensations, sensations=="Being conscious", "BeingConscious"),
         sensations = replace(sensations, sensations=="Being dazzled", "BeingDazzled"),
         sensations = replace(sensations, sensations=="Closeness (in social relations)",
                              "ClosenessInSocialRelations"),
         sensations = replace(sensations, sensations=="Feeling nauseous", "FeelingNauseous"),
         sensations = replace(sensations, sensations=="Feeling pain", "FeelingPain"),
         sensations = replace(sensations, sensations=="Feeling touch", "FeelingTouch"),
         sensations = replace(sensations, sensations=="Having cold", "HavingCold"),
         sensations = replace(sensations, sensations=="Having fever", "HavingFever"),
         sensations = replace(sensations, sensations=="Having flu", "HavingFlu"),
         sensations = replace(sensations, sensations=="Having headache", "HavingHeadache"),
         sensations = replace(sensations, sensations=="Having stomach flu", "HavingStomachFlu"),
         sensations = replace(sensations, sensations=="Having toothache", "HavingToothache"),
         sensations = replace(sensations, sensations=="Longing for", "LongingFor"),
         sensations = replace(sensations, sensations=="Self-regulation", "SelfRegulation"),
         sensations = replace(sensations, sensations=="Sexual arousal", "SexualArousal"),
         sensations = replace(sensations, sensations=="Social exclusion", "SocialExclusion"),
         sensations = replace(sensations, sensations=="Social longing", "SocialLonging"))

d2 <- read_csv(paste0(scriptPath, "/Data/Fig2_tSNE_coords.csv")) %>%
  rename(xcoord = Var1, ycoord = Var2, sensations = Row)

d0 <- inner_join(d1, d2) %>%
  select(-DBSCAN_labels) %>%
  rename(dbscan = DBSCAN_class,
         kmeans = KMEANS_class,
         hc = HC_class) %>%
  mutate(dbscan = as.character(dbscan),
         dbscan = recode(dbscan,
                         "-1" = "Between",
                         "1" = "Negative Emotions",
                         "2" = "Positive Emotions",
                         "3" = "Illness",
                         "4" = "Cognition",
                         "5" = "Homeostasis"),
         dbscan = factor(dbscan, levels=c("Between",
                                          "Negative Emotions",
                                          "Positive Emotions",
                                          "Illness",
                                          "Cognition",
                                          "Homeostasis"))) %>%
  mutate(kmeans = as.character(kmeans),
         kmeans = recode(kmeans,
                         "1" = "Positive Emotions & Cognition",
                         "2" = "Illness",
                         "3" = "Negative Emotions",
                         "4" = "Between",
                         "5" = "Homeostasis"),
         kmeans = factor(kmeans, levels=c("Between",
                                          "Negative Emotions",
                                          "Positive Emotions & Cognition",
                                          "Illness",
                                          "Homeostasis"))) %>%
  mutate(hc = as.character(hc),
         hc = recode(hc,
                     "1" = "Homeostasis",
                     "2" = "Cognition",
                     "3" = "Illness",
                     "4" = "Negative Emotions",
                     "5" = "Positive Emotions"),
         hc = factor(hc, levels=c("Negative Emotions",
                                  "Positive Emotions",
                                  "Illness",
                                  "Cognition",
                                  "Homeostasis")))

feelcolors.dbscan <- c("#636363", "#4292c6", "#de2d26", "#756bb1", "#31a354", "#fdae6b")
feelcolors.kmeans <- c("#636363", "#4292c6", "#de2d26", "#756bb1", "#fdae6b")
feelcolors.hc <- c("#4292c6", "#de2d26", "#756bb1", "#31a354", "#fdae6b")

# DBSCAN
plot.dbscan <- ggplot(d0, aes(x=xcoord, y=ycoord, group=dbscan, color=dbscan)) + 
  geom_point(size = 2) +
  geom_label(label=d0$sensations, nudge_x=0.25, nudge_y=0.2,
             size=2, show.legend=FALSE) +
  scale_color_manual(name="DBSCAN",
                     values=feelcolors.dbscan) +
  xlab("t-SNE1") +
  ylab("t-SNE2") +
  pnas_theme +
  guides(color = guide_legend(override.aes = list(size=4))) +
  theme(legend.title = element_text(size = 12),
        legend.text = element_text(size = 10),
        axis.text=element_blank(),
        legend.position="bottom")

# K-MEANS
plot.kmeans <- ggplot(d0, aes(x=xcoord, y=ycoord, group=kmeans, color=kmeans)) + 
  geom_point(size = 2) +
  geom_label(label=d0$sensations, nudge_x=0.25, nudge_y=0.2,
             size=2, show.legend=FALSE) +
  scale_color_manual(name="K-Means",
                     values=feelcolors.kmeans) +
  xlab("t-SNE1") +
  ylab("t-SNE2") +
  pnas_theme +
  guides(color = guide_legend(override.aes = list(size=4))) +
  theme(legend.title = element_text(size = 12),
        legend.text = element_text(size = 10),
        axis.text=element_blank(),
        legend.position="bottom")

# HIERARCHICAL CLUSTERING
plot.hc <- ggplot(d0, aes(x=xcoord, y=ycoord, group=hc, color=hc)) + 
  geom_point(size = 2) +
  geom_label(label=d0$sensations, nudge_x=0.25, nudge_y=0.2,
             size=2, show.legend=FALSE) +
  scale_color_manual(name="Hierarchical Clustering",
                     values=feelcolors.hc) +
  xlab("t-SNE1") +
  ylab("t-SNE2") +
  pnas_theme +
  guides(color = guide_legend(override.aes = list(size=4))) +
  theme(legend.title = element_text(size = 12),
        legend.text = element_text(size = 10),
        axis.text=element_blank(),
        legend.position="bottom")

plot_grid(plot.dbscan, plot.kmeans, plot.hc, ncol=1)

