#-----------------------------------------------------------------------------------
#Filename:  24092024 GP covergae plot
#Author:		Maya Ogonah
#Purpose:		Create a plot to show GP coverage of SAIL datasets
#Notes:
#-----------------------------------------------------------------------------------
#OP: 			R version 4.3.3 (2023-10-31 ucrt) -- "Eye Holes"
#-----------------------------------------------------------------------------------

# set working directory ####
setwd("C:/Users/mayao/OneDrive - Nexus365/traumatic brain injury and violence/research documentation/data")

# install packages:
#install.packages("openxlsx")
#install.packages("dplyr")
#install.packages("tidyverse")
#install.packages("sf")
#install.packages("ggplot2")

library(openxlsx)
library(dplyr)
library(tidyverse)
library(sf)
library(ggplot2)

# load data ###
gp.data <- read.xlsx("gp_coverage.xlsx")

my_geojson <- read_sf("/Users/mayao/OneDrive - Nexus365/traumatic brain injury and violence/research documentation/data/features.json")

# plot basic geospatial object ###
ggplot(my_geojson) + 
  geom_sf(fill = "white", color = "black", linewidth = 0.3) +
  theme_void()

# merge geospatial and numeric data ###
gp.map <- my_geojson %>%
  left_join(gp.data, by = c("name_en" = "name_en"))

# create the basic choropleth map ###
ggplot(gp.map) + 
  geom_sf(aes(fill = sail_percent)) +
  theme_void()

# customise the plot ###
plot <- ggplot(gp.map) + 
  geom_sf(aes(fill = sail_percent), linewidth = 0.5, alpha = 0.9) +
  theme_void()+
  scale_fill_viridis_c(option = "mako",
    trans = "log", breaks = c(1, 30, 40, 50, 60, 70, 80, 100),
    name = "SAIL GP (% by No. of Practices)",
    guide = guide_legend(
      keyheight = unit(3, units = "mm"),
      keywidth = unit(10, units = "mm"),
      label.position = "bottom",
      title.position = "top",
      nrow = 1
    )
  ) +
  labs(
    title = "Coverage of General Practices \nin SAIL Databank",
    caption = "Map contains public secotr information lcensed unde the Open Government License v3.0."
  ) +
  theme(
    text = element_text(color = "#22211d"),
    plot.background = element_rect(fill = "#f5f5f2", color = NA),
    panel.background = element_rect(fill = "#f5f5f2", color = NA),
    legend.background = element_rect(fill = "#f5f5f2", color = NA),
    plot.title = element_text(
      size = 40, hjust = 0.01, color = "#4e4d47",
      margin = margin(
        b = -0.1, t = 0.4, l = 2,
        unit = "cm"
      )
    ),
    plot.caption = element_text(
      size = 6,
      color = "#4e4d47",
      margin = margin(
        b = 0.3, r = -99, t = 0.3,
        unit = "cm"
      )
    ),
    legend.position = c(0.32, 0.01)
  )

# save plot ###
pdf("gp_coverage_plot.pdf", width = 18, height = 13, pointsize = 20)
  plot
dev.off()

# clear environment ####
rm(list = ls()) 

# clear console ####
cat("\014")  # ctrl+L
