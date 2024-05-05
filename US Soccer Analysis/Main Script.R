library(tidyverse)
library(rvest)
library(fuzzyjoin)
library(scales)
library(ggthemes)
library(readxl)
library(here)
library(rio)

## Input and clean USL attendance data ##
html <- read_html("https://soccerstadiumdigest.com/2023-usl-championship-attendance/")

usl_2023_attendance <- html %>% 
  html_node("table") %>% 
  html_table(
    header = TRUE,
  )

usl_2023_attendance <- as.data.frame(usl_2023_attendance)
usl_2023_attendance <- usl_2023_attendance[,-1]
usl_2023_attendance <- usl_2023_attendance[,-7]
usl_2023_attendance <- usl_2023_attendance[-(24:26),]


usl_2023_attendance <- usl_2023_attendance %>% 
  rename(Average = Av.,
         Games = Gms,
         '2022 Average' = '2022')

usl_2023_attendance$Average <- gsub(",","",usl_2023_attendance$Average)
usl_2023_attendance$Totals <- gsub(",","",usl_2023_attendance$Totals)
usl_2023_attendance$`2022 Average` <- gsub(",","",usl_2023_attendance$`2022 Average`)

usl <- usl_2023_attendance %>% 
  mutate_at(c('Average','Totals','2022 Average'), as.numeric)




# Input and clean MLS attendance data
htmlMLS <- read_html("https://soccerstadiumdigest.com/2023-mls-attendance/")

MLS_2023_attendance <- htmlMLS %>% 
  html_node("table") %>% 
  html_table(
    header = TRUE
  )

MLS_2023_attendance <- as.data.frame(MLS_2023_attendance)
MLS_2023_attendance <- MLS_2023_attendance[,-1]
MLS_2023_attendance <- MLS_2023_attendance[,-(7)]
MLS_2023_attendance <- MLS_2023_attendance[-(30:31),]

MLS_2023_attendance <- MLS_2023_attendance %>% 
  rename(Average = Av.,
         Games = Gms,
         '2022 Average' = '2022',
         Totals = Total)

MLS_2023_attendance$Average <- gsub(",","",MLS_2023_attendance$Average)
MLS_2023_attendance$Totals <- gsub(",","",MLS_2023_attendance$Totals)
MLS_2023_attendance$`2022 Average` <- gsub(",","",MLS_2023_attendance$`2022 Average`)

MLS <- MLS_2023_attendance %>% 
  mutate_at(c('Average','Totals','2022 Average'), as.numeric)




# rename points for join - this is to make joining easier in future
# with other data sets 
usl$Team <- gsub("CS Switchbacks FC", "Colorado Springs Switchbacks FC", usl$Team)

MLS$Team <- gsub("LA Galaxy", "Los Angeles Galaxy", MLS$Team)

MLS$Team <- gsub("St. Louis SC", "St. Louis City SC", MLS$Team)

MLS$Team <- gsub("NE Revolution", "New England Revolution", MLS$Team)

MLS$Team <- gsub("LAFC", "Los Angeles FC", MLS$Team)

MLS$Team <- gsub("NYC FC","New York City FC", MLS$Team)

MLS$Team <- gsub("Sporting KC",
                 "Sporting Kansas City", MLS$Team)
MLS$Team <- gsub("SJ Earthquakes",
                 "San Jose Earthquakes", MLS$Team)
MLS$Team <- gsub("NY Red Bulls",
                 "New York Red Bulls", MLS$Team)
usl$Team <- gsub("Rio Grande Valley FC Toros", "Rio Grande Valley FC",
                 usl$Team)

# join attendance together
leagues_joined <-rbind(usl, MLS)



## Adding stadium capacity data ##
htmlstadium <- read_html("https://en.wikipedia.org/wiki/List_of_Major_League_Soccer_stadiums")

stadium_MLS <- htmlstadium %>% 
  html_node("table.wikitable.sortable") %>% 
  html_table(
    header = TRUE,
  )

stadium_MLS <- stadium_MLS %>%
  select(-c(Image,`Ref(s)`)) 

stadium_MLS$Capacity <- readr::parse_number(stadium_MLS$Capacity)

stadium_MLS$Team <- gsub("LA Galaxy", "Los Angeles Galaxy", stadium_MLS$Team)

stadium_MLS$Team <- gsub("St. Louis SC", "St. Louis City SC", stadium_MLS$Team)

stadium_MLS$Team <- gsub("NE Revolution", "New England Revolution", stadium_MLS$Team)

stadium_MLS$Team <- gsub("LAFC", "Los Angeles FC", stadium_MLS$Team)

stadium_MLS$Team <- gsub("NYC FC","New York City FC", stadium_MLS$Team)

stadium_MLS$Team <- gsub("Sporting KC",
                         "Sporting Kansas City", stadium_MLS$Team)
stadium_MLS$Team <- gsub("SJ Earthquakes",
                         "San Jose Earthquakes", stadium_MLS$Team)
stadium_MLS$Team <- gsub("NY Red Bulls",
                         "New York Red Bulls", stadium_MLS$Team)




# Adding USL stadium data
html_usl_stadium <- read_html("https://en.wikipedia.org/wiki/2023_USL_Championship_season")

usl_stadium <- html_usl_stadium %>%
  html_node("table.wikitable.sortable") %>%
  html_table(
    header= T
  )
usl_stadium$Capacity <- readr::parse_number(usl_stadium$Capacity)
usl_stadium$Stadium <- gsub("\\Q[A]\\E","",usl_stadium$Stadium)

usl_stadium$Team <- gsub("CS Switchbacks FC", 
                         "Colorado Springs Switchbacks FC", usl_stadium$Team)
usl_stadium$Team <- gsub("Rio Grande Valley FC Toros", "Rio Grande Valley FC",
                         usl_stadium$Team)


# Merge stadium data with leagues data frame
mls_filter <- stadium_MLS %>%
  subset(select = c("Stadium","Team","Capacity"))

stadium_joined <- rbind(mls_filter, usl_stadium)

# joining data for attendance and stadium capacity
leagues_master <- leagues_joined %>%
  stringdist_inner_join(stadium_joined, by ="Team", max_dist = 3) %>%
  select(-Team.y) %>%
  rename(Teams = Team.x)
# creation of % filled columns
leagues_master <- leagues_master %>%
  mutate("%_2023_Fill" = (Average/Capacity)) %>%
  mutate("%_2022_Fill" = (leagues_master$`2022 Average`/Capacity))


#also making master sheets for mls and usl specific analysis
mls_master <- MLS %>%
  stringdist_inner_join(stadium_MLS, by ="Team", max_dist = 3) %>%
  select(-Team.y) %>%
  rename(Teams = Team.x)
# creation of % filled columns
mls_master <- mls_master %>%
  mutate("%_2023_Fill" = (Average/Capacity)) %>%
  mutate("%_2022_Fill" = (mls_master$`2022 Average`/Capacity))

usl_master <- usl %>%
  stringdist_inner_join(usl_stadium, by ="Team", max_dist = 3) %>%
  select(-Team.y) %>%
  rename(Teams = Team.x)
# creation of % filled columns
usl_master <- usl_master %>%
  mutate("%_2023_Fill" = (Average/Capacity)) %>%
  mutate("%_2022_Fill" = (usl_master$`2022 Average`/Capacity))






## Adding in city and state data for future analysis ##

html_city_USL <- read_html("https://en.wikipedia.org/wiki/USL_Championship")

usl_city <- html_city_USL %>%
  html_nodes("table.wikitable") %>%
  .[2] %>%
  html_table(header = T)

usl_city <- data.frame(Reduce(rbind, usl_city))


# clean table
usl_city<- usl_city[-c(1,14),]
usl_city<- usl_city[,-8]

# separating city and state for USL
usl_city <- separate_wider_delim(usl_city, City, delim = ",", 
                                 names = c("City", "State"))
usl_city <- usl_city %>%
  subset(select = c("Team", "City", "State")) %>%
  rename(Teams = Team)


#adding data to usl specific USL DF
usl_master <- usl_master %>%
  stringdist_inner_join(usl_city, by = "Teams", max_dist = 3) %>%
  select(-Teams.y) %>%
  rename(Teams = Teams.x)

# separating city and state MLS
stadium_MLS <- separate_wider_delim(stadium_MLS, Location, delim = ",",
                                    names = c("City", "State"))
stadium_city_mls <- stadium_MLS %>%
  subset(select = c("Team", "City", "State"))%>%
  rename(Teams = Team)

mls_master <- mls_master %>%
  stringdist_inner_join(stadium_city_mls, by = "Teams", max_dist = 3) %>%
  select(-Teams.y) %>%
  rename(Teams = Teams.x)

cities <- rbind(usl_city, stadium_city_mls)


# joining cities with leagues_master DF
leagues_master <- leagues_master %>%
  stringdist_inner_join(cities, by = "Teams", max_dist = 3) %>%
  select(-Teams.y) %>%
  rename(Teams = Teams.x)





##importing team records for MLS and USL then joining into one sheet to join with master ##

#mls
html_MLS_records <- read_html("https://footballdatabase.com/league-scores-tables/united-states-mls-2022")
html_usl_points <- read_html("https://en.wikipedia.org/wiki/2022_USL_Championship_season")

records_MLS <- html_MLS_records %>% 
  html_node("table.table") %>% 
  html_table(
    header = TRUE,
  )

points_MLS <- records_MLS %>%
  select(P, Club) %>%
  rename(Teams = Club, '2022 Pts' = P)


#usl
usl_records <- html_usl_points %>%
  html_table(
    header = TRUE
  )

eastern <- purrr::map_dfr(usl_records[5], dplyr::bind_rows)
names(eastern)[2] <- "Teams"
eastern <- eastern %>%
  select(Teams, Pts)

western <- purrr::map_dfr(usl_records[6], dplyr::bind_rows)
names(western)[2] <- "Teams"
western <- western %>%
  select(Teams, Pts)

usl_2022_standings <- rbind(eastern, western) %>%
  rename('2022 Pts' = Pts)

usl_2022_standings$Teams <- gsub("\\Q (C, X)\\E","",usl_2022_standings$Teams)
usl_2022_standings$Teams <- gsub("\\Q Toros\\E"," FC", usl_2022_standings$Teams)

#joining with both mls and usl masters
usl_master <- usl_master %>%
  stringdist_inner_join(usl_2022_standings, by = "Teams", max_dist = 3)%>%
  select(-Teams.y) %>%
  rename(Teams = Teams.x)

points_MLS$Teams <- gsub("LA Galaxy", "Los Angeles Galaxy", points_MLS$Teams)
mls_master <- mls_master %>%
  stringdist_inner_join(points_MLS, by = "Teams", max_dist = 3)%>%
  select(-Teams.y) %>%
  rename(Teams = Teams.x)


# merging mls and usl points for inner join
Final_standings <- rbind(usl_2022_standings, points_MLS)


# joining final 2022 points with other data 
Final <- leagues_master %>%
  stringdist_inner_join(Final_standings, by = "Teams", max_dist = 3)
Final <- Final[,-13] 
Final <- rename(.data = Final, Teams = Teams.x)





## loading in other explanatory variable data for regression
governor <- read_csv(here("Data", "Morning Consult Pro Governor Raitings Q2 2023.csv"), 
                     col_names = TRUE )

# joining ratings with main df
ratings <- subset(governor, select = c("Governor", "State", "Approve", "Dissaprove"))

#remove white space for trim
ratings$State <- trimws(ratings$State)
Final$State <- trimws(Final$State)

#join
Final <- left_join(Final, ratings, by = "State")
Final$Approve<- parse_number(x = Final$Approve )
Final$Dissaprove<- parse_number(x = Final$Dissaprove )


## loading in club finances (in millions of euros)
finances <- read_xlsx(here("data", "Club Market Values.xlsx"), sheet = "Values")
finances$`Market Value`<- parse_number(finances$`Market Value`)
finances$`Total market value`<- parse_number(finances$`Total market value`)

#joining data
Final <- Final %>%
  stringdist_inner_join(finances, by = "Teams", max_dist = 3)%>%
  select(-Teams.y) %>%
  rename(Teams = Teams.x)


#joining finance with usl master
finances_usl <- read_xlsx(here("Data", "Club Market Values.xlsx"), sheet = "USL")
finances_usl$`Market Value`<- parse_number(finances_usl$`Market Value`)
finances_usl$`Total market value`<- parse_number(finances_usl$`Total market value`)
usl_master <- usl_master %>%
  stringdist_inner_join(finances_usl, by = "Teams", max_dist = 3)%>%
  select(-Teams.y) %>%
  rename(Teams = Teams.x)

#joining finance with mls master
finances_mls <- read_xlsx(here("Data", "Club Market Values.xlsx"), sheet = "MLS")
finances_mls$`Market Value`<- parse_number(finances_mls$`Market Value`)
finances_mls$`Total market value`<- parse_number(finances_mls$`Total market value`)
mls_master <- mls_master %>%
  stringdist_inner_join(finances_mls, by = "Teams", max_dist = 3)%>%
  select(-Teams.y) %>%
  rename(Teams = Teams.x)



# mls and usl 2023 points data
#mls
mls_2023_record <- read_xlsx(here("data", "MLS_USL Standings 2023.xlsx"), "MLS")
mls_2023_points <- mls_2023_record %>%
  select(Team, Pts)
mls_2023_points <- mls_2023_points %>%
  rename(Teams = Team)
#usl
usl_2023_record <- read_xlsx(here("data", "MLS_USL Standings 2023.xlsx"), "USL")
usl_2023_points <- usl_2023_record %>%
  select(Team, Pts)
usl_2023_points <- usl_2023_points %>%
  rename(Teams = Team)

# joining 2023 Pts with data frames
mls_master <- mls_master %>%
  stringdist_inner_join(mls_2023_points, by = "Teams", max_dist = 3)%>%
  select(-Teams.y) %>%
  rename(Teams = Teams.x, `Pts 2023` = Pts)

usl_master <- usl_master %>%
  stringdist_inner_join(usl_2023_points, by = "Teams", max_dist = 3)%>%
  select(-Teams.y) %>%
  rename(Teams = Teams.x, `Pts 2023` = Pts)



# adding 2023 points to full data frame with all data
`2023_pts` <- rbind(mls_2023_points, usl_2023_points)

Final <- Final%>%
  stringdist_inner_join(`2023_pts`, by = "Teams", max_dist = 3)%>%
  select(-Teams.y) %>%
  rename(Teams = Teams.x, `Pts 2023` = Pts)


# calculating new column based on percentage increase in Pts from 2022 to 2023

Final <- Final %>% 
  mutate("Pts_change_yoy" = ((`Pts 2023` -`2022 Pts`)/ `2022 Pts`) * 100)

mls_master <- mls_master %>%
  mutate("Pts_change_yoy" = ((`Pts 2023` -`2022 Pts`)/ `2022 Pts`) * 100)

usl_master <- usl_master %>%
  mutate("Pts_change_yoy" = ((`Pts 2023` -`2022 Pts`)/ `2022 Pts`) * 100)







## cleaning - phoenix and Birmingham only have four games
# number of games are too low
usl_master %>%
  group_by(Games) %>%
  arrange(Games)

usl_master <- usl_master %>% 
  filter(Games >= 10)
Final <- Final %>%
  filter(Games >=10 )


# capacity skews attendance percentage
Final %>%
  filter(`%_2023_Fill`< .10) %>%
  select(Teams, Capacity)
# Miam FC is an outlier and this makes sense given their capacity

Final <- Final %>%
  filter(`%_2023_Fill`> .10)


# Export of collected data in totality
export(Final, here("Output Data", "Collected US Soccer Data.csv"))



## exploratory plotting

# plot of Attendance vs Pts 2022
p <- ggplot(data = Final, mapping = aes(x = `2022 Pts`, y = `%_2022_Fill`)) +
  geom_point(color='blue') + 
  ggtitle(label = "Attendance vs Final Points at End of Season 2022") +
  xlab(label = "Final points in 2022") + 
  ylab(label = "% of stadium filled on average ") + 
  theme(plot.title = element_text(hjust = 0.5), 
        text = element_text(size = 16 ,
                            family = "TT Arial")) +
  scale_y_continuous(labels = scales::percent_format())
p + theme_light() 


# plot of Attendance vs Pts 2023
q <- ggplot(data = Final, mapping = aes(x = `Pts 2023`, y = `%_2023_Fill`)) +
  geom_point(color='blue') + 
  ggtitle(label = "Attendance vs Final Points at End of Season 2023") +
  xlab(label = "Final points in 2023") + 
  ylab(label = "% of stadium filled on average ") + 
  theme(plot.title = element_text(hjust = 0.5), 
        text = element_text(size = 16 ,
                            family = "TT Arial")) +
  scale_y_continuous(labels = scales::percent_format())
q + theme_light() 


# bar chart of capacity across leagues
ggplot(data = Final, aes(x = Teams, y = Capacity)) +
  geom_col(aes(fill = Capacity)) + theme(plot.title = element_text(hjust = 0.5),
                                         axis.title.x=element_blank(),
                                         axis.text.x=element_blank(),
                                         axis.ticks.x=element_blank()) +
  labs(title = "Capacity of US Soccer Venues") + 
  scale_fill_gradient(low = "blue",
                      high = "red",
                      space = "Lab")



# 2022 Attendance vs capacity
ggplot(data = Final, aes(x = Capacity, y = `%_2022_Fill`)) +
  geom_point() + theme_clean() +
  scale_y_continuous(labels = scales::percent_format())


# attendance vs governor approval
ggplot(data = Final, aes(x = Approve, y = `%_2023_Fill`)) +
  geom_point() + theme_few()+
  scale_y_continuous(labels = scales::percent_format())+
  scale_x_continuous(labels = scales::percent_format(scale = 1))+
  ggtitle(label = "Attendance vs Governor Approval")


ggplot(data = mls_master %>% filter(`Total market value` < 70), 
       aes(x = `Total market value`, y = `%_2023_Fill`)) +
  geom_point(color = "purple") +
  ggtitle(label = "Attendence vs Market Value in MLS 2023") +
  theme_clean()+ scale_y_continuous(labels = scales::percent_format())+
  theme(plot.title = element_text(hjust = 0.5)) + 
  xlab(label = "Total Market Value (Millions of Euros)") + 
  ylab(label = "% Of Stadium Filled on Average ") + 
  geom_smooth(method = "lm", se = FALSE)

ggplot(data = usl_master, aes(x = `Total market value`, y = `%_2023_Fill`)) +
  geom_point(color = "purple") +
  ggtitle(label = "Attendence vs Market Value in USL 2023") +
  theme_clean()+ scale_y_continuous(labels = scales::percent_format())+
  theme(plot.title = element_text(hjust = 0.5)) + 
  xlab(label = "Total Market Value (Millions of Euros)") + 
  ylab(label = "% Of Stadium Filled on Average ")


# illustrates that leagues need to largely be treated separately
ggplot(data = Final, aes(x = `Total market value`, y = `%_2023_Fill`)) +
  geom_point(color = "skyblue") +
  ggtitle(label = "Attendence vs Market Value in US soccer") +
  theme_clean()+ scale_y_continuous(labels = scales::percent_format())+
  theme(plot.title = element_text(hjust = 0.5)) + 
  xlab(label = "Total Market Value (Millions of Euros)") + 
  ylab(label = "% Of Stadium Filled on Average ")

# % filled vs capacity MLS
ggplot(data = mls_master, aes(x = `Capacity`, y = `%_2023_Fill`)) +
  geom_point(color = "darkred") +
  ggtitle(label = "Attendence vs Capacity") +
  theme_clean()+ scale_y_continuous(labels = scales::percent_format())+
  theme(plot.title = element_text(hjust = 0.5)) + 
  xlab(label = "Capacity") + 
  ylab(label = "% Of Stadium Filled on Average 2023")

# % yoy attendance vs 2023 attendance
ggplot(data = Final, aes(x = Pts_change_yoy, y = `%_2023_Fill`)) +
  geom_point(color = "darkred") +
  ggtitle(label = "Attendence vs Capacity") +
  theme_clean()+ scale_y_continuous(labels = scales::percent_format())+
  scale_x_continuous(labels = scales::percent_format(scale = 1))
theme(plot.title = element_text(hjust = 0.5)) + 
  xlab(label = "Change in Pts from 2022 to 2023") + 
  ylab(label = "Change in stadium attendance")


# plot of 2023 pts and attendance
ggplot(data = Final, aes(x = `Pts 2023`, y = `%_2023_Fill`)) +
  geom_point(color = "black") +
  ggtitle(label = "Attendence vs Market Value in US soccer") +
  scale_y_continuous(labels = scales::percent_format())+
  theme(plot.title = element_text(hjust = 0.5), panel.background 
        = element_rect(fill = "skyblue")) + 
  xlab(label = "2023 Total Pts") + 
  ylab(label = "% Of Stadium Filled on Average")

# focusing on MLS specifically
ggplot(data = mls_master, aes(x = `Pts 2023`, y = `%_2023_Fill`)) +
  geom_point(color = "black") +
  ggtitle(label = "Attendence vs Market Value in MLS") +
  scale_y_continuous(labels = scales::percent_format())+
  theme(plot.title = element_text(hjust = 0.5), panel.background 
        = element_rect(fill = "skyblue")) + 
  xlab(label = "2023 Total Pts") + 
  ylab(label = "% Of Stadium Filled on Average")



# stat exploration
cor(mls_master$Capacity, mls_master$`%_2023_Fill`)

cor(mls_master$`Pts 2023`, mls_master$`%_2023_Fill`)

# no real correlation here
cor(mls_master$YOY, mls_master$Pts_change_yoy)
cor(mls_master$`%_2023_Fill`, mls_master$Pts_change_yoy)



# capacity
# for MLS stadiums
summary(stadium$Capacity)
#for USL
summary(usl_stadium$Capacity)
#for all
summary(Final$Capacity)

# % fill 2022 & 2023
summary(Final$`%_Fill`)
summary(Final$`%_2022_Fill`)






## regression modeling
# relationship between points and market value?
# need 2023 pts for more accurate control of models


#MLS models
# removing the Messi effect inflating market value with filter
model_mls <- lm(`%_2023_Fill` ~ `Total market value`,mls_master %>% 
                  filter(`Total market value` < 70))
summary(model_mls)


# change in response variable to YOY changes in attendance
model_mls2 <- lm(`YOY` ~ `2022 Pts` + `Total market value`, mls_master)
summary(model_mls2)


model_usl2 <- lm(`YOY` ~ `2022 Pts` + `Total market value`, mls_master)
summary(model_usl2)