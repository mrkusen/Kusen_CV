#Guidance provided and generated with support and reference from https://www.sharpsightlabs.com/blog/map-talent-competitiveness/

#load packages
library(tidyverse)
library(rvest)
library(magrittr)
library(ggmap)
library(stringr)
library(tidyverse)

#update country experience list and country support list
country_w <- c("Indonesia","Philippines","Fiji",
"Papua New Guinea","Haiti", "Central African Republic", "Democratic Republic of the Congo", "Togo", "Sierra Leone", "USA", "Thailand","France","Denmark")
country_work <- cbind(country_w,"worked")

country_s <- c("Nigeria","Chad","Burkina Faso","Niger","Ghana","South Sudan","Tanzania","Afghanistan","Pakistan","India","Bangladesh","Sri Lanka","Myanmar","Syria","Yemen","Uganda","Kenya")
country_support <- cbind(country_s,"support")

country_list_CV <- rbind(country_work,country_support) %>% as_tibble()
country_list_CV <- rename(country_list_CV, country = country_w,
       type = V2)

#load map data
map.world <- map_data("world")

#verify all countries found in world map
check <- map.world %>% filter(region %in% country_list_CV$country)
checked <- unique(as.character(check$region))
# checked
# dim(country_list_CV)

#join
map.world_joined <- left_join(map.world, country_list_CV, by = c('region' = 'country'))

# flag the countries to be filled in for worked in and supported remotely

plot_work_experience <- ggplot() +
    geom_polygon(data = map.world_joined, 
                 aes(x = long, y = lat, group = group,
                     fill = type))+
    theme(axis.ticks = element_blank(),axis.text = element_blank(),
          axis.title = element_blank(),panel.grid = element_blank(),
          legend.position = c(.15,.3),
          plot.background = element_rect(fill = "#FFFFFF"),
          panel.background = element_rect(fill = "#FFFFFF"))+
    labs(fill="Country Experience")+
    scale_fill_discrete(name="Country Experience", 
                      labels=c("Supported Remotely",
                               "Worked In-Country"," "))
plot_work_experience

# saved plot manually to improve image quality
# ggsave(plot_work_experience,filename = "work_experience_map.jpg")
