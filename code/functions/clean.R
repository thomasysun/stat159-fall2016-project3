#setwd("C:/Users/Lydia/Documents/Stat159/project3")
#raw2012 <- read.csv("./CollegeScorecard_Raw_Data/MERGED2012_13_PP.csv")
#original dataset, but can't upload to git because too big

#rename columns
colnames(raw2012)[which(colnames(raw2012)== "C100_4")] <- "completion_4yr"
colnames(raw2012)[which(colnames(raw2012)== "C100_L4")] <- "completion_not4yr"

#data documentation tells us this is the variable for earnings
# MN_EARN_WNE_P*
# P* indicates measurement period in years after cohort entry
# eg ten-year earnings (*p10) in the 2011_12 data file refer to the
# 2000-01 and 2001-02 pooled cohorts measured in the 2011 and 2012 calendar years.

#find which index is mean earnings for the institutional aggregate of all federally aided students 
#who enroll in the institution and who are employed but nor enrolled
which(colnames(raw2012)== "MN_EARN_WNE_P10")

#rename columns
colnames(raw2012)[which(colnames(raw2012)== "MN_EARN_WNE_P10")] <- "earnings_agg"

#seperating by income level
colnames(raw2012)[which(colnames(raw2012)== "MN_EARN_WNE_INC1_P10")] <- "earnings_INC1"
colnames(raw2012)[which(colnames(raw2012)== "MN_EARN_WNE_INC2_P10")] <- "earnings_INC2"
colnames(raw2012)[which(colnames(raw2012)== "MN_EARN_WNE_INC3_P10")] <- "earnings_INC3"

#convert non-numbers to NA
raw2012$earnings_INC1 <- as.numeric(as.character(raw2012$earnings_INC1))
raw2012$earnings_INC2 <- as.numeric(as.character(raw2012$earnings_INC2))
raw2012$earnings_INC3 <- as.numeric(as.character(raw2012$earnings_INC3))

##plotting completion rates

#package to unfactor
library("varhandle")
raw2012$completion_4yr <- unfactor(raw2012$completion_4yr)
completion_4yr_bp <- as.vector(raw2012$completion_4yr[!is.na(raw2012$completion_4yr)])

#converting non-numeric to NA
raw2012$completion_4yr <- as.numeric(as.character(raw2012$completion_4yr))
raw2012$completion_not4yr <- as.numeric(as.character(raw2012$completion_not4yr))

boxplot(completion_4yr_bp)
#template for more advanced plots later
#ggplot(ca_nucs, aes(Month, `Total Netgen`, col = `Plant Id`)) 
#+ geom_line(size = .9, alpha = .9) 
#+ ggtitle("Total Generated Power By CA Nuclear Plants over Time")

#getting top 25% of completion
college_names <- raw2012[,which(colnames(raw2012)== "INSTNM")]

college_names[order(raw2012$completion_4yr, decreasing=TRUE)][1:round(length(completion_4yr_bp)/4)]

##getting top 25% of aggregated earnings

#convert non-numbers to NA
raw2012$earnings_agg <- as.numeric(as.character(raw2012$earnings_agg))
earnings_agg <- as.vector(raw2012$earnings_agg[!is.na(raw2012$earnings_agg)])

college_names[order(raw2012$earnings_agg, decreasing=TRUE)][1:round(length(earnings_agg)/4)]

##student population

#low income
#percentage of TitleIV-receiving students from income ranges of $0-30,000
colnames(raw2012)[which(colnames(raw2012)== "INC_PCT_LO")] <- "low_income_pct"
#percentage of TitleIV-receiving students from income ranges of $30,001-48,000
colnames(raw2012)[which(colnames(raw2012)== "INC_PCT_M1")] <- "m1_income_pct"

#share of first generation students
colnames(raw2012)[which(colnames(raw2012)== "PAR_ED_PCT_1STGEN")] <- "firstgen_pct"

#convert non-numbers to NA
raw2012$low_income_pct <- as.numeric(as.character(raw2012$low_income_pct))
raw2012$m1_income_pct <- as.numeric(as.character(raw2012$m1_income_pct))
raw2012$firstgen_pct <- as.numeric(as.character(raw2012$firstgen_pct))

#by race
colnames(raw2012)[which(colnames(raw2012)== "UGDS")] <- "total"
colnames(raw2012)[which(colnames(raw2012)== "UGDS_WHITE")] <- "white"
colnames(raw2012)[which(colnames(raw2012)== "UGDS_BLACK")] <- "black"
colnames(raw2012)[which(colnames(raw2012)== "UGDS_HISP")] <- "hispanic"
colnames(raw2012)[which(colnames(raw2012)== "UGDS_ASIAN")] <- "asian"
colnames(raw2012)[which(colnames(raw2012)== "UGDS_AIAN")] <- "aian"
colnames(raw2012)[which(colnames(raw2012)== "UGDS_NHPI")] <- "pac_islander"
colnames(raw2012)[which(colnames(raw2012)== "UGDS_2MOR")] <- "mixed"
colnames(raw2012)[which(colnames(raw2012)== "UGDS_NRA")] <- "nr_alien"
colnames(raw2012)[which(colnames(raw2012)== "UGDS_UNKN")] <- "unknown"

#getting rid of null values
raw2012$total <- as.numeric(as.character(raw2012$total))
raw2012$white <- as.numeric(as.character(raw2012$white))
raw2012$black <- as.numeric(as.character(raw2012$black))
raw2012$hispanic <- as.numeric(as.character(raw2012$hispanic))
raw2012$asian <- as.numeric(as.character(raw2012$asian))
raw2012$aian <- as.numeric(as.character(raw2012$aian))
raw2012$pac_islander <- as.numeric(as.character(raw2012$pac_islander))
raw2012$mixed <- as.numeric(as.character(raw2012$mixed))
raw2012$nr_alien <- as.numeric(as.character(raw2012$nr_alien))
raw2012$unknown <- as.numeric(as.character(raw2012$unknown))

#turning numeric representations into words: Public/Private Nonprofit/Private For-Profit
raw2012[raw2012$CONTROL == 1,]$CONTROL = "Public"
raw2012[raw2012$CONTROL == 2,]$CONTROL = "Private NonProf"
raw2012[raw2012$CONTROL == 3,]$CONTROL = "Private ForProf"

colnames(raw2012)[which(colnames(raw2012)== "CONTROL")] <- "school_type"

#adding thomas' data
raw2012_thresholdearnings <- read.csv("~/Stat159/project3/data/raw2012_thresholdearnings.csv")
colnames(raw2012_thresholdearnings)[which(colnames(raw2012_thresholdearnings)== "GT_25K_P10")] <- "threshold_earnings"


#make new data frame from variables to be used
clean_2012 <- cbind.data.frame(college_names, raw2012$school_type, raw2012$total, raw2012$white, raw2012$black, raw2012$hispanic,
                    raw2012$asian, raw2012$aian, raw2012$pac_islander, raw2012$mixed, raw2012$nr_alien,
                    raw2012$unknown, raw2012$completion_4yr, raw2012$completion_not4yr, raw2012$earnings_agg,
                    raw2012$earnings_INC1, raw2012$earnings_INC2, raw2012$earnings_INC3, raw2012$low_income_pct,
                    raw2012$m1_income_pct, raw2012$firstgen_pct)
colnames(clean_2012) <- c("College Names", "School Type", "Total", "White", "Black", "Hispanic", "Asian", "Aian",
                          "Pac. Islander", "Mixed", "Non Res Alien", "Unknown", "Completion 4yr", "Completion Non4yr", 
                          "Earnings Agg", "Earnings INC1", "Earnings INC2", "Earnings INC3", "Low Income",
                          "Mid1 Income","First Gen")

saveRDS(clean_2012,
     file = "./data/clean_2012.rds")



#only public schools
clean_2012_public <-clean_2012[clean_2012$`School Type` == "Public" ,]
saveRDS(clean_2012_public,
     file = "./data/clean_2012_public.RData")

#plot of total population vs 4yr completion rates
library("ggplot2")
#total_plot<- na.omit(clean_2012$Total)
p1 <- ggplot(clean_2012, aes(x = total_plot, y = clean_2012$`Completion 4yr`))
p1 + geom_point(aes(color=factor(clean_2012$`School Type`)),
                size = ) +
theme(axis.title.x = element_text(face="bold", color="black", size=12),
      axis.title.y = element_text(face="bold", color="black", size=12),
      plot.title=element_text(size=15, face="bold"),
      axis.ticks.x = element_blank(),
      axis.text.x = element_blank()) +
labs(x = "Total",
     y = "4yr Completion",
     title = "Total Population of School vs 4yr Completion Rates",
     color = "School Type\n") 

p2 <- ggplot(clean_2012, aes(x = total_plot, y = clean_2012$`Completion 4yr`))
p2 + geom_point(aes(color=factor(clean_2012$`School Type`)),
                size = ) +
  theme(axis.title.x = element_text(face="bold", color="black", size=12),
        axis.title.y = element_text(face="bold", color="black", size=12),
        plot.title=element_text(size=15, face="bold"),
        axis.ticks.x = element_blank(),
        axis.text.x = element_blank()) +
  labs(x = "Total",
       y = "4yr Completion",
       title = "Total Population of School vs 4yr Completion Rates",
       color = "School Type\n") 

#graphs
library("lattice")
library("reshape2")

#final results
lowincome25 <-clean_2012$CollegeNames[order(clean_2012$LowIncome, decreasing=FALSE)][1:25]
fedloans25 <-clean_2012$CollegeNames[order(clean_2012$FedLoans, decreasing=FALSE)][1:25]
firstgen25 <-clean_2012$CollegeNames[order(clean_2012$FirstGen, decreasing=FALSE)][1:25]

df <- data.frame(c(lowincome25, fedloans25, firstgen25))

table1 <-table(df)
clean_2012$CollegeNames[c(1872, 2047, 4701, 6876, 6984, 7346, 7498)]
------------------------------------------------------------------------------
#random stuff I was testing out
clean_2012$id <- 1:nrow(clean_2012)
dat <- melt(clean_2012,id.vars = "id")

by_schooltype <- group_by(clean_2012, "School Type")
destinations <- group_by(flights, dest)
summarise(by_schooltype,
          completion = mean(completion_4yr),
          schools = n()
)


ggplot(dat,aes(x=factor(id), y = value))+
  facet_wrap(~variable)+
  geom_bar(aes(fill = factor(id)), stat = "identity")

ggplot(clean_2012, aes(college_names, raw2012$completion_4yr, col = raw2012$school_type)) 
+geom_bar(stat= "identity")
+ scale_y_continuous(name="Completion Rate", limits=c(0, 1), breaks =seq(from =0, to =1, by = 0.05))

coeffs_values$id <- 1:nrow(coeffs_values)
dat <- melt(coeffs_values,id.vars = "id")

ggplot(dat,aes(x=factor(id), y = value))+
  facet_wrap(~variable)+
  geom_bar(aes(fill = factor(id)), stat = "identity")
ggplot(ca_nucs, aes(Month, `Total Netgen`, col = `Plant Id`)) 
+geom_line(size = .9, alpha = .9) 
+ggtitle("Total Generated Power By CA Nuclear Plants over Time")

+geom_line(size = .9, alpha = .9) 
+ggtitle("Total Generated Power By CA Nuclear Plants over Time")

#gets tid of stuff after jan 1st 2016
binned_ts <- monthly_ts_caiso_ngcc %>% filter(as.numeric(Month) < as.numeric(as.Date("2016-01-01"))) %>% group_by(`Plant ID`, Month)
%>% summarise(`Total Netgen` = sum(Netgen, na.rm = TRUE))
%>% left_join(caiso_plant_bins, by="Plant ID")

binned_ts %>% group_by(`Capacity Bin`, Month) 
%>% summarize(`Total Netgen` = sum(`Total Netgen`, na.rm = TRUE))
%>% ggplot(aes(Month, `Total Netgen`, col = `Capacity Bin`)) 
+ geom_smooth(se = FALSE) 
+ geom_vline(xintercept = as.numeric(as.Date("2012-02-01")), linetype=4, col="red", size=1) 
+ ggtitle("Total Generated Power of NGs by Capacity Bin")


#colnames(clean_2012) <- c(CollegeNames, SchoolType, Total, White, Black, Hispanic, Asian, Aian,
#                          Pac.Islander, Mixed, NonResAlien, Unknown, Completion4yr, CompletionNon4yr, 
#                          EarningsAgg, EarningsINC1, EarningsINC2, EarningsINC3)