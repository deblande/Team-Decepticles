#Feature 
#Cornering speed

#Step 1
#speed vs. radius of curvature, model relationship with an exponential, y=b*x^(z)
#Used the nls (non-linear least squares) function to determine this. 

#When this is done, there are a large number of points which exist below the max threshold, 
#i.e where point=(radius,speed) if you have two points, (50,10), and (50,5), the driver could corner faster, but doesn't
#It may be useful to remove some of these lower points, as the slower speed could be due to some other factor. 


numb=4  #number of drivers to test
b<-matrix(data=0,nrow=200,ncol=numb)
z<-matrix(data=0,nrow=200,ncol=numb)
trip=1:200
d=list.files('../drivers/')
for (i in 1:200) {
for (j in 1:numb) {

datapath = paste('../drivers/',d[j],'/',trip[i],'.csv',sep = "")
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

#Plot example speed vs. radius of curvature
#putting a best fit line on this could yield a good predictor
#plot(r_c,speed,xlim=c(0,100),ylim=c(0,15))

#Pull out statistics related to speed vs radius of curvature
data <- data.frame(speed,r_c)

#
radius_cut=200 #cutoff radius of curvature
myData <- subset(data,r_c<radius_cut&r_c>1&speed>1)

if (length(myData[,1])>3) {
res1=nls(speed~b*r_c^z,start = list(b = 0.1, z = 1),data=myData) #non linear least squares fit to data.
}

#This section checks to see if points are lower than the initial estimate, makes second estimate
slow=summary(res1)[["parameters"]]["b","Estimate"]*myData$r_c^(summary(res1)[["parameters"]]["z","Estimate"])
myData=data.frame(myData,slow)
myData2 <- subset(myData,speed>slow)
if (length(myData2[,1])>3) {
  res=nls(speed~b*r_c^z,start = list(b = 0.1, z = 1),data=myData2) #non linear least squares fit to data.
b[i,j]=summary(res)[["parameters"]]["b","Estimate"]
z[i,j]=summary(res)[["parameters"]]["z","Estimate"]
}

if (length(myData2[,1])<=3) {
b[i,j]=0
z[i,j]=0
}
}
}

#Sample plot of speed vs r_c with non-linear ls lines with error bars. 
plot(myData$r_c,myData$speed,ylim=c(0,15),xlim=c(0,200))
x=seq(0,radius_cut,.1)
y=summary(res1)[["parameters"]]["b","Estimate"]*x^(summary(res1)[["parameters"]]["z","Estimate"])
lines(x,y) #plot best fit exponential function
y1=summary(res1)[["parameters"]]["b","Estimate"]*x^(summary(res1)[["parameters"]]["z","Estimate"]-summary(res)[["parameters"]]["z","Std. Error"])
lines(x,y1) #plot best fit exponential function
y2=summary(res1)[["parameters"]]["b","Estimate"]*x^(summary(res1)[["parameters"]]["z","Estimate"]+summary(res)[["parameters"]]["z","Std. Error"])
lines(x,y2) #plot best fit exponential function
points(myData2$r_c,myData2$speed,col="blue")
y=summary(res)[["parameters"]]["b","Estimate"]*x^(summary(res)[["parameters"]]["z","Estimate"])
lines(x,y,col="blue") #plot best fit exponential function
y1=summary(res)[["parameters"]]["b","Estimate"]*x^(summary(res)[["parameters"]]["z","Estimate"]-summary(res)[["parameters"]]["z","Std. Error"])
lines(x,y1,col="blue") #plot best fit exponential function
y2=summary(res)[["parameters"]]["b","Estimate"]*x^(summary(res)[["parameters"]]["z","Estimate"]+summary(res)[["parameters"]]["z","Std. Error"])
lines(x,y2,col="blue") #plot best fit exponential function

# b*x^(z) is the exponential equation, the following are scatterplots of the constants b and z
#There appears to be some predictability (more red at higher z, more blue at lower?)
sig<-data.frame(b,z)
plot(b[,1],z[,1],type="p",ylim=c(0.2,.7),xlim=c(1,2.5))
points(b[,2],z[,2],col="blue",pch=3)
points(b[,3],z[,3],col="red",pch=3)
points(b[,4],z[,4],col="green",pch=3)
