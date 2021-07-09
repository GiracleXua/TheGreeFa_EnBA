# -*- coding: utf-8 -*-
"""
@author: yafuerst
"""
import math
import numpy as np
from .gas import ideal_gas as gas
# import IdealGas as gas
import matplotlib.pyplot as plt
from matplotlib import rc, rcParams

rc("text", usetex=True)
rc("font", family="serif")
rcParams["text.latex.preamble"] = ["\\usepackage[decimalsymbol=comma,"
                                   "per=slash]{siunitx}"]
rcParams["legend.loc"] = "lower right"


class psychrometricChart(object):

    def __init__(self, x_min, x_max, h_min, h_max, T_min, T_max, p=101325.0,
                 x_resolution=1e-6, dh=10000.0, dT=10.0,
                 phi=[0.1, 0.2, 0.4, 0.6, 0.8, 1.0]):
        self._p = p
        self.__x_min = x_min
        self.__x_max = x_max
        self.__x_resolution = x_resolution
        self.__h_min = h_min
        self.__h_max = h_max
        self.__dh = dh
        self.__T_min = T_min
        self.__T_max = T_max
        self.__dT = dT
        self.__phi = phi
        self.__moistAir = gas.moistAir()
        self.__fig = None
        self.__ax = None

    def generateFigure(self, size_x, size_y):
        eps = self.__moistAir.getTolerance()
        R_air = self.__moistAir.gasConstantAir()
        R_steam = self.__moistAir.gasConstantWater()

        # Isotherms
        T_ticks = np.arange(self.__T_min,
                            self.__T_max,
                            self.__dT)
        # Isenthalps
        h_ticks = np.arange(self.__h_min,
                            self.__h_max * 2.5,
                            self.__dh)
        # Steps on x axis
        x_ticks = np.arange(self.__x_min,
                            self.__x_max + self.__x_resolution,
                            self.__x_resolution)

        # Shearing of the diagram
        m = self.__moistAir.shearing(p=self._p, T=273.15)

        h_T = np.zeros((len(T_ticks), len(x_ticks)))
        h_phi = np.zeros((len(self.__phi), len(x_ticks)))
        h_shear = np.zeros((len(h_ticks), len(x_ticks)))
        ps = np.zeros((len(self.__phi), len(x_ticks)))
        Ts = np.zeros((len(self.__phi), len(x_ticks)))

        # Calculate specific enthalpy as a function of isotherms T
        for i in range(0, len(T_ticks)):
            for j in range(0, len(x_ticks)):
                h_T[i][j] = self.__moistAir.specificEnthalpy_shear(
                    p=self._p,
                    T=T_ticks[i],
                    x=x_ticks[j])

        # Calculate specific enthalpy of isenthalps after shearing
        for i in range(0, len(h_ticks)):
            for j in range(0, len(x_ticks)):
                h_shear[i][j] = h_ticks[i] - m * x_ticks[j]

        # Calculate specific enthalpy as a function of phi
        for i in range(0, len(self.__phi)):
            for j in range(0, len(x_ticks)):
                ps[i][j] = max(
                    self._p / max(
                        self.__phi[i], eps) * x_ticks[j] / (x_ticks[j] +
                                                            R_air / R_steam), eps)
                Ts[i][j] = self.__moistAir.saturationTemperature(
                    p_sat=ps[i][j])
                h_phi[i][j] = self.__moistAir.specificEnthalpy_shear(
                    p=self._p,
                    T=Ts[i][j],
                    x=x_ticks[j])

        # Create figure
        h_T = h_T / 1000.0
        h_shear = h_shear / 1000.0
        h_phi = h_phi / 1000.0
        x_ticks = x_ticks * 1000.0

        self.__fig = plt.figure(figsize=(size_x, size_y))
        self.__ax = self.__fig.add_subplot(1, 1, 1)
        # self.__ax.set_title(r"Mollier-diagram at $p = \SI{" +
        #                     str(self._p / 1e5) +
        #                     r"}{\bar}$", y=1.05)
        self.__ax.set_xlabel(r"Humidity ratio $x/(\si{\gram\per\kilo\gram})$")
        self.__ax.set_ylabel(r"Specific enthalpy "
                             r"$h/(\si{\kilo\joule\per\kilo\gram})$")
        self.__ax.set_xlim(self.__x_min * 1000, self.__x_max * 1000)
        self.__ax.set_ylim(self.__h_min / 1000, self.__h_max / 1000)
        self.__ax.tick_params(axis=u"both", which=u"both", length=0)

        # Plotting isotherms
        for i in range(0, len(T_ticks)):
            self.__ax.plot(x_ticks, h_T[i], "--k", linewidth=0.5)

        # Plotting isenthalps
        for i in range(0, len(h_ticks)):
            self.__ax.plot(x_ticks, h_shear[i], ":k", linewidth=0.25)

        # Plotting phi=const
        for i in range(0, len(self.__phi)):
            self.__ax.plot(x_ticks, h_phi[i], "k", linewidth=0.5)

        # Plotting x=const
        x_ticks = self.__ax.get_xticks()
        for i in range(0, len(x_ticks)):
            self.__ax.plot((x_ticks[i], x_ticks[i]),
                           (self.__h_min, self.__h_max), "k", linewidth=0.25)

        # Labeling
        x_label = 1
        y_label = [self.__moistAir.specificEnthalpy_shear(p=self._p,
                                                          T=T_ticks[i],
                                                          x=x_label / 1000) / 1000
                   for i in range(1, len(T_ticks))]
        dx = self.__moistAir.xsaturation(
            p=self._p,
            T=self.__T_min + self.__dT)
        dy = [(self.__moistAir.specificEnthalpy_shear(
            p=self._p,
            T=T_ticks[i],
            x=dx) - self.__moistAir.specificEnthalpy_shear(
                p=self._p,
                T=T_ticks[i],
                x=0.0)) for i in range(1, len(T_ticks))]
        alpha = [math.degrees(math.atan(dy[i] / dx / 1e6))
                 for i in range(len(dy))]

        for i in range(len(y_label)):
            self.__ax.annotate(r"$\vartheta = \SI{" +
                               str(int(round(T_ticks[i + 1] - 273.15, 0))) +
                               "}{\degreeCelsius}$",
                               xy=(x_label, y_label[i] + dy[i] / 1000.0 + 1.0),
                               horizontalalignment="left",
                               rotation=alpha[i] / math.pi)

        plt.tight_layout()
        return None

    def point_xT(self, x, T):
        h = self.__moistAir.specificEnthalpy_shear(
            p=self._p,
            T=T,
            x=x)
        return (x, h)

    def point_xphi(self, x, phi):
        R_air = self.__moistAir.gasConstantAir()
        R_steam = self.__moistAir.gasConstantWater()
        p_steam = self._p * x / (phi * (x + R_air / R_steam))
        T = self.__moistAir.saturationTemperature(
            p_sat=p_steam)
        h = self.__moistAir.specificEnthalpy_shear(
            p=self._p,
            T=T,
            x=x)
        return (x, h)

    def point_Tphi(self, T, phi):
        R_air = self.__moistAir.gasConstantAir()
        R_steam = self.__moistAir.gasConstantWater()
        p_sat = self.__moistAir.saturationPressure(
            T_sat=T)
        x = R_air / R_steam * p_sat / (self._p / phi - p_sat)
        h = self.__moistAir.specificEnthalpy_shear(
            p=self._p,
            T=T,
            x=x)
        return (x, h)

    def plotPoint(self, x, h, shape="ok"):
        point = self.__ax.plot(x * 1000.0, h / 1000.0, shape)
        return point

    def plotPoint_xT(self, x, T, shape="ok"):
        (x, h) = self.point_xT(x=x, T=T)
        point = self.plotPoint(x=x, h=h, shape=shape)
        return point

    def plotPoint_xphi(self, x, phi, shape="ok"):
        (x, h) = self.point_xphi(x=x, phi=phi)
        point = self.plotPoint(x=x, h=h, shape=shape)
        return point

    def plotPoint_Tphi(self, T, phi, shape="ok"):
        (x, h) = self.point_Tphi(T=T, phi=phi)
        point = self.plotPoint(x=x, h=h, shape=shape)
        return point

    def plotLine(self, x1, h1, x2, h2, color="r"):
        line, = self.__ax.plot(
            (x1 * 1000.0, x2 * 1000.0),
            (h1 / 1000.0, h2 / 1000.0),
            color)
        return line

    def plotLine_xT(self, x1, T1, x2, T2, color="r"):
        (x1, h1) = self.point_xT(x=x1, T=T1)
        (x2, h2) = self.point_xT(x=x2, T=T2)
        line = self.plotLine(x1=x1, h1=h1, x2=x2, h2=h2,
                             color=color)
        return line

    def plotChange_xh(self, x1, h1, x2, h2, shape="ok", color="r"):
        plot = []
        plot.append(self.plotLine_xh(x1, h1, x2, h2, color=color))
        plot.append(self.plotPoint_xh(x1, h1, shape=shape))
        plot.append(self.plotPoint_xh(x2, h2, shape=shape))
        return plot

    def plotChange_xT(self, x1, T1, x2, T2, shape="ok", color="r"):
        plot = []
        plot.append(self.plotLine_xT(x1=x1, T1=T1, x2=x2,
                                     T2=T2, color=color))
        plot.append(self.plotPoint_xT(x=x1, T=T1, shape=shape))
        plot.append(self.plotPoint_xT(x=x2, T=T2, shape=shape))
        return plot

    def showLegend(self):
        self.__ax.legend()

    def saveFig(self, name, dataType="pdf", dpi=300):
        self.__fig.savefig("{}.{}".format(name, dataType),
                           format=dataType,
                           dpi=dpi)
        return None

    def removeObject(self, *obj):
        for item in obj:
            for entry in item:
                self.__ax.lines.remove(entry)
        return None

    def closeFig(self):
        plt.close()
        return None
