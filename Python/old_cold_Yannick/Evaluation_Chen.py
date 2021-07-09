import os, sys, inspect

cmd_subfolder = os.path.realpath(os.path.abspath(os.path.join(os.path.split(
    inspect.getfile(inspect.currentframe()))[0], "Psychrometrics")))
if cmd_subfolder not in sys.path:
    sys.path.insert(0, cmd_subfolder)


from buildingspy.io.outputfile import Reader
import Evaluation.psychrometrics.gas.ideal_gas as gas
import Evaluation.psychrometrics.psychrometric_chart as ps
import numpy as np


def readResults(n, mat="LiCl_Chen_2016_Dehumdification"):
    res = Reader(("./Results/Case_{}/".format(str(n + 1)) +
                  "{}.mat".format(mat)),
                 "dymola")
    return res


def getTemperatures(res):
    (time, T_air_in) = res.values("abs.air_in.T")
    (time, T_air_out) = res.values("abs.air_out.T")
    (time, T_abs_in) = res.values("abs.abs_in.T")
    (time, T_abs_out) = res.values("abs.abs_out.T")
    return (T_air_in[-1], T_air_out[-1], T_abs_in[-1], T_abs_out[-1])


def getMassFraction(res):
    (time, X_air_in) = res.values("abs.air_in.X[1]")
    (time, X_air_out) = res.values("abs.air_out.X[1]")
    (time, X_abs_in) = res.values("abs.abs_in.X[2]")
    (time, X_abs_out) = res.values("abs.abs_out.X[2]")
    return (X_air_in[-1], X_air_out[-1], X_abs_in[-1], X_abs_out[-1])


def main():
    ma = gas.moistAir()

    # Get the dir of this file and change to it
    py_path = os.path.dirname(os.path.realpath(__file__))
    os.chdir(py_path)

    chart = ps.psychrometricChart(T_min=253.15, T_max=323.15, x_min = 0, x_max = 30, h_min = -30, h_max = 40)
    chart.generateFigure(size_x=4.5, size_y=4.5,) #  latex = Ture, language="english", pos_label_isotherm="left"

    # Air outlet from literature
    T_air_out_lit = np.array([19.2, 22.9, 21.9, 23.5, 21.6,
                              14.1, 16.5, 19.2, 18.1, 20.1,
                              20.9, 21.3, 21.1, 22.6, 21.6]) + 273.15
    x_air_out_lit = np.array([0.0091, 0.0116, 0.0099, 0.0097, 0.0087,
                              0.0057, 0.0077, 0.0080, 0.0072, 0.0075,
                              0.0077, 0.0075, 0.0069, 0.0077, 0.0066])
    X_air_out_lit = x_air_out_lit / (x_air_out_lit + 1.0)
    T_abs_out_lit = np.array([21.3, 25.2, 24.3, 25.8, 23.7,
                              14.6, 18.6, 21.6, 20.3, 23.1,
                              23.9, 24.1, 23.9, 25.8, 24.5]) + 273.15

    h_air_out_lit = np.empty_like(T_air_out_lit)
    h_air_out_sim = np.empty_like(T_air_out_lit)
    T_air_out_sim = np.empty_like(T_air_out_lit)
    x_air_out_sim = np.empty_like(T_air_out_lit)
    T_abs_out_sim = np.empty_like(T_air_out_lit)

    # Plot the Mollier-diagrams
    for i in range(len(x_air_out_lit)):
        h_air_out_lit[i] = np.asscalar(ma.specificEnthalpy(
            p=101325, T=T_air_out_lit[i], X=[[X_air_out_lit[i], 1 - X_air_out_lit[i]]]))

        res = readResults(n=i)
        (T_air_in, T_air_out, T_abs_in, T_abs_out) = getTemperatures(res=res)
        (X_air_in, X_air_out, X_abs_in, X_abs_out) = getMassFraction(res=res)
        x_air_in = X_air_in / (1.0 - X_air_in)
        x_air_out = X_air_out / (1.0 - X_air_out)
        h_air_out = np.asscalar(ma.specificEnthalpy(
            p=101325, T=T_air_out, X=[[X_air_out, 1 - X_air_out]]))
        h_air_out_sim[i] = h_air_out
        T_air_out_sim[i] = T_air_out
        x_air_out_sim[i] = x_air_out
        T_abs_out_sim[i] = T_abs_out

        print("Simulation {}: h_air_out={}".format(str(i + 1), str(h_air_out)))
        print("Simulation {}: T_air_out={}".format(str(i + 1), str(T_air_out - 273.15)))
        print("Simulation {}: x_air_out={}".format(str(i + 1), str(x_air_out * 1000)))
        print("Simulation {}: T_abs_out={}".format(str(i + 1), str(T_abs_out - 273.15)))
        print("Simulation {}: X_abs_out={}\n".format(str(i + 1), str(X_abs_out * 100)))

        change_lit = chart.plotChange_xT(
            s1=(x_air_in, T_air_in),
            s2=(x_air_out_lit[i], T_air_out_lit[i]),
            pcolor="b",
            marker="o",
            lcolor="b",
            label="Chen et al. 2016")
        change_sim = chart.plotChange_xT(
            s1=(x_air_in, T_air_in),
            s2=(x_air_out, T_air_out),
            pcolor="r",
            marker="D",
            lcolor="r",
            linestyle="dashed",
            label="This work")
        chart.showLegend()

        try:
            chart.saveChart(name="Mollier_{}".format(str(i + 1)), dir="Results")
        except FileNotFoundError:
            os.makedirs("Results")
            chart.saveChart("Mollier_{}".format(str(i + 1)), dir="Results")
        chart.removeObject(change_sim, change_lit)
    chart.closeChart()

if __name__ == "__main__":
    main()
