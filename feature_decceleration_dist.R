#Feature Demonstration File
#Decceleration profile (from full speed to stopped). 

#Step 1
#Identify region of decceleration
# - Must begin from full speed (full speed hard to define, will just use decceleration time)
# - Must end in a stop (speed[end of decceleration]<0.5 m/s?) Doesn't usually end in a complete stop...
# - period of uninterrupted decceleration?

#Step 2
#Smooth velocity profile? This would give a less noisy acceleration profile....

#Step 3
#Calculate accelerations, create distribution.


#Basic calculations (to be replaced by functions?)

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


#Step 1

#determine regions where uninterrupted decceleration occurred. 
accel_period = 6 # threshold number of seconds of consecutive decceleration. (these will be included for evaluation)
speed_min = 0.5 # (m/s) speed which designates coming to a stop... The actual calculated speed rarely is = 0. 
cons_d = vector(mode="integer",l-2)  #vector to record consecutive decceleration periods
mask = vector(mode="integer",l-2)
for (i in 2:(l-2) )
{
  if (a_t[i-1]<0 & a_t[i]<0) {
  cons_d[i]=cons_d[i-1]+1
  }
  if (cons_d[i]>accel_period & speed[i]<speed_min) {
    mask[(i-cons_d[i]):i]=1
  }
}

#Zoom in on region of interest (Driver 1_4)
plot(speed[70:100],ylim=c(-5,15))
lines(a_t[70:100])
lines(vector(mode="integer",30))
lines(mask[70:100])

#Step 2 ????

#Step 3 Profit... and acceleration profile

a_decc=a_t[as.logical(mask>0)]
hist(a_decc,breaks=-0.25*0:24)

#Interesting result, distribution is not perfect, perhaps smoothing the velocity would help...
#A low percentage of trips actually has a large number of stop and go's, this may be a way to evaluate 
#trips with numerous stops. 


