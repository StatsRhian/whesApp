library(shiny)
library(tidyverse)
library(DT)
library(bootstraplib)
library(shinyBS)
library(scales)

indicators = readr::read_csv("indicators.csv")
ind1 = readr::read_csv("ind1.csv")
