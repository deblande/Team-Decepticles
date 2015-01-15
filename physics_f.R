physics_f <- function(position,np,n)


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
p<-matrix(data=0,nrow=(l-(np-1)*2),ncol=2) #position matrix in order to calculate radius of curvature(requires extra points)
v<-matrix(data=0,nrow=(l-np*2),ncol=2) #preset position, velocity, accel, jerk matrices
a<-matrix(data=0,nrow=(l-np*2),ncol=2)
j<-matrix(data=0,nrow=(l-np*2),ncol=2)

for (i in (np+1):(l-np)) {  #loop through trip points 
t=(1):(2*np+1)
x=position[(i-np):(i+np),1]
y=position[(i-np):(i+np),2]
estx=polynomial(rev(polyfit(t, x, n))) #fits an nth order polynomial to the np data points
esty=polynomial(rev(polyfit(t, y, n))) #fits an nth order polynomial to the np data points

if (i == (np+1) ) {  #Calculation of extra point at beginning
  p[(i-np),1]=predict(estx,(np)) #x, first point
  p[(i-np),2]=predict(esty,(np)) #y, first point
}
if (i == (l-np) ) {  #Calculation of extra point at end
  p[(i-np+2),1]=predict(estx,(np+2)) #x, last point
  p[(i-np+2),2]=predict(esty,(np+2)) #y, last point
}

p[(i-np+1),1]=predict(estx,(np+1)) #x, first point
p[(i-np+1),2]=predict(esty,(np+1)) #y, first point
estx1=deriv(estx) #first derivative of polynomial
v[i-np,1]=predict(estx1,(np+1)) #x-component of velocity
estx2=deriv(estx1) #second derivative of polynomial
a[i-np,1]=predict(estx2,(np+1)) #x-acceleration
estx3=deriv(estx2) #third derivative of polynomial
j[i-np,1]=predict(estx3,(np+1)) #x-jerk

esty1=deriv(esty) #first derivative of polynomial
v[i-np,2]=predict(esty1,(np+1)) #y-component of velocity
esty2=deriv(esty1) #second derivative of polynomial
a[i-np,2]=predict(esty2,(np+1)) #y-acceleration
esty3=deriv(esty2) #third derivative of polynomial
j[i-np,2]=predict(esty3,(np+1)) #y-jerk
}
 
speed=sqrt(v[,1]^2+v[,2]^2)
a_mag=sqrt(a[,1]^2+a[,2]^2)

#Computes acceleration wrt normal and tangential components
theta_v=atan2(v[,2],v[,1]) #velocity angle (This creates NaN's when the driver is at rest)
theta_a=atan2(a[,2],a[,1]) #acceleration angle (This creates NaN's when the driver is at rest)
a_t=a_mag*cos(theta_a-theta_v) #tangential Acceleration
a_n=a_mag*sin(theta_a-theta_v) #normal Acceleration

#Radius of curvature using 3 points (May work better with smoothed position data)
l=length(p[,1]) #length of trip *updated after smoothing
x1=p[1:(l-2),1]
x2=p[2:(l-1),1]
x3=p[3:l,1]
y1=p[1:(l-2),2]
y2=p[2:(l-1),2]
y3=p[3:l,2]
# Equation for radius of curvature given 3 points. 
r_c=sqrt(((x2-x1)^2+(y2-y1)^2)*((x2-x3)^2+(y2-y3)^2)*((x3-x1)^2+(y3-y1)^2))/(2*abs(x1*y2+x2*y3+x3*y1-x1*y3-x2*y1-x3*y2))

physics<- data.frame(p[2:(length(p[,1])-1),],v,a,j,speed,a_mag,a_t,a_n,r_c)
names(physics)[1] <- paste("p_x")
names(physics)[2] <- paste("p_y")
names(physics)[3] <- paste("v_x")
names(physics)[4] <- paste("v_y")
names(physics)[5] <- paste("a_x")
names(physics)[6] <- paste("a_y")
names(physics)[7] <- paste("j_x")
names(physics)[8] <- paste("j_y")


