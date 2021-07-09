# -*- coding: utf-8 -*-

from buildingspy.io.outputfile import Reader
import os
from Psychrometrics import PsychrometricChart as psy

def readResults(n):
    res = Reader(("./Results/Koronaki/Case_{}/".format(str(n + 1)) +
                  "TestLiCl_Dehumdification_"
                  "KoronakiChristodoulakiPapaefthimiouRogdakis.mat"),
                 "dymola")
    return res

def getTemperatures(res):
    (time, T_air_in) = res.values("abs.air_a.T")
    (time, T_air_out) = res.values("abs.air_b.T")
    return (T_air_in[-1], T_air_out[-1])

def getMassFraction(res):
    (time, X_air_in) = res.values("abs.air_a.X[1]")
    (time, X_air_out) = res.values("abs.air_b.X[1]")
    return (X_air_in[-1], X_air_out[-1])

def main():
    # Change to the dir the file is in
    os.chdir(os.path.dirname(os.path.abspath("__file__")))

    chart = psy.psychrometricChart(
        x_min=0.0,
        x_max=0.025,
        h_min=-20000.0,
        h_max=40000.0,
        T_min=253.15,
        T_max=323.15)
    chart.generateFigure(size_x=6, size_y=6)

    # Air outlet from literature
    T_air_out_lit = [64.0, 63.6, 63.1, 64.0, 66.3,
                     66.3, 66.3, 66.0, 69.1, 67.9,
                     67.6, 67.1, 66.1, 65.5, 65.3,
                     65.2]
    T_air_out_lit = [(T_air_out_lit[i] + 459.67)*5/9
                     for i in range(len(T_air_out_lit))]
    x_air_out_lit = [0.0064, 0.0063, 0.0066, 0.0067, 0.0080,
                     0.0077, 0.0075, 0.0073, 0.0058, 0.0058,
                     0.0051, 0.0052, 0.0049, 0.0047, 0.0046,
                     0.0045]

    # Plot the Mollier-diagrams
    for i in range(len(x_air_out_lit)):
        res = readResults(n=i)
        (T_air_in, T_air_out) = getTemperatures(res=res)
        (X_air_in, X_air_out) = getMassFraction(res=res)
        x_air_in = X_air_in/(1.0 - X_air_in)
        x_air_out = X_air_out/(1.0 - X_air_out)

        change_sim = chart.plotChange_xT(
            x1=x_air_in,
            T1=T_air_in,
            x2=x_air_out,
            T2=T_air_out,
            shape="Dr",
            color="r--")
        change_lit = chart.plotChange_xT(
            x1=x_air_in,
            T1=T_air_in,
            x2=x_air_out_lit[i],
            T2=T_air_out_lit[i],
            shape="og",
            color="g")

        try:
            chart.saveFig("./Results/Koronaki/Mollier_{}".format(str(i + 1)))
        except FileNotFoundError:
            os.makedirs("./Results/Koronaki/")
            chart.saveFig("./Results/Koronaki/Mollier_{}".format(str(i + 1)))
        chart.removeObject(change_sim, change_lit)
    chart.closeFig()

if __name__ == "__main__":
    main()
