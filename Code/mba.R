#Importing data through Titanic package
require(titanic)
require(arules)
titanic.raw
summary(titanic.raw)
str(titanic.raw)
head(titanic.raw)
model1<-apriori(titanic.raw)
model1
summary(model1)
inspect(model1)
model2<-apriori(titanic.raw,control=list(verbose=T),parameter = list(support=0.005,confidence=0.8,minlen=2),appearance = list(rhs=c("Survived=Yes","Survived=No"),default="lhs"))
model2
inspect(model2)
#quality(model2)<-round(quality(model2),digits = 3)
sorted_model2<-sort(model2,by="lift")
inspect(sorted_model2)

#Removing redundant information

subset.matrix<-is.subset(sorted_model2,sorted_model2)
subset.matrix[lower.tri(subset.matrix,diag = T)]<-NA
redundant<-colSums(subset.matrix,na.rm = T)>=1
which(redundant)
model2_pruned<-sorted_model2[!redundant]
inspect(model2_pruned)

model3<-apriori(titanic.raw,control = list(verbose=F),parameter = list(support=0.002,confidence=0.2,minlen=2),appearance = list(lhs=c("Class=1st","Class=2nd","Class=3rd","Age=Adult","Age=Child"),rhs=c("Survived=Yes"),default="none"))
model3_sorted<-sort(model3,by="lift")
inspect(model3_sorted)

#Plots

require(arulesViz)
plot(model1)
plot(model1,method="grouped")
plot(model1,method="graph")

