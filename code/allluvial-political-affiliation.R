## author: cnoble
## create alluvial diagram to visualize many-response questionnaire 
## and color code by political affiliation

# load packages and read data
library(SubgrPlots)
survey <- read.csv("data/survey2.csv", header = T)

# change column names
names(survey) <- c("y", "robot_replacement", "climate_change", 
                   "transformers_movies", "scientists", "vaccines", 
                   "books", "ghosts", "research_pct", 
                   "adequate_funds", "sun", "smart", "shower")

# drop political affiliations that are not democrat or republican
survey <- survey[which(survey$y =='Democrat' |
                        survey$y == 'Republican'), ]

# Change factor levels
survey$y <- factor(survey$y)
survey$climate_change
levels(survey$climate_change) <- c("DK/ \n REF", "Not Real", 
  "Real, \n People-Caused", "Real, \n not People-Caused")
levels(survey$robot_replacement)[1] <- c("DK/ \n REF")
levels(survey$ghosts)[1] <- c("DK/ \n REF")
levels(survey$sun)[1] <- c("DK/ \n REF")
levels(survey$smart)[1] <- c("DK/ \n REF")
levels(survey$shower)[2] <- c("DK/ \n REF")

# alluvial plot
tp <- as.data.frame(table(survey[c(1:3,8,11:13)]))
tp2 <- tp[tp$Freq!=0,] 

plot_alluvial(tp2[1:7], freq=tp2$Freq, border = NA, rotate = 90,
              cex = 0.75,
         col = ifelse(tp2$y == "Democrat", "darkblue", "darkred"))

