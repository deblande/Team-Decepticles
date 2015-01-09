# Loads file 1_1 (driver 1, trip 1) Computes velocity, acceleration. These calculations will be done wrt a
# fixed reference frame. 
getwd()
datapath = c('../drivers/1/4.csv')
position = read.csv(datapath)
l=length(position[,1])
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

#Radius of curvature using 3 points (May work better with smoothed position data)
x1=position[1:(l-2),1]
x2=position[2:(l-1),1]
x3=position[3:l,1]
y1=position[1:(l-2),2]
y2=position[2:(l-1),2]
y3=position[3:l,2]
# Equation for radius of curvature given 3 points. 
r_c=sqrt(((x2-x1)^2+(y2-y1)^2)*((x2-x3)^2+(y2-y3)^2)*((x3-x1)^2+(y3-y1)^2))/(2*abs(x1*y2+x2*y3+x3*y1-x1*y3-x2*y1-x3*y2))

#Plot example acceleration
plot(speed[115:130])
axis(2,at=5*(-1:3))
lines(a_t[115:130])

#Plot example speed vs. radius of curvature
#putting a best fit line on this could yield a good predictor
plot(r_c,speed,xlim=c(0,200),ylim=c(0,15))

