#!/usr/bin/env python
import numpy as np
import pylab as pylab
import skfuzzy as fuzz
import matplotlib.pyplot as plt
pylab.rcParams['figure.figsize'] = (10.0, 5.0)

########## INPUTS ########################
#Input Universe functions
accell_avg = np.arange(0,11,.1)
speed_avg  = np.arange(0,40,.1)

# Input Membership Functions
#Figure out better curves for these
#This is where we decide at what values we classify the profiles as "calm, normal or aggressive"
# Accelleration
acc_calm = fuzz.sigmf(accell_avg ,1.5,-1.3)
acc_normal = fuzz.gaussmf(accell_avg ,2,1.5)
acc_aggressive = fuzz.sigmf(accell_avg, 3,1.3)

# speed_avg 
speed_calm = fuzz.sigmf(speed_avg , 8,-.4) #also have trapezoid and others (see test2.py)
speed_normal = fuzz.gaussmf(speed_avg, 17.5,10) #peak at ~40 mph
speed_aggressive = fuzz.sigmf(speed_avg ,26,.4) #above ~60 mph is aggressive


#PLOTTING RELATIONSHIPS
fig, ax  = plt.subplots()
fig, bx = plt.subplots()
ax.plot(speed_avg, speed_calm, 'r', label = "Calm")
ax.plot(speed_avg, speed_normal, 'm', label = "Normal")
ax.plot(speed_avg, speed_aggressive, 'b',label = "Aggressive")

ax.set_ylabel('Fuzzy Membership')
ax.set_xlabel('Fuzzy Addition')
ax.set_ylim(-0.05, 1.05)
ax.set_xlim(0,40)
ax.legend()

bx.plot(accell_avg, acc_calm, 'r', label = "Calm")
bx.plot(accell_avg, acc_normal, 'm', label = "Normal")
bx.plot(accell_avg, acc_aggressive, 'b', label = "Aggressive")
bx.set_ylabel('Fuzzy Membership')
bx.set_xlabel('Fuzzy Addition')
bx.set_ylim(-0.05, 1.05)
bx.set_xlim(0,5)
bx.legend()

plt.show()

#Main methods used to calculate the membership in each fuzzy set
#Returns how "calm" the drivers speed was according to the charts created above
#Returns how "normal" the drivers speed was according to the charts created above
#Returns how "aggressive" the drivers speed was according to the charts created above
#Does the same for accelleration below
def speed_category(speed_in):
    speed_cat_calm = fuzz.interp_membership(speed_avg,speed_calm,speed_in) # Depends from Step 1
    speed_cat_normal = fuzz.interp_membership(speed_avg,speed_normal,speed_in) # Depends from Step 1
    speed_cat_aggressive = fuzz.interp_membership(speed_avg,speed_aggressive,speed_in) # Depends form Step 1
    return dict(calm = speed_cat_calm,normal = speed_cat_normal,aggressive = speed_cat_aggressive)

def accelleration_category(accelleration_in):
    accelleration_cat_calm = fuzz.interp_membership(accell_avg,acc_calm, accelleration_in) # Depends from Step 1
    accelleration_cat_normal = fuzz.interp_membership(accell_avg,acc_normal, accelleration_in)
    accelleration_cat_aggressive = fuzz.interp_membership(accell_avg,acc_aggressive, accelleration_in)
    return dict(calm = accelleration_cat_calm, normal = accelleration_cat_normal, aggressive = accelleration_cat_aggressive)

#Example input variables 
spd_in = 35.2;#in meters/second
acc_in = 5.03;#m/s^2 

speed_in = speed_category(spd_in)
accelleration_in = accelleration_category(acc_in)

#Print evaluation
print ""
print "Fuzzy Set inclusion for inputs:"
print "Scores for drivers accelleration = ", acc_in 
print "\tcalm: ",accelleration_in['calm']
print "\tnormal: ",accelleration_in['normal']
print "\taggressive: ",accelleration_in['aggressive']
print ""
print "Scores for drivers speed = ", spd_in
print "\tcalm: ",speed_in['calm']
print "\tnormal: ",speed_in['normal']
print "\taggressive: ",speed_in['aggressive']
'''
#MAKE RULES HERE TO GIVE SCORES TO DRIVERS BASED ON ALL VARIABLES DEFINED ABOVE
#TODO LATER
rule1 = np.fmax(accelleration_in['calm'],speed_in['calm'])
rule2 = np.fmax(accelleration_in['normal'],speed_in['normal'])
rule3 = np.fmax(speed_in['aggressive'],accelleration_in['aggressive'])

########## OUTPUT ########################
# Tip
# Output Variables Domain
tip = np.arange(0,30,.1)

# Output  Membership Function 
#Once 'train' for driver profiles, we can compare here to get the most likely driver or drivers

tip_ch  = fuzz.trimf(tip, [0, 5, 10])
tip_ave = fuzz.trimf(tip, [10, 15, 25])
tip_gen = fuzz.trimf(tip, [20, 25, 30])

imp1 = np.fmin(rule1,tip_ch)
imp2 = np.fmin(rule2,tip_ave)
imp3 = np.fmin(rule3,tip_gen)

aggregate_membership = np.fmax(imp1, np.fmax(imp2,imp3))

result_tip = fuzz.defuzz(tip, aggregate_membership , 'centroid')
print result_tip
'''
