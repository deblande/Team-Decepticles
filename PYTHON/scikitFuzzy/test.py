#!/usr/bin/env python
import numpy as np
import pylab as pylab
import skfuzzy as fuzz
pylab.rcParams['figure.figsize'] = (10.0, 5.0)

########## INPUTS ########################
#Input Universe functions
accell_avg = np.arange(0,11,.1)
speed_avg  = np.arange(0,11,.1)

# Input Membership Functions
#Figure out better curves for these
# Accelleration
acc_calm = fuzz.gaussmf(accell_avg ,0,1.5)
acc_normal = fuzz.gaussmf(accell_avg ,5,1.5)
acc_aggressive = fuzz.gaussmf(accell_avg ,10,5)

# speed_avg
speed_calm = fuzz.gaussmf(speed_avg , 0,2.5) #also have trapezoid and others
speed_normal = fuzz.gaussmf(speed_avg, 3,7)
speed_aggressive = fuzz.gaussmf(speed_avg ,10,7.5)

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

#Exaple input variables 
spd_in = 10.0;
acc_in = 5.03;

speed_in = speed_category(spd_in)
accelleration_in = accelleration_category(acc_in)

#Print evaluation
print "For accell_avg" 
print "\tcalm: ",accelleration_in['calm']
print "\tnormal: ",accelleration_in['normal']
print "\taggressive: ",accelleration_in['aggressive']
print ""
print "For speed_avg\n\t" 
print "\tcalm: ",speed_in['calm']
print "\tnormal: ",speed_in['normal']
print "\taggressive: ",speed_in['aggressive']
#MAKE RULES HERE

rule1 = np.fmax(accelleration_in['calm'],speed_in['calm'])
rule2 = np.fmax(accelleration_in['normal'],speed_in['normal'])
rule3 = np.fmax(speed_in['aggressive'],accelleration_in['aggressive'])

########## OUTPUT ########################
# Tip
# Output Variables Domain
tip = np.arange(0,30,.1)

# Output  Membership Function 
#Once 'train' for driver profiles, we can compare here to get the most likely driver or drivers
'''
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