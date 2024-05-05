---
title: "US Soccer Attendance"
output: 
  html_document:
    keep_md: true
    toc: true
    toc_float:
      collapsed: TRUE
      smooth_scroll: false
editor_options: 
  markdown: 
    wrap: 72
---



# Introduction

This is an analysis of US professional soccer attendance data. Through
looking at both MLS and USL attendance trends for 2022 and 2023 I am
hoping to come to some insights about what is driving attendance in US
soccer and how the USL and MLS (the two main professional leagues)
compare.

# Data Collection

## Inputing and Cleaning USL and MLS Attendance Data

Utilizing rvest package I scraped data from soccerstadiumdigest.com to
get data for the USL Championship league. I then coerced the
imputed data into a data frame for easier manipulation and renamed a few
of the columns.


```r
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
```

Following this I then did some quick cleaning to get rid of commas and
convert some of the DF columns into numeric values.


```r
usl_2023_attendance$Average <- gsub(",","",usl_2023_attendance$Average)
usl_2023_attendance$Totals <- gsub(",","",usl_2023_attendance$Totals)
usl_2023_attendance$`2022 Average` <- gsub(",","",usl_2023_attendance$`2022 Average`)

usl <- usl_2023_attendance %>% 
  mutate_at(c('Average','Totals','2022 Average'), as.numeric)
```

Here is a view of the USL Championships 2023 attendance data.

<table class="table" style="margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> Team </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> Average </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> Totals </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> Games </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> 2022 Average </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> YOY </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Sacramento Republic FC </td>
   <td style="text-align:right;"> 10627 </td>
   <td style="text-align:right;"> 180665 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 9876 </td>
   <td style="text-align:right;"> 0.08 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Louisville City FC </td>
   <td style="text-align:right;"> 10547 </td>
   <td style="text-align:right;"> 179299 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 10465 </td>
   <td style="text-align:right;"> 0.01 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Indy Eleven </td>
   <td style="text-align:right;"> 9709 </td>
   <td style="text-align:right;"> 155349 </td>
   <td style="text-align:right;"> 16 </td>
   <td style="text-align:right;"> 8285 </td>
   <td style="text-align:right;"> 0.17 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> New Mexico United </td>
   <td style="text-align:right;"> 9619 </td>
   <td style="text-align:right;"> 163518 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 10724 </td>
   <td style="text-align:right;"> -0.10 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> CS Switchbacks FC </td>
   <td style="text-align:right;"> 7753 </td>
   <td style="text-align:right;"> 124044 </td>
   <td style="text-align:right;"> 16 </td>
   <td style="text-align:right;"> 7199 </td>
   <td style="text-align:right;"> 0.08 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Phoenix Rising FC </td>
   <td style="text-align:right;"> 7409 </td>
   <td style="text-align:right;"> 29634 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 6401 </td>
   <td style="text-align:right;"> 0.16 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> San Antonio FC </td>
   <td style="text-align:right;"> 7325 </td>
   <td style="text-align:right;"> 124522 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 5980 </td>
   <td style="text-align:right;"> 0.22 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> El Paso Locomotive FC </td>
   <td style="text-align:right;"> 6590 </td>
   <td style="text-align:right;"> 112038 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 6517 </td>
   <td style="text-align:right;"> 0.01 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Detroit City FC </td>
   <td style="text-align:right;"> 6032 </td>
   <td style="text-align:right;"> 102544 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 6118 </td>
   <td style="text-align:right;"> -0.01 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Tampa Bay Rowdies </td>
   <td style="text-align:right;"> 5984 </td>
   <td style="text-align:right;"> 77797 </td>
   <td style="text-align:right;"> 13 </td>
   <td style="text-align:right;"> 5148 </td>
   <td style="text-align:right;"> 0.16 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Birmingham Legion FC </td>
   <td style="text-align:right;"> 5091 </td>
   <td style="text-align:right;"> 20362 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 5920 </td>
   <td style="text-align:right;"> -0.14 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Pittsburgh Riverhounds </td>
   <td style="text-align:right;"> 5073 </td>
   <td style="text-align:right;"> 76095 </td>
   <td style="text-align:right;"> 15 </td>
   <td style="text-align:right;"> 3934 </td>
   <td style="text-align:right;"> 0.29 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Hartford Athletic </td>
   <td style="text-align:right;"> 4882 </td>
   <td style="text-align:right;"> 73224 </td>
   <td style="text-align:right;"> 15 </td>
   <td style="text-align:right;"> 5178 </td>
   <td style="text-align:right;"> -0.06 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> San Diego Loyal </td>
   <td style="text-align:right;"> 4754 </td>
   <td style="text-align:right;"> 71309 </td>
   <td style="text-align:right;"> 15 </td>
   <td style="text-align:right;"> 4519 </td>
   <td style="text-align:right;"> 0.05 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Rio Grande Valley FC </td>
   <td style="text-align:right;"> 4506 </td>
   <td style="text-align:right;"> 72095 </td>
   <td style="text-align:right;"> 16 </td>
   <td style="text-align:right;"> 4074 </td>
   <td style="text-align:right;"> 0.11 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Orange County SC </td>
   <td style="text-align:right;"> 4411 </td>
   <td style="text-align:right;"> 70568 </td>
   <td style="text-align:right;"> 16 </td>
   <td style="text-align:right;"> 4230 </td>
   <td style="text-align:right;"> 0.04 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> FC Tulsa </td>
   <td style="text-align:right;"> 4320 </td>
   <td style="text-align:right;"> 73443 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 4044 </td>
   <td style="text-align:right;"> 0.07 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Monterey Bay FC </td>
   <td style="text-align:right;"> 3963 </td>
   <td style="text-align:right;"> 67378 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 3683 </td>
   <td style="text-align:right;"> 0.08 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Oakland Roots SC </td>
   <td style="text-align:right;"> 3894 </td>
   <td style="text-align:right;"> 66196 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 4611 </td>
   <td style="text-align:right;"> -0.16 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Memphis 901 FC </td>
   <td style="text-align:right;"> 3344 </td>
   <td style="text-align:right;"> 33439 </td>
   <td style="text-align:right;"> 10 </td>
   <td style="text-align:right;"> 3683 </td>
   <td style="text-align:right;"> -0.09 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Charleston Battery </td>
   <td style="text-align:right;"> 3113 </td>
   <td style="text-align:right;"> 52919 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 2797 </td>
   <td style="text-align:right;"> 0.11 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Loudoun United FC </td>
   <td style="text-align:right;"> 2664 </td>
   <td style="text-align:right;"> 45288 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 1583 </td>
   <td style="text-align:right;"> 0.68 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Miami FC </td>
   <td style="text-align:right;"> 1432 </td>
   <td style="text-align:right;"> 24340 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 1162 </td>
   <td style="text-align:right;"> 0.23 </td>
  </tr>
</tbody>
</table>

Now following the same steps with the 2023 MLS data from
<https://soccerstadiumdigest.com/2023-mls-attendance/> we get this
result.



<table class="table" style="margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> Team </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> Average </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> Totals </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> Games </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> 2022 Average </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> YOY </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Atlanta United FC </td>
   <td style="text-align:right;"> 47526 </td>
   <td style="text-align:right;"> 807947 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 41116 </td>
   <td style="text-align:right;"> 0.16 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Charlotte FC </td>
   <td style="text-align:right;"> 35544 </td>
   <td style="text-align:right;"> 604246 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 35260 </td>
   <td style="text-align:right;"> 0.01 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Seattle Sounders </td>
   <td style="text-align:right;"> 32161 </td>
   <td style="text-align:right;"> 546744 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 33607 </td>
   <td style="text-align:right;"> -0.04 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Nashville SC </td>
   <td style="text-align:right;"> 28257 </td>
   <td style="text-align:right;"> 480370 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 27554 </td>
   <td style="text-align:right;"> 0.03 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> FC Cincinnati </td>
   <td style="text-align:right;"> 25367 </td>
   <td style="text-align:right;"> 431237 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 22487 </td>
   <td style="text-align:right;"> 0.13 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Toronto FC </td>
   <td style="text-align:right;"> 25310 </td>
   <td style="text-align:right;"> 430263 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 25423 </td>
   <td style="text-align:right;"> 0.00 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> LA Galaxy </td>
   <td style="text-align:right;"> 24106 </td>
   <td style="text-align:right;"> 409794 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 22841 </td>
   <td style="text-align:right;"> 0.06 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> NE Revolution </td>
   <td style="text-align:right;"> 23940 </td>
   <td style="text-align:right;"> 406981 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 20319 </td>
   <td style="text-align:right;"> 0.18 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Portland Timbers </td>
   <td style="text-align:right;"> 23103 </td>
   <td style="text-align:right;"> 392744 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 23841 </td>
   <td style="text-align:right;"> -0.03 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> St. Louis SC </td>
   <td style="text-align:right;"> 22423 </td>
   <td style="text-align:right;"> 381191 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:right;"> NA </td>
  </tr>
  <tr>
   <td style="text-align:left;"> LAFC </td>
   <td style="text-align:right;"> 22155 </td>
   <td style="text-align:right;"> 376643 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 22090 </td>
   <td style="text-align:right;"> 0.00 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Austin FC </td>
   <td style="text-align:right;"> 20738 </td>
   <td style="text-align:right;"> 352546 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 20738 </td>
   <td style="text-align:right;"> 0.00 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Orlando City SC </td>
   <td style="text-align:right;"> 20590 </td>
   <td style="text-align:right;"> 350023 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 17261 </td>
   <td style="text-align:right;"> 0.19 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Columbus Crew </td>
   <td style="text-align:right;"> 20314 </td>
   <td style="text-align:right;"> 345338 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 19237 </td>
   <td style="text-align:right;"> 0.06 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Minnesota United </td>
   <td style="text-align:right;"> 19568 </td>
   <td style="text-align:right;"> 332659 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 19555 </td>
   <td style="text-align:right;"> 0.00 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> NYC FC </td>
   <td style="text-align:right;"> 19477 </td>
   <td style="text-align:right;"> 331109 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 17180 </td>
   <td style="text-align:right;"> 0.13 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Real Salt Lake </td>
   <td style="text-align:right;"> 19429 </td>
   <td style="text-align:right;"> 330290 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 20470 </td>
   <td style="text-align:right;"> -0.05 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Philadelphia Union </td>
   <td style="text-align:right;"> 18907 </td>
   <td style="text-align:right;"> 321416 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 18126 </td>
   <td style="text-align:right;"> 0.04 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Sporting KC </td>
   <td style="text-align:right;"> 18616 </td>
   <td style="text-align:right;"> 316474 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 18365 </td>
   <td style="text-align:right;"> 0.01 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> SJ Earthquakes </td>
   <td style="text-align:right;"> 18412 </td>
   <td style="text-align:right;"> 313003 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 15260 </td>
   <td style="text-align:right;"> 0.21 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> NY Red Bulls </td>
   <td style="text-align:right;"> 18246 </td>
   <td style="text-align:right;"> 310190 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 17002 </td>
   <td style="text-align:right;"> 0.07 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> FC Dallas </td>
   <td style="text-align:right;"> 18239 </td>
   <td style="text-align:right;"> 310065 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 17469 </td>
   <td style="text-align:right;"> 0.04 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Chicago Fire </td>
   <td style="text-align:right;"> 18175 </td>
   <td style="text-align:right;"> 308975 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 15848 </td>
   <td style="text-align:right;"> 0.15 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Inter Miami CF </td>
   <td style="text-align:right;"> 17579 </td>
   <td style="text-align:right;"> 281257 </td>
   <td style="text-align:right;"> 16 </td>
   <td style="text-align:right;"> 12637 </td>
   <td style="text-align:right;"> 0.39 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> CF Montreal </td>
   <td style="text-align:right;"> 17562 </td>
   <td style="text-align:right;"> 298556 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 15905 </td>
   <td style="text-align:right;"> 0.10 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> D.C. United </td>
   <td style="text-align:right;"> 17540 </td>
   <td style="text-align:right;"> 298185 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 16256 </td>
   <td style="text-align:right;"> 0.08 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Vancouver Whitecaps </td>
   <td style="text-align:right;"> 16745 </td>
   <td style="text-align:right;"> 284661 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 16399 </td>
   <td style="text-align:right;"> 0.02 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Colorado Rapids </td>
   <td style="text-align:right;"> 15409 </td>
   <td style="text-align:right;"> 261953 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 14473 </td>
   <td style="text-align:right;"> 0.06 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Houston Dynamo </td>
   <td style="text-align:right;"> 15027 </td>
   <td style="text-align:right;"> 255465 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 16426 </td>
   <td style="text-align:right;"> -0.09 </td>
  </tr>
</tbody>
</table>


This next step is to prepare the data just imputed for a future join with
stadium data taken from Wikipedia. Some of the team names from the attendance 
date originating from soccerstadiumdigest.com do not exactly match the way the
names are presented on Wikipedia. In order to be able to join the two data sets
we essentially need to 'standardize' the team names so they match in both data 
sets.


```r
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
```

Then, using the rbind function we can combine both the USL and MLS attendance
data frames.


```r
# join attendance together
leagues_joined <-rbind(usl, MLS)
```

<table class="table" style="margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> Team </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> Average </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> Totals </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> Games </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> 2022 Average </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> YOY </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Sacramento Republic FC </td>
   <td style="text-align:right;"> 10627 </td>
   <td style="text-align:right;"> 180665 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 9876 </td>
   <td style="text-align:right;"> 0.08 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Louisville City FC </td>
   <td style="text-align:right;"> 10547 </td>
   <td style="text-align:right;"> 179299 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 10465 </td>
   <td style="text-align:right;"> 0.01 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Indy Eleven </td>
   <td style="text-align:right;"> 9709 </td>
   <td style="text-align:right;"> 155349 </td>
   <td style="text-align:right;"> 16 </td>
   <td style="text-align:right;"> 8285 </td>
   <td style="text-align:right;"> 0.17 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> New Mexico United </td>
   <td style="text-align:right;"> 9619 </td>
   <td style="text-align:right;"> 163518 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 10724 </td>
   <td style="text-align:right;"> -0.10 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Colorado Springs Switchbacks FC </td>
   <td style="text-align:right;"> 7753 </td>
   <td style="text-align:right;"> 124044 </td>
   <td style="text-align:right;"> 16 </td>
   <td style="text-align:right;"> 7199 </td>
   <td style="text-align:right;"> 0.08 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Phoenix Rising FC </td>
   <td style="text-align:right;"> 7409 </td>
   <td style="text-align:right;"> 29634 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 6401 </td>
   <td style="text-align:right;"> 0.16 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> San Antonio FC </td>
   <td style="text-align:right;"> 7325 </td>
   <td style="text-align:right;"> 124522 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 5980 </td>
   <td style="text-align:right;"> 0.22 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> El Paso Locomotive FC </td>
   <td style="text-align:right;"> 6590 </td>
   <td style="text-align:right;"> 112038 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 6517 </td>
   <td style="text-align:right;"> 0.01 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Detroit City FC </td>
   <td style="text-align:right;"> 6032 </td>
   <td style="text-align:right;"> 102544 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 6118 </td>
   <td style="text-align:right;"> -0.01 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Tampa Bay Rowdies </td>
   <td style="text-align:right;"> 5984 </td>
   <td style="text-align:right;"> 77797 </td>
   <td style="text-align:right;"> 13 </td>
   <td style="text-align:right;"> 5148 </td>
   <td style="text-align:right;"> 0.16 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Birmingham Legion FC </td>
   <td style="text-align:right;"> 5091 </td>
   <td style="text-align:right;"> 20362 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 5920 </td>
   <td style="text-align:right;"> -0.14 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Pittsburgh Riverhounds </td>
   <td style="text-align:right;"> 5073 </td>
   <td style="text-align:right;"> 76095 </td>
   <td style="text-align:right;"> 15 </td>
   <td style="text-align:right;"> 3934 </td>
   <td style="text-align:right;"> 0.29 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Hartford Athletic </td>
   <td style="text-align:right;"> 4882 </td>
   <td style="text-align:right;"> 73224 </td>
   <td style="text-align:right;"> 15 </td>
   <td style="text-align:right;"> 5178 </td>
   <td style="text-align:right;"> -0.06 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> San Diego Loyal </td>
   <td style="text-align:right;"> 4754 </td>
   <td style="text-align:right;"> 71309 </td>
   <td style="text-align:right;"> 15 </td>
   <td style="text-align:right;"> 4519 </td>
   <td style="text-align:right;"> 0.05 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Rio Grande Valley FC </td>
   <td style="text-align:right;"> 4506 </td>
   <td style="text-align:right;"> 72095 </td>
   <td style="text-align:right;"> 16 </td>
   <td style="text-align:right;"> 4074 </td>
   <td style="text-align:right;"> 0.11 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Orange County SC </td>
   <td style="text-align:right;"> 4411 </td>
   <td style="text-align:right;"> 70568 </td>
   <td style="text-align:right;"> 16 </td>
   <td style="text-align:right;"> 4230 </td>
   <td style="text-align:right;"> 0.04 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> FC Tulsa </td>
   <td style="text-align:right;"> 4320 </td>
   <td style="text-align:right;"> 73443 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 4044 </td>
   <td style="text-align:right;"> 0.07 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Monterey Bay FC </td>
   <td style="text-align:right;"> 3963 </td>
   <td style="text-align:right;"> 67378 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 3683 </td>
   <td style="text-align:right;"> 0.08 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Oakland Roots SC </td>
   <td style="text-align:right;"> 3894 </td>
   <td style="text-align:right;"> 66196 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 4611 </td>
   <td style="text-align:right;"> -0.16 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Memphis 901 FC </td>
   <td style="text-align:right;"> 3344 </td>
   <td style="text-align:right;"> 33439 </td>
   <td style="text-align:right;"> 10 </td>
   <td style="text-align:right;"> 3683 </td>
   <td style="text-align:right;"> -0.09 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Charleston Battery </td>
   <td style="text-align:right;"> 3113 </td>
   <td style="text-align:right;"> 52919 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 2797 </td>
   <td style="text-align:right;"> 0.11 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Loudoun United FC </td>
   <td style="text-align:right;"> 2664 </td>
   <td style="text-align:right;"> 45288 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 1583 </td>
   <td style="text-align:right;"> 0.68 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Miami FC </td>
   <td style="text-align:right;"> 1432 </td>
   <td style="text-align:right;"> 24340 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 1162 </td>
   <td style="text-align:right;"> 0.23 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Atlanta United FC </td>
   <td style="text-align:right;"> 47526 </td>
   <td style="text-align:right;"> 807947 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 41116 </td>
   <td style="text-align:right;"> 0.16 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Charlotte FC </td>
   <td style="text-align:right;"> 35544 </td>
   <td style="text-align:right;"> 604246 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 35260 </td>
   <td style="text-align:right;"> 0.01 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Seattle Sounders </td>
   <td style="text-align:right;"> 32161 </td>
   <td style="text-align:right;"> 546744 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 33607 </td>
   <td style="text-align:right;"> -0.04 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Nashville SC </td>
   <td style="text-align:right;"> 28257 </td>
   <td style="text-align:right;"> 480370 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 27554 </td>
   <td style="text-align:right;"> 0.03 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> FC Cincinnati </td>
   <td style="text-align:right;"> 25367 </td>
   <td style="text-align:right;"> 431237 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 22487 </td>
   <td style="text-align:right;"> 0.13 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Toronto FC </td>
   <td style="text-align:right;"> 25310 </td>
   <td style="text-align:right;"> 430263 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 25423 </td>
   <td style="text-align:right;"> 0.00 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Los Angeles Galaxy </td>
   <td style="text-align:right;"> 24106 </td>
   <td style="text-align:right;"> 409794 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 22841 </td>
   <td style="text-align:right;"> 0.06 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> New England Revolution </td>
   <td style="text-align:right;"> 23940 </td>
   <td style="text-align:right;"> 406981 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 20319 </td>
   <td style="text-align:right;"> 0.18 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Portland Timbers </td>
   <td style="text-align:right;"> 23103 </td>
   <td style="text-align:right;"> 392744 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 23841 </td>
   <td style="text-align:right;"> -0.03 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> St. Louis City SC </td>
   <td style="text-align:right;"> 22423 </td>
   <td style="text-align:right;"> 381191 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:right;"> NA </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Los Angeles FC </td>
   <td style="text-align:right;"> 22155 </td>
   <td style="text-align:right;"> 376643 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 22090 </td>
   <td style="text-align:right;"> 0.00 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Austin FC </td>
   <td style="text-align:right;"> 20738 </td>
   <td style="text-align:right;"> 352546 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 20738 </td>
   <td style="text-align:right;"> 0.00 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Orlando City SC </td>
   <td style="text-align:right;"> 20590 </td>
   <td style="text-align:right;"> 350023 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 17261 </td>
   <td style="text-align:right;"> 0.19 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Columbus Crew </td>
   <td style="text-align:right;"> 20314 </td>
   <td style="text-align:right;"> 345338 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 19237 </td>
   <td style="text-align:right;"> 0.06 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Minnesota United </td>
   <td style="text-align:right;"> 19568 </td>
   <td style="text-align:right;"> 332659 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 19555 </td>
   <td style="text-align:right;"> 0.00 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> New York City FC </td>
   <td style="text-align:right;"> 19477 </td>
   <td style="text-align:right;"> 331109 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 17180 </td>
   <td style="text-align:right;"> 0.13 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Real Salt Lake </td>
   <td style="text-align:right;"> 19429 </td>
   <td style="text-align:right;"> 330290 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 20470 </td>
   <td style="text-align:right;"> -0.05 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Philadelphia Union </td>
   <td style="text-align:right;"> 18907 </td>
   <td style="text-align:right;"> 321416 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 18126 </td>
   <td style="text-align:right;"> 0.04 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Sporting Kansas City </td>
   <td style="text-align:right;"> 18616 </td>
   <td style="text-align:right;"> 316474 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 18365 </td>
   <td style="text-align:right;"> 0.01 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> San Jose Earthquakes </td>
   <td style="text-align:right;"> 18412 </td>
   <td style="text-align:right;"> 313003 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 15260 </td>
   <td style="text-align:right;"> 0.21 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> New York Red Bulls </td>
   <td style="text-align:right;"> 18246 </td>
   <td style="text-align:right;"> 310190 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 17002 </td>
   <td style="text-align:right;"> 0.07 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> FC Dallas </td>
   <td style="text-align:right;"> 18239 </td>
   <td style="text-align:right;"> 310065 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 17469 </td>
   <td style="text-align:right;"> 0.04 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Chicago Fire </td>
   <td style="text-align:right;"> 18175 </td>
   <td style="text-align:right;"> 308975 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 15848 </td>
   <td style="text-align:right;"> 0.15 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Inter Miami CF </td>
   <td style="text-align:right;"> 17579 </td>
   <td style="text-align:right;"> 281257 </td>
   <td style="text-align:right;"> 16 </td>
   <td style="text-align:right;"> 12637 </td>
   <td style="text-align:right;"> 0.39 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> CF Montreal </td>
   <td style="text-align:right;"> 17562 </td>
   <td style="text-align:right;"> 298556 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 15905 </td>
   <td style="text-align:right;"> 0.10 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> D.C. United </td>
   <td style="text-align:right;"> 17540 </td>
   <td style="text-align:right;"> 298185 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 16256 </td>
   <td style="text-align:right;"> 0.08 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Vancouver Whitecaps </td>
   <td style="text-align:right;"> 16745 </td>
   <td style="text-align:right;"> 284661 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 16399 </td>
   <td style="text-align:right;"> 0.02 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Colorado Rapids </td>
   <td style="text-align:right;"> 15409 </td>
   <td style="text-align:right;"> 261953 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 14473 </td>
   <td style="text-align:right;"> 0.06 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Houston Dynamo </td>
   <td style="text-align:right;"> 15027 </td>
   <td style="text-align:right;"> 255465 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 16426 </td>
   <td style="text-align:right;"> -0.09 </td>
  </tr>
</tbody>
</table>


## Inputing and Cleaning USL and MLS Stadium Data

Now we are going to input the stadium specific data from Wikipedia.


```r
htmlstadium <- read_html("https://en.wikipedia.org/wiki/List_of_Major_League_Soccer_stadiums")

stadium_MLS <- htmlstadium %>% 
  html_node("table.wikitable.sortable") %>% 
  html_table(
    header = TRUE,
  )
```


With some quick manipulations.



```r
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
```


Giving us this table.


<table class="table" style="margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> Stadium </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> Team </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> Location </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> First MLS year in stadium </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> Capacity </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> Opened </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> Surface </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> Field dimensions </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> Coordinates </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> Roof type </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> Soccer specific </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Allianz Field </td>
   <td style="text-align:left;"> Minnesota United FC </td>
   <td style="text-align:left;"> Saint Paul, Minnesota </td>
   <td style="text-align:right;"> 2019 </td>
   <td style="text-align:right;"> 19400 </td>
   <td style="text-align:right;"> 2019 </td>
   <td style="text-align:left;"> Grass </td>
   <td style="text-align:left;"> 115 yd × 75 yd(105 m × 69 m) </td>
   <td style="text-align:left;"> .mw-parser-output .geo-default,.mw-parser-output .geo-dms,.mw-parser-output .geo-dec{display:inline}.mw-parser-output .geo-nondefault,.mw-parser-output .geo-multi-punct,.mw-parser-output .geo-inline-hidden{display:none}.mw-parser-output .longitude,.mw-parser-output .latitude{white-space:nowrap}44°57′10″N 93°9′54″W﻿ / ﻿44.95278°N 93.16500°W﻿ / 44.95278; -93.16500 </td>
   <td style="text-align:left;"> Open </td>
   <td style="text-align:left;"> Yes </td>
  </tr>
  <tr>
   <td style="text-align:left;"> America First Field </td>
   <td style="text-align:left;"> Real Salt Lake </td>
   <td style="text-align:left;"> Sandy, Utah </td>
   <td style="text-align:right;"> 2008 </td>
   <td style="text-align:right;"> 20213 </td>
   <td style="text-align:right;"> 2008 </td>
   <td style="text-align:left;"> Grass </td>
   <td style="text-align:left;"> 120 yd × 75 yd(110 m × 69 m) </td>
   <td style="text-align:left;"> 40°34′59″N 111°53′35″W﻿ / ﻿40.582923°N 111.893156°W﻿ / 40.582923; -111.893156﻿ (America First Field) </td>
   <td style="text-align:left;"> Open </td>
   <td style="text-align:left;"> Yes </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Audi Field </td>
   <td style="text-align:left;"> D.C. United </td>
   <td style="text-align:left;"> Washington, D.C. </td>
   <td style="text-align:right;"> 2018 </td>
   <td style="text-align:right;"> 20000 </td>
   <td style="text-align:right;"> 2018 </td>
   <td style="text-align:left;"> Grass </td>
   <td style="text-align:left;"> 115 yd × 75 yd(105 m × 69 m) </td>
   <td style="text-align:left;"> 38°52′6″N 77°0′44″W﻿ / ﻿38.86833°N 77.01222°W﻿ / 38.86833; -77.01222﻿ (Audi Field) </td>
   <td style="text-align:left;"> Open </td>
   <td style="text-align:left;"> Yes </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Bank of America Stadium </td>
   <td style="text-align:left;"> Charlotte FC </td>
   <td style="text-align:left;"> Charlotte, North Carolina </td>
   <td style="text-align:right;"> 2022 </td>
   <td style="text-align:right;"> 38000 </td>
   <td style="text-align:right;"> 1996 </td>
   <td style="text-align:left;"> FieldTurf </td>
   <td style="text-align:left;"> TBA </td>
   <td style="text-align:left;"> 35°13′33″N 80°51′10″W﻿ / ﻿35.22583°N 80.85278°W﻿ / 35.22583; -80.85278﻿ (Bank of America Stadium) </td>
   <td style="text-align:left;"> Open </td>
   <td style="text-align:left;"> No </td>
  </tr>
  <tr>
   <td style="text-align:left;"> BC Place ‡ </td>
   <td style="text-align:left;"> Vancouver Whitecaps FC </td>
   <td style="text-align:left;"> Vancouver, British Columbia </td>
   <td style="text-align:right;"> 2011 </td>
   <td style="text-align:right;"> 22120 </td>
   <td style="text-align:right;"> 1983 </td>
   <td style="text-align:left;"> Polytan </td>
   <td style="text-align:left;"> 117 yd × 75 yd(107 m × 69 m) </td>
   <td style="text-align:left;"> 49°16′36″N 123°6′43″W﻿ / ﻿49.27667°N 123.11194°W﻿ / 49.27667; -123.11194﻿ (BC Place) </td>
   <td style="text-align:left;"> Retractable </td>
   <td style="text-align:left;"> No </td>
  </tr>
  <tr>
   <td style="text-align:left;"> BMO Field </td>
   <td style="text-align:left;"> Toronto FC </td>
   <td style="text-align:left;"> Toronto, Ontario </td>
   <td style="text-align:right;"> 2007 </td>
   <td style="text-align:right;"> 30991 </td>
   <td style="text-align:right;"> 2007 </td>
   <td style="text-align:left;"> Hybrid grass
(SISGrass) </td>
   <td style="text-align:left;"> 115 yd × 74 yd(105 m × 68 m) </td>
   <td style="text-align:left;"> 43°37′58″N 79°25′07″W﻿ / ﻿43.63278°N 79.41861°W﻿ / 43.63278; -79.41861﻿ (BMO Field) </td>
   <td style="text-align:left;"> Open </td>
   <td style="text-align:left;"> Yes </td>
  </tr>
  <tr>
   <td style="text-align:left;"> BMO Stadium </td>
   <td style="text-align:left;"> Los Angeles FC </td>
   <td style="text-align:left;"> Los Angeles, California </td>
   <td style="text-align:right;"> 2018 </td>
   <td style="text-align:right;"> 22000 </td>
   <td style="text-align:right;"> 2018 </td>
   <td style="text-align:left;"> Grass </td>
   <td style="text-align:left;"> 115 yd × 75 yd(105 m × 69 m) </td>
   <td style="text-align:left;"> 34°00′47″N 118°17′6″W﻿ / ﻿34.01306°N 118.28500°W﻿ / 34.01306; -118.28500﻿ (BMO Stadium) </td>
   <td style="text-align:left;"> Open </td>
   <td style="text-align:left;"> Yes </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Chase Stadium </td>
   <td style="text-align:left;"> Inter Miami CF </td>
   <td style="text-align:left;"> Fort Lauderdale, Florida </td>
   <td style="text-align:right;"> 2020 </td>
   <td style="text-align:right;"> 21550 </td>
   <td style="text-align:right;"> 2020 </td>
   <td style="text-align:left;"> Grass </td>
   <td style="text-align:left;"> 115 yd × 75 yd(105 m × 69 m) </td>
   <td style="text-align:left;"> 26°11′35″N 80°9′40″W﻿ / ﻿26.19306°N 80.16111°W﻿ / 26.19306; -80.16111﻿ (DRV PNK Stadium) </td>
   <td style="text-align:left;"> Open </td>
   <td style="text-align:left;"> Yes </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Children's Mercy Park </td>
   <td style="text-align:left;"> Sporting Kansas City </td>
   <td style="text-align:left;"> Kansas City, Kansas </td>
   <td style="text-align:right;"> 2011 </td>
   <td style="text-align:right;"> 18467 </td>
   <td style="text-align:right;"> 2011 </td>
   <td style="text-align:left;"> Grass </td>
   <td style="text-align:left;"> 120 yd × 75 yd(110 m × 69 m) </td>
   <td style="text-align:left;"> 39°07′18″N 94°49′25″W﻿ / ﻿39.1218°N 94.8237°W﻿ / 39.1218; -94.8237﻿ (Children's Mercy Park) </td>
   <td style="text-align:left;"> Open </td>
   <td style="text-align:left;"> Yes </td>
  </tr>
  <tr>
   <td style="text-align:left;"> CityPark </td>
   <td style="text-align:left;"> St. Louis City SC </td>
   <td style="text-align:left;"> St. Louis, Missouri </td>
   <td style="text-align:right;"> 2023 </td>
   <td style="text-align:right;"> 22500 </td>
   <td style="text-align:right;"> 2022 </td>
   <td style="text-align:left;"> Grass </td>
   <td style="text-align:left;"> 114 yd × 74 yd(104 m × 68 m) </td>
   <td style="text-align:left;"> 38°37′51.7″N 90°12′39.3″W﻿ / ﻿38.631028°N 90.210917°W﻿ / 38.631028; -90.210917﻿ (Citypark) </td>
   <td style="text-align:left;"> Open </td>
   <td style="text-align:left;"> Yes </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Dick's Sporting Goods Park </td>
   <td style="text-align:left;"> Colorado Rapids </td>
   <td style="text-align:left;"> Commerce City, Colorado </td>
   <td style="text-align:right;"> 2007 </td>
   <td style="text-align:right;"> 18061 </td>
   <td style="text-align:right;"> 2007 </td>
   <td style="text-align:left;"> Grass </td>
   <td style="text-align:left;"> 120 yd × 75 yd(110 m × 69 m) </td>
   <td style="text-align:left;"> 39°48′20″N 104°53′31″W﻿ / ﻿39.80556°N 104.89194°W﻿ / 39.80556; -104.89194﻿ (Dick's Sporting Goods Park) </td>
   <td style="text-align:left;"> Open </td>
   <td style="text-align:left;"> Yes </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Dignity Health Sports Park </td>
   <td style="text-align:left;"> Los Angeles Galaxy </td>
   <td style="text-align:left;"> Carson, California </td>
   <td style="text-align:right;"> 2003 </td>
   <td style="text-align:right;"> 27000 </td>
   <td style="text-align:right;"> 2003 </td>
   <td style="text-align:left;"> Grass </td>
   <td style="text-align:left;"> 120 yd × 75 yd(110 m × 69 m) </td>
   <td style="text-align:left;"> 33°51′52″N 118°15′40″W﻿ / ﻿33.86444°N 118.26111°W﻿ / 33.86444; -118.26111﻿ (Dignity Health Sports Park) </td>
   <td style="text-align:left;"> Open </td>
   <td style="text-align:left;"> Yes </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Gillette Stadium </td>
   <td style="text-align:left;"> New England Revolution </td>
   <td style="text-align:left;"> Foxborough, Massachusetts </td>
   <td style="text-align:right;"> 2002 </td>
   <td style="text-align:right;"> 20000 </td>
   <td style="text-align:right;"> 2002 </td>
   <td style="text-align:left;"> FieldTurf </td>
   <td style="text-align:left;"> 115 yd × 75 yd(105 m × 69 m) </td>
   <td style="text-align:left;"> 42°05′27.40″N 71°15′51.64″W﻿ / ﻿42.0909444°N 71.2643444°W﻿ / 42.0909444; -71.2643444﻿ (Gillette Stadium) </td>
   <td style="text-align:left;"> Open </td>
   <td style="text-align:left;"> No </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Geodis Park </td>
   <td style="text-align:left;"> Nashville SC </td>
   <td style="text-align:left;"> Nashville, Tennessee </td>
   <td style="text-align:right;"> 2022 </td>
   <td style="text-align:right;"> 30000 </td>
   <td style="text-align:right;"> 2022 </td>
   <td style="text-align:left;"> Grass </td>
   <td style="text-align:left;"> 120 yd × 75 yd(110 m × 69 m) </td>
   <td style="text-align:left;"> 36°7′49″N 86°45′56″W﻿ / ﻿36.13028°N 86.76556°W﻿ / 36.13028; -86.76556﻿ (Geodis Park) </td>
   <td style="text-align:left;"> Open </td>
   <td style="text-align:left;"> Yes </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Inter&amp;Co Stadium </td>
   <td style="text-align:left;"> Orlando City SC </td>
   <td style="text-align:left;"> Orlando, Florida </td>
   <td style="text-align:right;"> 2017 </td>
   <td style="text-align:right;"> 25500 </td>
   <td style="text-align:right;"> 2017 </td>
   <td style="text-align:left;"> Grass </td>
   <td style="text-align:left;"> 120 yd × 75 yd(110 m × 69 m) </td>
   <td style="text-align:left;"> 28°37′27.83″N 81°23′20.53″W﻿ / ﻿28.6243972°N 81.3890361°W﻿ / 28.6243972; -81.3890361﻿ (Exploria Stadium) </td>
   <td style="text-align:left;"> Open </td>
   <td style="text-align:left;"> Yes </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Lower.com Field </td>
   <td style="text-align:left;"> Columbus Crew </td>
   <td style="text-align:left;"> Columbus, Ohio </td>
   <td style="text-align:right;"> 2021 </td>
   <td style="text-align:right;"> 20371 </td>
   <td style="text-align:right;"> 2021 </td>
   <td style="text-align:left;"> Grass </td>
   <td style="text-align:left;"> 120 yd × 75 yd(110 m × 69 m) </td>
   <td style="text-align:left;"> 39°58′6.46″N 83°1′1.52″W﻿ / ﻿39.9684611°N 83.0170889°W﻿ / 39.9684611; -83.0170889﻿ (Lower.com Field) </td>
   <td style="text-align:left;"> Open </td>
   <td style="text-align:left;"> Yes </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Lumen Field </td>
   <td style="text-align:left;"> Seattle Sounders FC </td>
   <td style="text-align:left;"> Seattle, Washington </td>
   <td style="text-align:right;"> 2009 </td>
   <td style="text-align:right;"> 37722 </td>
   <td style="text-align:right;"> 2002 </td>
   <td style="text-align:left;"> FieldTurf </td>
   <td style="text-align:left;"> 114 yd × 74 yd(104 m × 68 m) </td>
   <td style="text-align:left;"> 47°35′43″N 122°19′54″W﻿ / ﻿47.5952°N 122.3316°W﻿ / 47.5952; -122.3316﻿ (Lumen Field) </td>
   <td style="text-align:left;"> Open </td>
   <td style="text-align:left;"> No </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Mercedes-Benz Stadium ‡ </td>
   <td style="text-align:left;"> Atlanta United FC </td>
   <td style="text-align:left;"> Atlanta, Georgia </td>
   <td style="text-align:right;"> 2017 </td>
   <td style="text-align:right;"> 42500 </td>
   <td style="text-align:right;"> 2017 </td>
   <td style="text-align:left;"> FieldTurf </td>
   <td style="text-align:left;"> 115 yd × 75 yd(105 m × 69 m) </td>
   <td style="text-align:left;"> 33°45′19.30″N 84°24′4.29″W﻿ / ﻿33.7553611°N 84.4011917°W﻿ / 33.7553611; -84.4011917﻿ (Mercedes-Benz Stadium) </td>
   <td style="text-align:left;"> Retractable </td>
   <td style="text-align:left;"> No </td>
  </tr>
  <tr>
   <td style="text-align:left;"> PayPal Park </td>
   <td style="text-align:left;"> San Jose Earthquakes </td>
   <td style="text-align:left;"> San Jose, California </td>
   <td style="text-align:right;"> 2015 </td>
   <td style="text-align:right;"> 18000 </td>
   <td style="text-align:right;"> 2015 </td>
   <td style="text-align:left;"> SISGrass (Hybrid) </td>
   <td style="text-align:left;"> 115 yd × 75 yd(105 m × 69 m) </td>
   <td style="text-align:left;"> 37°21′5″N 121°55′30″W﻿ / ﻿37.35139°N 121.92500°W﻿ / 37.35139; -121.92500﻿ (PayPal Park) </td>
   <td style="text-align:left;"> Open </td>
   <td style="text-align:left;"> Yes </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Providence Park </td>
   <td style="text-align:left;"> Portland Timbers </td>
   <td style="text-align:left;"> Portland, Oregon </td>
   <td style="text-align:right;"> 2011 </td>
   <td style="text-align:right;"> 25218 </td>
   <td style="text-align:right;"> 1926 </td>
   <td style="text-align:left;"> FieldTurf </td>
   <td style="text-align:left;"> 110 yd × 75 yd(101 m × 69 m) </td>
   <td style="text-align:left;"> 45°31′17″N 122°41′30″W﻿ / ﻿45.52139°N 122.69167°W﻿ / 45.52139; -122.69167﻿ (Providence Park) </td>
   <td style="text-align:left;"> Open </td>
   <td style="text-align:left;"> Yes[note 2] </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Q2 Stadium </td>
   <td style="text-align:left;"> Austin FC </td>
   <td style="text-align:left;"> Austin, Texas </td>
   <td style="text-align:right;"> 2021 </td>
   <td style="text-align:right;"> 20738 </td>
   <td style="text-align:right;"> 2021 </td>
   <td style="text-align:left;"> Grass </td>
   <td style="text-align:left;"> 115 yd × 75 yd(105 m × 69 m) </td>
   <td style="text-align:left;"> 30°23′17.54″N 97°43′11.51″W﻿ / ﻿30.3882056°N 97.7198639°W﻿ / 30.3882056; -97.7198639﻿ (Q2 Stadium) </td>
   <td style="text-align:left;"> Open </td>
   <td style="text-align:left;"> Yes </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Red Bull Arena </td>
   <td style="text-align:left;"> New York Red Bulls </td>
   <td style="text-align:left;"> Harrison, New Jersey </td>
   <td style="text-align:right;"> 2010 </td>
   <td style="text-align:right;"> 25000 </td>
   <td style="text-align:right;"> 2010 </td>
   <td style="text-align:left;"> Grass </td>
   <td style="text-align:left;"> 120 yd × 75 yd(110 m × 69 m) </td>
   <td style="text-align:left;"> 40°44′12″N 74°9′1″W﻿ / ﻿40.73667°N 74.15028°W﻿ / 40.73667; -74.15028﻿ (Red Bull Arena) </td>
   <td style="text-align:left;"> Open </td>
   <td style="text-align:left;"> Yes </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Saputo Stadium </td>
   <td style="text-align:left;"> CF Montréal </td>
   <td style="text-align:left;"> Montreal, Quebec </td>
   <td style="text-align:right;"> 2012 </td>
   <td style="text-align:right;"> 19619 </td>
   <td style="text-align:right;"> 2008 </td>
   <td style="text-align:left;"> Grass </td>
   <td style="text-align:left;"> 120 yd × 77 yd(110 m × 70 m) </td>
   <td style="text-align:left;"> 45°33′47″N 73°33′9″W﻿ / ﻿45.56306°N 73.55250°W﻿ / 45.56306; -73.55250﻿ (Saputo Stadium) </td>
   <td style="text-align:left;"> Open </td>
   <td style="text-align:left;"> Yes </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Shell Energy Stadium </td>
   <td style="text-align:left;"> Houston Dynamo FC </td>
   <td style="text-align:left;"> Houston, Texas </td>
   <td style="text-align:right;"> 2012 </td>
   <td style="text-align:right;"> 22039 </td>
   <td style="text-align:right;"> 2012 </td>
   <td style="text-align:left;"> Grass </td>
   <td style="text-align:left;"> 115 yd × 73 yd(105 m × 67 m) </td>
   <td style="text-align:left;"> 29°45.132′N 95°21.144′W﻿ / ﻿29.752200°N 95.352400°W﻿ / 29.752200; -95.352400﻿ (BBVA Stadium) </td>
   <td style="text-align:left;"> Open </td>
   <td style="text-align:left;"> Yes </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Soldier Field </td>
   <td style="text-align:left;"> Chicago Fire FC </td>
   <td style="text-align:left;"> Chicago, Illinois </td>
   <td style="text-align:right;"> 1998 </td>
   <td style="text-align:right;"> 24955 </td>
   <td style="text-align:right;"> 1924 </td>
   <td style="text-align:left;"> Grass </td>
   <td style="text-align:left;"> 114 yd × 74 yd(104 m × 68 m) </td>
   <td style="text-align:left;"> 41°51′44″N 87°37′00″W﻿ / ﻿41.8623°N 87.6167°W﻿ / 41.8623; -87.6167﻿ (Soldier Field) </td>
   <td style="text-align:left;"> Open </td>
   <td style="text-align:left;"> No </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Subaru Park </td>
   <td style="text-align:left;"> Philadelphia Union </td>
   <td style="text-align:left;"> Chester, Pennsylvania </td>
   <td style="text-align:right;"> 2010 </td>
   <td style="text-align:right;"> 18500 </td>
   <td style="text-align:right;"> 2010 </td>
   <td style="text-align:left;"> Grass </td>
   <td style="text-align:left;"> 120 yd × 75 yd(110 m × 69 m) </td>
   <td style="text-align:left;"> 39°49′56″N 75°22′44″W﻿ / ﻿39.83222°N 75.37889°W﻿ / 39.83222; -75.37889﻿ (Subaru Park) </td>
   <td style="text-align:left;"> Open </td>
   <td style="text-align:left;"> Yes </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Toyota Stadium </td>
   <td style="text-align:left;"> FC Dallas </td>
   <td style="text-align:left;"> Frisco, Texas </td>
   <td style="text-align:right;"> 2005 </td>
   <td style="text-align:right;"> 19096 </td>
   <td style="text-align:right;"> 2005 </td>
   <td style="text-align:left;"> Grass </td>
   <td style="text-align:left;"> 117 yd × 74 yd(107 m × 68 m) </td>
   <td style="text-align:left;"> 33°9′16″N 96°50′7″W﻿ / ﻿33.15444°N 96.83528°W﻿ / 33.15444; -96.83528﻿ (Toyota Stadium) </td>
   <td style="text-align:left;"> Open </td>
   <td style="text-align:left;"> Yes </td>
  </tr>
  <tr>
   <td style="text-align:left;"> TQL Stadium </td>
   <td style="text-align:left;"> FC Cincinnati </td>
   <td style="text-align:left;"> Cincinnati, Ohio </td>
   <td style="text-align:right;"> 2021 </td>
   <td style="text-align:right;"> 26000 </td>
   <td style="text-align:right;"> 2021 </td>
   <td style="text-align:left;"> Hybrid grass </td>
   <td style="text-align:left;"> 110 yd × 75 yd(101 m × 69 m) </td>
   <td style="text-align:left;"> 39°06′41″N 84°31′20″W﻿ / ﻿39.11139°N 84.52222°W﻿ / 39.11139; -84.52222﻿ (TQL Stadium) </td>
   <td style="text-align:left;"> Open </td>
   <td style="text-align:left;"> Yes </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Yankee Stadium </td>
   <td style="text-align:left;"> New York City FC </td>
   <td style="text-align:left;"> Bronx, New York </td>
   <td style="text-align:right;"> 2015 </td>
   <td style="text-align:right;"> 30321 </td>
   <td style="text-align:right;"> 2009 </td>
   <td style="text-align:left;"> Grass </td>
   <td style="text-align:left;"> 110 yd × 70 yd(101 m × 64 m) </td>
   <td style="text-align:left;"> 40°49′45″N 73°55′35″W﻿ / ﻿40.82917°N 73.92639°W﻿ / 40.82917; -73.92639﻿ (Yankee Stadium) </td>
   <td style="text-align:left;"> Open </td>
   <td style="text-align:left;"> No </td>
  </tr>
</tbody>
</table>


The same steps were then taken for the USL Championship stadium data also taken 
from Wikipedia: https://en.wikipedia.org/wiki/2023_USL_Championship_season.

The USL data required an extra cleaning due to some stadium names having "[A]"
by their names, indicating that the stadium was not soccer-specific. Removing
the [A] required the use of the gsub function and a regular expression.



```r
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
```

<table class="table" style="margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> Team </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> Stadium </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> Capacity </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Birmingham Legion FC </td>
   <td style="text-align:left;"> Protective Stadium </td>
   <td style="text-align:right;"> 47000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Charleston Battery </td>
   <td style="text-align:left;"> Patriots Point Soccer Complex </td>
   <td style="text-align:right;"> 5000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Colorado Springs Switchbacks FC </td>
   <td style="text-align:left;"> Weidner Field </td>
   <td style="text-align:right;"> 8000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Detroit City FC </td>
   <td style="text-align:left;"> Keyworth Stadium </td>
   <td style="text-align:right;"> 7933 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> FC Tulsa </td>
   <td style="text-align:left;"> ONEOK Field </td>
   <td style="text-align:right;"> 7833 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> El Paso Locomotive FC </td>
   <td style="text-align:left;"> Southwest University Park </td>
   <td style="text-align:right;"> 9500 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Hartford Athletic </td>
   <td style="text-align:left;"> Trinity Health Stadium </td>
   <td style="text-align:right;"> 5500 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Indy Eleven </td>
   <td style="text-align:left;"> IU Michael A. Carroll Track &amp; Soccer Stadium </td>
   <td style="text-align:right;"> 10524 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Las Vegas Lights FC </td>
   <td style="text-align:left;"> Cashman Field </td>
   <td style="text-align:right;"> 9334 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Loudoun United FC </td>
   <td style="text-align:left;"> Segra Field </td>
   <td style="text-align:right;"> 5000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Louisville City FC </td>
   <td style="text-align:left;"> Lynn Family Stadium </td>
   <td style="text-align:right;"> 15304 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Memphis 901 FC </td>
   <td style="text-align:left;"> AutoZone Park </td>
   <td style="text-align:right;"> 10000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Miami FC </td>
   <td style="text-align:left;"> Riccardo Silva Stadium </td>
   <td style="text-align:right;"> 25000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Monterey Bay FC </td>
   <td style="text-align:left;"> Cardinale Stadium </td>
   <td style="text-align:right;"> 6000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> New Mexico United </td>
   <td style="text-align:left;"> Rio Grande Credit Union Field at Isotopes Park </td>
   <td style="text-align:right;"> 13500 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Oakland Roots SC </td>
   <td style="text-align:left;"> Pioneer Stadium </td>
   <td style="text-align:right;"> 5000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Orange County SC </td>
   <td style="text-align:left;"> Championship Soccer Stadium </td>
   <td style="text-align:right;"> 5000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Phoenix Rising FC </td>
   <td style="text-align:left;"> Phoenix Rising Soccer Stadium </td>
   <td style="text-align:right;"> 10000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Pittsburgh Riverhounds SC </td>
   <td style="text-align:left;"> Highmark Stadium </td>
   <td style="text-align:right;"> 5000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Rio Grande Valley FC </td>
   <td style="text-align:left;"> H-E-B Park </td>
   <td style="text-align:right;"> 9400 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Sacramento Republic FC </td>
   <td style="text-align:left;"> Heart Health Park </td>
   <td style="text-align:right;"> 11569 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> San Antonio FC </td>
   <td style="text-align:left;"> Toyota Field </td>
   <td style="text-align:right;"> 8296 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> San Diego Loyal SC </td>
   <td style="text-align:left;"> Torero Stadium </td>
   <td style="text-align:right;"> 6000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Tampa Bay Rowdies </td>
   <td style="text-align:left;"> Al Lang Stadium </td>
   <td style="text-align:right;"> 7227 </td>
  </tr>
</tbody>
</table>


## Joining both the MLS and USL data sets

For this join I utilized the stringdist_inner_join() function from the fuzzyjoin
library, allowing me to join both the attendance and stadium data by matching 
the two tables with the 'team' variable. This is why we went through the 
trouble of renaming some of team names earlier in the process. 



```r
# Merge stadium data with leagues data frame
mls_filter <- stadium_MLS %>%
  subset(select = c("Stadium","Team","Capacity"))

stadium_joined <- rbind(mls_filter, usl_stadium)

# joining data for attendance and stadium capacity
leagues_master <- leagues_joined %>%
  stringdist_inner_join(stadium_joined, by ="Team", max_dist = 3) %>%
  select(-Team.y) %>%
  rename(Teams = Team.x)
```


I also created two other columns in the table so we can have insight into what
percentage of the stadium was filled on average for both 2022 and 2023. 



```r
# creation of % filled columns
leagues_master <- leagues_master %>%
  mutate("%_2023_Fill" = (Average/Capacity)) %>%
  mutate("%_2022_Fill" = (leagues_master$`2022 Average`/Capacity))
```


Here is the table with the most recent additions:


<table class="table" style="margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> Teams </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> Average </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> Totals </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> Games </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> 2022 Average </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> YOY </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> Stadium </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> Capacity </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> %_2023_Fill </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> %_2022_Fill </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Sacramento Republic FC </td>
   <td style="text-align:right;"> 10627 </td>
   <td style="text-align:right;"> 180665 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 9876 </td>
   <td style="text-align:right;"> 0.08 </td>
   <td style="text-align:left;"> Heart Health Park </td>
   <td style="text-align:right;"> 11569 </td>
   <td style="text-align:right;"> 0.9185755 </td>
   <td style="text-align:right;"> 0.8536606 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Louisville City FC </td>
   <td style="text-align:right;"> 10547 </td>
   <td style="text-align:right;"> 179299 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 10465 </td>
   <td style="text-align:right;"> 0.01 </td>
   <td style="text-align:left;"> Lynn Family Stadium </td>
   <td style="text-align:right;"> 15304 </td>
   <td style="text-align:right;"> 0.6891662 </td>
   <td style="text-align:right;"> 0.6838082 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Indy Eleven </td>
   <td style="text-align:right;"> 9709 </td>
   <td style="text-align:right;"> 155349 </td>
   <td style="text-align:right;"> 16 </td>
   <td style="text-align:right;"> 8285 </td>
   <td style="text-align:right;"> 0.17 </td>
   <td style="text-align:left;"> IU Michael A. Carroll Track &amp; Soccer Stadium </td>
   <td style="text-align:right;"> 10524 </td>
   <td style="text-align:right;"> 0.9225580 </td>
   <td style="text-align:right;"> 0.7872482 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> New Mexico United </td>
   <td style="text-align:right;"> 9619 </td>
   <td style="text-align:right;"> 163518 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 10724 </td>
   <td style="text-align:right;"> -0.10 </td>
   <td style="text-align:left;"> Rio Grande Credit Union Field at Isotopes Park </td>
   <td style="text-align:right;"> 13500 </td>
   <td style="text-align:right;"> 0.7125185 </td>
   <td style="text-align:right;"> 0.7943704 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Colorado Springs Switchbacks FC </td>
   <td style="text-align:right;"> 7753 </td>
   <td style="text-align:right;"> 124044 </td>
   <td style="text-align:right;"> 16 </td>
   <td style="text-align:right;"> 7199 </td>
   <td style="text-align:right;"> 0.08 </td>
   <td style="text-align:left;"> Weidner Field </td>
   <td style="text-align:right;"> 8000 </td>
   <td style="text-align:right;"> 0.9691250 </td>
   <td style="text-align:right;"> 0.8998750 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Phoenix Rising FC </td>
   <td style="text-align:right;"> 7409 </td>
   <td style="text-align:right;"> 29634 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 6401 </td>
   <td style="text-align:right;"> 0.16 </td>
   <td style="text-align:left;"> Phoenix Rising Soccer Stadium </td>
   <td style="text-align:right;"> 10000 </td>
   <td style="text-align:right;"> 0.7409000 </td>
   <td style="text-align:right;"> 0.6401000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> San Antonio FC </td>
   <td style="text-align:right;"> 7325 </td>
   <td style="text-align:right;"> 124522 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 5980 </td>
   <td style="text-align:right;"> 0.22 </td>
   <td style="text-align:left;"> Toyota Field </td>
   <td style="text-align:right;"> 8296 </td>
   <td style="text-align:right;"> 0.8829556 </td>
   <td style="text-align:right;"> 0.7208293 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> El Paso Locomotive FC </td>
   <td style="text-align:right;"> 6590 </td>
   <td style="text-align:right;"> 112038 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 6517 </td>
   <td style="text-align:right;"> 0.01 </td>
   <td style="text-align:left;"> Southwest University Park </td>
   <td style="text-align:right;"> 9500 </td>
   <td style="text-align:right;"> 0.6936842 </td>
   <td style="text-align:right;"> 0.6860000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Detroit City FC </td>
   <td style="text-align:right;"> 6032 </td>
   <td style="text-align:right;"> 102544 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 6118 </td>
   <td style="text-align:right;"> -0.01 </td>
   <td style="text-align:left;"> Keyworth Stadium </td>
   <td style="text-align:right;"> 7933 </td>
   <td style="text-align:right;"> 0.7603681 </td>
   <td style="text-align:right;"> 0.7712089 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Tampa Bay Rowdies </td>
   <td style="text-align:right;"> 5984 </td>
   <td style="text-align:right;"> 77797 </td>
   <td style="text-align:right;"> 13 </td>
   <td style="text-align:right;"> 5148 </td>
   <td style="text-align:right;"> 0.16 </td>
   <td style="text-align:left;"> Al Lang Stadium </td>
   <td style="text-align:right;"> 7227 </td>
   <td style="text-align:right;"> 0.8280061 </td>
   <td style="text-align:right;"> 0.7123288 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Birmingham Legion FC </td>
   <td style="text-align:right;"> 5091 </td>
   <td style="text-align:right;"> 20362 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 5920 </td>
   <td style="text-align:right;"> -0.14 </td>
   <td style="text-align:left;"> Protective Stadium </td>
   <td style="text-align:right;"> 47000 </td>
   <td style="text-align:right;"> 0.1083191 </td>
   <td style="text-align:right;"> 0.1259574 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Pittsburgh Riverhounds </td>
   <td style="text-align:right;"> 5073 </td>
   <td style="text-align:right;"> 76095 </td>
   <td style="text-align:right;"> 15 </td>
   <td style="text-align:right;"> 3934 </td>
   <td style="text-align:right;"> 0.29 </td>
   <td style="text-align:left;"> Highmark Stadium </td>
   <td style="text-align:right;"> 5000 </td>
   <td style="text-align:right;"> 1.0146000 </td>
   <td style="text-align:right;"> 0.7868000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Hartford Athletic </td>
   <td style="text-align:right;"> 4882 </td>
   <td style="text-align:right;"> 73224 </td>
   <td style="text-align:right;"> 15 </td>
   <td style="text-align:right;"> 5178 </td>
   <td style="text-align:right;"> -0.06 </td>
   <td style="text-align:left;"> Trinity Health Stadium </td>
   <td style="text-align:right;"> 5500 </td>
   <td style="text-align:right;"> 0.8876364 </td>
   <td style="text-align:right;"> 0.9414545 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> San Diego Loyal </td>
   <td style="text-align:right;"> 4754 </td>
   <td style="text-align:right;"> 71309 </td>
   <td style="text-align:right;"> 15 </td>
   <td style="text-align:right;"> 4519 </td>
   <td style="text-align:right;"> 0.05 </td>
   <td style="text-align:left;"> Torero Stadium </td>
   <td style="text-align:right;"> 6000 </td>
   <td style="text-align:right;"> 0.7923333 </td>
   <td style="text-align:right;"> 0.7531667 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Rio Grande Valley FC </td>
   <td style="text-align:right;"> 4506 </td>
   <td style="text-align:right;"> 72095 </td>
   <td style="text-align:right;"> 16 </td>
   <td style="text-align:right;"> 4074 </td>
   <td style="text-align:right;"> 0.11 </td>
   <td style="text-align:left;"> H-E-B Park </td>
   <td style="text-align:right;"> 9400 </td>
   <td style="text-align:right;"> 0.4793617 </td>
   <td style="text-align:right;"> 0.4334043 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Orange County SC </td>
   <td style="text-align:right;"> 4411 </td>
   <td style="text-align:right;"> 70568 </td>
   <td style="text-align:right;"> 16 </td>
   <td style="text-align:right;"> 4230 </td>
   <td style="text-align:right;"> 0.04 </td>
   <td style="text-align:left;"> Championship Soccer Stadium </td>
   <td style="text-align:right;"> 5000 </td>
   <td style="text-align:right;"> 0.8822000 </td>
   <td style="text-align:right;"> 0.8460000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> FC Tulsa </td>
   <td style="text-align:right;"> 4320 </td>
   <td style="text-align:right;"> 73443 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 4044 </td>
   <td style="text-align:right;"> 0.07 </td>
   <td style="text-align:left;"> ONEOK Field </td>
   <td style="text-align:right;"> 7833 </td>
   <td style="text-align:right;"> 0.5515128 </td>
   <td style="text-align:right;"> 0.5162773 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Monterey Bay FC </td>
   <td style="text-align:right;"> 3963 </td>
   <td style="text-align:right;"> 67378 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 3683 </td>
   <td style="text-align:right;"> 0.08 </td>
   <td style="text-align:left;"> Cardinale Stadium </td>
   <td style="text-align:right;"> 6000 </td>
   <td style="text-align:right;"> 0.6605000 </td>
   <td style="text-align:right;"> 0.6138333 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Oakland Roots SC </td>
   <td style="text-align:right;"> 3894 </td>
   <td style="text-align:right;"> 66196 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 4611 </td>
   <td style="text-align:right;"> -0.16 </td>
   <td style="text-align:left;"> Pioneer Stadium </td>
   <td style="text-align:right;"> 5000 </td>
   <td style="text-align:right;"> 0.7788000 </td>
   <td style="text-align:right;"> 0.9222000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Memphis 901 FC </td>
   <td style="text-align:right;"> 3344 </td>
   <td style="text-align:right;"> 33439 </td>
   <td style="text-align:right;"> 10 </td>
   <td style="text-align:right;"> 3683 </td>
   <td style="text-align:right;"> -0.09 </td>
   <td style="text-align:left;"> AutoZone Park </td>
   <td style="text-align:right;"> 10000 </td>
   <td style="text-align:right;"> 0.3344000 </td>
   <td style="text-align:right;"> 0.3683000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Charleston Battery </td>
   <td style="text-align:right;"> 3113 </td>
   <td style="text-align:right;"> 52919 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 2797 </td>
   <td style="text-align:right;"> 0.11 </td>
   <td style="text-align:left;"> Patriots Point Soccer Complex </td>
   <td style="text-align:right;"> 5000 </td>
   <td style="text-align:right;"> 0.6226000 </td>
   <td style="text-align:right;"> 0.5594000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Loudoun United FC </td>
   <td style="text-align:right;"> 2664 </td>
   <td style="text-align:right;"> 45288 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 1583 </td>
   <td style="text-align:right;"> 0.68 </td>
   <td style="text-align:left;"> Segra Field </td>
   <td style="text-align:right;"> 5000 </td>
   <td style="text-align:right;"> 0.5328000 </td>
   <td style="text-align:right;"> 0.3166000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Miami FC </td>
   <td style="text-align:right;"> 1432 </td>
   <td style="text-align:right;"> 24340 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 1162 </td>
   <td style="text-align:right;"> 0.23 </td>
   <td style="text-align:left;"> Riccardo Silva Stadium </td>
   <td style="text-align:right;"> 25000 </td>
   <td style="text-align:right;"> 0.0572800 </td>
   <td style="text-align:right;"> 0.0464800 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Atlanta United FC </td>
   <td style="text-align:right;"> 47526 </td>
   <td style="text-align:right;"> 807947 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 41116 </td>
   <td style="text-align:right;"> 0.16 </td>
   <td style="text-align:left;"> Mercedes-Benz Stadium ‡ </td>
   <td style="text-align:right;"> 42500 </td>
   <td style="text-align:right;"> 1.1182588 </td>
   <td style="text-align:right;"> 0.9674353 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Charlotte FC </td>
   <td style="text-align:right;"> 35544 </td>
   <td style="text-align:right;"> 604246 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 35260 </td>
   <td style="text-align:right;"> 0.01 </td>
   <td style="text-align:left;"> Bank of America Stadium </td>
   <td style="text-align:right;"> 38000 </td>
   <td style="text-align:right;"> 0.9353684 </td>
   <td style="text-align:right;"> 0.9278947 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Seattle Sounders </td>
   <td style="text-align:right;"> 32161 </td>
   <td style="text-align:right;"> 546744 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 33607 </td>
   <td style="text-align:right;"> -0.04 </td>
   <td style="text-align:left;"> Lumen Field </td>
   <td style="text-align:right;"> 37722 </td>
   <td style="text-align:right;"> 0.8525794 </td>
   <td style="text-align:right;"> 0.8909125 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Nashville SC </td>
   <td style="text-align:right;"> 28257 </td>
   <td style="text-align:right;"> 480370 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 27554 </td>
   <td style="text-align:right;"> 0.03 </td>
   <td style="text-align:left;"> Geodis Park </td>
   <td style="text-align:right;"> 30000 </td>
   <td style="text-align:right;"> 0.9419000 </td>
   <td style="text-align:right;"> 0.9184667 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> FC Cincinnati </td>
   <td style="text-align:right;"> 25367 </td>
   <td style="text-align:right;"> 431237 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 22487 </td>
   <td style="text-align:right;"> 0.13 </td>
   <td style="text-align:left;"> TQL Stadium </td>
   <td style="text-align:right;"> 26000 </td>
   <td style="text-align:right;"> 0.9756538 </td>
   <td style="text-align:right;"> 0.8648846 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Toronto FC </td>
   <td style="text-align:right;"> 25310 </td>
   <td style="text-align:right;"> 430263 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 25423 </td>
   <td style="text-align:right;"> 0.00 </td>
   <td style="text-align:left;"> BMO Field </td>
   <td style="text-align:right;"> 30991 </td>
   <td style="text-align:right;"> 0.8166887 </td>
   <td style="text-align:right;"> 0.8203349 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Los Angeles Galaxy </td>
   <td style="text-align:right;"> 24106 </td>
   <td style="text-align:right;"> 409794 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 22841 </td>
   <td style="text-align:right;"> 0.06 </td>
   <td style="text-align:left;"> Dignity Health Sports Park </td>
   <td style="text-align:right;"> 27000 </td>
   <td style="text-align:right;"> 0.8928148 </td>
   <td style="text-align:right;"> 0.8459630 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> New England Revolution </td>
   <td style="text-align:right;"> 23940 </td>
   <td style="text-align:right;"> 406981 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 20319 </td>
   <td style="text-align:right;"> 0.18 </td>
   <td style="text-align:left;"> Gillette Stadium </td>
   <td style="text-align:right;"> 20000 </td>
   <td style="text-align:right;"> 1.1970000 </td>
   <td style="text-align:right;"> 1.0159500 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Portland Timbers </td>
   <td style="text-align:right;"> 23103 </td>
   <td style="text-align:right;"> 392744 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 23841 </td>
   <td style="text-align:right;"> -0.03 </td>
   <td style="text-align:left;"> Providence Park </td>
   <td style="text-align:right;"> 25218 </td>
   <td style="text-align:right;"> 0.9161313 </td>
   <td style="text-align:right;"> 0.9453961 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> St. Louis City SC </td>
   <td style="text-align:right;"> 22423 </td>
   <td style="text-align:right;"> 381191 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:left;"> CityPark </td>
   <td style="text-align:right;"> 22500 </td>
   <td style="text-align:right;"> 0.9965778 </td>
   <td style="text-align:right;"> NA </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Los Angeles FC </td>
   <td style="text-align:right;"> 22155 </td>
   <td style="text-align:right;"> 376643 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 22090 </td>
   <td style="text-align:right;"> 0.00 </td>
   <td style="text-align:left;"> BMO Stadium </td>
   <td style="text-align:right;"> 22000 </td>
   <td style="text-align:right;"> 1.0070455 </td>
   <td style="text-align:right;"> 1.0040909 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Austin FC </td>
   <td style="text-align:right;"> 20738 </td>
   <td style="text-align:right;"> 352546 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 20738 </td>
   <td style="text-align:right;"> 0.00 </td>
   <td style="text-align:left;"> Q2 Stadium </td>
   <td style="text-align:right;"> 20738 </td>
   <td style="text-align:right;"> 1.0000000 </td>
   <td style="text-align:right;"> 1.0000000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Orlando City SC </td>
   <td style="text-align:right;"> 20590 </td>
   <td style="text-align:right;"> 350023 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 17261 </td>
   <td style="text-align:right;"> 0.19 </td>
   <td style="text-align:left;"> Inter&amp;Co Stadium </td>
   <td style="text-align:right;"> 25500 </td>
   <td style="text-align:right;"> 0.8074510 </td>
   <td style="text-align:right;"> 0.6769020 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Columbus Crew </td>
   <td style="text-align:right;"> 20314 </td>
   <td style="text-align:right;"> 345338 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 19237 </td>
   <td style="text-align:right;"> 0.06 </td>
   <td style="text-align:left;"> Lower.com Field </td>
   <td style="text-align:right;"> 20371 </td>
   <td style="text-align:right;"> 0.9972019 </td>
   <td style="text-align:right;"> 0.9443326 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Minnesota United </td>
   <td style="text-align:right;"> 19568 </td>
   <td style="text-align:right;"> 332659 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 19555 </td>
   <td style="text-align:right;"> 0.00 </td>
   <td style="text-align:left;"> Allianz Field </td>
   <td style="text-align:right;"> 19400 </td>
   <td style="text-align:right;"> 1.0086598 </td>
   <td style="text-align:right;"> 1.0079897 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> New York City FC </td>
   <td style="text-align:right;"> 19477 </td>
   <td style="text-align:right;"> 331109 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 17180 </td>
   <td style="text-align:right;"> 0.13 </td>
   <td style="text-align:left;"> Yankee Stadium </td>
   <td style="text-align:right;"> 30321 </td>
   <td style="text-align:right;"> 0.6423601 </td>
   <td style="text-align:right;"> 0.5666040 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Real Salt Lake </td>
   <td style="text-align:right;"> 19429 </td>
   <td style="text-align:right;"> 330290 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 20470 </td>
   <td style="text-align:right;"> -0.05 </td>
   <td style="text-align:left;"> America First Field </td>
   <td style="text-align:right;"> 20213 </td>
   <td style="text-align:right;"> 0.9612131 </td>
   <td style="text-align:right;"> 1.0127146 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Philadelphia Union </td>
   <td style="text-align:right;"> 18907 </td>
   <td style="text-align:right;"> 321416 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 18126 </td>
   <td style="text-align:right;"> 0.04 </td>
   <td style="text-align:left;"> Subaru Park </td>
   <td style="text-align:right;"> 18500 </td>
   <td style="text-align:right;"> 1.0220000 </td>
   <td style="text-align:right;"> 0.9797838 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Sporting Kansas City </td>
   <td style="text-align:right;"> 18616 </td>
   <td style="text-align:right;"> 316474 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 18365 </td>
   <td style="text-align:right;"> 0.01 </td>
   <td style="text-align:left;"> Children's Mercy Park </td>
   <td style="text-align:right;"> 18467 </td>
   <td style="text-align:right;"> 1.0080684 </td>
   <td style="text-align:right;"> 0.9944766 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> San Jose Earthquakes </td>
   <td style="text-align:right;"> 18412 </td>
   <td style="text-align:right;"> 313003 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 15260 </td>
   <td style="text-align:right;"> 0.21 </td>
   <td style="text-align:left;"> PayPal Park </td>
   <td style="text-align:right;"> 18000 </td>
   <td style="text-align:right;"> 1.0228889 </td>
   <td style="text-align:right;"> 0.8477778 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> New York Red Bulls </td>
   <td style="text-align:right;"> 18246 </td>
   <td style="text-align:right;"> 310190 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 17002 </td>
   <td style="text-align:right;"> 0.07 </td>
   <td style="text-align:left;"> Red Bull Arena </td>
   <td style="text-align:right;"> 25000 </td>
   <td style="text-align:right;"> 0.7298400 </td>
   <td style="text-align:right;"> 0.6800800 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> FC Dallas </td>
   <td style="text-align:right;"> 18239 </td>
   <td style="text-align:right;"> 310065 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 17469 </td>
   <td style="text-align:right;"> 0.04 </td>
   <td style="text-align:left;"> Toyota Stadium </td>
   <td style="text-align:right;"> 19096 </td>
   <td style="text-align:right;"> 0.9551215 </td>
   <td style="text-align:right;"> 0.9147989 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Chicago Fire </td>
   <td style="text-align:right;"> 18175 </td>
   <td style="text-align:right;"> 308975 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 15848 </td>
   <td style="text-align:right;"> 0.15 </td>
   <td style="text-align:left;"> Soldier Field </td>
   <td style="text-align:right;"> 24955 </td>
   <td style="text-align:right;"> 0.7283110 </td>
   <td style="text-align:right;"> 0.6350631 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Inter Miami CF </td>
   <td style="text-align:right;"> 17579 </td>
   <td style="text-align:right;"> 281257 </td>
   <td style="text-align:right;"> 16 </td>
   <td style="text-align:right;"> 12637 </td>
   <td style="text-align:right;"> 0.39 </td>
   <td style="text-align:left;"> Chase Stadium </td>
   <td style="text-align:right;"> 21550 </td>
   <td style="text-align:right;"> 0.8157309 </td>
   <td style="text-align:right;"> 0.5864037 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> CF Montreal </td>
   <td style="text-align:right;"> 17562 </td>
   <td style="text-align:right;"> 298556 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 15905 </td>
   <td style="text-align:right;"> 0.10 </td>
   <td style="text-align:left;"> Saputo Stadium </td>
   <td style="text-align:right;"> 19619 </td>
   <td style="text-align:right;"> 0.8951527 </td>
   <td style="text-align:right;"> 0.8106937 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> D.C. United </td>
   <td style="text-align:right;"> 17540 </td>
   <td style="text-align:right;"> 298185 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 16256 </td>
   <td style="text-align:right;"> 0.08 </td>
   <td style="text-align:left;"> Audi Field </td>
   <td style="text-align:right;"> 20000 </td>
   <td style="text-align:right;"> 0.8770000 </td>
   <td style="text-align:right;"> 0.8128000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Vancouver Whitecaps </td>
   <td style="text-align:right;"> 16745 </td>
   <td style="text-align:right;"> 284661 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 16399 </td>
   <td style="text-align:right;"> 0.02 </td>
   <td style="text-align:left;"> BC Place ‡ </td>
   <td style="text-align:right;"> 22120 </td>
   <td style="text-align:right;"> 0.7570072 </td>
   <td style="text-align:right;"> 0.7413653 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Colorado Rapids </td>
   <td style="text-align:right;"> 15409 </td>
   <td style="text-align:right;"> 261953 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 14473 </td>
   <td style="text-align:right;"> 0.06 </td>
   <td style="text-align:left;"> Dick's Sporting Goods Park </td>
   <td style="text-align:right;"> 18061 </td>
   <td style="text-align:right;"> 0.8531643 </td>
   <td style="text-align:right;"> 0.8013399 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Houston Dynamo </td>
   <td style="text-align:right;"> 15027 </td>
   <td style="text-align:right;"> 255465 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 16426 </td>
   <td style="text-align:right;"> -0.09 </td>
   <td style="text-align:left;"> Shell Energy Stadium </td>
   <td style="text-align:right;"> 22039 </td>
   <td style="text-align:right;"> 0.6818367 </td>
   <td style="text-align:right;"> 0.7453151 </td>
  </tr>
</tbody>
</table>


I also made separate data frames for both the MLS and USL. This will allow us 
to analyze the leagues separately later on.



```r
#MLS DF
mls_master <- MLS %>%
  stringdist_inner_join(stadium_MLS, by ="Team", max_dist = 3) %>%
  select(-Team.y) %>%
  rename(Teams = Team.x)
# creation of % filled columns
mls_master <- mls_master %>%
  mutate("%_2023_Fill" = (Average/Capacity)) %>%
  mutate("%_2022_Fill" = (mls_master$`2022 Average`/Capacity))


#USL DF
usl_master <- usl %>%
  stringdist_inner_join(usl_stadium, by ="Team", max_dist = 3) %>%
  select(-Team.y) %>%
  rename(Teams = Team.x)
# creation of % filled columns
usl_master <- usl_master %>%
  mutate("%_2023_Fill" = (Average/Capacity)) %>%
  mutate("%_2022_Fill" = (usl_master$`2022 Average`/Capacity))
```



# Adding Extra Data Values for Exploratory and Correlative Analysis

Two important variables that can provide insight into attendance are points 
and financials. Points being the point value of the team at the end of the 
season. In professional soccer, teams are awarded 3 points for a win and 1 point
for a draw. Theoretically, teams that have more points would have higher
attendance. 

Furthermore, I also hypothesize that there will be a correlation between
the financial valuation of a clubs roster and it's attendance. Teams that 
have higher payrolls and more star players should be able to draw bigger crowds.

Lastly, I'm also curious about what I call "city moral." If a city has happier 
citizens will they be more likely to support the city's club, because in a sense 
the club represents a city. One way to analyze this is by using approval 
ratings of government officials as a measure of support. Mayoral data is tricky
to find so I decided to use Governor approval ratings. This obviously is not the
most effective strategy so this aspect of the project is really just an extra
step.

Let's now input data for these variables. 


## City and State Values

Firstly, I wanted to add in city/state columns for the main data set that 
has been created thus far. Having the location date is important for joining
Governor approval ratings with the correct teams.

Like in the past steps I decided to scrape data from the USL championship 
Wikipedia page. Because this page has multiple tables I had to take the extra
step of subset a list of the tables from the webpage in order to retrive the
table I needed. This required me to utilize html_nodes rather then html_node.


```r
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
```


Fortunately, my MLS stadium data that was previously retrieved already had
location data. Although I did need to separate the city and state names into
different columns and then add the two variables back into the MLS master sheet.



```r
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
```



## 2022 Point Values

Using the same web scraping method as before I utilized data from 
footballdatabase.com for the 2022 MLS points values and data from Wikipedia for 
the 2022 USL Championship point values.



```r
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
```


Here is the DF with the points variable added.


<table class="table" style="margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> Teams </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> Average </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> Totals </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> Games </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> 2022 Average </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> YOY </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> Stadium </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> Capacity </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> %_2023_Fill </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> %_2022_Fill </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> City </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> State </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> 2022 Pts </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Sacramento Republic FC </td>
   <td style="text-align:right;"> 10627 </td>
   <td style="text-align:right;"> 180665 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 9876 </td>
   <td style="text-align:right;"> 0.08 </td>
   <td style="text-align:left;"> Heart Health Park </td>
   <td style="text-align:right;"> 11569 </td>
   <td style="text-align:right;"> 0.9185755 </td>
   <td style="text-align:right;"> 0.8536606 </td>
   <td style="text-align:left;"> Sacramento </td>
   <td style="text-align:left;"> California </td>
   <td style="text-align:right;"> 53 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Louisville City FC </td>
   <td style="text-align:right;"> 10547 </td>
   <td style="text-align:right;"> 179299 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 10465 </td>
   <td style="text-align:right;"> 0.01 </td>
   <td style="text-align:left;"> Lynn Family Stadium </td>
   <td style="text-align:right;"> 15304 </td>
   <td style="text-align:right;"> 0.6891662 </td>
   <td style="text-align:right;"> 0.6838082 </td>
   <td style="text-align:left;"> Louisville </td>
   <td style="text-align:left;"> Kentucky </td>
   <td style="text-align:right;"> 72 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Indy Eleven </td>
   <td style="text-align:right;"> 9709 </td>
   <td style="text-align:right;"> 155349 </td>
   <td style="text-align:right;"> 16 </td>
   <td style="text-align:right;"> 8285 </td>
   <td style="text-align:right;"> 0.17 </td>
   <td style="text-align:left;"> IU Michael A. Carroll Track &amp; Soccer Stadium </td>
   <td style="text-align:right;"> 10524 </td>
   <td style="text-align:right;"> 0.9225580 </td>
   <td style="text-align:right;"> 0.7872482 </td>
   <td style="text-align:left;"> Indianapolis </td>
   <td style="text-align:left;"> Indiana </td>
   <td style="text-align:right;"> 41 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> New Mexico United </td>
   <td style="text-align:right;"> 9619 </td>
   <td style="text-align:right;"> 163518 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 10724 </td>
   <td style="text-align:right;"> -0.10 </td>
   <td style="text-align:left;"> Rio Grande Credit Union Field at Isotopes Park </td>
   <td style="text-align:right;"> 13500 </td>
   <td style="text-align:right;"> 0.7125185 </td>
   <td style="text-align:right;"> 0.7943704 </td>
   <td style="text-align:left;"> Albuquerque </td>
   <td style="text-align:left;"> New Mexico </td>
   <td style="text-align:right;"> 51 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Colorado Springs Switchbacks FC </td>
   <td style="text-align:right;"> 7753 </td>
   <td style="text-align:right;"> 124044 </td>
   <td style="text-align:right;"> 16 </td>
   <td style="text-align:right;"> 7199 </td>
   <td style="text-align:right;"> 0.08 </td>
   <td style="text-align:left;"> Weidner Field </td>
   <td style="text-align:right;"> 8000 </td>
   <td style="text-align:right;"> 0.9691250 </td>
   <td style="text-align:right;"> 0.8998750 </td>
   <td style="text-align:left;"> Colorado Springs </td>
   <td style="text-align:left;"> Colorado </td>
   <td style="text-align:right;"> 55 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Phoenix Rising FC </td>
   <td style="text-align:right;"> 7409 </td>
   <td style="text-align:right;"> 29634 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 6401 </td>
   <td style="text-align:right;"> 0.16 </td>
   <td style="text-align:left;"> Phoenix Rising Soccer Stadium </td>
   <td style="text-align:right;"> 10000 </td>
   <td style="text-align:right;"> 0.7409000 </td>
   <td style="text-align:right;"> 0.6401000 </td>
   <td style="text-align:left;"> Phoenix </td>
   <td style="text-align:left;"> Arizona </td>
   <td style="text-align:right;"> 42 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> San Antonio FC </td>
   <td style="text-align:right;"> 7325 </td>
   <td style="text-align:right;"> 124522 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 5980 </td>
   <td style="text-align:right;"> 0.22 </td>
   <td style="text-align:left;"> Toyota Field </td>
   <td style="text-align:right;"> 8296 </td>
   <td style="text-align:right;"> 0.8829556 </td>
   <td style="text-align:right;"> 0.7208293 </td>
   <td style="text-align:left;"> San Antonio </td>
   <td style="text-align:left;"> Texas </td>
   <td style="text-align:right;"> 77 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Detroit City FC </td>
   <td style="text-align:right;"> 6032 </td>
   <td style="text-align:right;"> 102544 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 6118 </td>
   <td style="text-align:right;"> -0.01 </td>
   <td style="text-align:left;"> Keyworth Stadium </td>
   <td style="text-align:right;"> 7933 </td>
   <td style="text-align:right;"> 0.7603681 </td>
   <td style="text-align:right;"> 0.7712089 </td>
   <td style="text-align:left;"> Hamtramck </td>
   <td style="text-align:left;"> Michigan </td>
   <td style="text-align:right;"> 54 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Tampa Bay Rowdies </td>
   <td style="text-align:right;"> 5984 </td>
   <td style="text-align:right;"> 77797 </td>
   <td style="text-align:right;"> 13 </td>
   <td style="text-align:right;"> 5148 </td>
   <td style="text-align:right;"> 0.16 </td>
   <td style="text-align:left;"> Al Lang Stadium </td>
   <td style="text-align:right;"> 7227 </td>
   <td style="text-align:right;"> 0.8280061 </td>
   <td style="text-align:right;"> 0.7123288 </td>
   <td style="text-align:left;"> St. Petersburg </td>
   <td style="text-align:left;"> Florida </td>
   <td style="text-align:right;"> 67 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Pittsburgh Riverhounds </td>
   <td style="text-align:right;"> 5073 </td>
   <td style="text-align:right;"> 76095 </td>
   <td style="text-align:right;"> 15 </td>
   <td style="text-align:right;"> 3934 </td>
   <td style="text-align:right;"> 0.29 </td>
   <td style="text-align:left;"> Highmark Stadium </td>
   <td style="text-align:right;"> 5000 </td>
   <td style="text-align:right;"> 1.0146000 </td>
   <td style="text-align:right;"> 0.7868000 </td>
   <td style="text-align:left;"> Pittsburgh </td>
   <td style="text-align:left;"> Pennsylvania </td>
   <td style="text-align:right;"> 57 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Hartford Athletic </td>
   <td style="text-align:right;"> 4882 </td>
   <td style="text-align:right;"> 73224 </td>
   <td style="text-align:right;"> 15 </td>
   <td style="text-align:right;"> 5178 </td>
   <td style="text-align:right;"> -0.06 </td>
   <td style="text-align:left;"> Trinity Health Stadium </td>
   <td style="text-align:right;"> 5500 </td>
   <td style="text-align:right;"> 0.8876364 </td>
   <td style="text-align:right;"> 0.9414545 </td>
   <td style="text-align:left;"> Hartford </td>
   <td style="text-align:left;"> Connecticut </td>
   <td style="text-align:right;"> 36 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Orange County SC </td>
   <td style="text-align:right;"> 4411 </td>
   <td style="text-align:right;"> 70568 </td>
   <td style="text-align:right;"> 16 </td>
   <td style="text-align:right;"> 4230 </td>
   <td style="text-align:right;"> 0.04 </td>
   <td style="text-align:left;"> Championship Soccer Stadium </td>
   <td style="text-align:right;"> 5000 </td>
   <td style="text-align:right;"> 0.8822000 </td>
   <td style="text-align:right;"> 0.8460000 </td>
   <td style="text-align:left;"> Irvine </td>
   <td style="text-align:left;"> California </td>
   <td style="text-align:right;"> 34 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> FC Tulsa </td>
   <td style="text-align:right;"> 4320 </td>
   <td style="text-align:right;"> 73443 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 4044 </td>
   <td style="text-align:right;"> 0.07 </td>
   <td style="text-align:left;"> ONEOK Field </td>
   <td style="text-align:right;"> 7833 </td>
   <td style="text-align:right;"> 0.5515128 </td>
   <td style="text-align:right;"> 0.5162773 </td>
   <td style="text-align:left;"> Tulsa </td>
   <td style="text-align:left;"> Oklahoma </td>
   <td style="text-align:right;"> 42 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Monterey Bay FC </td>
   <td style="text-align:right;"> 3963 </td>
   <td style="text-align:right;"> 67378 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 3683 </td>
   <td style="text-align:right;"> 0.08 </td>
   <td style="text-align:left;"> Cardinale Stadium </td>
   <td style="text-align:right;"> 6000 </td>
   <td style="text-align:right;"> 0.6605000 </td>
   <td style="text-align:right;"> 0.6138333 </td>
   <td style="text-align:left;"> Seaside </td>
   <td style="text-align:left;"> California </td>
   <td style="text-align:right;"> 40 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Oakland Roots SC </td>
   <td style="text-align:right;"> 3894 </td>
   <td style="text-align:right;"> 66196 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 4611 </td>
   <td style="text-align:right;"> -0.16 </td>
   <td style="text-align:left;"> Pioneer Stadium </td>
   <td style="text-align:right;"> 5000 </td>
   <td style="text-align:right;"> 0.7788000 </td>
   <td style="text-align:right;"> 0.9222000 </td>
   <td style="text-align:left;"> Oakland </td>
   <td style="text-align:left;"> California </td>
   <td style="text-align:right;"> 46 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Memphis 901 FC </td>
   <td style="text-align:right;"> 3344 </td>
   <td style="text-align:right;"> 33439 </td>
   <td style="text-align:right;"> 10 </td>
   <td style="text-align:right;"> 3683 </td>
   <td style="text-align:right;"> -0.09 </td>
   <td style="text-align:left;"> AutoZone Park </td>
   <td style="text-align:right;"> 10000 </td>
   <td style="text-align:right;"> 0.3344000 </td>
   <td style="text-align:right;"> 0.3683000 </td>
   <td style="text-align:left;"> Memphis </td>
   <td style="text-align:left;"> Tennessee </td>
   <td style="text-align:right;"> 68 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Charleston Battery </td>
   <td style="text-align:right;"> 3113 </td>
   <td style="text-align:right;"> 52919 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 2797 </td>
   <td style="text-align:right;"> 0.11 </td>
   <td style="text-align:left;"> Patriots Point Soccer Complex </td>
   <td style="text-align:right;"> 5000 </td>
   <td style="text-align:right;"> 0.6226000 </td>
   <td style="text-align:right;"> 0.5594000 </td>
   <td style="text-align:left;"> Mount Pleasant </td>
   <td style="text-align:left;"> South Carolina </td>
   <td style="text-align:right;"> 25 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Loudoun United FC </td>
   <td style="text-align:right;"> 2664 </td>
   <td style="text-align:right;"> 45288 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 1583 </td>
   <td style="text-align:right;"> 0.68 </td>
   <td style="text-align:left;"> Segra Field </td>
   <td style="text-align:right;"> 5000 </td>
   <td style="text-align:right;"> 0.5328000 </td>
   <td style="text-align:right;"> 0.3166000 </td>
   <td style="text-align:left;"> Leesburg </td>
   <td style="text-align:left;"> Virginia </td>
   <td style="text-align:right;"> 28 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Miami FC </td>
   <td style="text-align:right;"> 1432 </td>
   <td style="text-align:right;"> 24340 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 1162 </td>
   <td style="text-align:right;"> 0.23 </td>
   <td style="text-align:left;"> Riccardo Silva Stadium </td>
   <td style="text-align:right;"> 25000 </td>
   <td style="text-align:right;"> 0.0572800 </td>
   <td style="text-align:right;"> 0.0464800 </td>
   <td style="text-align:left;"> University Park </td>
   <td style="text-align:left;"> Florida </td>
   <td style="text-align:right;"> 55 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Atlanta United FC </td>
   <td style="text-align:right;"> 47526 </td>
   <td style="text-align:right;"> 807947 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 41116 </td>
   <td style="text-align:right;"> 0.16 </td>
   <td style="text-align:left;"> Mercedes-Benz Stadium ‡ </td>
   <td style="text-align:right;"> 42500 </td>
   <td style="text-align:right;"> 1.1182588 </td>
   <td style="text-align:right;"> 0.9674353 </td>
   <td style="text-align:left;"> Atlanta </td>
   <td style="text-align:left;"> Georgia </td>
   <td style="text-align:right;"> 23 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Atlanta United FC </td>
   <td style="text-align:right;"> 47526 </td>
   <td style="text-align:right;"> 807947 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 41116 </td>
   <td style="text-align:right;"> 0.16 </td>
   <td style="text-align:left;"> Mercedes-Benz Stadium ‡ </td>
   <td style="text-align:right;"> 42500 </td>
   <td style="text-align:right;"> 1.1182588 </td>
   <td style="text-align:right;"> 0.9674353 </td>
   <td style="text-align:left;"> Atlanta </td>
   <td style="text-align:left;"> Georgia </td>
   <td style="text-align:right;"> 40 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Charlotte FC </td>
   <td style="text-align:right;"> 35544 </td>
   <td style="text-align:right;"> 604246 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 35260 </td>
   <td style="text-align:right;"> 0.01 </td>
   <td style="text-align:left;"> Bank of America Stadium </td>
   <td style="text-align:right;"> 38000 </td>
   <td style="text-align:right;"> 0.9353684 </td>
   <td style="text-align:right;"> 0.9278947 </td>
   <td style="text-align:left;"> Charlotte </td>
   <td style="text-align:left;"> North Carolina </td>
   <td style="text-align:right;"> 42 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Seattle Sounders </td>
   <td style="text-align:right;"> 32161 </td>
   <td style="text-align:right;"> 546744 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 33607 </td>
   <td style="text-align:right;"> -0.04 </td>
   <td style="text-align:left;"> Lumen Field </td>
   <td style="text-align:right;"> 37722 </td>
   <td style="text-align:right;"> 0.8525794 </td>
   <td style="text-align:right;"> 0.8909125 </td>
   <td style="text-align:left;"> Seattle </td>
   <td style="text-align:left;"> Washington </td>
   <td style="text-align:right;"> 41 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Nashville SC </td>
   <td style="text-align:right;"> 28257 </td>
   <td style="text-align:right;"> 480370 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 27554 </td>
   <td style="text-align:right;"> 0.03 </td>
   <td style="text-align:left;"> Geodis Park </td>
   <td style="text-align:right;"> 30000 </td>
   <td style="text-align:right;"> 0.9419000 </td>
   <td style="text-align:right;"> 0.9184667 </td>
   <td style="text-align:left;"> Nashville </td>
   <td style="text-align:left;"> Tennessee </td>
   <td style="text-align:right;"> 50 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> FC Cincinnati </td>
   <td style="text-align:right;"> 25367 </td>
   <td style="text-align:right;"> 431237 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 22487 </td>
   <td style="text-align:right;"> 0.13 </td>
   <td style="text-align:left;"> TQL Stadium </td>
   <td style="text-align:right;"> 26000 </td>
   <td style="text-align:right;"> 0.9756538 </td>
   <td style="text-align:right;"> 0.8648846 </td>
   <td style="text-align:left;"> Cincinnati </td>
   <td style="text-align:left;"> Ohio </td>
   <td style="text-align:right;"> 49 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Toronto FC </td>
   <td style="text-align:right;"> 25310 </td>
   <td style="text-align:right;"> 430263 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 25423 </td>
   <td style="text-align:right;"> 0.00 </td>
   <td style="text-align:left;"> BMO Field </td>
   <td style="text-align:right;"> 30991 </td>
   <td style="text-align:right;"> 0.8166887 </td>
   <td style="text-align:right;"> 0.8203349 </td>
   <td style="text-align:left;"> Toronto </td>
   <td style="text-align:left;"> Ontario </td>
   <td style="text-align:right;"> 34 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Los Angeles Galaxy </td>
   <td style="text-align:right;"> 24106 </td>
   <td style="text-align:right;"> 409794 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 22841 </td>
   <td style="text-align:right;"> 0.06 </td>
   <td style="text-align:left;"> Dignity Health Sports Park </td>
   <td style="text-align:right;"> 27000 </td>
   <td style="text-align:right;"> 0.8928148 </td>
   <td style="text-align:right;"> 0.8459630 </td>
   <td style="text-align:left;"> Carson </td>
   <td style="text-align:left;"> California </td>
   <td style="text-align:right;"> 50 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> New England Revolution </td>
   <td style="text-align:right;"> 23940 </td>
   <td style="text-align:right;"> 406981 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 20319 </td>
   <td style="text-align:right;"> 0.18 </td>
   <td style="text-align:left;"> Gillette Stadium </td>
   <td style="text-align:right;"> 20000 </td>
   <td style="text-align:right;"> 1.1970000 </td>
   <td style="text-align:right;"> 1.0159500 </td>
   <td style="text-align:left;"> Foxborough </td>
   <td style="text-align:left;"> Massachusetts </td>
   <td style="text-align:right;"> 42 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Portland Timbers </td>
   <td style="text-align:right;"> 23103 </td>
   <td style="text-align:right;"> 392744 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 23841 </td>
   <td style="text-align:right;"> -0.03 </td>
   <td style="text-align:left;"> Providence Park </td>
   <td style="text-align:right;"> 25218 </td>
   <td style="text-align:right;"> 0.9161313 </td>
   <td style="text-align:right;"> 0.9453961 </td>
   <td style="text-align:left;"> Portland </td>
   <td style="text-align:left;"> Oregon </td>
   <td style="text-align:right;"> 46 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Los Angeles FC </td>
   <td style="text-align:right;"> 22155 </td>
   <td style="text-align:right;"> 376643 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 22090 </td>
   <td style="text-align:right;"> 0.00 </td>
   <td style="text-align:left;"> BMO Stadium </td>
   <td style="text-align:right;"> 22000 </td>
   <td style="text-align:right;"> 1.0070455 </td>
   <td style="text-align:right;"> 1.0040909 </td>
   <td style="text-align:left;"> Los Angeles </td>
   <td style="text-align:left;"> California </td>
   <td style="text-align:right;"> 67 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Austin FC </td>
   <td style="text-align:right;"> 20738 </td>
   <td style="text-align:right;"> 352546 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 20738 </td>
   <td style="text-align:right;"> 0.00 </td>
   <td style="text-align:left;"> Q2 Stadium </td>
   <td style="text-align:right;"> 20738 </td>
   <td style="text-align:right;"> 1.0000000 </td>
   <td style="text-align:right;"> 1.0000000 </td>
   <td style="text-align:left;"> Austin </td>
   <td style="text-align:left;"> Texas </td>
   <td style="text-align:right;"> 56 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Orlando City SC </td>
   <td style="text-align:right;"> 20590 </td>
   <td style="text-align:right;"> 350023 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 17261 </td>
   <td style="text-align:right;"> 0.19 </td>
   <td style="text-align:left;"> Inter&amp;Co Stadium </td>
   <td style="text-align:right;"> 25500 </td>
   <td style="text-align:right;"> 0.8074510 </td>
   <td style="text-align:right;"> 0.6769020 </td>
   <td style="text-align:left;"> Orlando </td>
   <td style="text-align:left;"> Florida </td>
   <td style="text-align:right;"> 48 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Columbus Crew </td>
   <td style="text-align:right;"> 20314 </td>
   <td style="text-align:right;"> 345338 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 19237 </td>
   <td style="text-align:right;"> 0.06 </td>
   <td style="text-align:left;"> Lower.com Field </td>
   <td style="text-align:right;"> 20371 </td>
   <td style="text-align:right;"> 0.9972019 </td>
   <td style="text-align:right;"> 0.9443326 </td>
   <td style="text-align:left;"> Columbus </td>
   <td style="text-align:left;"> Ohio </td>
   <td style="text-align:right;"> 46 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Minnesota United </td>
   <td style="text-align:right;"> 19568 </td>
   <td style="text-align:right;"> 332659 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 19555 </td>
   <td style="text-align:right;"> 0.00 </td>
   <td style="text-align:left;"> Allianz Field </td>
   <td style="text-align:right;"> 19400 </td>
   <td style="text-align:right;"> 1.0086598 </td>
   <td style="text-align:right;"> 1.0079897 </td>
   <td style="text-align:left;"> Saint Paul </td>
   <td style="text-align:left;"> Minnesota </td>
   <td style="text-align:right;"> 48 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> New York City FC </td>
   <td style="text-align:right;"> 19477 </td>
   <td style="text-align:right;"> 331109 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 17180 </td>
   <td style="text-align:right;"> 0.13 </td>
   <td style="text-align:left;"> Yankee Stadium </td>
   <td style="text-align:right;"> 30321 </td>
   <td style="text-align:right;"> 0.6423601 </td>
   <td style="text-align:right;"> 0.5666040 </td>
   <td style="text-align:left;"> Bronx </td>
   <td style="text-align:left;"> New York </td>
   <td style="text-align:right;"> 55 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Real Salt Lake </td>
   <td style="text-align:right;"> 19429 </td>
   <td style="text-align:right;"> 330290 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 20470 </td>
   <td style="text-align:right;"> -0.05 </td>
   <td style="text-align:left;"> America First Field </td>
   <td style="text-align:right;"> 20213 </td>
   <td style="text-align:right;"> 0.9612131 </td>
   <td style="text-align:right;"> 1.0127146 </td>
   <td style="text-align:left;"> Sandy </td>
   <td style="text-align:left;"> Utah </td>
   <td style="text-align:right;"> 47 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Philadelphia Union </td>
   <td style="text-align:right;"> 18907 </td>
   <td style="text-align:right;"> 321416 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 18126 </td>
   <td style="text-align:right;"> 0.04 </td>
   <td style="text-align:left;"> Subaru Park </td>
   <td style="text-align:right;"> 18500 </td>
   <td style="text-align:right;"> 1.0220000 </td>
   <td style="text-align:right;"> 0.9797838 </td>
   <td style="text-align:left;"> Chester </td>
   <td style="text-align:left;"> Pennsylvania </td>
   <td style="text-align:right;"> 67 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Sporting Kansas City </td>
   <td style="text-align:right;"> 18616 </td>
   <td style="text-align:right;"> 316474 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 18365 </td>
   <td style="text-align:right;"> 0.01 </td>
   <td style="text-align:left;"> Children's Mercy Park </td>
   <td style="text-align:right;"> 18467 </td>
   <td style="text-align:right;"> 1.0080684 </td>
   <td style="text-align:right;"> 0.9944766 </td>
   <td style="text-align:left;"> Kansas City </td>
   <td style="text-align:left;"> Kansas </td>
   <td style="text-align:right;"> 40 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> San Jose Earthquakes </td>
   <td style="text-align:right;"> 18412 </td>
   <td style="text-align:right;"> 313003 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 15260 </td>
   <td style="text-align:right;"> 0.21 </td>
   <td style="text-align:left;"> PayPal Park </td>
   <td style="text-align:right;"> 18000 </td>
   <td style="text-align:right;"> 1.0228889 </td>
   <td style="text-align:right;"> 0.8477778 </td>
   <td style="text-align:left;"> San Jose </td>
   <td style="text-align:left;"> California </td>
   <td style="text-align:right;"> 35 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> New York Red Bulls </td>
   <td style="text-align:right;"> 18246 </td>
   <td style="text-align:right;"> 310190 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 17002 </td>
   <td style="text-align:right;"> 0.07 </td>
   <td style="text-align:left;"> Red Bull Arena </td>
   <td style="text-align:right;"> 25000 </td>
   <td style="text-align:right;"> 0.7298400 </td>
   <td style="text-align:right;"> 0.6800800 </td>
   <td style="text-align:left;"> Harrison </td>
   <td style="text-align:left;"> New Jersey </td>
   <td style="text-align:right;"> 15 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> New York Red Bulls </td>
   <td style="text-align:right;"> 18246 </td>
   <td style="text-align:right;"> 310190 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 17002 </td>
   <td style="text-align:right;"> 0.07 </td>
   <td style="text-align:left;"> Red Bull Arena </td>
   <td style="text-align:right;"> 25000 </td>
   <td style="text-align:right;"> 0.7298400 </td>
   <td style="text-align:right;"> 0.6800800 </td>
   <td style="text-align:left;"> Harrison </td>
   <td style="text-align:left;"> New Jersey </td>
   <td style="text-align:right;"> 53 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> FC Dallas </td>
   <td style="text-align:right;"> 18239 </td>
   <td style="text-align:right;"> 310065 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 17469 </td>
   <td style="text-align:right;"> 0.04 </td>
   <td style="text-align:left;"> Toyota Stadium </td>
   <td style="text-align:right;"> 19096 </td>
   <td style="text-align:right;"> 0.9551215 </td>
   <td style="text-align:right;"> 0.9147989 </td>
   <td style="text-align:left;"> Frisco </td>
   <td style="text-align:left;"> Texas </td>
   <td style="text-align:right;"> 53 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Chicago Fire </td>
   <td style="text-align:right;"> 18175 </td>
   <td style="text-align:right;"> 308975 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 15848 </td>
   <td style="text-align:right;"> 0.15 </td>
   <td style="text-align:left;"> Soldier Field </td>
   <td style="text-align:right;"> 24955 </td>
   <td style="text-align:right;"> 0.7283110 </td>
   <td style="text-align:right;"> 0.6350631 </td>
   <td style="text-align:left;"> Chicago </td>
   <td style="text-align:left;"> Illinois </td>
   <td style="text-align:right;"> 39 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Inter Miami CF </td>
   <td style="text-align:right;"> 17579 </td>
   <td style="text-align:right;"> 281257 </td>
   <td style="text-align:right;"> 16 </td>
   <td style="text-align:right;"> 12637 </td>
   <td style="text-align:right;"> 0.39 </td>
   <td style="text-align:left;"> Chase Stadium </td>
   <td style="text-align:right;"> 21550 </td>
   <td style="text-align:right;"> 0.8157309 </td>
   <td style="text-align:right;"> 0.5864037 </td>
   <td style="text-align:left;"> Fort Lauderdale </td>
   <td style="text-align:left;"> Florida </td>
   <td style="text-align:right;"> 48 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> CF Montreal </td>
   <td style="text-align:right;"> 17562 </td>
   <td style="text-align:right;"> 298556 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 15905 </td>
   <td style="text-align:right;"> 0.10 </td>
   <td style="text-align:left;"> Saputo Stadium </td>
   <td style="text-align:right;"> 19619 </td>
   <td style="text-align:right;"> 0.8951527 </td>
   <td style="text-align:right;"> 0.8106937 </td>
   <td style="text-align:left;"> Montreal </td>
   <td style="text-align:left;"> Quebec </td>
   <td style="text-align:right;"> 65 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> D.C. United </td>
   <td style="text-align:right;"> 17540 </td>
   <td style="text-align:right;"> 298185 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 16256 </td>
   <td style="text-align:right;"> 0.08 </td>
   <td style="text-align:left;"> Audi Field </td>
   <td style="text-align:right;"> 20000 </td>
   <td style="text-align:right;"> 0.8770000 </td>
   <td style="text-align:right;"> 0.8128000 </td>
   <td style="text-align:left;"> Washington </td>
   <td style="text-align:left;"> D.C. </td>
   <td style="text-align:right;"> 27 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Vancouver Whitecaps </td>
   <td style="text-align:right;"> 16745 </td>
   <td style="text-align:right;"> 284661 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 16399 </td>
   <td style="text-align:right;"> 0.02 </td>
   <td style="text-align:left;"> BC Place ‡ </td>
   <td style="text-align:right;"> 22120 </td>
   <td style="text-align:right;"> 0.7570072 </td>
   <td style="text-align:right;"> 0.7413653 </td>
   <td style="text-align:left;"> Vancouver </td>
   <td style="text-align:left;"> British Columbia </td>
   <td style="text-align:right;"> 43 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Colorado Rapids </td>
   <td style="text-align:right;"> 15409 </td>
   <td style="text-align:right;"> 261953 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 14473 </td>
   <td style="text-align:right;"> 0.06 </td>
   <td style="text-align:left;"> Dick's Sporting Goods Park </td>
   <td style="text-align:right;"> 18061 </td>
   <td style="text-align:right;"> 0.8531643 </td>
   <td style="text-align:right;"> 0.8013399 </td>
   <td style="text-align:left;"> Commerce City </td>
   <td style="text-align:left;"> Colorado </td>
   <td style="text-align:right;"> 43 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Houston Dynamo </td>
   <td style="text-align:right;"> 15027 </td>
   <td style="text-align:right;"> 255465 </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:right;"> 16426 </td>
   <td style="text-align:right;"> -0.09 </td>
   <td style="text-align:left;"> Shell Energy Stadium </td>
   <td style="text-align:right;"> 22039 </td>
   <td style="text-align:right;"> 0.6818367 </td>
   <td style="text-align:right;"> 0.7453151 </td>
   <td style="text-align:left;"> Houston </td>
   <td style="text-align:left;"> Texas </td>
   <td style="text-align:right;"> 36 </td>
  </tr>
</tbody>
</table>



## Governor Raitings




Here is the Governor rating data taken from Morning Consult Pro. This data was
then added to the main data frame.


<table class="table" style="margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> period_start </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> period_end </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> State </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> Governor </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> demo </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> n </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> Margin of error </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> Approve </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> Dissaprove </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> Don't know/No opinion </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> 4/1/2023 </td>
   <td style="text-align:left;"> 6/30/2023 </td>
   <td style="text-align:left;"> Alabama </td>
   <td style="text-align:left;"> Kay Ivey </td>
   <td style="text-align:left;"> Registered Voters </td>
   <td style="text-align:right;"> 4422 </td>
   <td style="text-align:left;"> 1% </td>
   <td style="text-align:left;"> 62% </td>
   <td style="text-align:left;"> 32% </td>
   <td style="text-align:left;"> 6% </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 4/1/2023 </td>
   <td style="text-align:left;"> 6/30/2023 </td>
   <td style="text-align:left;"> Alaska </td>
   <td style="text-align:left;"> Michael Dunleavy </td>
   <td style="text-align:left;"> Registered Voters </td>
   <td style="text-align:right;"> 380 </td>
   <td style="text-align:left;"> 5% </td>
   <td style="text-align:left;"> 62% </td>
   <td style="text-align:left;"> 28% </td>
   <td style="text-align:left;"> 10% </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 4/1/2023 </td>
   <td style="text-align:left;"> 6/30/2023 </td>
   <td style="text-align:left;"> Arizona </td>
   <td style="text-align:left;"> Katie Hobbs </td>
   <td style="text-align:left;"> Registered Voters </td>
   <td style="text-align:right;"> 5225 </td>
   <td style="text-align:left;"> 1% </td>
   <td style="text-align:left;"> 47% </td>
   <td style="text-align:left;"> 40% </td>
   <td style="text-align:left;"> 13% </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 4/1/2023 </td>
   <td style="text-align:left;"> 6/30/2023 </td>
   <td style="text-align:left;"> Arkansas </td>
   <td style="text-align:left;"> Sarah Huckabee Sanders </td>
   <td style="text-align:left;"> Registered Voters </td>
   <td style="text-align:right;"> 2541 </td>
   <td style="text-align:left;"> 2% </td>
   <td style="text-align:left;"> 60% </td>
   <td style="text-align:left;"> 30% </td>
   <td style="text-align:left;"> 10% </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 4/1/2023 </td>
   <td style="text-align:left;"> 6/30/2023 </td>
   <td style="text-align:left;"> California </td>
   <td style="text-align:left;"> Gavin Newsom </td>
   <td style="text-align:left;"> Registered Voters </td>
   <td style="text-align:right;"> 20247 </td>
   <td style="text-align:left;"> 1% </td>
   <td style="text-align:left;"> 56% </td>
   <td style="text-align:left;"> 37% </td>
   <td style="text-align:left;"> 6% </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 4/1/2023 </td>
   <td style="text-align:left;"> 6/30/2023 </td>
   <td style="text-align:left;"> Colorado </td>
   <td style="text-align:left;"> Jared Polis </td>
   <td style="text-align:left;"> Registered Voters </td>
   <td style="text-align:right;"> 3408 </td>
   <td style="text-align:left;"> 2% </td>
   <td style="text-align:left;"> 60% </td>
   <td style="text-align:left;"> 32% </td>
   <td style="text-align:left;"> 8% </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 4/1/2023 </td>
   <td style="text-align:left;"> 6/30/2023 </td>
   <td style="text-align:left;"> Connecticut </td>
   <td style="text-align:left;"> Ned Lamont </td>
   <td style="text-align:left;"> Registered Voters </td>
   <td style="text-align:right;"> 3307 </td>
   <td style="text-align:left;"> 2% </td>
   <td style="text-align:left;"> 62% </td>
   <td style="text-align:left;"> 32% </td>
   <td style="text-align:left;"> 6% </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 4/1/2023 </td>
   <td style="text-align:left;"> 6/30/2023 </td>
   <td style="text-align:left;"> Delaware </td>
   <td style="text-align:left;"> John Carney </td>
   <td style="text-align:left;"> Registered Voters </td>
   <td style="text-align:right;"> 1161 </td>
   <td style="text-align:left;"> 3% </td>
   <td style="text-align:left;"> 55% </td>
   <td style="text-align:left;"> 32% </td>
   <td style="text-align:left;"> 13% </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 4/1/2023 </td>
   <td style="text-align:left;"> 6/30/2023 </td>
   <td style="text-align:left;"> Florida </td>
   <td style="text-align:left;"> Ron DeSantis </td>
   <td style="text-align:left;"> Registered Voters </td>
   <td style="text-align:right;"> 22556 </td>
   <td style="text-align:left;"> 1% </td>
   <td style="text-align:left;"> 54% </td>
   <td style="text-align:left;"> 42% </td>
   <td style="text-align:left;"> 4% </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 4/1/2023 </td>
   <td style="text-align:left;"> 6/30/2023 </td>
   <td style="text-align:left;"> Georgia </td>
   <td style="text-align:left;"> Brian Kemp </td>
   <td style="text-align:left;"> Registered Voters </td>
   <td style="text-align:right;"> 10176 </td>
   <td style="text-align:left;"> 1% </td>
   <td style="text-align:left;"> 59% </td>
   <td style="text-align:left;"> 33% </td>
   <td style="text-align:left;"> 8% </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 4/1/2023 </td>
   <td style="text-align:left;"> 6/30/2023 </td>
   <td style="text-align:left;"> Hawaii </td>
   <td style="text-align:left;"> Josh Green </td>
   <td style="text-align:left;"> Registered Voters </td>
   <td style="text-align:right;"> 720 </td>
   <td style="text-align:left;"> 4% </td>
   <td style="text-align:left;"> 64% </td>
   <td style="text-align:left;"> 24% </td>
   <td style="text-align:left;"> 12% </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 4/1/2023 </td>
   <td style="text-align:left;"> 6/30/2023 </td>
   <td style="text-align:left;"> Idaho </td>
   <td style="text-align:left;"> Brad Little </td>
   <td style="text-align:left;"> Registered Voters </td>
   <td style="text-align:right;"> 838 </td>
   <td style="text-align:left;"> 3% </td>
   <td style="text-align:left;"> 54% </td>
   <td style="text-align:left;"> 38% </td>
   <td style="text-align:left;"> 8% </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 4/1/2023 </td>
   <td style="text-align:left;"> 6/30/2023 </td>
   <td style="text-align:left;"> Illinois </td>
   <td style="text-align:left;"> JB Pritzker </td>
   <td style="text-align:left;"> Registered Voters </td>
   <td style="text-align:right;"> 11054 </td>
   <td style="text-align:left;"> 1% </td>
   <td style="text-align:left;"> 54% </td>
   <td style="text-align:left;"> 41% </td>
   <td style="text-align:left;"> 5% </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 4/1/2023 </td>
   <td style="text-align:left;"> 6/30/2023 </td>
   <td style="text-align:left;"> Indiana </td>
   <td style="text-align:left;"> Eric Holcomb </td>
   <td style="text-align:left;"> Registered Voters </td>
   <td style="text-align:right;"> 5854 </td>
   <td style="text-align:left;"> 1% </td>
   <td style="text-align:left;"> 55% </td>
   <td style="text-align:left;"> 35% </td>
   <td style="text-align:left;"> 10% </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 4/1/2023 </td>
   <td style="text-align:left;"> 6/30/2023 </td>
   <td style="text-align:left;"> Iowa </td>
   <td style="text-align:left;"> Kim Reynolds </td>
   <td style="text-align:left;"> Registered Voters </td>
   <td style="text-align:right;"> 2400 </td>
   <td style="text-align:left;"> 2% </td>
   <td style="text-align:left;"> 54% </td>
   <td style="text-align:left;"> 42% </td>
   <td style="text-align:left;"> 4% </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 4/1/2023 </td>
   <td style="text-align:left;"> 6/30/2023 </td>
   <td style="text-align:left;"> Kansas </td>
   <td style="text-align:left;"> Laura Kelly </td>
   <td style="text-align:left;"> Registered Voters </td>
   <td style="text-align:right;"> 2122 </td>
   <td style="text-align:left;"> 2% </td>
   <td style="text-align:left;"> 58% </td>
   <td style="text-align:left;"> 34% </td>
   <td style="text-align:left;"> 7% </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 4/1/2023 </td>
   <td style="text-align:left;"> 6/30/2023 </td>
   <td style="text-align:left;"> Kentucky </td>
   <td style="text-align:left;"> Andy Beshear </td>
   <td style="text-align:left;"> Registered Voters </td>
   <td style="text-align:right;"> 4921 </td>
   <td style="text-align:left;"> 1% </td>
   <td style="text-align:left;"> 64% </td>
   <td style="text-align:left;"> 32% </td>
   <td style="text-align:left;"> 5% </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 4/1/2023 </td>
   <td style="text-align:left;"> 6/30/2023 </td>
   <td style="text-align:left;"> Louisiana </td>
   <td style="text-align:left;"> John Bel Edwards </td>
   <td style="text-align:left;"> Registered Voters </td>
   <td style="text-align:right;"> 3426 </td>
   <td style="text-align:left;"> 2% </td>
   <td style="text-align:left;"> 53% </td>
   <td style="text-align:left;"> 39% </td>
   <td style="text-align:left;"> 8% </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 4/1/2023 </td>
   <td style="text-align:left;"> 6/30/2023 </td>
   <td style="text-align:left;"> Maine </td>
   <td style="text-align:left;"> Janet Mills </td>
   <td style="text-align:left;"> Registered Voters </td>
   <td style="text-align:right;"> 1350 </td>
   <td style="text-align:left;"> 3% </td>
   <td style="text-align:left;"> 59% </td>
   <td style="text-align:left;"> 39% </td>
   <td style="text-align:left;"> 3% </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 4/1/2023 </td>
   <td style="text-align:left;"> 6/30/2023 </td>
   <td style="text-align:left;"> Maryland </td>
   <td style="text-align:left;"> Wes Moore </td>
   <td style="text-align:left;"> Registered Voters </td>
   <td style="text-align:right;"> 4779 </td>
   <td style="text-align:left;"> 1% </td>
   <td style="text-align:left;"> 58% </td>
   <td style="text-align:left;"> 22% </td>
   <td style="text-align:left;"> 20% </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 4/1/2023 </td>
   <td style="text-align:left;"> 6/30/2023 </td>
   <td style="text-align:left;"> Massachusetts </td>
   <td style="text-align:left;"> Maura Healey </td>
   <td style="text-align:left;"> Registered Voters </td>
   <td style="text-align:right;"> 5138 </td>
   <td style="text-align:left;"> 1% </td>
   <td style="text-align:left;"> 60% </td>
   <td style="text-align:left;"> 23% </td>
   <td style="text-align:left;"> 17% </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 4/1/2023 </td>
   <td style="text-align:left;"> 6/30/2023 </td>
   <td style="text-align:left;"> Michigan </td>
   <td style="text-align:left;"> Gretchen Whitmer </td>
   <td style="text-align:left;"> Registered Voters </td>
   <td style="text-align:right;"> 9975 </td>
   <td style="text-align:left;"> 1% </td>
   <td style="text-align:left;"> 57% </td>
   <td style="text-align:left;"> 39% </td>
   <td style="text-align:left;"> 4% </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 4/1/2023 </td>
   <td style="text-align:left;"> 6/30/2023 </td>
   <td style="text-align:left;"> Minnesota </td>
   <td style="text-align:left;"> Tim Walz </td>
   <td style="text-align:left;"> Registered Voters </td>
   <td style="text-align:right;"> 4008 </td>
   <td style="text-align:left;"> 2% </td>
   <td style="text-align:left;"> 54% </td>
   <td style="text-align:left;"> 42% </td>
   <td style="text-align:left;"> 4% </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 4/1/2023 </td>
   <td style="text-align:left;"> 6/30/2023 </td>
   <td style="text-align:left;"> Mississippi </td>
   <td style="text-align:left;"> Tate Reeves </td>
   <td style="text-align:left;"> Registered Voters </td>
   <td style="text-align:right;"> 2380 </td>
   <td style="text-align:left;"> 2% </td>
   <td style="text-align:left;"> 48% </td>
   <td style="text-align:left;"> 42% </td>
   <td style="text-align:left;"> 11% </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 4/1/2023 </td>
   <td style="text-align:left;"> 6/30/2023 </td>
   <td style="text-align:left;"> Missouri </td>
   <td style="text-align:left;"> Mike Parson </td>
   <td style="text-align:left;"> Registered Voters </td>
   <td style="text-align:right;"> 5166 </td>
   <td style="text-align:left;"> 1% </td>
   <td style="text-align:left;"> 51% </td>
   <td style="text-align:left;"> 36% </td>
   <td style="text-align:left;"> 13% </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 4/1/2023 </td>
   <td style="text-align:left;"> 6/30/2023 </td>
   <td style="text-align:left;"> Montana </td>
   <td style="text-align:left;"> Greg Gianforte </td>
   <td style="text-align:left;"> Registered Voters </td>
   <td style="text-align:right;"> 619 </td>
   <td style="text-align:left;"> 4% </td>
   <td style="text-align:left;"> 57% </td>
   <td style="text-align:left;"> 33% </td>
   <td style="text-align:left;"> 10% </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 4/1/2023 </td>
   <td style="text-align:left;"> 6/30/2023 </td>
   <td style="text-align:left;"> Nebraska </td>
   <td style="text-align:left;"> Jim Pillen </td>
   <td style="text-align:left;"> Registered Voters </td>
   <td style="text-align:right;"> 1314 </td>
   <td style="text-align:left;"> 3% </td>
   <td style="text-align:left;"> 51% </td>
   <td style="text-align:left;"> 29% </td>
   <td style="text-align:left;"> 20% </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 4/1/2023 </td>
   <td style="text-align:left;"> 6/30/2023 </td>
   <td style="text-align:left;"> Nevada </td>
   <td style="text-align:left;"> Joseph Lombardo </td>
   <td style="text-align:left;"> Registered Voters </td>
   <td style="text-align:right;"> 2863 </td>
   <td style="text-align:left;"> 2% </td>
   <td style="text-align:left;"> 57% </td>
   <td style="text-align:left;"> 26% </td>
   <td style="text-align:left;"> 17% </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 4/1/2023 </td>
   <td style="text-align:left;"> 6/30/2023 </td>
   <td style="text-align:left;"> New Hampshire </td>
   <td style="text-align:left;"> Chris Sununu </td>
   <td style="text-align:left;"> Registered Voters </td>
   <td style="text-align:right;"> 1372 </td>
   <td style="text-align:left;"> 3% </td>
   <td style="text-align:left;"> 64% </td>
   <td style="text-align:left;"> 29% </td>
   <td style="text-align:left;"> 7% </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 4/1/2023 </td>
   <td style="text-align:left;"> 6/30/2023 </td>
   <td style="text-align:left;"> New Jersey </td>
   <td style="text-align:left;"> Philip Murphy </td>
   <td style="text-align:left;"> Registered Voters </td>
   <td style="text-align:right;"> 7732 </td>
   <td style="text-align:left;"> 1% </td>
   <td style="text-align:left;"> 55% </td>
   <td style="text-align:left;"> 37% </td>
   <td style="text-align:left;"> 8% </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 4/1/2023 </td>
   <td style="text-align:left;"> 6/30/2023 </td>
   <td style="text-align:left;"> New Mexico </td>
   <td style="text-align:left;"> Michelle Lujan Grisham </td>
   <td style="text-align:left;"> Registered Voters </td>
   <td style="text-align:right;"> 1155 </td>
   <td style="text-align:left;"> 3% </td>
   <td style="text-align:left;"> 52% </td>
   <td style="text-align:left;"> 42% </td>
   <td style="text-align:left;"> 6% </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 4/1/2023 </td>
   <td style="text-align:left;"> 6/30/2023 </td>
   <td style="text-align:left;"> New York </td>
   <td style="text-align:left;"> Kathy Hochul </td>
   <td style="text-align:left;"> Registered Voters </td>
   <td style="text-align:right;"> 19856 </td>
   <td style="text-align:left;"> 1% </td>
   <td style="text-align:left;"> 51% </td>
   <td style="text-align:left;"> 40% </td>
   <td style="text-align:left;"> 9% </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 4/1/2023 </td>
   <td style="text-align:left;"> 6/30/2023 </td>
   <td style="text-align:left;"> North Carolina </td>
   <td style="text-align:left;"> Roy Cooper III </td>
   <td style="text-align:left;"> Registered Voters </td>
   <td style="text-align:right;"> 9906 </td>
   <td style="text-align:left;"> 1% </td>
   <td style="text-align:left;"> 54% </td>
   <td style="text-align:left;"> 36% </td>
   <td style="text-align:left;"> 10% </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 4/1/2023 </td>
   <td style="text-align:left;"> 6/30/2023 </td>
   <td style="text-align:left;"> North Dakota </td>
   <td style="text-align:left;"> Doug Burgum </td>
   <td style="text-align:left;"> Registered Voters </td>
   <td style="text-align:right;"> 470 </td>
   <td style="text-align:left;"> 5% </td>
   <td style="text-align:left;"> 57% </td>
   <td style="text-align:left;"> 27% </td>
   <td style="text-align:left;"> 16% </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 4/1/2023 </td>
   <td style="text-align:left;"> 6/30/2023 </td>
   <td style="text-align:left;"> Ohio </td>
   <td style="text-align:left;"> Mike DeWine </td>
   <td style="text-align:left;"> Registered Voters </td>
   <td style="text-align:right;"> 11851 </td>
   <td style="text-align:left;"> 1% </td>
   <td style="text-align:left;"> 57% </td>
   <td style="text-align:left;"> 36% </td>
   <td style="text-align:left;"> 7% </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 4/1/2023 </td>
   <td style="text-align:left;"> 6/30/2023 </td>
   <td style="text-align:left;"> Oklahoma </td>
   <td style="text-align:left;"> Kevin Stitt </td>
   <td style="text-align:left;"> Registered Voters </td>
   <td style="text-align:right;"> 3180 </td>
   <td style="text-align:left;"> 2% </td>
   <td style="text-align:left;"> 51% </td>
   <td style="text-align:left;"> 40% </td>
   <td style="text-align:left;"> 9% </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 4/1/2023 </td>
   <td style="text-align:left;"> 6/30/2023 </td>
   <td style="text-align:left;"> Oregon </td>
   <td style="text-align:left;"> Tina Kotek </td>
   <td style="text-align:left;"> Registered Voters </td>
   <td style="text-align:right;"> 2644 </td>
   <td style="text-align:left;"> 2% </td>
   <td style="text-align:left;"> 45% </td>
   <td style="text-align:left;"> 39% </td>
   <td style="text-align:left;"> 16% </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 4/1/2023 </td>
   <td style="text-align:left;"> 6/30/2023 </td>
   <td style="text-align:left;"> Pennsylvania </td>
   <td style="text-align:left;"> Josh Shapiro </td>
   <td style="text-align:left;"> Registered Voters </td>
   <td style="text-align:right;"> 14599 </td>
   <td style="text-align:left;"> 1% </td>
   <td style="text-align:left;"> 56% </td>
   <td style="text-align:left;"> 28% </td>
   <td style="text-align:left;"> 17% </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 4/1/2023 </td>
   <td style="text-align:left;"> 6/30/2023 </td>
   <td style="text-align:left;"> Rhode Island </td>
   <td style="text-align:left;"> Dan McKee </td>
   <td style="text-align:left;"> Registered Voters </td>
   <td style="text-align:right;"> 1018 </td>
   <td style="text-align:left;"> 3% </td>
   <td style="text-align:left;"> 52% </td>
   <td style="text-align:left;"> 33% </td>
   <td style="text-align:left;"> 15% </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 4/1/2023 </td>
   <td style="text-align:left;"> 6/30/2023 </td>
   <td style="text-align:left;"> South Carolina </td>
   <td style="text-align:left;"> Henry McMaster </td>
   <td style="text-align:left;"> Registered Voters </td>
   <td style="text-align:right;"> 5347 </td>
   <td style="text-align:left;"> 1% </td>
   <td style="text-align:left;"> 56% </td>
   <td style="text-align:left;"> 33% </td>
   <td style="text-align:left;"> 11% </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 4/1/2023 </td>
   <td style="text-align:left;"> 6/30/2023 </td>
   <td style="text-align:left;"> South Dakota </td>
   <td style="text-align:left;"> Kristi Noem </td>
   <td style="text-align:left;"> Registered Voters </td>
   <td style="text-align:right;"> 599 </td>
   <td style="text-align:left;"> 4% </td>
   <td style="text-align:left;"> 63% </td>
   <td style="text-align:left;"> 35% </td>
   <td style="text-align:left;"> 2% </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 4/1/2023 </td>
   <td style="text-align:left;"> 6/30/2023 </td>
   <td style="text-align:left;"> Tennessee </td>
   <td style="text-align:left;"> Bill Lee </td>
   <td style="text-align:left;"> Registered Voters </td>
   <td style="text-align:right;"> 5997 </td>
   <td style="text-align:left;"> 1% </td>
   <td style="text-align:left;"> 59% </td>
   <td style="text-align:left;"> 32% </td>
   <td style="text-align:left;"> 9% </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 4/1/2023 </td>
   <td style="text-align:left;"> 6/30/2023 </td>
   <td style="text-align:left;"> Texas </td>
   <td style="text-align:left;"> Gregory Abbott </td>
   <td style="text-align:left;"> Registered Voters </td>
   <td style="text-align:right;"> 19050 </td>
   <td style="text-align:left;"> 1% </td>
   <td style="text-align:left;"> 53% </td>
   <td style="text-align:left;"> 42% </td>
   <td style="text-align:left;"> 5% </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 4/1/2023 </td>
   <td style="text-align:left;"> 6/30/2023 </td>
   <td style="text-align:left;"> Utah </td>
   <td style="text-align:left;"> Spencer Cox </td>
   <td style="text-align:left;"> Registered Voters </td>
   <td style="text-align:right;"> 1487 </td>
   <td style="text-align:left;"> 3% </td>
   <td style="text-align:left;"> 61% </td>
   <td style="text-align:left;"> 26% </td>
   <td style="text-align:left;"> 13% </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 4/1/2023 </td>
   <td style="text-align:left;"> 6/30/2023 </td>
   <td style="text-align:left;"> Vermont </td>
   <td style="text-align:left;"> Phil Scott </td>
   <td style="text-align:left;"> Registered Voters </td>
   <td style="text-align:right;"> 513 </td>
   <td style="text-align:left;"> 4% </td>
   <td style="text-align:left;"> 76% </td>
   <td style="text-align:left;"> 22% </td>
   <td style="text-align:left;"> 2% </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 4/1/2023 </td>
   <td style="text-align:left;"> 6/30/2023 </td>
   <td style="text-align:left;"> Virginia </td>
   <td style="text-align:left;"> Glenn Youngkin </td>
   <td style="text-align:left;"> Registered Voters </td>
   <td style="text-align:right;"> 8123 </td>
   <td style="text-align:left;"> 1% </td>
   <td style="text-align:left;"> 57% </td>
   <td style="text-align:left;"> 32% </td>
   <td style="text-align:left;"> 11% </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 4/1/2023 </td>
   <td style="text-align:left;"> 6/30/2023 </td>
   <td style="text-align:left;"> Washington </td>
   <td style="text-align:left;"> Jay Inslee </td>
   <td style="text-align:left;"> Registered Voters </td>
   <td style="text-align:right;"> 4239 </td>
   <td style="text-align:left;"> 2% </td>
   <td style="text-align:left;"> 51% </td>
   <td style="text-align:left;"> 43% </td>
   <td style="text-align:left;"> 6% </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 4/1/2023 </td>
   <td style="text-align:left;"> 6/30/2023 </td>
   <td style="text-align:left;"> West Virginia </td>
   <td style="text-align:left;"> Jim Justice </td>
   <td style="text-align:left;"> Registered Voters </td>
   <td style="text-align:right;"> 2112 </td>
   <td style="text-align:left;"> 2% </td>
   <td style="text-align:left;"> 62% </td>
   <td style="text-align:left;"> 33% </td>
   <td style="text-align:left;"> 5% </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 4/1/2023 </td>
   <td style="text-align:left;"> 6/30/2023 </td>
   <td style="text-align:left;"> Wisconsin </td>
   <td style="text-align:left;"> Tony Evers </td>
   <td style="text-align:left;"> Registered Voters </td>
   <td style="text-align:right;"> 4949 </td>
   <td style="text-align:left;"> 1% </td>
   <td style="text-align:left;"> 51% </td>
   <td style="text-align:left;"> 44% </td>
   <td style="text-align:left;"> 5% </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 4/1/2023 </td>
   <td style="text-align:left;"> 6/30/2023 </td>
   <td style="text-align:left;"> Wyoming </td>
   <td style="text-align:left;"> Mark Gordon </td>
   <td style="text-align:left;"> Registered Voters </td>
   <td style="text-align:right;"> 285 </td>
   <td style="text-align:left;"> 6% </td>
   <td style="text-align:left;"> 69% </td>
   <td style="text-align:left;"> 19% </td>
   <td style="text-align:left;"> 11% </td>
  </tr>
</tbody>
</table>




## Club Finances

This club finance data comes from https://www.transfermarkt.com and is current 
as of October 11, 2023. So, towards the end of the 2023 season. 



```r
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
```


## 2023 Point Values 

In addition to the 2022 point records I also wanted to include the data from 
2023 for comparison and analysis. This data was importated from a spreadsheet
and joined with the main data set like the past steps in this process. 




With both the 2022 values and 2023 values I created a new column in the data 
frame for the percentage change in values from 2022 to 2023. 


```r
# calculating new column based on percentage increase in Pts from 2022 to 2023
  
Final <- Final %>% 
  mutate("Pts_change_yoy" = ((`Pts 2023` -`2022 Pts`)/ `2022 Pts`) * 100)

mls_master <- mls_master %>%
  mutate("Pts_change_yoy" = ((`Pts 2023` -`2022 Pts`)/ `2022 Pts`) * 100)

usl_master <- usl_master %>%
  mutate("Pts_change_yoy" = ((`Pts 2023` -`2022 Pts`)/ `2022 Pts`) * 100)
```



## Quick Data Cleaning

After imputing these explanatory variables I then removed data that
skewed the data. For example one USL teams only had 4 home games, unlike other
teams which played 10 or more games.



```r
## cleaning - phoenix and Birmingham only have four games
# number of games are too low
usl_master %>%
  group_by(Games) %>%
  arrange(Games)
```

```
## # A tibble: 19 × 20
## # Groups:   Games [6]
##    Teams              Average Totals Games `2022 Average`   YOY Stadium Capacity
##    <chr>                <dbl>  <dbl> <int>          <dbl> <dbl> <chr>      <dbl>
##  1 Phoenix Rising FC     7409  29634     4           6401  0.16 Phoeni…    10000
##  2 Memphis 901 FC        3344  33439    10           3683 -0.09 AutoZo…    10000
##  3 Tampa Bay Rowdies     5984  77797    13           5148  0.16 Al Lan…     7227
##  4 Pittsburgh Riverh…    5073  76095    15           3934  0.29 Highma…     5000
##  5 Hartford Athletic     4882  73224    15           5178 -0.06 Trinit…     5500
##  6 Indy Eleven           9709 155349    16           8285  0.17 IU Mic…    10524
##  7 Colorado Springs …    7753 124044    16           7199  0.08 Weidne…     8000
##  8 Orange County SC      4411  70568    16           4230  0.04 Champi…     5000
##  9 Sacramento Republ…   10627 180665    17           9876  0.08 Heart …    11569
## 10 Louisville City FC   10547 179299    17          10465  0.01 Lynn F…    15304
## 11 New Mexico United     9619 163518    17          10724 -0.1  Rio Gr…    13500
## 12 San Antonio FC        7325 124522    17           5980  0.22 Toyota…     8296
## 13 Detroit City FC       6032 102544    17           6118 -0.01 Keywor…     7933
## 14 FC Tulsa              4320  73443    17           4044  0.07 ONEOK …     7833
## 15 Monterey Bay FC       3963  67378    17           3683  0.08 Cardin…     6000
## 16 Oakland Roots SC      3894  66196    17           4611 -0.16 Pionee…     5000
## 17 Charleston Battery    3113  52919    17           2797  0.11 Patrio…     5000
## 18 Loudoun United FC     2664  45288    17           1583  0.68 Segra …     5000
## 19 Miami FC              1432  24340    17           1162  0.23 Riccar…    25000
## # ℹ 12 more variables: `%_2023_Fill` <dbl>, `%_2022_Fill` <dbl>, City <chr>,
## #   State <chr>, `2022 Pts` <int>, Squad <dbl>, Age <dbl>, Foreigners <dbl>,
## #   `Market Value` <dbl>, `Total market value` <dbl>, `Pts 2023` <dbl>,
## #   Pts_change_yoy <dbl>
```

```r
usl_master <- usl_master %>% 
  filter(Games >= 10)
Final <- Final %>%
  filter(Games >=10 )


# capacity skews attendance percentage
Final %>%
  filter(`%_2023_Fill`< .10) %>%
  select(Teams, Capacity)
```

```
##      Teams Capacity
## 1 Miami FC    25000
```

```r
# Miam FC is an outlier and this makes sense given their capacity

Final <- Final %>%
  filter(`%_2023_Fill`> .10)
```


# Exploratoy Plotting and Analysis

![](READme_files/figure-html/unnamed-chunk-29-1.png)<!-- -->


An initial plot of attendance (as a percentage of the stadium filled) versus the
2022 point values of the various teams across all leagues does not provide any
visual correlation.


Lets look at 2023.

![](READme_files/figure-html/unnamed-chunk-30-1.png)<!-- -->


Much of the same result.


![](READme_files/figure-html/unnamed-chunk-31-1.png)<!-- -->

Looking as the capacity of stadiums across both leagues we see a wide difference
in size.


```r
summary(Final$Capacity)
```

```
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##    5000    8722   19510   18708   24989   42500
```


Maybe the capacity of the stadium has some kind of effect on the ability for 
teams to fill the stadium? 

![](READme_files/figure-html/unnamed-chunk-33-1.png)<!-- -->

There does appear to be a slight trend that bigger stadiums are actually 
more well filled. Perhaps because clubs with bigger stadiums are more well
established and popular. 

Looking at governor support versus attendance there does not appear to be any 
real correlation between the two variables. 

![](READme_files/figure-html/unnamed-chunk-34-1.png)<!-- -->




```
## `geom_smooth()` using formula = 'y ~ x'
```

![](READme_files/figure-html/unnamed-chunk-35-1.png)<!-- -->

This plot of attendance versus market value indicates that there is potentially
a correlation between the two variables. 


However, the USL data does not indicate the same correlation.

![](READme_files/figure-html/unnamed-chunk-36-1.png)<!-- -->

This chart below illustrates the stark differences between the two leagues. All 
the USL teams have a significantly lower value and little difference between 
the size of values. 

![](READme_files/figure-html/unnamed-chunk-37-1.png)<!-- -->

Looking further at the relation between season-ending point values and 
Attendance. We can see that there is potentially some correlation within the
MLS data set for the 2023 season. 

![](READme_files/figure-html/unnamed-chunk-38-1.png)<!-- -->


R can confirm this with the cor function,


```r
cor(mls_master$`Pts 2023`, mls_master$`%_2023_Fill`)
```

```
## [1] 0.3050948
```



# Regression Analysis

Using the prior exploratory analysis as a guide it appears that there
are potentially some correlative relationships between attendance rates and 
market valuations, as well as season-ending point values. 

## First Model (MLS)


```r
#MLS models
# removing the Messi effect inflating market value with filter
model_mls <- lm(`%_2023_Fill` ~ `Total market value`,mls_master %>% 
                  filter(`Total market value` < 70))
summary(model_mls)
```

```
## 
## Call:
## lm(formula = `%_2023_Fill` ~ `Total market value`, data = mls_master %>% 
##     filter(`Total market value` < 70))
## 
## Residuals:
##      Min       1Q   Median       3Q      Max 
## -0.31603 -0.09119  0.02722  0.06908  0.26844 
## 
## Coefficients:
##                      Estimate Std. Error t value Pr(>|t|)    
## (Intercept)          0.642120   0.120724   5.319 1.86e-05 ***
## `Total market value` 0.006389   0.002802   2.281   0.0317 *  
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 0.1235 on 24 degrees of freedom
## Multiple R-squared:  0.1781,	Adjusted R-squared:  0.1439 
## F-statistic: 5.201 on 1 and 24 DF,  p-value: 0.03174
```

This first model does indicate a some relationship between Total Market Value
and % of the stadium filled in 2023 for the MLS data set. Although the adjusted 
R-squared on 0.14 indicates weak correlation. 

## Second Model (MLS) - YOY as Response Variable 

However, a model which incorporates year-over-year attendance rate as the
response variable and the 2022 season ending point and total market value 
as the explanatory variables offers a stronger fit.


```r
# change in response variable to YOY changes in attendance
model_mls2 <- lm(`YOY` ~ `2022 Pts` + `Total market value`, mls_master)
summary(model_mls2)
```

```
## 
## Call:
## lm(formula = YOY ~ `2022 Pts` + `Total market value`, data = mls_master)
## 
## Residuals:
##      Min       1Q   Median       3Q      Max 
## -0.14638 -0.04498 -0.02992  0.05224  0.15353 
## 
## Coefficients:
##                       Estimate Std. Error t value Pr(>|t|)    
## (Intercept)          -0.059109   0.087614  -0.675 0.506341    
## `2022 Pts`           -0.002063   0.001730  -1.192 0.244934    
## `Total market value`  0.005088   0.001327   3.833 0.000802 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 0.0829 on 24 degrees of freedom
## Multiple R-squared:  0.3803,	Adjusted R-squared:  0.3286 
## F-statistic: 7.363 on 2 and 24 DF,  p-value: 0.00321
```

The Adjusted R-squared of 0.3286 is a much stronger fit and Total Market Value
has a high level of significance. 


## Third Model (USL) - YOY as Response Variable

The same model as above, except it utilizes USL data, indicates the same
relationship and fit as the model utilizing MLS data. 


```r
model_usl2 <- lm(`YOY` ~ `2022 Pts` + `Total market value`, mls_master)
summary(model_usl2)
```

```
## 
## Call:
## lm(formula = YOY ~ `2022 Pts` + `Total market value`, data = mls_master)
## 
## Residuals:
##      Min       1Q   Median       3Q      Max 
## -0.14638 -0.04498 -0.02992  0.05224  0.15353 
## 
## Coefficients:
##                       Estimate Std. Error t value Pr(>|t|)    
## (Intercept)          -0.059109   0.087614  -0.675 0.506341    
## `2022 Pts`           -0.002063   0.001730  -1.192 0.244934    
## `Total market value`  0.005088   0.001327   3.833 0.000802 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 0.0829 on 24 degrees of freedom
## Multiple R-squared:  0.3803,	Adjusted R-squared:  0.3286 
## F-statistic: 7.363 on 2 and 24 DF,  p-value: 0.00321
```




