# -*- coding: utf-8 -*-
"""
This script is a thermodynamical media model for water

the script intend to calculate the thermodinamical variable of water 

Validity range: 
    T  = [0-100] °C
    

Elaborated By:
    mathieu Provost 
    Teschnishe Universität Berlin
    mathieu.provost@tu-berlin.de
"""
#media model for water
#import necessary libraries
from math import exp as exp

# necessary constant for the calculation
p = 1.013 #atmos press in bar
R = 8.314772 # universal gas constant
M_h2o = 2 * 1.00794 + 15.9994 # molar mass of water in g/mol

#definition of the necessary functions for water
def p_h2o_sat(T, model = 'Buck'):
    """
    
    Saturated Pressure of water gas in kPa
    
    input variavbles: 
       - T temperature in K
        
    """
    if model == "Buck":
        T_corr = T-273.15
        p_v = 0.61121 * exp( (18.678-T_corr/234.5) * (T_corr/(257.14 + T_corr)))
    if model == "Wagner":
        p_v = 100 * 220.64 * exp(((-7.85823) * (1 - T / 647.226) + (1.83991) * (1 - T / 647.226) ** 1.5 + (-11.7811) * (1 - T / 647.226) ** 3 + (22.6705) * (1 - T / 647.226) ** 3.5 + (-15.9393) * (1 - T / 647.226) ** 4 + (1.77516) * (1 - T / 647.226) ** 7.5) / (1 - (1 - T / 647.226)))
    return p_v

def rho_h2o(T):
    """
    
    volumic mass of water Liquid in kg/m3
    
    input variavbles: 
       - T temperature in K
        
    """
    rho_crit = 322
    T_crit = 647.022
    tau = 1 - (T / T_crit)
    return rho_crit * (1 + 1.993771843 * tau ** (1 / 3) + 1.0985211604 * tau ** (2 / 3) - 0.5094492996 * tau ** (5 / 3) - 1.761912427 * tau ** (16 / 3) - 44.9005480267 * tau ** (43 / 3) - 723692.2618632 * tau ** (110 / 3))


def rho_h2o_g(T):
    """
    
    volumic mass of water steam in kg/m3
    
    input variavbles: 
       - T temperature in K
        
    """
    return  (1.013 * 100 * M_h2o) / (T * R)

def cp_h2o(T):
    """
    
    Specific Heat Capacity of water Liquid in kJ/kg.K
    
    input variavbles: 
       - T temperature in K
        
    """
    a = 88.79
    b = -120.196
    C = -16.926
    d = 52.4654
    e = 0.10826
    f = 0.46988
    O = (T / 228) - 1
    return a + b * O ** 0.02 + C * O ** 0.04 + d * O ** 0.06 + e * O ** 1.8 + f * O ** 8

def cp_h2o_g(T):
    """
    
    Specific Heat Capacity of water steam in kJ/kg.K
    
    input variavbles: 
       - T temperature in K
        
    """
    return ((1833.1 - ((T) * 0.035) + (0.000696 * (T) ** 2) - (0.000000215 * (T) ** 3) - (0.000000026 / ((T) ** 2))) / 1000)

def Hv_h2o(T):
    """
    
    Heat of Vaporisation (Latent heat) of water  in kJ/kg
    
    input variavbles: 
       - T temperature in K
        
    """
    return 2921 * (1 - ((T) / (373.946 + 273.15))) ** (0.293 - (0.09956 * ((T) / (373.946 + 273.15))) + 0.15778 * (((T) / (373.946 + 273.15)) ** 2) + 0.054734 * (((T) / (373.946 + 273.15)) ** 3))
   
def h_h2o_g(T):
    """
    
    Spesific enthalpy of water steam in kJ/kg
    
    input variavbles: 
       - T temperature in K
        
    """
    return Hv_h2o(273.15) + (cp_h2o_g(T) * (T) - cp_h2o_g(273.15) * (273.15))

def h_h2o(T):
    """
    
    Spesific enthalpy of water liquid in kJ/kg
    
    input variavbles: 
       - T temperature in K
        
    """
    return (cp_h2o(T) * (T) - cp_h2o(273.15) * (273.15))

def dynvisc_h2o(T): #
    """
    
    Dynamic viscosity of water in Pa.s
    
    input variavbles: 
       - T temperature in K
        
    """
    return ((0.00002414) * 10 ** (247.8 / (T - 140))) #wikipedia unit Pa.s
    #return ((4.2844e-5)+(0.157*((T+64.993)**2)-91.296)**-1) #claudio --> somehow wrong
    
