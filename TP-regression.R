rm(list=ls())

#Pour calculer Var, Ecart-type et Cov avec les formules du cours
Var=function(x)
{
  Var=var(x)*(length(x)-1)/length(x)
  return(Var)
}
SD=function(x)
{
  SD=sqrt(var(x)*(length(x)-1)/length(x))
  return(SD)
}
Cov=function(x,y)
{
  Cov=cov(x,y)*(length(x)-1)/length(x)
  return(Cov)
}

#Pour telecharger le jeu de donnees sous R, il faut installer la library MASS
library(MASS)
##La premiere fois, faire #install.packages("MASS")

View(Boston)
? Boston


# Ajustement pas moindres carres: Sous R la commande est lm
y<-Boston$medv
x<-Boston$lstat
# le modele qu'on veut implementer : y_i = beta_0 + beta_1*x_i + e_i
model_lm<-lm(y~x)
summary(model_lm)
# On voit un effet de lstat sur mdev
# Une augmentation de 1 lstat engendre une baisse de medv de -0.95 en moyenne
plot(x,y,main="medv en fonction de notre lstat",xla="lstat",ylab="mdev")
#coefficient de correlation
cor(x,y)
(cor(x,y))^2
#R^2=0.5441 #se trouve egalement dans le summary

#Test de correlation
#install.packages("rlang")
#library(rlang)
#install.packages("usethis")
#library(usethis)
install.packages("devtools")
library(devtools)
install_github("obouaziz/robusTest")
library(robusTest)
cortest(x,y)

# Nuage de point et droite de régression
plot(x,y,main="medv en fonction de lstat",xlab="lstat",ylab="medv")
abline(model_lm,col="red",lwd=2) #pour tracer la droite des moindres carres
legend("topright", legend=c("--- Droite Moindres Carrés"),
       text.col=c("red"))

# On peut retrouver les sorties R a la main
beta_1_hat <- cov(x,y)/var(x)
beta_1_hat
beta_0_hat <- mean(y) - mean(x)*beta_1_hat
beta_0_hat #meme valeurs que dans lm !

# les predictions sont hat{y}_i = hat{beta}_0 + hat{beta}_1*x_i
y_hat <- beta_0_hat + beta_1_hat*x
# Remarque : avec lm il suffit d'utiliser la commande fitted du modele pour obtenir la meme chose
fitted(model_lm) #donne egalement y_hat

#Le R2 peut se calculer de 2 facons
R2 <- var(y_hat) / var(y)
R2#meme valeur que dans lm !
cor(x,y)^2 #meme resultat

# les residus sont hat{e}_i = y_i - hat{y}_i
e_hat <- y - y_hat
# Remarque : avec lm la commande resid donne directement les residus du modele
resid(model_lm)
#ou encore
model_lm$residuals


# l'ecart-type de e_hat
std_e_hat <- sqrt(sum(e_hat^2)/504)#meme valeur que Residual standard error dans lm !
std_e_hat
# avec la formule du cours
SD(e_hat)

#Histogramme des residus
hist(e_hat,freq=FALSE,col="yellow") #utiliser l'option frequency=FALSE pour avoir la densite

#boxplot des résidus
boxplot(e_hat, col="yellow", main="Boxplot des résidus")

#Nuage de points des residus en fonction de x
plot(e_hat~x,type="p",xlab="lstat",ylab="Residus", main="Graphe des résidus")
abline(h=0,lwd=2)
abline(h=2*SD(e_hat),lty=2,lwd=2)
abline(h=-2*SD(e_hat),lty=2,lwd=2)

#Predictions avec predict
predict(model_lm,newdata = data.frame(x=30))
predict(model_lm,newdata = data.frame(x=c(10,20,30)))

#Predictions a la main
beta_0_hat + beta_1_hat*c(10,20,30)

#Courbe de régression
max(x)
newx<-cut(x,breaks=c(0,5,10,15,20,25,40))
levels(newx) #les modalites de cette nouvelle variable
table(newx) #on verifie qu'il y a suffisament d'observations dans chaque classe de donnees

newy<-tapply(y,newx,mean) #faire la moyenne de y pour chaque modalite de x
newy
plot(x,y,main="medv en fonction de lstat",xlab="lstat",ylab="medv")
lines(c(2.5,7.5,12.5,17.5,22.5,32.5),c(newy),type="l",col="red", lwd=2)
#pour completer les droites jusqu'aux bords
pente1<-(newy[2]-newy[1])/5
y0<-newy[1]-pente1*2.5
pente6<-(newy[6]-newy[5])/10
y40<-pente6*40+newy[6]-pente6*32.5
lines(c(0,2.5,7.5,12.5,17.5,22.5,32.5,40),c(y0,newy,y40),type="l",col="red", lwd=2)
legend("topright", legend=c("--- Courbe de régression"),
       text.col=c("red"))

##Ajustement polynomial d'ordre 2
model_poly2<-lm(y~x+I(x^2))
summary(model_poly2)
#R^2=0.6407

xseq<-seq(min(x),max(x),by=0.01)
coef_poly2<-model_poly2$coefficients
plot(x,y,main="medv en fonction de lstat",xlab="lstat",ylab="medv")
abline(model_lm,col="red",lwd=2)
lines(xseq,coef_poly2[1]+coef_poly2[2]*xseq+coef_poly2[3]*xseq^2,lty=2,col="blue",lwd=2)

##Ajustement polynomial d'ordre 3
model_poly3<-lm(y~x+I(x^2)+I(x^3))
summary(model_poly3)
#R^2=0.6578

coef_poly3<-model_poly3$coefficients
lines(xseq,coef_poly3[1]+coef_poly3[2]*xseq+coef_poly3[3]*xseq^2+coef_poly3[4]*xseq^3,lty=3,col="cyan", lwd=2)

##Ajustement polynomial d'ordre 4
model_poly4<-lm(y~x+I(x^2)+I(x^3)+I(x^4))
summary(model_poly4)
#R^2=0.673

coef_poly4<-model_poly4$coefficients
lines(xseq,coef_poly4[1]+coef_poly4[2]*xseq+coef_poly4[3]*xseq^2+coef_poly4[4]*xseq^3+coef_poly4[5]*xseq^4,lty=5,col="green", lwd=2)

##Ajustement polynomial d'ordre 5
model_poly5<-lm(y~x+I(x^2)+I(x^3)+I(x^4)+I(x^5))
summary(model_poly5)
#R^2=0.6817

coef_poly5<-model_poly5$coefficients
lines(xseq,coef_poly5[1]+coef_poly5[2]*xseq+coef_poly5[3]*xseq^2+coef_poly5[4]*xseq^3+coef_poly5[5]*xseq^4+coef_poly5[6]*xseq^5,lty=5,col="purple", lwd=2)
legend("topright", legend=c("Deg. 1", "Deg. 2",  "Deg. 3", "Deg. 4", "Deg. 5"),
       text.col=c("red", "blue", "cyan", "green", "purple"))

# Graphes des résidus du modèle 5
plot(model_poly5$residuals~x)
abline(0,0, lwd=2)
abline(2*SD(model_poly5$residuals), 0, lwd=2, col="blue")
abline(-2*SD(model_poly5$residuals), 0, lwd=2, col="blue")
# Boxplot des résidus du modèle 5
boxplot(model_poly5$residuals,col="yellow", main="Boîte à moustache des résidus")

#Critère AIC
AIC(model_lm)
AIC(model_poly2)
AIC(model_poly3)
AIC(model_poly4)
AIC(model_poly5)#minimal
model_poly6<-lm(y~x+I(x^2)+I(x^3)+I(x^4)+I(x^5)+I(x^6))
AIC(model_poly6)

###Remarque : on peut egalement utiliser la commande poly pour faire des ajustements polynomiaux
#Par exemple
#model_poly4bis<-lm(y~poly(x,4,raw=TRUE)) #donne la meme chose que model_poly4
#Par ailleurs on peut tracer la courbe polynomiale a l'aide de predict

#pred_poly4<-predict(model_poly4bis,newdata=data.frame(x=xseq)) #les predictions pour x=xseq
#plot(x,y,main="medv en fonction de lstat",xlab="lstat",ylab="medv")
#lines(xseq,pred_poly4,type="l",col="red")

##########################################
######Pour aller plus loin : ggplot2######
##########################################
library(ggplot2)
ggp <- ggplot(Boston, aes(lstat, medv)) +geom_point()
ggp    # Pour tracer les points

gglm <- stat_smooth(method = "lm",formula = y ~ x,se = FALSE,aes(color='red'))
ggp+gglm+scale_color_identity(guide = "legend")

ggpoly2 <- stat_smooth(method = "lm",formula = y ~ poly(x,2,raw=TRUE),se = FALSE,aes(colour='blue'),linetype="dotted")
ggp+gglm+ggpoly2+scale_color_identity(name="Modeles",breaks=c("red","blue"),labels=c("Lineaire","Quadratique"),guide = "legend")

ggpoly3 <- stat_smooth(method = "lm",formula = y ~ poly(x,3,raw=TRUE),se = FALSE,linetype="dotdash",aes(colour='cyan'))
ggp+gglm+ggpoly2+ggpoly3+scale_color_identity(name="Modeles",breaks=c("red","blue","cyan"),labels=c("Lineaire","Quadratique","Cubique"),guide = "legend")

ggpoly4 <- stat_smooth(method = "lm",formula = y ~ poly(x,4,raw=TRUE),se = FALSE,linetype="twodash",aes(colour='green'))
ggp+gglm+ggpoly2+ggpoly3+ggpoly4+scale_color_identity(name="Modeles",breaks=c("red","blue","cyan","green"),labels=c("Lineaire","Quadratique","Cubique","Poly 4"),guide = "legend")






