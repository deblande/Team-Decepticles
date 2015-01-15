#!/usr/bin/env python
import numpy as np
import skfuzzy as fuzz
import pylab as pylab
import matplotlib.pyplot as plt
pylab.rcParams['figure.figsize'] = (10.0, 5.0)

#Generate universe functions
n_domain = np.arange(0,10,1)

# Membership function for "about a #"
#speed_calm = fuzz.gaussmf(speed_avg , 0,2.5)

#LOOK in skfuzzy/membership/generatemf.py for reference
#gaussmf(x, mean, sigma):
#gauss2mf(x, mean1, sigma1, mean2, sigma2):
#gbellmf(x, a, b, c):
#piecemf(x, abc):
#sigmoid(WX, B):
#sigmf(x, b, c):
#trapmf(x, abcd):

about2_5 = fuzz.gaussmf(n_domain, 3,2.5)
about5 = fuzz.sigmf(n_domain,4,-4)

about9 = fuzz.fuzzy_add(n_domain,about2_5,n_domain,about5)

fig, ax = plt.subplots()

ax.plot(n_domain, about2_5, 'r', label = "About 2.5")
ax.plot(n_domain, about5, 'm', label = "About 5")
#ax.plot(about9[0], about9[1], 'b', label = "About 9")
ax.set_ylabel('Fuzzy Membership')
ax.set_xlabel('Fuzzy Addition')
ax.set_ylim(-0.05, 1.05);
ax.legend()

plt.show()
'''
# Crisp Number with Fuzzy Representation / Ordinary 4
n_domain = np.arange(0,10,1)
crisp2 = fuzz.trimf(n_domain, [2,2,2])

#Fuzzy Number "About 4"
n_domain = np.arange(0,10,1)
about4 = fuzz.trimf(n_domain, [3.5 , 4, 4.5])
about8 = fuzz.fuzzy_mult(n_domain, crisp2, n_domain, about4)

fig, ax = plt.subplots()

ax.plot(n_domain, crisp2, 'r', label ="Crisp 2")
ax.plot(n_domain, about4, 'm', label = "About 4")
ax.plot(about8[0], about8[1], 'b', label = "About 8")
ax.set_ylabel('Fuzzy Membership')

ax.set_xlabel('Fuzzy Addition')
ax.set_ylim(-0.05, 1.05)
ax.set_xlim(0,24);
ax.legend()

plt.show()
'''