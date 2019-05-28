
library(plotly)
library(shiny)
library(dplyr)
library(shinydashboard)
library(leaflet)

library(googleVis)
library(DT)
library(shinydashboard)
library(threejs)
library(maps)
library(rgdal)
library(wordcloud)
library(maptools)

library(graphics)
library(ggplot2)
library(ggmap)
library(RColorBrewer)
library(proxy)

#read data
country_locations <- read.csv("data/country_location.csv")

# load population data frame
population_df = read.csv("data/Book3.csv", header = T,sep ="")
tobacco_df = read.csv("data/tobacco2.csv", header = T,sep ="")
overweight_df = read.csv("data/overweight.csv", header = T,sep ="")

#tobacco_male <- tobacco_df[order(tobacco_df$Male, tobacco_df$Female),]

mydatag <- read.csv(file="data/Full.csv",header=TRUE, na.strings=c("","NA"), stringsAsFactors = FALSE)
mydatag <- mydatag[1:21]
data_full <-mydatag
data_full <- data_full[order(data_full$Region, data_full$Country),]
data_full$size <- data_full$UHI
colors <- c('#4AC6B7', '#1972A4', '#965F8A', '#FF7070', '#C61951','#FFFF00')

year = c(
  "1950",
  "1960",
  "1970",
  "1980",
  "1990",
  "2000",
  "2010",
  "2020",
  "2030",
  "2040",
  "2050"
)


# ------------------------------------------------------------------------------
get_country_names_by_area = function(area) {
  names = switch(
    area,
    "Entire world" = all_country_names,
    "Africa" = Africa,
    "Americas" = Americas,
    "Eastern Mediterranean" = Eastern_Mediterranean,
    "Europe" = Europe,
    "Western Pacific" = Western_Pacific,
    "South-East Asia" = South_East_Asia
  )
  return(names)
}


# used for the items of drop down widget in ui
world_region_list = c(
  "Entire world",
  "Africa",
  "Americas",
  "Eastern Mediterranean",
  "Europe",
  "South-East Asia",
  "Western Pacific"
)

world_area_list = c(
  "Africa",
  "Americas",
  "Eastern Mediterranean",
  "Europe",
  "South-East Asia",
  "Western Pacific"
)

world_country_list = c(
  "Algeria",
  "Angola",
  "Benin",
  "Botswana",
  "Burkina Faso",
  "Burundi",
  "Cameroon",
  "Central African Republic",
  "Chad",
  "Comoros",
  "Congo",
  "C̫te d'Ivoire",
  "Equatorial Guinea",
  "Eritrea",
  "Ethiopia",
  "Gabon",
  "Gambia",
  "Ghana",
  "Guinea",
  "Guinea-Bissau",
  "Kenya",
  "Lesotho",
  "Liberia",
  "Madagascar",
  "Malawi",
  "Mali",
  "Mauritania",
  "Mauritius",
  "Mozambique",
  "Namibia",
  "Niger",
  "Nigeria",
  "Rwanda",
  "Sao Tome and Principe",
  "Senegal",
  "Sierra Leone",
  "South Africa",
  "Togo",
  "Uganda",
  "Zambia",
  "Zimbabwe"
)

# ------------------------------------------------------------------------------
get_start_and_end_index_of_area = function(area_name) {
  # the number pairs correspond the row index of countries in each area in data frame 'mortality_df'
  start_and_end_index_of_areas = switch(
    area_name,
    "World level overview" = c(3,165),
    "Africa" = c(3,42),
    "Americas" = c(43,70),
    "Eastern Mediterranean" = c(71,90),
    "Europe" = c(91,136),
    "South-East Asia" = c(137,146),
    "Western Pacific" = c(147,165)
    
  )
  return(start_and_end_index_of_areas)
}

# ------------------------------------------------------------------------------
# create vectors of country/place names, used for global sphere view in ui.R
Africa <- c(
  "Algeria",
  "Angola",
  "Benin",
  "Botswana",
  "Burkina Faso",
  "Burundi",
  "Cameroon",
  "Central African Republic",
  "Chad",
  "Comoros",
  "Congo",
  "C̫te d'Ivoire",
  "Equatorial Guinea",
  "Eritrea",
  "Ethiopia",
  "Gabon",
  "Gambia",
  "Ghana",
  "Guinea",
  "Guinea-Bissau",
  "Kenya",
  "Lesotho",
  "Liberia",
  "Madagascar",
  "Malawi",
  "Mali",
  "Mauritania",
  "Mauritius",
  "Mozambique",
  "Namibia",
  "Niger",
  "Nigeria",
  "Rwanda",
  "Sao Tome and Principe",
  "Senegal",
  "Sierra Leone",
  "South Africa",
  "Togo",
  "Uganda",
  "Zambia",
  "Zimbabwe"
)

Americas <- c(
  "Argentina",
  "Bahamas",
  "Barbados",
  "Belize",
  "Brazil",
  "Canada",
  "Chile",
  "Colombia",
  "Costa Rica",
  "Cuba",
  "Dominican Republic",
  "Ecuador",
  "El Salvador",
  "Grenada",
  "Guatemala",
  "Guyana",
  "Haiti",
  "Honduras",
  "Jamaica",
  "Mexico",
  "Nicaragua",
  "Panama",
  "Paraguay",
  "Peru",
  "Saint Lucia",
  "Saint Vincent and the Grenadines",
  "Suriname",
  "Trinidad and Tobago",
  "Uruguay"
)

Eastern_Mediterranean <- c(
  'Afghanistan',
  'Bahrain',
  'Djibouti',
  'Egypt',
  'Iraq',
  'Jordan',
  'Kuwait',
  'Lebanon',
  'Morocco',
  'Oman',
  'Pakistan',
  'Qatar',
  'Saudi Arabia',
  'Somalia',
  'Sudan',
  'Syrian Arab Republic',
  'Tunisia',
  'United Arab Emirates',
  'Yemen'
)

Europe <- c(
  'Albania',
  'Armenia',
  'Austria',
  'Azerbaijan',
  'Belarus',
  'Belgium',
  'Bosnia and Herzegovina',
  'Bulgaria',
  'Croatia',
  'Cyprus',
  'Denmark',
  'Estonia',
  'Finland',
  'France',
  'Georgia',
  'Germany',
  'Greece',
  'Hungary',
  'Iceland',
  'Ireland',
  'Israel',
  'Italy',
  'Kazakhstan',
  'Kyrgyzstan',
  'Latvia',
  'Lithuania',
  'Luxembourg',
  'Malta',
  'Montenegro',
  'Netherlands',
  'Norway',
  'Poland',
  'Portugal',
  'Romania',
  'Russian Federation',
  'Serbia',
  'Slovakia',
  'Slovenia',
  'Spain',
  'Sweden',
  'Switzerland',
  'Tajikistan',
  'Turkey',
  'Turkmenistan',
  'Ukraine',
  'Uzbekistan'
)

South_East_Asia <-c(
  
  'Bangladesh',
  'Bhutan',
  'India',
  'Indonesia',
  'Maldives',
  'Myanmar',
  'Nepal',
  'Sri Lanka',
  'Thailand',
  'Timor-Leste'
)

Western_Pacific <- c(
  'Australia',
  'Brunei Darussalam',
  'Cambodia',
  'China',
  'Fiji',
  'Japan',
  'Kiribati',
  'Lao Peoples Democratic Republic',
  'Malaysia',
  'Mongolia',
  'New Zealand',
  'Papua New Guinea',
  'Philippines',
  'Samoa',
  'Singapore',
  'Solomon Islands',
  'Tonga',
  'Vanuatu',
  'Viet Nam'
)

all_country_names = c(Africa,Americas,Eastern_Mediterranean,Europe,Western_Pacific,South_East_Asia)

# create another data frame in which each row corresponds to a country
# population_of_countries_df <- population_df %>%
# filter(Country %in% all_country_names) 

