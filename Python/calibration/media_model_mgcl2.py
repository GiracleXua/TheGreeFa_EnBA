#*\t*- coding: utf-8*\t*-
"""
This script is a thermodynamical media model for Magnesium Cholride aqueous solution

the script intend to calculate the thermodinamical variable Magnesium Cholride aqueous solution 

Validity range: 
    T  = ]0-100] °C
    C =  [0-100] %
    V  > 0       l/min

Elaborated By:
    mathieu Provost 
    Teschnishe Universität Berlin
    mathieu.provost@tu-berlin.de
"""
# media model for MgCl2 solution

# Import necessary libraries
from media_model_water import p_h2o_sat, cp_h2o, rho_h2o, dynvisc_h2o
from math import exp as exp
# necessary constant for the calculation
M_h2o = 18.015 # molar mass of water in g/mol
M_salz = 95.211 # molar mass of Mgcl2 in g/mol

# conversion: massfraction to molality 
def massfr_to_molal(x):
    M_mgcl2 = 95.211
    m = x/(95.211/1000) / (1-x)
    return m

#definition of the necessary functions for the desiccant solution
def x(xi):
    """
    moleanteil, aber angepasst mit vH = 3. (questionable)    
    input variavbles: 
       *\t xi Concentration in kg/kg
        
    """
    vH = 3
    return (xi / M_salz/1000 * vH) / ((xi / M_salz/1000 * vH) + ((1 - xi) / M_h2o/1000))
 
def pv_MgCl2(T, xi, if_return = 'pressure'):
    """
    
    vapor pressure of the Desiccant Solution in kPa
    
    input variavbles: 
        - T temperature in K
        - xi Concentration in kg/kg
        
    """
    Gamma = exp(x(xi) * ((x(xi) - (-1.195 + 0.002513 * (298 - T))) + (x(xi) * (-19.31 - 0.01843 * (298 - T)))))
    activity = Gamma * (1 - x(xi))
    ps_h2o = p_h2o_sat(T)
    if if_return == 'pressure':
        return activity * ps_h2o
    elif if_return == 'rH':
        return activity
 

def rho_MgCl2(T, xi):
    """
    
    Volumic mass of Desiccant Solution in kg/m3
    
    input variavbles: 
        - T temperature in K
        - xi Concentration in kg/kg
        
    """
    rho_red_fun = (0.108 + 0.000868 * T) * xi ** 2 + (0.6802 + 0.0004928 * T) * xi + 1
    #return round(rho_red_fun * rho_h2o(T),1)
    return rho_red_fun * rho_h2o(T)

def xi_MgCl2(T,rho):
    """
    
    Concentration of desiccant % (kg/kg)
    
    input variavbles: 
        - T temperature in K
        - rho Concentration in kg/m3
        
    """
    a=(0.108 + 0.000868 * T)* rho_h2o(T)
    b= (0.6802 + 0.0004928 * T)* rho_h2o(T)
    c= rho_h2o(T)-rho
    delta=b**2 - 4*a*c
    x1=(-b+delta**(1/2))/(2*a)
    
    #x2=(-b-delta**(1/2))/(2*a)
#    xi=0
#    for x in range (0,4000):
#        xi=x*0.0001
#        if round(rho,1)== round(rho_MgCl2(T, x*0.0001),1):
#            break
#        else:
#            xi=-1
    #return round(xi,4)
    return x1
    

def cp_MgCl2(T, xi):
    """
    
    Specific Heat Capacity of Desiccant Solution in kJ/kg.K
    
    input variavbles: 
        - T temperature in K
        - xi Concentration in kg/kg
        
    """
    cp_rel = exp(1.148 * xi) + (-7.316 - 0.005528 * T + T ** 0.3264) * xi
    return cp_rel * cp_h2o(T)

def h_MgCl2(T, xi):
    """
    
    Specific enthalpy of Desiccant Solution in kJ/kg
    
    input variavbles: 
        - T temperature in K
        - xi Concentration in kg/kg
        
    """
    # (T - 273.15) * cp_MgCl2(T, xi)
    h = 3.75550823e+00 * T + -5.11934879e+02 *xi + 4.78672511e-04 * T**2 + T*xi*-4.44122366e+00 + xi**2*8.36881428e+02 -1052.5261563
    return h
 

def dynvisc_MgCl2(T, xi):
    """
    ##################### not usable before it is checked ####################
    
    Dynamic viscosity of Desiccant Solution in Pa.s
    reference: Königberger2008, (Properties of electrolyte solutions relevant to high concentration
    chloride leaching. II. Density, viscosity and heat capacity
    of mixed aqueous solutions of magnesium chloride
    and nickel chloride measured to 90 °C)
    
    input variavbles: 
        - V volume flow rate in m3/h
        - T temperature in K
        - xi Concentration in kg/kg
        
    """
    m = massfr_to_molal(xi)
    B0 = 0.37094869
    B1 = -2.2560189e-5
    D0 = 0.014234217
    D1 = -1.5776297e-4
    visc_rel = exp((B0 + B1 * (T-273.15))*m + (D0 + D1 * (T-273.15))*m**2)
    # print(visc_rel)
    # visc_rel = exp(-152.9 * x(xi) ** 0.987 + 158.9 * x(xi) * 697 * x(xi) / T)
    return  visc_rel * dynvisc_h2o(T) 

def m_dot_desiccant(V,T,xi):
    """
    
    mass flow rate of Desiccant Solution in kg/s
    
    input variavbles: 
        - V volume flow rate in l/m
        - T temperature in K
        - xi Concentration in kg/kg
        
    """
    return V*rho_MgCl2(T, xi)/(60*1000)

def Hr_eq(T,xi):
    """
    
    Relativ humidity of the air in thermodynamical equilibrium with the desiccant in %
        Tair=Tdes
        p_h20=pv_des
    
    input variavbles: 
        - T temperature in K
        - xi Concentration in kg/kg
        
    """
    pv_eq=pv_MgCl2(T,xi)
    for hr in range(0,10000):
        p_h2o_eq = hr*0.01 * p_h2o_sat(T)
        if round(pv_eq,5)==round(p_h2o_eq,5):
            hr_eq=hr*0.01
#            print(hr_eq, pv_eq,p_h2o_eq)
            break
        else:
            hr_eq=9999
    return hr_eq

def C_max_desiccant(T):
    """
    
    Christalisation concentration of desiccant for a given Temperature in kg/kg
    
    source: curve fit from wikipedia solubility tables
    https://en.wikipedia.org/wiki/Solubility_table
    
    input variavbles: 
        - T temperature in K
        
    """
    s=0.0000077459*(T-273.15)**3+0.00046275*(T-273.15)**2+0.080746*(T-273.15)+52.82
    return s/(100+s)
