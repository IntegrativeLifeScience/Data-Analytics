

########### Working with rasters and performing environmental correlation test ##############

install.packages(c("raster", "sp", "gdistance"), dependencies = TRUE)
install.packages("rgdal")
library(raster)
library(rgdal)
install.packages("dismo")
library(dismo)

install.packages("corrplot")
library(corrplot)

setwd("~/Desktop/modeling_materials_bio1-19_30s_bil")




#### climate rasters downloaded from WorldClim.org ####

bilFile <- list.files (pattern=".bil")
# or pattern=".bil" could be ".tiff" or ".asc
# you may need to crop these to a smaller extent 
    #(i.e. one that is slightly larger than the extent of your location data)

#### ex <- extent(-87,-81, 8, 13) # this is extent(longitude min, longitude max, latitude min, latitude max)
#### bio2 <- raster("bio_2.bil")
####    bio2c <- crop(x=bio2, y=ex)
####    plot(bio2c)
####    writeRaster(x=bio2c, file="bio2_pa.bil", overwrite=TRUE)

# check to see how the location data maps onto the cropped (or reprojected) raster
####    points(Data_A$Longitude, Data_A$Latitude, pch=15, col="dodgerblue4", cex=20, add=TRUE)



# perform the cropping of raster files for each environmental variable considered in the correlation test

bioStack1 <- stack(bio1, bio2, bio3, bio4, bio5, bio6, bio7, bio8, bio9, bio10, bio11, bio12, bio13, bio14, bio15, bio16, bio17, bio18, bio19)
bioclim.vars.crop <- crop(bioStack1, ex)

##make sure all environmental raster layers have the same projection
##### if you want to change the projection use the following code
crs.laea <- CRS("+proj=laea +lat_0=0 +lon_0=-80 +ellps=WGS84 +units=m +no_defs")
bio2p <- projectRaster(bio2c, crs=crs.laea)
writeRaster(bio2p, "bio2_utm.bil")

# OR

bioStack2 <- stack(bio1, bio2, bio3, bio4, bio5, bio6, bio7, bio8, bio9, bio10, bio11, bio12, bio13, bio14, bio15, bio16, bio17, bio18, bio19)
bioclim.vars.LAEA <- projectRaster(bioStack2, crs=crs.laea)
# write rasters to a new directory using the function writeRaster



#### location data ####

setwd("~/path/to/file")
Data_Pa <- read.csv(file="Pa_genus_coords_for_Maxent_noRedundant.csv")
# Data_Pa contains 3 columns: 1st is species name, 2nd is longitude, 3rd is longitude)
Data_P <- Data_Pa[,2:3]


# for loop to create a matrix of each location's climate value for each raster layer
for(file in bilFile){
  print(file)
  r<- raster(file, native=TRUE)
  x <- extract(r, Data_P[,c('Longitude', 'Latitude')])
  Data_P[[file]] <- x
}



#### Perform a correlation test ####
                        
Corplot1 <- cor(Data_P, use="pairwise.complete.obs")
Corplot1

setwd("~/path/to/directory")
write.csv(Corplot1, file="Pa_bioclim_correlations.csv")



