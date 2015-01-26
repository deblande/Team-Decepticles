#random forest analysis

#Initial analysis will use max v, trip_length, dist_travelled, mean_v
#Will train the model on 1000 random negative trips, and the 200 positive trips. 

#Random trip matrix
n_random=200
n_pos=200
data <-matrix(data=0,nrow=n_random+n_pos,ncol=118)
featurefile="feature1"
submissionfile="sub_RF_1.csv"
datapath = paste('random/',featurefile,'.csv',sep = "")
data[1:200,]=data.matrix(read.csv(datapath), rownames.force = NA)
submission=NULL



d=list.files('../drivers/')

for (j in 1:length(d)) {
  
  datapath = paste('../drivers/',d[j],'/',featurefile,'.csv',sep = "")
  data[201:400,] = data.matrix(read.csv(datapath), rownames.force = NA)

weight=c(1:200*0,(1:200*0)+1)
dataT=data.frame(weight,data)
#driver2$X5=factor(driver2$X5)

set.seed(71)
try.rf <- randomForest(weight ~ ., data=dataT,importance=TRUE, proximity=TRUE)
#print(try.rf)
p=unlist(try.rf["predicted"])
p=as.vector(p[201:400])
labels = sapply(1:200, function(x) paste0(d[j],'_', x))
result = cbind(labels, p)
submission = rbind(submission, result)

print(j/length(d))
}


colnames(submission) = c("driver_trip","prob")
write.csv(submission, submissionfile, row.names=F, quote=F)


