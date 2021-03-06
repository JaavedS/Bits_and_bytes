# -*- coding: utf-8 -*-
# ---------------------------------------------------------------------------
# selecting dates2.py
# Created on: 2016-04-12 19:11:29.00000
#   (generated by ArcGIS/ModelBuilder)
# Description:
# This program was designed to break up my bear data (one file of all bears from 2007-2015)
# into multiple files containing each bear per year. The reason for this is that
# I need to turn each individual bear's gps points into a line for that bear and that year 
# Written by: Jaaved Singh - McGill University 
# ---------------------------------------------------------------------------

#import relevant modules
import arcpy  
import os, sys, numpy 

#allows for previously created files to be over-written 
arcpy.env.overwriteOutput = True   

#function to find unique values 
def unique_values(table, field):
	data = arcpy.da.TableToNumPyArray(table, [field])
	return numpy.unique(data[field])

#file location for bear data to be cut 
gps_pts = "C:\\Users\\jeff\\Desktop\\temp\\temp.gdb\\GB_Loc_5_ADEN"

#add individual bear names to list 
bear_names = unique_values(gps_pts,"name")

#create empty list to be filled with files from crashes 
bearstodel = []

#for loop goes through each year and each bear name, the for loop stops 1 early so I used 2016 so it ran until 2015
#target_bear is the output location, I placed on desktop to avoid weird encryption problems
#try function allows me to run code that may crash, if code crashes, program continues by going to the except argument

for byear in xrange(2007, 2016): 
	for bname in bear_names:
	    target_bear = "C:\\Users\\jeff\\Desktop\\temp\\bear-pts\\"+str(byear)+"\\"+str(bname)+"_"+str(byear)
	    try:
	    	arcpy.Select_analysis(gps_pts, target_bear, "\"name\"='{}' AND \"loc_year\"={}".format(str(bname), str(byear)))
	    except RuntimeError:
	    	print "No data found for "+str(bname)+" of year "+str(byear) 
	    	print (arcpy.GetMessages())
	    	bearstodel.append(target_bear)

print "Done..."

#this for loop was to delete empty files created during crashing but for some reason
#the code no longer crashes, now I have various empty files 
#for btodel in bearstodel:
#        os.remove(str(btodel))

