simplephysics_f <- function(position,np,n)
{

#Physics function, with smoothing, 

#Inputs:
#  position = 2xl matrix with x and y postions over time. 
#  np = number of points on either side of the desired point to use for the polynomial fit. 
#         This will yield np*2+1 points in the estimate. 
#  n = order of the polynomial approximation, must be at least 3 in order to calculate jerk. 

# OUtputs: All placed in the "physics" dataframe
# p = smoothed position estimates x,and y components
# v = smoothed velocity x,and y components
# a = smoothed acceleration x,and y components
# j = smoothed jerk x,and y components
# speed = magnitude of v vector
# a_mag = magnitude of acceleration
# a_t = tangential acceleration
# a_n = normal acceleration
# r_c = radius of curvature using smoothed points.

#Number of points to be used in approximation
l=length(position[,1]) #length of trip
#np=3 #number of points on either end of n (you lose np*2 points from trip length, the points on either end of the trip)
#n=4 #order of polynomial approximation

t=1:l
v_x=(position[3:l,1]-position[1:(l-2),1] )/2 # vx(n)=(x(n+1)-x(n-1))/2t
v_y=(position[3:l,2]-position[1:(l-2),2] )/2
a_x=(position[3:l,1]-2*position[2:(l-1),1]+position[1:(l-2),1] ) # ax(n)=(x(n+1)-2x(n)+x(n-1))/t^2
a_y=(position[3:l,2]-2*position[2:(l-1),2]+position[1:(l-2),2] )
speed=sqrt(v_x^2+v_y^2)
a=sqrt(a_x^2+a_y^2)

#Computes acceleration wrt normal and tangential components
theta_v=atan2(v_y,v_x) #velocity angle (This creates NaN's when the driver is at rest)
theta_a=atan2(a_y,a_x) #acceleration angle (This creates NaN's when the driver is at rest)
a_t=a*cos(theta_a-theta_v) #tangential Acceleration
a_n=a*sin(theta_a-theta_v) #normal Acceleration

j_t=c(0,diff(a_t,lag=1))
j_n=c(0,diff(a_n,lag=1))

physics<- data.frame(speed,a_t,a_n,j_t,j_n)

return(physics)
}
