# -*- coding: utf-8 -*-
"""
Created 13/feb/2020
Create by: Diego Fernandes Rodrigues
More https://eaiconvergiu.wordpress.com/
"""

#import math
import numpy as np
import csv
import matplotlib.pyplot as plt
import pandas as pd

#--------------------------------------------------------------------------
# Input Deck
#--------------------------------------------------------------------------

#Mean Applied Force (N) 
F_mu = 2600*pow(10,1.0)

#Standard Deviation Applied Force (N) 
F_sigma = (F_mu*0.02)/6

#Mean Thickness of the sample (mm)
t_mu = 2.5

#Standard Deviation Thickness of the sample (mm)
t_sigma = 0.01/6

#Mean Width of the sample (mm)
w_mu = 15.0

#Standard Deviation Width of the sample (mm)
w_sigma = 0.02/6

#Sample Fatigue Coeficient (MPa) Limits of and Uniform Distribution
Sfsp_mu = 606

#Standard Deviation Fatigue limite
Sfsp_sigma = 20

#Sample Fatigue Expoent
bsp = -0.214

#Number of cycles for infinity life
N_inf = 900000

#Number of Samples
n = 10

#--------------------------------------------------------------------------
# Generating sampling data
#--------------------------------------------------------------------------

sample = np.zeros((n, 6))
reliability = [None] * n
for i in range(n):
    #Random Force
    F = np.random.normal(F_mu, F_sigma, 1)
    #Random Thickness
    t = np.random.normal(t_mu, t_sigma, 1)
    #Random width
    w = np.random.normal(w_mu, w_sigma, 1)
    #Area (mm^2)
    A = t * w
    #Stress (MPa)
    S = F / A
    #Fatigue limit (MPa) 
    Sfsp = np.random.normal(Sfsp_mu, Sfsp_sigma, 1)
    #Number of cylces of life for the sample
    N = pow(((S)/(Sfsp))/2,1/bsp)
    #Stress fatigue for the sample, should be S = Sa
    Sa = (Sfsp*(2*N**bsp))
    #Stress limit for infity life
    Sa_inf = (Sfsp*(2*N_inf**bsp))
    #Replace values
    sample[i,0] = F
    sample[i,1] = A
    sample[i,2] = S
    sample[i,3] = N
    sample[i,4] = F_mu/(t_mu*w_mu)
    sample[i,5] = Sa_inf
    if (S >= Sa_inf):
        #Falha
        reliability[i] = "F"
    else:
        #Suspenso
        reliability[i] = "S"

#--------------------------------------------------------------------------
# Exporting data to .csv file
#--------------------------------------------------------------------------

#Generating data to export
#Append variables before export
data = np.c_[sample,reliability]
#Add a head
head = np.array([['Force[N]'],
                 ['Area[mm2]'],
                 ['Stress[MPa]'],
                 ['NumberOfCycles'],
                 ['TheoreticalStress[MPa]'],
                 ['FatigueLimit[MPa]'],
                 ['Status']]).transpose()
#Export file
with open('data.csv', 'w') as writeFile:
    write = csv.writer(writeFile, lineterminator = '\n')
    write.writerows(np.r_[head,data])
writeFile.close()

#--------------------------------------------------------------------------
# Ploting Variables
#--------------------------------------------------------------------------

# DataFrame for reliability
aux_df = pd.DataFrame({'status': reliability, 'Number Of Cycles':sample[:,3]})
plt.figure();
aux_df['Number Of Cycles'].plot.hist()

#DataFrame for histogram plot
sample = pd.DataFrame({'Stress Load':sample[:,2], 'Fatigue Limite':sample[:,5]})
plt.figure();
sample.plot.hist()