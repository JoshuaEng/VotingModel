rm(list = ls())
library(tidyverse)
library(hrbrthemes)



## ------------------- import data --------------------##
setwd("C:/Users/Joshua Engels/Desktop/A-Voting-Folder/Papers and Data Analysis/2020 ICCM/Data")
votes <- read_delim("multi_layout_summary_50.csv",col_names=TRUE, delim=",")
# maxY = 500
# votes = filter(votes, yPos < maxY)


## ------------------- add columns --------------------##

# Add a new binary column whether this race was skipped or not
votes$yesVoted <- votes$votedOn >= 0

## ------------------ calculate values to graph ------##

averageError = mean(votes$yesVoted)

# Eror rate by various spacing variables
raceSpaceError <- votes %>% group_by(raceSpace) %>% summarise(
  percentVotedOn = mean(yesVoted)
)
titleSpaceError <- votes %>% group_by(titleSpace) %>% summarise(
  percentVotedOn = mean(yesVoted)
)
candidateSpaceError <- votes %>% group_by(candidateSpace) %>% summarise(
  percentVotedOn = mean(yesVoted)
)

# Error rate by column
columnError <- votes %>% group_by(column) %>% summarise(
  percentVotedOn = mean(yesVoted)
)

# Error rate by y column bin
# yError <- votes %>% group_by(bins) %>% summarise(
#   percentVotedOn = mean(yesVoted))

# Error rate by size of race
raceLengthError <- votes %>% group_by(raceLength) %>% summarise(
  percentVotedOn = mean(yesVoted))

## --------------------- show graphs -------------- ##

# Error rate by space between races
averageSuccess = mean(votes$yesVoted)
ggplot(
  raceSpaceError,
  aes(x=raceSpace, y=100 * (1 - percentVotedOn))) + geom_point() + 
  theme_minimal() + 
  labs(
       x="Pixels Between Races", 
       y = "Percent Error") +
  geom_hline(yintercept=100 * (1 - averageSuccess), linetype="dashed", color = "red") +
  geom_smooth(method='lm') +
  coord_cartesian(ylim=c(8,18))


# # Y position start frequency
# ggplot(votes, aes(bins * 10)) +
#   geom_bar(width = 8, fill="steelblue") +
#   theme_minimal() + 
#   labs(title="Y Position Histogram", 
#        x="Y Position (bin size = 10 pixels, from the top)", 
#        y = "Number of Races")

# # Error rate by y position
# ggplot(
#   yError,
#   aes(x=bins * 10, y = 1 - percentVotedOn)) +
#   geom_bar(stat="identity", fill="steelblue", width=8) +
#   theme_minimal() + 
#   labs(title="Voting Error by Y Position (pixels from screen top)", 
#        x="Y Position", 
#        y = "Percent Error")
# 
# Error rate by column position
ggplot(
  columnError,
  aes(x=column, y = 100 * (1 - percentVotedOn))) +
  geom_bar(stat="identity", fill="blue", width=0.7) +
  theme_minimal() +
  labs(
       x="Column Number",
       y = "Percent Error")

# Error rate by race length
ggplot(raceLengthError, aes(x = raceLength, y = 100 * (1 - percentVotedOn))) +
  geom_bar(stat = "identity", width = 0.7, fill="red") +
  theme_minimal() + 
  labs(
       x="Number of Candidates Per Race", 
       y = "Percent Error")






# -------------- More interesting graphs

position_map <- function(binSize, maxY){
  
  # Maybe excludes the lower part of the graph
  votes$bins <- floor(votes$yPos / binSize)
  newVotes = filter(votes, yPos < maxY)
  maxBins <- max(votes$bins)
  
  
  # By position on screen:
  positionError <- newVotes %>% 
    group_by(bins, column) %>% 
    summarise(percentVotedOn = mean(yesVoted))
  
  ggplot(positionError, 
         aes(x=column, y=(maxBins - bins) * binSize, fill=100 * (1 - percentVotedOn))) + geom_tile() +
    scale_fill_distiller(palette = "Reds", name = "Percent Error", direction="horizontal") +
    xlab("Column Number") +
    ylab("Pixels from Bottom") +
    theme_minimal()
  }

position_map(10, 600)
position_map(10, 500)


# Error rate by space before
library(reshape2)
binSize = 5
votes$before_bins <- floor(votes$closest_before / binSize)
closestBeforeError <- filter(votes, before_bins >= 0) %>% 
  group_by(before_bins) %>% summarise(
  totalVotedOn = sum(yesVoted),
  totalNotVotedOn = n() - sum(yesVoted))

testtest <- melt(closestBeforeError, id=c("before_bins"))

# By dif from race before
# Stacked
ggplot(testtest, aes(fill=variable, y=value, x=binSize * before_bins)) + 
  geom_bar(position="stack", stat="identity") + 
  labs(
       x="Verticle pixel distance to closest race in prior column", 
       y = "Number of races") +
  scale_fill_manual(name = "Legend", labels = c("Voted on", "Not voted on"), values = c("blue", "red")) +
  coord_cartesian(xlim=c(0,75)) +
  theme_minimal() +
  theme(text = element_text(size=13))

  

test <- votes %>% group_by(before_bins) %>% tally()
