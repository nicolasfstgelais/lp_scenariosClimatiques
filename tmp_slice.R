library(ncdf4)

#open netCDF file (.nc)
# good tutorial: https://www.youtube.com/watch?v=roMf6xzB9NI&ab_channel=EmpowerDat
USA_tas_CanESM2_rcp45=nc_open("data/raw/USA_tas_year_CanESM2_CanRCM4_NAM-22_rcp45.nc")

#print what is in the object
print(USA_tas_CanESM2_rcp45)

# extract the temperature data (tas)
temp_array=ncvar_get(USA_tas_CanESM2_rcp45,"tas")
dim(temp_array)

# extract lat and lon
lon_array=ncvar_get(USA_tas_CanESM2_rcp45,"lon")
lat_array=ncvar_get(USA_tas_CanESM2_rcp45,"lat")

# extract the time (year)
time_array=ncvar_get(USA_tas_CanESM2_rcp45,"time")


#close the connection when the data is extracted
nc_close(USA_tas_CanESM2_rcp45)

#look at one time slice
tmp.slice=list()

tmp.slice$x=lon_array
tmp.slice$y=lat_array
tmp.slice$z=temp_array[,,1]

# attribute a longitude to each row
rownames(tmp.slice)=lon_array
# attribute a latitude to each column
colnames(tmp.slice)=lat_array


xy <- data.frame(ID = 1:length(lon_array), X = lon_array, Y = lat_array)
coordinates(xy) <- c("X", "Y")
proj4string(xy) <- CRS("+proj=longlat +datum=WGS84")  ## for example


# small version of your test set
dat1=list()
 dat1$x=seq(302339.6,by=1000,len=71)
 dat1$y=seq(5431470,by=1000,len=124)
 dat1$z=matrix(runif(71*124),71,124)
 str(dat1)

 image(dat1,asp=1)
 
 r <-raster(
   tmp.slice$z,
   xmn=range(tmp.slice$x)[1], xmx=range(tmp.slice$x)[2],
   ymn=range(tmp.slice$y)[1], ymx=range(tmp.slice$y)[2], 
   crs=CRS("+ EPSG:4326")
 )
 
 