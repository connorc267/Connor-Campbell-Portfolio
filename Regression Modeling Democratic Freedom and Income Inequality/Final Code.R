#### Democratic freedom and income inequality regression modeling ####

library(tidyverse)
library(readxl)
library(here)
library(ggthemes)



wdi <- read_xlsx(here("Data", "WDI 2015.xlsx"))

# renaming variables
colnames(wdi)[5] <- "GDP"
colnames(wdi)[6] <- "GINI"
colnames(wdi)[7] <- "Trade"
colnames(wdi)[8] <- "CO2"
colnames(wdi)[9] <- "LifeExpectancy"
colnames(wdi)[10] <- "GovExp"
colnames(wdi)[11] <- "Education_Years"
colnames(wdi)[12] <- "GovExp_Education"
colnames(wdi)[13] <- "r"
colnames(wdi)[14] <- "TenpercentShare"
colnames(wdi)[15] <- "DemocracyIndex"
colnames(wdi)[17] <- "FundRights"
colnames(wdi)[18] <- "Union"

summary(wdi)

# creating histograms to view each variable prior to making model to see if
# any transformations will need to be made
hist(wdi$GDP)
hist(wdi$GINI)
hist(wdi$Trade)
hist(wdi$LifeExpectancy)
hist(wdi$Education_Years)
hist(wdi$GovExp_Education)
hist(wdi$r)
hist(wdi$TenpercentShare)
hist(wdi$DemocracyIndex)
hist(wdi$FundRights)
hist(wdi$Union)

#plotting of variables to get a slightly better look at data
t <- ggplot(wdi, mapping = aes(LifeExpectancy,GINI))+
  geom_point()
t

c <- ggplot(wdi, mapping = aes(Education_Years,GINI))+
  geom_point()
c

s <- ggplot(wdi, mapping = aes(Union,GINI))+
  geom_point()
s

#plotting Gini vs Democracy Index
p <- ggplot(wdi, mapping = aes(DemocracyIndex,GINI))+
         geom_point()
p + ggtitle("GINI Index vs Democracy Index") +
  xlab("Democracy Index") + ylab("GINI")+ theme_classic()



#variance of cor of Democracy Index and Gini
var(wdi$DemocracyIndex,wdi$GINI,na.rm = TRUE)
cor(wdi$DemocracyIndex,wdi$GINI, use = "complete.obs")



#plotting Democracy Index vs Top ten percent share of income
q <- ggplot(wdi, mapping = aes(DemocracyIndex,TenpercentShare))+
  geom_point()
q + ggtitle("Income held by top 10% vs Democracy Index") +
  xlab("Democracy Index") + ylab("Percentage of income held by top 10%") +
  theme_classic()

var(wdi$DemocracyIndex,wdi$TenpercentShare,na.rm = TRUE)
cor(wdi$DemocracyIndex,wdi$TenpercentShare, use = "complete.obs")





#Table of correlation 
numeric <- select(wdi,GINI,Trade,LifeExpectancy,GovExp,DemocracyIndex,
                  Union)
cor(numeric, use = "complete.obs")



# regression model
inequality_reg = lm(GINI ~ Trade +  LifeExpectancy +
                      Education_Years + GovExp + DemocracyIndex + Union, data = wdi)
summary(inequality_reg)


inequality_reg2 = lm(TenpercentShare ~ Trade +  LifeExpectancy +
                      Education_Years + GovExp + DemocracyIndex + Union, data = wdi)
summary(inequality_reg2)


# alternative model 1
inequality_reg3 = lm(GINI ~ LifeExpectancy + Trade + GDP +
                       Education_Years + GovExp + DemocracyIndex + Union, data = wdi)
summary(inequality_reg3)

# alternative model 2
inequality_reg4 = lm(GINI ~ LifeExpectancy + Trade +
                       Education_Years + GovExp + DemocracyIndex, data = wdi)

summary(inequality_reg4)




