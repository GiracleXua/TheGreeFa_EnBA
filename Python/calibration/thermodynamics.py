# io
import os
from pathlib import Path

# mathematics
import numpy as np
import pandas as pd
import math
from math import exp

# thermal
import  CoolProp.CoolProp as CP
from CoolProp.HumidAirProp import HAPropsSI
import psychrolib as psylib
psylib.SetUnitSystem(psylib.SI)

import media_model_mgcl2 as model_mg
import media_model_water as model_w

import scipy.integrate as intg
import scipy.interpolate as inp

###########################begin thermodynamic calculation######################

## basic equation

# density of dry air
get_rho_dry = lambda T, RH: 1/HAPropsSI("Vda", "T", T, "RH", RH, "P", 101325)
get_rho_humid = lambda T, RH: 1/HAPropsSI("Vha", "T", T, "RH", RH, "P", 101325)
# thermal conductivity of air (little influence from moisture)
get_lambda = lambda T, RH: HAPropsSI('k', 'T', T, 'RH', RH, 'P', 101325)
# thermal capacity of air
get_cp_a = lambda T, x: HAPropsSI('cp', 'T', T, 'W', x, 'P', 101325)

# mass diffusion
get_d_a = lambda T: -2.775e-6 + 4.479e-8*T + 1.656e-10*T**2

# enthalpy of humid air
get_h = lambda T, RH: HAPropsSI('Hda', 'T',T, 'RH',RH, 'P', 101325)
get_h_dry = lambda T, RH: HAPropsSI('Hda', 'T',T, 'RH',RH, 'P', 101325)

# absolute humidity of moist air
get_x = lambda T, RH: HAPropsSI("W", "T", T, "RH", RH, "P", 101325)
get_RH = lambda T, x: HAPropsSI("RH", "T", T, "W", x, "P", 101325)

# calculation thermodynamic key parameters: Nu, Sh

# variable definition
# T: Temperature in K
# x: Luftfeuchte (absolute): in kg/kg
# xi: desiccant concentration

#### unit conversion ####
# mass fraction to humidity ratio
def air_mf_to_hr(x_w):
    """
    x: mass fraction
    w: humidity ration kg/kg
    """
    x_a = 1-x_w
    w = x_w / x_a

    return w

def molal_to_massfr(m, MM = 95.211):
    '''
    convert molality (mol (solute) /kg (solvent) ) to mass fraction
    default solute, MgCl2, whose molar mass is 95.211 g/mol
    '''    
    x = m*MM/1000 / (m*MM/1000 + 1 )
    return x

def massfr_to_molal(x, MM = 95.211):
    '''
    convert mass fraction to molality (mol (solute) /kg (solvent) )
    default solute, MgCl2, whose molar mass is 95.211 g/mol
    '''
    m = x/(MM/1000) / (1-x)
    return m
#########################

# Nu
def calc_delta_enthalpy(T_a_in, T_a_out):
    delta_h = psylib.GetDryAirEnthalpy(TDryBulb=T_a_in-273.15) - psylib.GetDryAirEnthalpy(TDryBulb=T_a_out-273.15)
    return delta_h # J/kg sensible heat

def calc_log_mean_delta_T(T_a_in, T_a_out, T_des_in, T_des_out, flow = 'counter'):
    if flow == 'counter' or flow == 'cross':
        delta_T_1 = T_a_in - T_des_out
        delta_T_2 = T_a_out - T_des_in
    elif flow == 'parallel':
        delta_T_1 = T_a_in - T_des_in
        delta_T_2 = T_a_out - T_des_out    
    else:
        raise('only support counter, parallel and cross flow')
    assert delta_T_1 * delta_T_2 > 0, "temperature of one media should be always bigger or smaller than the other."
    if delta_T_1 == delta_T_2:
        T_logm = delta_T_1
    else:
        T_logm = (delta_T_1 - delta_T_2) / (math.log(delta_T_1/delta_T_2))
    if flow == 'cross':
        T_logm = 0.9 * T_logm
    return T_logm # K

def calc_alpha(m_a, T_a_in, T_a_out, T_des_in, T_des_out, exchange_area, flow = 'counter'):
    # m_a: kg/s
    Q_s = m_a * calc_delta_enthalpy(T_a_in, T_a_out)
    T_logm = calc_log_mean_delta_T(T_a_in, T_a_out, T_des_in, T_des_out, flow = flow)
    alpha = Q_s/(T_logm * exchange_area)
    return alpha

def calc_Nu(d_e, m_a, T_a_in, T_a_out, T_des_in, T_des_out, exchange_area, flow = 'counter'):
    # heat transfer coeff
    alpha = calc_alpha(m_a, T_a_in, T_a_out, T_des_in, T_des_out, exchange_area, flow) 
    # print("alpha is: {}".format(alpha))
    # thermal conductivity
    lambda_air = CP.PropsSI('L', 'T', (T_a_in + T_a_out)/2, 'P', 101325, 'Air') 
    # equivalent parameter
    d_e = d_e

    Nu = alpha*d_e/lambda_air
    return Nu

# Sh
def p_h2o_sat(T):
    """
    Saturated Pressure of water vapor in Pa
    
    input variavbles: 
        - T temperature in K

    output
        - Saturated Pressure of water in Pa
    """
    return 1e5 * 220.64 * exp(((-7.85823) * (1 - T / 647.226) + (1.83991) * (1 - T / 647.226) ** 1.5 + (-11.7811) * (1 - T / 647.226) ** 3 + (22.6705) * (1 - T / 647.226) ** 3.5 + (-15.9393) * (1 - T / 647.226) ** 4 + (1.77516) * (1 - T / 647.226) ** 7.5) / (1 - (1 - T / 647.226)))

def p_LiCl_sat(T, xi):
    param = [0.28, 4.3, 0.6, 0.21, 5.1, 0.49, 0.362, -4.75, -0.40, 0.03]
    A = 2- (1+(xi/param[0])**param[1])**param[2]
    B = (1+(xi/param[3])**param[4])**param[5] - 1
    C = 1-(1+(xi/param[6])**param[7])**param[8] - param[9]*exp(-(xi-0.1)**2/0.005)
    
    ps_H2O = CP.PropsSI('P','T', T, 'Q', 1 ,'Water')
    p_LiCl_sat = ps_H2O * C * (A+B*(T/647))
    return p_LiCl_sat

def p_MgCl2_sat(T,xi):
    """
    T in K
    xi in kg/kg

    return water vapor pressure in moist air, unit Pa
    """
    M_H2O = 18.015/1000
    M_salz= 95.211/1000
    vH = 3
    x = (xi/M_salz*vH)/((xi/M_salz*vH)+((1-xi)/M_H2O))
    gamma = exp(x*((x-(-1.195+0.002513*(298-T)))+(x*(-19.31-0.01843*(298-T)))))
    activity = gamma*(1-x)
    ps_H2O = CP.PropsSI('P','T', T, 'Q', 1 ,'Water')
    p_sat = activity*ps_H2O   
    return p_sat

def calc_xi_des_out(m_a, m_des_in, x_a_in, x_a_out, xi_des_in):
    # calculate xi_des_out by mass balance
    m_solute = m_des_in * xi_des_in
    m_des_out = m_des_in + m_a*(x_a_in-x_a_out)
    xi_des_out = m_solute/m_des_out
    return xi_des_out

def calc_x_des_equ(T_des, xi_des, type_desiccant = 'MgCl2'):
    if type_desiccant == 'LiCl':
        x_des = psylib.GetHumRatioFromVapPres(VapPres=p_LiCl_sat(T=T_des, xi = xi_des), Pressure=101325)
    elif type_desiccant == 'MgCl2':
        x_des = psylib.GetHumRatioFromVapPres(VapPres=p_MgCl2_sat(T=T_des, xi = xi_des), Pressure=101325)
    return x_des

def calc_beta(m_a, m_des_in, T_des_in, T_des_out, x_a_in, x_a_out, xi_des_in, exchange_area, type_desiccant = 'MgCl2', flow = 'counter'):
    # m_a: kg/s
    M_s = m_a * (x_a_in-x_a_out)
    x_logm = calc_log_mean_delta_x(x_a_in, x_a_out, xi_des_in, T_des_in, T_des_out, type_desiccant = type_desiccant, flow = flow)
    # print(x_logm)
    beta = M_s/(x_logm * exchange_area)
    return beta

def calc_Sh(d_e, m_a, m_des_in, x_a_in, x_a_out, T_des_in, T_des_out, xi_des_in, exchange_area, T_a_in, T_a_out, flow = 'counter'):
    # heat transfer coeff
    beta = calc_beta(m_a, m_des_in, T_des_in, T_des_out, x_a_in, x_a_out, xi_des_in, exchange_area, flow = flow)
    # mass diffusion -- reference Bolz and Tuve (1976), diffusion coefficient of water vapor in air
    D_a = lambda T: -2.775e-6 + 4.479e-8*T + 1.656e-10*T**2
    # density
    rho_a = CP.PropsSI('D', 'T', (T_a_in + T_a_out)/2, 'P', 101325, 'Air')
    # d_e equivalent parameter

    Sh = beta*d_e/(D_a(T_a_in/2 + T_a_out/2)*rho_a)
    return Sh

def calc_Re(m_flow, T, w, D, A, P = 101325):
    """
    rynolds number: 
    Re = rho * u *D / dynamic_viscosity

    w: air humidity ratio, kg/kg_dry air
    D: characteristic length, m
    A: cross flow area m2
    """
    # dynamic viscosity
    mu = HAPropsSI('mu', 'T', T, 'P', P, 'W', w)    
    Re = m_flow*D/(A*mu)
    return Re

def calc_Pr(T, w, P = 101325):
    """
    prandt number:
    Pr = cp*mu/k
    
    w: air humidity ratio, kg/kg_dry air
    D: characteristic length, m
    A: cross flow area m2

    """
    c_p = HAPropsSI('C', 'T', T, 'P', P, 'W', w)
    mu = HAPropsSI('mu', 'T', T, 'P', P, 'W', w)
    k = HAPropsSI('k', 'T', T, 'P', P, 'W', w)
    Pr = c_p * mu / k
    return Pr

def calc_Sc(T, w, P = 101325):
    """
    schmidt number: 
    Sc = mu/rho/Diff
    Diff: diffusion rate
    
    w: air humidity ratio, kg/kg_dry air
    D: characteristic length, m
    A: cross flow area m2
    """
    # dynamic viscosity
    mu = HAPropsSI('mu', 'T', T, 'P', P, 'W', w)
    # density of humid air
    rho = 1/HAPropsSI('Vha', 'T', T, 'P', P, 'W', w)
    # mass diffusivity
    Diff = -2.775e-6 + 4.479e-8*T + 1.656e-10*T**2
    Sc = mu/(rho * Diff) # re = rho * u *D / dynamic_viscosity
    return Sc
    
# calculate Nu and Sh using equation:
def cp_integral(W, T_1, T_2):
    cp_T = lambda T: HAPropsSI('cp', 'T',T, 'W', W, 'P', 101325)
    result = intg.quad(cp_T, T_1, T_2)
    return result

def calc_log_mean_delta_x(x_a_in, x_a_out, xi_des_in, T_des_in, T_des_out, type_desiccant = 'MgCl2', flow = 'counter'):
    # calculate log mean concentration difference

    # 1. calculate xi_des_out, which are not given in Paper
    if type_desiccant == 'LiCl':
        p_sat_in = p_LiCl_sat(T=T_des_in, xi = xi_des_in)
        p_sat_out = p_LiCl_sat(T=T_des_out, xi = xi_des_in) # consider concentration as constant
    elif type_desiccant == 'MgCl2':
        p_sat_in = p_MgCl2_sat(T=T_des_in, xi = xi_des_in)
        p_sat_out = p_MgCl2_sat(T=T_des_out, xi = xi_des_in) # consider concentration as constant
        
    # xi_des_out = calc_xi_des_out(m_a = m_a, m_des_in = m_des_in, x_a_in = x_a_in, x_a_out = x_a_out, xi_des_in = xi_des_in)

    x_des_in = psylib.GetHumRatioFromVapPres(VapPres=p_sat_in, Pressure=101325)
    x_des_out =psylib.GetHumRatioFromVapPres(VapPres=p_sat_out, Pressure=101325)

    if flow == 'counter' or flow == 'cross':
        delta_x_1 = x_a_in - x_des_out
        delta_x_2 = x_a_out - x_des_in
    elif flow == 'parallel':
        delta_x_1 = x_a_in - x_des_in
        delta_x_2 = x_a_out - x_des_out    
    else:
        raise('only support counter, parallel and cross flow')

    assert delta_x_1 * delta_x_2 > 0, "current air inlet humidity ratio is {}: error, check humidity ratio".format(x_a_in)
    # if not (delta_x_1 * delta_x_2 > 0 and abs(delta_x_1) > abs(delta_x_2)):
    #     print("{}: error, check humidity ratio".format(x_a_in))
    
    if delta_x_1 == delta_x_2:
        x_logm = delta_x_1
    else:
        try:
            x_logm = (delta_x_1 - delta_x_2) / math.log(delta_x_1/delta_x_2)
        except:
            x_logm = delta_x_1
            print("using maximal humidity difference instead of real value")
    if flow == 'cross':
        x_logm = x_logm*0.9
    # print(delta_x_1, delta_x_2)
    return x_logm

def calc_T_ratio(df):
    delta_T_d = df.T_d_o_exp-df.T_d_in
    delta_T_a = df.T_a_in-df.T_a_o_exp
    coeff_P = (df.T_a_o_exp-df.T_a_in)/(df.T_d_in-df.T_a_in)
    coeff_R = abs(delta_T_d/delta_T_a)
    
    df_result = pd.DataFrame({'delta_T_d':delta_T_d,
                            'delta_T_a':delta_T_a,
                            'coeff_P_efficiency':coeff_P,
                            'coeff_R_ratio':coeff_R})
    return df_result

def calc_sen_heat(T_a_in, T_a_out, m_da, W=0):
    '''
    W: since sensible heat, the default moisture of air is set to 0
    m_da: mass flow of dry air kg/s

    return sensible heat exchange in W
    '''
    result = m_da * cp_integral(W, T_a_out, T_a_in)[0] # cooling: T_a_out < T_a_in
    return result

def prepare_for_h_m(df, type_des = 'MgCl2', if_calc_effectiveness = False):
    df['hr_air_in'] = np.vectorize(get_RH)(df.T_a_in, df.x_a_in)
    df['hr_air_out'] = np.vectorize(get_RH)(df.T_a_o_exp, df.x_a_o_exp)
    
    # air
    df['rho_da'] = np.vectorize(get_rho_dry)(df.T_a_in, df.hr_air_in) # density
    df['rho_ha'] = np.vectorize(get_rho_humid)(df.T_a_in, df.hr_air_in) # density
    df['k'] = np.vectorize(get_lambda)((df.T_a_in + df.T_a_o_exp)/2, df.hr_air_in) # thermal conductivity
     
    df['m_da'] = df['m_a_in'] # assume the measured mass flow rate is the mass flow rate of dry air

    df['h_a_in'] = np.vectorize(get_h)(df.T_a_in, df.hr_air_in) # unit kJ/kg
    df['h_a_out'] = np.vectorize(get_h)(df.T_a_o_exp, df.hr_air_out)    
        
    df['delta_Q_a'] = df.m_da * (df.h_a_in - df.h_a_out)
    df['delta_m_a'] = df.m_da * (df.x_a_in - df.x_a_o_exp)
    
    try:
        df['m_solute'] = df['m_d_in'] * df['xi_d_in']
        df['m_des_out'] = df['m_solute'] / df['xi_d_o_exp']
        df['delta_m_des'] = df['m_des_out'] - df['m_d_in']
    except:
        print('not possible to compute mass difference of solution.')
        
    # desiccant
    df['cp_d'] = np.vectorize(model_mg.cp_MgCl2)(df.T_d_in, df.xi_d_in)
    df['delta_Q_d'] = df.m_d_in * df.cp_d * (df.T_d_o_exp - df.T_d_in)*1000 # unit W
    df['x_d_in_equ'] = np.vectorize(calc_x_des_equ)(df.T_d_in, df.xi_d_in, type_des)

    if if_calc_effectiveness:
        df['delta_T'] = df.T_a_in - df.T_d_in
        df['delta_x'] = df.x_a_in-df.x_d_in_equ
        df['epsilon_T'] = (df.T_a_in-df.T_a_o_exp)/df['delta_T']
        df['epsilon_x'] = (df.x_a_in-df.x_a_o_exp)/df['delta_x']
    return df

def calc_heat_exchange(df, exchange_area, d_e, flow_config = 'counter'):
    '''
    Nu = h_c * d_e / lambda
    unit of h_c: W/(m2*K)
    unit of Q: kJ/kg
    unit of Q: kJ/kg
    unit of temperature: K
    counter, parallel, cross
    d_e: equivalent diameter
    '''
    # sensible heat
    df['delta_Q_sen'] = np.vectorize(calc_sen_heat)(df.T_a_in, df.T_a_o_exp, df.m_da)
    
    df['log_m_delta_T'] = np.vectorize(calc_log_mean_delta_T)(df.T_a_in, df.T_a_o_exp, df.T_d_in, df.T_d_o_exp, flow_config)
    df['h_c'] = df.delta_Q_sen/df.log_m_delta_T/exchange_area # W/(m2*K)
    
    df['Nu_2'] = df['h_c']*d_e/df['k']
    return df

def calc_mass_exchange(df, exchange_area, d_e, type_d = 'MgCl2', flow_config ='counter'):
    
    df['delta_m_a'] = df.m_da * (df.x_a_in - df.x_a_o_exp)
    df['log_m_delta_x'] = np.vectorize(calc_log_mean_delta_x)(df.x_a_in,
                                                             df.x_a_o_exp,
                                                             df.xi_d_in,
                                                             df.T_d_in,
                                                             df.T_d_o_exp,
                                                             type_d,
                                                             flow_config)
    df['h_d'] = df['delta_m_a']/exchange_area/df['log_m_delta_x']
    df['Sh_2'] = df['h_d']*d_e/df['rho_ha']/(df.T_a_in/2+df.T_a_o_exp/2).apply(get_d_a)
    df['cp_a'] = np.vectorize(get_cp_a)((df['T_a_in']+df.T_a_o_exp)/2, (df.x_a_in+df.x_a_o_exp)/2)
    df['Le'] = df.h_c/df.cp_a/df.h_d
    df['alpha'] = df['cp_a'] * df['h_d']
    return df
#########################end thermodynamic calculation############################

# # performance analysis
# # Moisture removal rate (MRR)
def calc_MRR(m, w_in, w_out):

    return m*(w_in-w_out)

# # Latent effectiveness
def calc_epsilon_w(w_a_in, w_a_out, T_d_in, xi_d_in, LD = "MgCl2"):
    w_s_in = calc_x_des_equ(T_d_in, xi_d_in, type_desiccant=LD)
    epsilon = (w_a_in-w_a_out)/(w_a_in-w_s_in)
    return epsilon

# # sensible effectiveness
def calc_epsilon_T(T_a_in, T_a_out, T_s_in):
    epsilon = (T_a_in - T_a_out)/(T_a_in - T_s_in)
    return epsilon

def calc_epsilon_h(T_a_in, w_a_in, T_a_out, w_a_out, T_d_in, xi_d_in, LD = "MgCl2"):
    w_s_in = calc_x_des_equ(T_d_in, xi_d_in, type_desiccant=LD)
    h_a_in = HAPropsSI('H','T',T_a_in,'P',101325,'W',w_a_in)
    h_a_out = HAPropsSI('H','T',T_a_out,'P',101325,'W',w_a_out)
    h_equ = HAPropsSI('H','T',T_d_in,'P',101325,'W',w_s_in)
    
    epsilon = (h_a_in - h_a_out) / (h_a_in - h_equ)
    return epsilon
#########################end thermodynamic calculation############################
