#install.packages("ggmap")

# Définition du working directory, et sélection des packages
setwd("/Users/astephan/Desktop/PositionGMaps")
options(stringsAsFactors = T)
library(jsonlite)
library(ggplot2)
library(ggmap)

# On lit le fichier json
system.time(x <- fromJSON("positions.json"))

# Extraction des différentes locations du fichier json
loc = x$locations

# Conversion du temps Unix en temps lisible
loc$time = as.POSIXct(as.numeric(x$locations$timestampMs)/1000, origin = "1970-01-01")

# On convertit les positions E7 en positions GPS
loc$lat = loc$latitudeE7 / 1e7
loc$lon = loc$longitudeE7 / 1e7

# On ne prend que les 10.000 dernières positions
loc <- head(loc[rev(order(loc$time)),],10000)
head(loc)

# Création des différentes cartes
geneve <- get_map(location = 'Geneva', zoom = 12, color = "bw")
lausanne <- get_map(location = 'Lausanne', zoom = 12, color = "bw")

# Visualisation pour Genève
ggmap(geneve) + 
  stat_summary_2d(geom = "tile", bins = 100, data = loc, aes(x = lon, y = lat, z = accuracy), alpha = 0.5) + 
  scale_fill_gradient(low = "blue", high = "red", guide = guide_legend(title = "Précision")) +
  labs(
    x = "Longitude", 
    y = "Latitude", 
    title = "Historique des positions autour de Genève")

# Visualisation pour Lausanne
ggmap(lausanne) + 
  stat_summary_2d(geom = "tile", bins = 100, data = loc, aes(x = lon, y = lat, z = accuracy), alpha = 0.5) + 
  scale_fill_gradient(low = "blue", high = "red", guide = guide_legend(title = "Précision")) +
  labs(
    x = "Longitude", 
    y = "Latitude", 
    title = "Historique des positions autour de Lausanne")
