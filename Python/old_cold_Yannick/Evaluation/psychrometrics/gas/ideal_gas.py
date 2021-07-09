# -*- coding: utf-8 -*-
"""
@author: yafuerst
"""

import math

from ..data import gas_data as data


class partialMedium(object):
    def gasConstant(self):
        pass

    def specificEnthalpy(self):
        pass

    def specificHeatCapacity(self):
        pass

class gas(partialMedium):
    def __init__(self, data):
        self.__R = data["R"]
        self.__alow = data["alow"]
        self.__blow = data["blow"]
        self.__ahigh = data["ahigh"]
        self.__bhigh = data["bhigh"]
        self.__Hf = data["Hf"]

    def gasConstant(self):
        return self.__R

    def specificEnthalpy(self, T, h_off):
        h = (self.__R*((-self.__alow[0] +
                       T*(self.__blow[0] +
                          self.__alow[1]*math.log(T) +
                          T*(self.__alow[2] +
                             T*(0.5*self.__alow[3] +
                                T*(1.0/3.0*self.__alow[4] +
                                   T*(0.25*self.__alow[5] +
                                      0.2*self.__alow[6]*T))))))/T) -
             self.__Hf + h_off)
        return h

    def specificHeatCapacity(self, T):
        cp = (self.__R*(1.0/(T*T)*(self.__alow[0] +
                                   T*(self.__alow[1] +
                                      T*(1.0*self.__alow[2] +
                                         T*(self.__alow[3] +
                                            T*(self.__alow[4] +
                                               T*(self.__alow[5] +
                                                  self.__alow[6]*T))))))))
        return cp


class moistAir(partialMedium):
    def __init__(self, T_min=190.0, T_max=647.0, iter_max=200, tolerance=1e-10):
        self.Water = 0
        self.Air = 1
        self.__dryAir = gas(data=data.air)
        self.__steam = gas(data=data.H2O)
        self.__iter_max = iter_max
        self.__T_min = T_min
        self.__T_max = T_max
        self.__Tcritical = 647.096
        self.__pcritical = 22.064e6
        self.__Ttriple = 273.16
        self.__ptriple = 611.657
        self.__tolerance = tolerance

    def getTolerance(self):
        eps = self.__tolerance
        return eps

    def gasConstantAir(self):
        R = self.__dryAir.gasConstant()
        return R

    def gasConstantWater(self):
        R = self.__steam.gasConstant()
        return R

    def gasConstant(self, X):
        R = (X[self.Air]*self.gasConstantAir() +
             X[self.Water]*self.gasConstantWater())
        return R

    def specificEnthalpy_dryAir(self, T):
        h = self.__dryAir.specificEnthalpy(T=T, h_off=25104.684)
        return h

    def specificEnthalpy_steam(self, T):
        h = self.__steam.specificEnthalpy(T=T, h_off=46479.819 + 2501014.5)
        return h

    def enthalpyOfWater(self, T):
        h = spliceFunction(
            pos=4200*(T - 273.15),
            neg=2050*(T - 273.15) - 333000,
            x=T - 273.16,
            deltax=0.1)
        return h

    def specificEnthalpy(self, p, T, X):
        h_air = self.specificEnthalpy_dryAir(T=T)
        h_steam = self.specificEnthalpy_steam(T=T)
        h_water = self.enthalpyOfWater(T=T)
        R_air = self.__dryAir.gasConstant()
        R_steam = self.__steam.gasConstant()
        p_sat = self.saturationPressure(T_sat=T)
        X_sat = min(p_sat*R_air/R_steam/max(100*self.__tolerance, p -
                                            p_sat)*(1 - X[self.Water]), 1.0)
        X_liq = max(X[self.Water] - X_sat, 0.0)
        X_steam = X[self.Water] - X_liq
        h = h_air*X[self.Air] + h_steam*X_steam + h_water*X_liq
        return h

    def specificEnthalpy_x(self, p, T, x):
        h_air = self.specificEnthalpy_dryAir(T=T)
        h_steam = self.specificEnthalpy_steam(T=T)
        h_water = self.enthalpyOfWater(T=T)
        x_sat = self.xsaturation(p=p, T=T)
        x_liq = max(x - x_sat, 0.0)
        x_steam = x - x_liq
        h = h_air + h_steam*x_steam + h_water*x_liq
        return h

    def shearing(self, p, T):
        h_xsat = self.specificEnthalpy_x(p=p, T=T, x=self.xsaturation(p=p, T=T))
        h_0 = self.specificEnthalpy_x(p=p, T=T, x=0.0)
        m = (h_xsat - h_0)/self.xsaturation(p=p, T=T)
        return m

    def specificEnthalpy_shear(self, p, T, x):
        m = self.shearing(p=p, T=273.15)
        h = self.specificEnthalpy_x(p=p, T=T, x=x) - m*x
        return h

    def specificHeatCapacity_dryAir(self, T):
        cp = self.__dryAir.specificHeatCapacity(T=T)
        return cp

    def specificHeatCapacity_steam(self, T):
        cp = self.__steam.specificHeatCapacity(T=T)
        return cp

    def specificHeatCapacity(self, T, X):
        cp_air = self.specificHeatCapacity_dryAir(T)
        cp_steam = self.specificHeatCapacity_steam(T)
        cp = (cp_air*X[self.Air] + cp_steam*X[self.Water])
        return cp

    def xsaturation(self, p, T):
        R_air = self.__dryAir.gasConstant()
        R_steam = self.__steam.gasConstant()
        p_sat = self.saturationPressure(T_sat=T)
        x_sat = R_air/R_steam*min(p_sat, 0.999*p)/(p - min(p_sat, 0.999*p))
        return x_sat

    def Xsaturation(self, p, T):
        R_air = self.__dryAir.gasConstant()
        R_steam = self.__steam.gasConstant()
        p_sat = self.saturationPressure(T_sat=T)
        X_sat = R_air/R_steam/(p/min(p_sat, 0.999*p) - 1 + R_air/R_steam)
        return X_sat

    def absoluteHumidity(self, X):
        x = X[self.Water]/(1.0 - X[self.Water])
        return x

    def relativeHumidity_pTX(self, p, T, X):
        R_air = self.__dryAir.gasConstant()
        R_steam = self.__steam.gasConstant()
        p_sat = self.saturationPressure(T_sat=T)
        phi = max(0.0, min(1.0,
                           p/p_sat*X[self.Water]/(X[self.Water] +
                                                   R_air/R_steam*X[self.Air])))
        return phi

    def relativeHumidity_pTx(self, p, T, x):
        R_air = self.__dryAir.gasConstant()
        R_steam = self.__steam.gasConstant()
        p_sat = self.saturationPressure(T_sat=T)
        phi = p/p_sat*x/(x + R_air/R_steam)
        return phi

    def massFraction(self, x):
        X = [x/(x + 1.0), 1.0/(x + 1.0)]
        return X

    def absoluteHumidity_pTphi(self, p, T, phi):
        R_air = self.__dryAir.gasConstant()
        R_steam = self.__steam.gasConstant()
        p_sat = self.saturationPressure(T_sat=T)
        x = R_air/R_steam*p_sat/(p/phi - p_sat)
        return x

    def saturationPressure_liquid(self, T_sat):
        r1 = (1.0 - T_sat/self.__Tcritical)
        a = [-7.85951783, 1.84408259, -11.7866497,
             22.6807411, -15.9618719, 1.80122502]
        n = [1.0, 1.5, 3.0, 3.5, 4.0, 7.5]
        poly = (a[0]*r1**n[0] + a[1]*r1**n[1] + a[2]*r1**n[2] +
                a[3]*r1**n[3] + a[4]*r1**n[4] + a[5]*r1**n[5])
        p_sat = math.exp(((poly)*self.__Tcritical)/T_sat)*self.__pcritical
        return p_sat

    def saturationPressure_ice(self, T_sat):
        r1 = T_sat/self.__Ttriple
        a = [-13.9281690, 34.7078238]
        n = [-1.5, -1.25]
        p_sat = math.exp(a[0] - a[0]*r1**n[0] + a[1] -
                         a[1]*r1**n[1])*self.__ptriple
        return p_sat

    def saturationPressure(self, T_sat):
        p_sat = spliceFunction(
            pos=self.saturationPressure_liquid(T_sat=T_sat),
            neg=self.saturationPressure_ice(T_sat=T_sat),
            x=T_sat - 273.16,
            deltax=1.0)
        return p_sat

    def temperature_phx(self, p, h, x):
        iter_cur = 1

        T_iter = (self.__T_min + self.__T_max)/2
        T_min = self.__T_min
        T_max = self.__T_max

        RES_min = self.specificEnthalpy_x(p=p, T=T_min, x=x) - h
        RES_max = self.specificEnthalpy_x(p=p, T=T_max, x=x) - h
        RES_h = self.specificEnthalpy_x(p=p, T=T_iter, x=x) - h

        if (RES_h*RES_min < 0):
            T_max = T_iter
            RES_max = RES_h
        elif (RES_h*RES_max < 0):
            T_min = T_iter
            RES_min = RES_h

        while ((abs(RES_h/h) > self.__tolerance) and
               (iter_cur < self.__iter_max)):
            iter_cur = iter_cur + 1
            cp = self.specificHeatCapacity_moistAir(T=T_iter,
                                                    X=self.massFraction(x=x))
            T_iter = T_iter - RES_h/cp

            if (T_iter < T_min) or (T_iter > T_max):
                print("T_iter out of bounds")
                T_iter = (T_min + T_max)/2

            RES_h = self.specificEnthalpy_x(p=p, T=T_iter, x=x) - h
            if (RES_h*RES_min < 0):
                T_max = T_iter
                RES_max = RES_h
            elif (RES_h*RES_max < 0):
                T_min = T_iter
                RES_min = RES_h
        T = T_iter
        return T

    def saturationTemperature(self, p_sat):
        iter_cur = 1

        T_iter = (self.__T_min + self.__T_max)/2
        T_min = self.__T_min
        T_max = self.__T_max

        RES_min = self.saturationPressure(T_sat=T_min) - p_sat
        RES_max = self.saturationPressure(T_sat=T_max) - p_sat
        RES_p = self.saturationPressure(T_sat=T_iter) - p_sat

        if (RES_p*RES_min < 0):
            T_max = T_iter
            RES_max = RES_p
        elif (RES_p*RES_max < 0):
            T_min = T_iter
            RES_min = RES_p

        while ((abs(RES_p/p_sat) > self.__tolerance) and
               (iter_cur < self.__iter_max)):
            iter_cur = iter_cur + 1

            T_iter = (T_min + T_max)/2

            RES_p = self.saturationPressure(T_sat=T_iter) - p_sat
            if (RES_p*RES_min < 0):
                T_max = T_iter
                RES_max = RES_p
            elif (RES_p*RES_max < 0):
                T_min = T_iter
                RES_min = RES_p
        T = T_iter
        return T


def spliceFunction(pos, neg, x, deltax):
    scaledX1 = x/deltax
    scaledX = scaledX1*math.asin(1)
    if scaledX1 <= -0.999999999:
        y = 0
    elif scaledX1 >= 0.999999999:
        y = 1
    else:
        y = (math.tanh(math.tan(scaledX)) + 1.0)/2.0
    out = pos*y + (1 - y)*neg
    return out

if __name__ == "__main__":
    # Validation
    air = moistAir()
    print(air.specificEnthalpy(p=101325, T=293.15, X=[0.1, 0.9]))
    print(air.specificEnthalpy_shear(p=101325, T=293.15, x=0.010))
    print(air.specificEnthalpy_dryAir(T=293.15))
    print(air.specificEnthalpy_steam(T=293.15))
