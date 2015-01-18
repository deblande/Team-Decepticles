outlier_f <- function(position,jumpy_length)
{

#Finds jumps. 
# jumpy_length... In order to be included in the start_file distance between jumps must exceed jumpy_length
  
# i.e with jumpy_length=10, consider data with jumps between 115,116 and 121,122 
  #116-121 is fine, but only 5 points so it will not be passed to the start_file. 
  #must be 1 or greater
#The data has a fairly prevalent issue with jumps in position (at least for driver 1), this could be due to the gps losing signal, 
#being turned off, or something else. When smoothed by the physics function, this results in incorrect values 
#close to the jumps in position.

#This script will locate the jumps.

#1D example:
#given 5 points:x= (1,2,3,10,11) v_x (using 1-sided difference) = (1,1,7,1) a_x=(0,6,-6)
#thus, given an acceleration threshold, one could determine which jumps are incorrect. 

#datapath = c('../drivers/1/55.csv')
#position = read.csv(datapath)
l=length(position[,1])
vx=diff(position[,1],lag=1)
vy=diff(position[,2],lag=1)
speed=sqrt(vx^2+vy^2)

#The following computes the difference between the average of the two adjacent speeds and the point in question
#When you lie on the point of the jump, you will calculate a large positive spd. When the jump point is to either side,
#there will be a negative spd. (spd is a central difference acceleration calculation, that smoothes the jump)
spd=speed[2:(l-2)]-(speed[1:(l-3)]+speed[3:(l-1)])/2 
spd=data.frame(spd)
# with the spd calculation, as long as you don't have two adjacent jumps, the jump will be located at the large 
#positive spd. An spd of greater than 4 was found to be a good cutoff to find jumps. I will need to analyze the
# whole dataset to make sure this remains a good cutoff. 
outlier= as.logical(spd>4|spd<(-4))
jump_number=sum(outlier)

#Since there is a discontinuity in speed between jumps, it will be necessary to start, stop, and restart the calculations 
# in the physics function. Basically the output will be a list of starts and stops. I will require 11 non-outlier points between 
# outliers, this way short pieces of data between outliers will be ignored. This data may be suspect anyway.
if (jump_number>0) {   #Only runs code if there are jumps
  
# spd_index, finds the index points where there are jumps, adds in the length of the trip in order to calculate stop_start
spd_index=c(1,which(outlier)+1,l-1)
# calculates the difference in indices, this is then used in order to remove jumpy sections of trip
index=diff(spd_index)
# finds sections of trip between jumps which exceed 10 seconds. 
index1=which(as.logical(index>jumpy_length)) 
l_start=length(index1)
start_file<-matrix(data=0,nrow=l_start,ncol=2)
for (j in 1:l_start) {
  # Sets up starts and stops. This will be input into physics function. 
start_file[j,]=c((spd_index[index1[j]+1]-index[index1[j]]),(spd_index[index1[j]+1]+1))
}
}
if (jump_number==0) {
  start_file=c(1,l)
}
return(start_file)
}
