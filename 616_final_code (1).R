library(readxl)
library(matrixStats)
library(dplyr)
library(olsrr)
library(FrF2)
library(car)
#library(danielplot)
#library(EnvStats)
library(leaps)

df <- read_excel("C:/Users/ishan/OneDrive/Desktop/616_project/data.csv.xlsx")
View(df)

# Calculating Y_bar
df$y_bar <- rowMeans(df[,c(13,14,15)])
df$y_bar

#calculating ln_s^2
df$s2 <- apply(df[,c(13,14,15)],1,sd,na.rm=T)
df$s2

df$ln_s2 <- log(df$s2)



#Need to calculate Maineffects for location parameters
cols_to_sum <- c("l","w","L","W","d","F","f7","f8","f9","f10","f11")
location_val <- list()
for(col in cols_to_sum)
{
  s<- (sum(df$y_bar[df[[col]] == 1]) - sum(df$y_bar[df[[col]] == -1]))/6
  location_val<-append(location_val,s)
}

factors <- list("l","w","L","W","d","F","f7","f8","f9","f10","f11")
df_loc <- data.frame(unlist(factors),unlist(location_val))
names(df_loc) <- c("Factors","location_values")
df_loc

#need to calculate the Maineffects for the disperaion parameters
cols_to_sum <- c("l","w","L","W","d","F","f7","f8","f9","f10","f11")
dispersion_val <- list()
for(col in cols_to_sum)
{
  s<- (sum(df$ln_s2[df[[col]] == 1]) - sum(df$ln_s2[df[[col]] == -1]))/6
  dispersion_val<-append(dispersion_val,s)
}
df_dispersion <- data.frame(unlist(factors),unlist(dispersion_val))
names(df_dispersion) <- c("Factors","dispersion_values")
df_dispersion


#Half Plot For the Location factorS
#m1 (dont know how to add labels it was sirs method)
# if you know how add it otherwise remove this and use danielplot codes
# Its your choice
plot(sort(abs(df_loc$location_values)),qnorm(0.5+(1:11-0.5)/22))
text(abs(df_loc$location_values), df_loc$Factors, pos=1)


reg_LOC=lm(y_bar~l+w+L+W+d+F+f7+f8+f9+f10+f11, data=df)
summary(reg_LOC)
DanielPlot(reg_LOC, half = TRUE, autolab = "F", main = "Half-Normal Plot -Location")
# From the half normal plot identified the factor "l" only to be significant
# y_bar = intercept + coeff*l

# do we need to to again regression ?????
#reg_loc_sf<-lm(y_bar ~ l,df)
#summary(reg_loc_sf)

#average (y_bar) is my intercept as 2.325833
intercept <- mean(df$y_bar)
coeff_l   <- df_loc$location_values[df_loc$Factors=="l"]/2
print(paste0("y_ =", intercept,"+",coeff_l, "*l"))

# Half plot for the dispersion Factors

reg_disp=lm(ln_s2~l+w+L+W+d+F+f7+f8+f9+f10+f11, data=df)
summary(reg_disp)
DanielPlot(reg_disp, half = TRUE, autolab = "F", main = "Half-Normal Plot")
# 2 factors are identified as significant : d and f11

intercept_d <- mean(df$ln_s2)
coeff_d   <- df_dispersion$dispersion_val[df_dispersion$Factors=="d"]/2
coeff_f11 <- df_dispersion$dispersion_val[df_dispersion$Factors=="f11"]/2
print(paste0("lns2_ =", intercept_d,"+",coeff_d, "*d","+",coeff_f11,"*f11"))

# then calculate max time by minimizing variance - 2 step approach


#-----------------------------------------------------------------------------------------#
#################################################################
################### HAMADA WU APPROACH ##########################

####################LOCATION ##################################
######################### Step 1 ################################
#factor l
m11=lm(y_bar~l+l:w+l:L+l:W+l:d+l:F,data=df)
ols_step_both_p(m11)
# Tried tuning by changing the values of pent and prem but no change
# 3 factors : l,l:w,l:F

# factor w
m12=lm(y_bar~w+w:l+w:L+w:W+w:d+w:F,data=df)
ols_step_both_p(m12)
# only 1 factor significant  - w:L

#factor L
m13=lm(y_bar~L+L:l+L:w+L:W+L:d+L:F,data=df)
ols_step_both_p(m13)
# factors : L:W , L

#factor W
m14=lm(y_bar~W+W:l+W:w+W:L+W:d+W:F,data=df)
ols_step_both_p(m14)
# facors : W:L

# factor d
m15=lm(y_bar~d+d:l+d:w+d:L+d:W+d:F,data=df)
ols_step_both_p(m15)
# FACTOR : d:L

# factor F
m16=lm(y_bar~F+F:l+F:w+F:L+F:W+F:d,data=df)
ols_step_both_p(m16)
# only factor F:W

###################### Step 2 ##################################
# IDENTIFIED SIGNIFICANT EFFECTS FROM step 1 and all main effects
#step 1 Significant interactions - w:L, L:W, d:L, F:W, l:w, l:F
m21 <- lm(y_bar~l+w+L+W+d+F+l:w+l:F+w:L+L:W+d:L+F:W,df)
ols_step_both_p(m21)
#significant factors - l,w

#################### Step 3 #################################
# all the significant main effects and allpossible interaction effects
# which have at least one parent as signifant main effect
m31 <- lm(y_bar~l+w+l:w+l:L+l:W+l:d+l:F+w:L+w:W+w:d+w:F,df)
ols_step_both_p(m31)
# signifiant factors l, l:w, l:F, w, w:d

#################### Step 4 ################################
#repeating step 2 and 3
m41 <- lm(y_bar~l+w+L+F+d+W+l:w+l:F+w:d,df)
ols_step_both_p(m41)
# again same 2 factors 

#so if we perform step 3 again will get same result
m42<-lm(y_bar~l+w+l:w+l:L+l:W+l:d+l:F+w:L+w:W+w:d+w:F,df)
ols_step_both_p(m42)
# signifiant factors l, l:w, l:F, w, w:d
#Thus it is the final model with Adj R^2 of 0.932

####################### FINAL MODEL ##########################
ols_step_both_p(m42)$model
print(paste0("Y_ = 2.32583 + 0.27062*X_l - 0.06695*X_w - 0.09028*X_lw + 0.09170*X_lF+0.05936*X_wd"))

######################## LOCATION ##############################

#-----------------------------------------------------------------------------------#

########################DISPERSION#################################

###################### STEP 1 ####################################
#factor l
md11=lm(ln_s2~l+l:w+l:L+l:W+l:d+l:F,data=df)
ols_step_both_p(md11)
# 1 factors : l:L

# factor w
md12=lm(ln_s2~w+w:l+w:L+w:W+w:d+w:F,data=df)
ols_step_both_p(md12)
#2 factors significant  - w

#factor L
md13=lm(ln_s2~L+L:l+L:w+L:W+L:d+L:F,data=df)
ols_step_both_p(md13)
# factors : L:l

#factor W
md14=lm(ln_s2~W+W:l+W:w+W:L+W:d+W:F,data=df)
ols_step_both_p(md14)
# facTors : W:F

# factor d
md15=lm(ln_s2~d+d:l+d:w+d:L+d:W+d:F,data=df)
ols_step_both_p(md15)
# FACTOR : d

# factor F
md16=lm(ln_s2~F+F:l+F:w+F:L+F:W+F:d,data=df)
ols_step_both_p(md16)
# only factor F

######################  STEP 2 ##########################
# Significant interaction effects identified from step 1 are:
# l:L, W:F
# model with these and main effects
md21=lm(ln_s2~l+w+L+W+d+F+l:L+W:F,data=df)
ols_step_both_p(md21)
# Only factor d

################### STEP 3 ##############################
# so consider all significant main effects from step2 
# and all interaction effects for which at least 1 component is significant main effect
md31=lm(ln_s2~d+d:l+d:w+d:L+d:W+d:F,data=df)
ols_step_both_p(md31)

################## STEP 4 ##############################
md41=lm(ln_s2~l+w+L+W+d+F,data=df)
ols_step_both_p(md41)
# only explaining 0.374 variation

#best model is one with only 1 factor d
ols_step_both_p(md41)$model
########################DISPERSION#################################


