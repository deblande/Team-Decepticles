# Creates the following features:

#Feature 1 -- Trip length 
#Feature 2 -- endpoint distance (distance to last point)
#Feature 3 -- Max v (includes outliers...)
#Feature 4 -- Mean v (includes outliers...) 
#Feature 5 -- distance travelled (integral of speed... ) 
#Feature 6 -- max distance from origin
#Feature 7 -- speed histogram binned from 0 to 20 by 2 
#Feature 8 -- tangential acceleration histogram binned -4:0.5:-0.5 , -0.5:0.1:0.5 , 0.5:0.5:4
#Feature 9 -- tangential jerk histogram binned -2.5:0.5:-0.5 , 0:.1:0.5 , 0.5:0.5:2.5
#Feature 10 - normal acceleration binned -4:0.5:-0.5 , -0.5:0.1:0.5 , 0.5:0.5:4
#Feature 11 -- normal jerk histogram binned -2.5:0.5:-0.5 , 0:.1:0.5 , 0.5:0.5:2.5

# Data for positive case
setwd("/Users/evandeblander/DriverLocal/")
source("simplephysics_f.r")
n_pos=200
data <-matrix(data=0,nrow=n_pos,ncol=118)

trip=1:200
submission = NULL
d=list.files('../drivers/')

for (j in 1:1) {
 
for (i in 1:n_pos) {
  
  datapath = paste('../drivers/',d[j],'/',trip[i],'.csv',sep = "")
  position = read.csv(datapath)
  tl=length(position[,1])
  data[(i),1] =tl #Trip Length
  data[(i),2] = (sqrt(position$x[tl]^2+position$y[tl]^2)) #endpoint distance
  vx=diff(position[,1],lag=1)
  vy=diff(position[,2],lag=1)
  data[(i),3]=max(sqrt(vx^2+vy^2)) #Max v
  data[(i),4]=mean(sqrt(vx^2+vy^2)) #MEan v
  data[(i),5]=sum(sqrt(vx^2+vy^2)) #integral speed (dist travelled)
  data[(i),6]= max(sqrt(position$x^2+position$y^2))
  
  #Call physics function
  physics<-simplephysics_f(position,np,n)
  
  #speed histogram
  hist1=c(0:10,6:10*2,6:10*4)
  hist1_log=as.logical(physics$speed<40&physics$speed>0)
  mm=hist(physics$speed[hist1_log],hist1,freq=F,plot=F)
  data[(i),7:26]=mm$density
  
  #tangential acceleration
  hist1=c(-8:-1*0.5,-4:4*0.1,1:8*0.5)
  hist1_log=as.logical(physics$a_t<(4)&physics$a_t>(-4))
  mm=hist(physics$a_t[hist1_log],hist1,freq=F,plot=F)
  data[(i),27:50]=mm$density
  
  #tangential jerk histogram
  hist1=c(-7:-1*0.5,-4:4*0.1,1:7*0.5)
  hist1_log=as.logical(physics$j_t<(3.5)&physics$j_t>(-3.5))
  mm=hist(physics$j_t[hist1_log],hist1,freq=F,plot=F)
  data[(i),51:72]=mm$density
  
  #normal acceleration
  hist1=c(-8:-1*0.5,-4:4*0.1,1:8*0.5)
  hist1_log=as.logical(physics$a_n<(4)&physics$a_n>(-4))
  mm=hist(physics$a_n[hist1_log],hist1,freq=F,plot=F)
  data[(i),73:96]=mm$density
  
  #norml jerk histogram
  hist1=c(-7:-1*0.5,-4:4*0.1,1:7*0.5)
  hist1_log=as.logical(physics$j_n<(3.5)&physics$j_n>(-3.5))
  mm=hist(physics$j_n[hist1_log],hist1,freq=F,plot=F)
  data[(i),97:118]=mm$density
  
  
}

data[is.nan(data)] <-0  #Remove nan's replace with zeros (might consider changing to something large... so they are different from actual zeros)
feature1=data
#driver2$X5=factor(driver2$X5)

print(j/length(d))
savepath= paste('../drivers/',d[j],'/feature1.csv',sep = "")
write.csv(feature1, savepath, row.names=F, quote=F)
}



#Random driver 
#
#keeps  feature creation separate from submission
data <-matrix(data=0,nrow=n_pos,ncol=118)

trip=1:200
  
  for (i in 1:n_pos) {
    trip_n=sample(1:200,1)
    driver_n=sample(1:length(d),1)
    datapath = paste('../drivers/',d[driver_n],'/',trip_n,'.csv',sep = "")
    position = read.csv(datapath)
    tl=length(position[,1])
    data[(i),1] =tl #Trip Length
    data[(i),2] = (sqrt(position$x[tl]^2+position$y[tl]^2)) #endpoint distance
    vx=diff(position[,1],lag=1)
    vy=diff(position[,2],lag=1)
    data[(i),3]=max(sqrt(vx^2+vy^2)) #Max v
    data[(i),4]=mean(sqrt(vx^2+vy^2)) #MEan v
    data[(i),5]=sum(sqrt(vx^2+vy^2)) #integral speed (dist travelled)
    data[(i),6]= max(sqrt(position$x^2+position$y^2))
    
    #Call physics function
    physics<-simplephysics_f(position,np,n)
    
    #speed histogram
    hist1=c(0:10,6:10*2,6:10*4)
    hist1_log=as.logical(physics$speed<40&physics$speed>0)
    mm=hist(physics$speed[hist1_log],hist1,freq=F,plot=F)
    data[(i),7:26]=mm$density
    
    #tangential acceleration
    hist1=c(-8:-1*0.5,-4:4*0.1,1:8*0.5)
    hist1_log=as.logical(physics$a_t<(4)&physics$a_t>(-4))
    mm=hist(physics$a_t[hist1_log],hist1,freq=F,plot=F)
    data[(i),27:50]=mm$density
    
    #tangential jerk histogram
    hist1=c(-7:-1*0.5,-4:4*0.1,1:7*0.5)
    hist1_log=as.logical(physics$j_t<(3.5)&physics$j_t>(-3.5))
    mm=hist(physics$j_t[hist1_log],hist1,freq=F,plot=F)
    data[(i),51:72]=mm$density
    
    #normal acceleration
    hist1=c(-8:-1*0.5,-4:4*0.1,1:8*0.5)
    hist1_log=as.logical(physics$a_n<(4)&physics$a_n>(-4))
    mm=hist(physics$a_n[hist1_log],hist1,freq=F,plot=F)
    data[(i),73:96]=mm$density
    
    #norml jerk histogram
    hist1=c(-7:-1*0.5,-4:4*0.1,1:7*0.5)
    hist1_log=as.logical(physics$j_n<(3.5)&physics$j_n>(-3.5))
    mm=hist(physics$j_n[hist1_log],hist1,freq=F,plot=F)
    data[(i),97:118]=mm$density
    
    
  }
  
  data[is.nan(data)] <-0  #Remove nan's replace with zeros (might consider changing to something large... so they are different from actual zeros)
  feature1=data
  #driver2$X5=factor(driver2$X5)
  
  savepath= paste('random/feature1.csv',sep = "")
  write.csv(feature1, savepath, row.names=F, quote=F)










