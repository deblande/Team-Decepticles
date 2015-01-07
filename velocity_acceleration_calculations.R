# Loads file 1_1 (driver 1, trip 1) Computes velocity, acceleration. These calculations will be done wrt a
# fixed reference frame. 

datapath = c('/Users/evandeblander/Documents/R/Driver/drivers/1/4.csv')
position = read.csv(datapath)
l=length(data[,1])
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




