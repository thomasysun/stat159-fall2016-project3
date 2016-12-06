#part 2

clean_2012 <- readRDS("../../data/clean_2012.rds")
clean_2012_public <- readRDS("../../data/clean_2012_public.rds")

#graph creation 
#plot of total population vs 4yr completion rates
library("ggplot2")
#total_plot<- na.omit(clean_2012$Total)
jpeg("../../images/totalvs4yrcompletion.png")
p1 <- ggplot(clean_2012, aes(x = clean_2012$Total, y = clean_2012$Completion4yr))
p1 + geom_point(aes(color=factor(clean_2012$SchoolType))) +
  theme(axis.title.x = element_text(face="bold", color="black", size=12),
        axis.title.y = element_text(face="bold", color="black", size=12),
        plot.title=element_text(size=15, face="bold"),
        axis.ticks.x = element_blank(),
        axis.text.x = element_blank()) +
  labs(x = "Total",
       y = "4yr Completion",
       title = "Total Population of School vs 4yr Completion Rates",
       color = "School Type\n") 
dev.off()

#plot of black population vs earnings agg
jpeg("../../images/black_earnings_all.png")
p2 <- ggplot(clean_2012, aes(x = clean_2012$Black, y = clean_2012$EarningsAgg))
p2 + geom_point(aes(color=factor(clean_2012$SchoolType))) +
  theme(axis.title.x = element_text(face="bold", color="black", size=12),
        axis.title.y = element_text(face="bold", color="black", size=12),
        plot.title=element_text(size=15, face="bold"),
        axis.ticks.x = element_blank(),
        axis.text.x = element_blank()) +
  labs(x = "% black pop.",
       y = "Earnings Agg",
       title = "Black Population of School vs Earnings Agg",
       color = "School Type\n")
dev.off()

#same plot, only for public school though
jpeg("../../images/black_earnings_public.png")
p3 <- ggplot(clean_2012_public, aes(x = clean_2012_public$Black, y = clean_2012_public$EarningsAgg))
p3 + geom_point() +
  theme(axis.title.x = element_text(face="bold", color="black", size=12),
        axis.title.y = element_text(face="bold", color="black", size=12),
        plot.title=element_text(size=15, face="bold"),
        axis.ticks.x = element_blank(),
        axis.text.x = element_blank()) +
  labs(x = "% black pop.",
       y = "Earnings Agg",
       title = "Public Schools Black Pop. vs Earnings Agg")
dev.off()

jpeg("../../images/black_completion_public.png")
p4 <- ggplot(clean_2012_public, aes(x = clean_2012_public$Black, y = clean_2012_public$Completion4yr))
p4 + geom_point() +
  theme(axis.title.x = element_text(face="bold", color="black", size=12),
        axis.title.y = element_text(face="bold", color="black", size=12),
        plot.title=element_text(size=15, face="bold"),
        axis.ticks.x = element_blank(),
        axis.text.x = element_blank()) +
  labs(x = "% black pop.",
       y = "Completion Rates",
       title = "%Black Population of School vs 4yr Completion Rates")

jpeg("../../images/avgSAT_histogram.png")
qplot(clean_2012$Avg_SAT ,data = clean_2012, geom = "histogram")
dev.off()

jpeg("../../images/avgSAT_completion.png")
p6 <- ggplot(clean_2012, aes(x = clean_2012$Avg_SAT, y = clean_2012$Completion4yr))
p6 + geom_point(aes(color = clean_2012$EarningsAgg)) +
  labs(x = "Avg SAT Score",
       y = "4 yr Completion Rates",
       title = "Avg SAT Scores vs 4yr Completion Rates",
       color = "Earnings Agg \n")+
  scale_color_gradient2()+
theme(axis.title.x = element_text(face="bold", color="black", size=12),
      axis.title.y = element_text(face="bold", color="black", size=12),
      plot.title=element_text(size=15, face="bold"),
      axis.ticks.x = element_blank(),
      axis.text.x = element_blank())
dev.off()

jpeg("../../images/avgSAT_earnings.png")
p7 <- ggplot(clean_2012, aes(x = clean_2012$Avg_SAT, y = clean_2012$EarningsAgg))
p7 + geom_point() +
  theme(axis.title.x = element_text(face="bold", color="black", size=12),
        axis.title.y = element_text(face="bold", color="black", size=12),
        plot.title=element_text(size=15, face="bold"),
        axis.ticks.x = element_blank(),
        axis.text.x = element_blank()) +
  labs(x = "Avg SAT Score",
       y = "Earnings",
       title = "Avg SAT Scores vs Earnings")
dev.off()

jpeg("../../images/costattend_earnings.png")
p8 <- ggplot(clean_2012, aes(x = clean_2012$CostAttendance, y = clean_2012$EarningsAgg))
p8 + geom_point() +
  theme(axis.title.x = element_text(face="bold", color="black", size=12),
        axis.title.y = element_text(face="bold", color="black", size=12),
        plot.title=element_text(size=15, face="bold"),
        axis.ticks.x = element_blank(),
        axis.text.x = element_blank()) +
  labs(x = "Cost of Attendance",
       y = "Earnings",
       title = "Cost of Attendance vs Earnings")
dev.off()

jpeg("../../images/costattend_completion.png")
p88 <- ggplot(clean_2012, aes(x = clean_2012$CostAttendance, y = clean_2012$Completion4yr))
p88 + geom_point() +
  theme(axis.title.x = element_text(face="bold", color="black", size=12),
        axis.title.y = element_text(face="bold", color="black", size=12),
        plot.title=element_text(size=15, face="bold"),
        axis.ticks.x = element_blank(),
        axis.text.x = element_blank()) +
  labs(x = "Cost of Attendance",
       y = "Completion",
       title = "Cost of Attendance vs Completion")
dev.off()

jpeg("../../images/firstgen_earnings.png")
p9 <- ggplot(clean_2012, aes(x = clean_2012$FirstGen, y = clean_2012$EarningsAgg))
p9 + geom_point() +
  theme(axis.title.x = element_text(face="bold", color="black", size=12),
        axis.title.y = element_text(face="bold", color="black", size=12),
        plot.title=element_text(size=15, face="bold"),
        axis.ticks.x = element_blank(),
        axis.text.x = element_blank()) +
  labs(x = "% First Gen",
       y = "Earnings Agg",
       title = "% First Gen vs Earnings Agg")
dev.off()

jpeg("../../images/firstgen_completion.png")
p9 <- ggplot(clean_2012, aes(x = clean_2012$FirstGen, y = clean_2012$Completion4yr))
p9 + geom_point() +
  theme(axis.title.x = element_text(face="bold", color="black", size=12),
        axis.title.y = element_text(face="bold", color="black", size=12),
        plot.title=element_text(size=15, face="bold"),
        axis.ticks.x = element_blank(),
        axis.text.x = element_blank()) +
  labs(x = "% First Gen",
       y = "Completion",
       title = "% First Gen vs Completion")
dev.off()

jpeg("../../images/lowincome_completion.png")
p10 <- ggplot(clean_2012, aes(x = clean_2012$LowIncome, y = clean_2012$Completion4yr))
p10 + geom_point() +
  theme(axis.title.x = element_text(face="bold", color="black", size=12),
        axis.title.y = element_text(face="bold", color="black", size=12),
        plot.title=element_text(size=15, face="bold"),
        axis.ticks.x = element_blank(),
        axis.text.x = element_blank()) +
  labs(x = "Low Income",
       y = "Completion",
       title = "Low Income vs Completion")
dev.off()

## Correlation Matrix
correlation_matrix = cor(clean_2012[, c(which(colnames(clean_2012)== "Total"),
                      which(colnames(clean_2012)== "White"), which(colnames(clean_2012)== "Black"),
                      which(colnames(clean_2012)== "Hispanic"), which(colnames(clean_2012)== "Asian"),
                      which(colnames(clean_2012)== "Aian"), which(colnames(clean_2012)== "Avg_SAT"),
                      which(colnames(clean_2012)== "EarningsAgg"), which(colnames(clean_2012)== "FirstGen"),
                      which(colnames(clean_2012)== "CostAttendance"), which(colnames(clean_2012)== "ThresholdEarnings"),
                      which(colnames(clean_2012)== "Completion4yr"), which(colnames(clean_2012)== "FedLoans"),
                      which(colnames(clean_2012)== "LowIncome")), ]) 
                        
save(correlation_matrix,
     file = "../../data/correlation-matrix.Rdata")

## Scatter Plot Matrix
jpeg("../../images/scatterplot-matrix.png")
pairs(clean_2012[, c(which(colnames(clean_2012)== "Total"),
                     which(colnames(clean_2012)== "White"), which(colnames(clean_2012)== "Black"),
                     which(colnames(clean_2012)== "Hispanic"), which(colnames(clean_2012)== "Asian"),
                     which(colnames(clean_2012)== "Aian"), which(colnames(clean_2012)== "Avg_SAT"),
                     which(colnames(clean_2012)== "EarningsAgg"), which(colnames(clean_2012)== "FirstGen"),
                     which(colnames(clean_2012)== "CostAttendance"), which(colnames(clean_2012)== "ThresholdEarnings"),
                     which(colnames(clean_2012)== "Completion4yr"), which(colnames(clean_2012)== "FedLoans"),
                     which(colnames(clean_2012)== "LowIncome")), ]) 
dev.off()


#graphs
library("lattice")
library("reshape2")

#rough work
p6 <- ggplot(clean_2012, aes(x = clean_2012$Avg_SAT, y = clean_2012$Completion4yr))
p6 + geom_point(aes(color = cut(clean_2012$ThresholdEarnings, c(0, 0.3, 0.6, Inf)))) +
  scale_color_manual(name = "Threshold Earnings",
                     values = c("(0,0.2]" = "black",
                                "(0.2,0.6]" = "yellow",
                                "(0.6, 1]" = "orange"),
                     labels = c("<= 0.25", "0.25 < qsec <=0.75", "> 0.75"))
theme(axis.title.x = element_text(face="bold", color="black", size=12),
      axis.title.y = element_text(face="bold", color="black", size=12),
      plot.title=element_text(size=15, face="bold"),
      axis.ticks.x = element_blank(),
      axis.text.x = element_blank()) +
  labs(x = "Avg SAT Score",
       y = "4 yr Completion Rates",
       title = "Avg SAT Scores vs 4yr Completion Rates")

ggplot(mtcars, aes(wt, mpg)) + 
  geom_point(aes(colour = cut(qsec, c(-Inf, 17, 19, Inf))),
             size = 5) +
  scale_color_manual(name = "qsec",
                     values = c("(-Inf,17]" = "black",
                                "(17,19]" = "yellow",
                                "(19, Inf]" = "red"),
                     labels = c("<= 17", "17 < qsec <= 19", "> 19"))