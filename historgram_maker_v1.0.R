#R-Coloured-Histogram 
#Jaaved Singh 
#script for creating coloured histogram 
#Version 1.0 
#inspired from http://www.r-graph-gallery.com/83-histogram-with-colored-tail/   

#load libraries
if(!require(tools)){install.packages("tools")}
require(tools)

#list all csv's in a folder
histolist <- list.files("./Data", full.names = FALSE) 
histoname <- file_path_sans_ext(histolist)

for (namepos in 1:length(histolist)) {
  plottitle = paste("Histogram of ",histoname[namepos], sep="")
  
  # Create data
  #data location
  csvname = paste("./Data/",histolist[namepos], sep="")
  #read data
  my_variable=read.csv(csvname) 
  #select data [all of column 2]
  my_data = my_variable[,2]
  
  # Calculate histogram, but does not draw it  
  #change breaks to change amount of bars that appear
  my_hist=hist(my_data , breaks=75  , plot=F)
  
  # Color vector (below -7 is black, above -6.3 is white, everything else grey)
  my_color= ifelse(my_hist$breaks < -7, "black" , ifelse (my_hist$breaks >=-6.3, "white", "grey53"))
  
  #to save plot 
  jpegname = paste("./Output/","Histogram_", histoname[namepos], ".jpg",sep="") 
  jpeg(jpegname,quality=100)
  
  # Final plot  
  par(bg = "azure3") #make background not white 
  #xlim set as min, max of circuitscape output
  plot(my_hist, col=my_color , border=F , main=plottitle, xlab="Current Density Values (Logged)", xlim=c(-9,-4) )
  
  #saves plot
  dev.off()

}
