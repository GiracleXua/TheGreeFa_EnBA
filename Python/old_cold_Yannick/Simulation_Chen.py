import buildingspy.simulate.Simulator as si
from multiprocessing import Pool
import multiprocessing as mp
import numpy as np
import os


def simulateCase(s):
    s.setStopTime(3600)
    s.setTimeOut(3600)
    s.setSolver("dassl")
    s.showProgressBar(False)
    s.printModelAndTime()
    s.simulate()


def simulateTranslatedModel(s):
    s.setStopTime(3600)
    s.setTimeOut(3600)
    s.setSolver("dassl")
    s.showProgressBar(False)
    s.printModelAndTime()
    s.simulate_translated()


def main():
    bib_path = os.path.join(os.path.expanduser("~"),
                            "GIT", "BrineGrid_HDisNet")
    os.chdir(bib_path)
    model_path = ("BrineGrid.Fluid.Absorbers.Examples."
                  "Validation.LiCl_Chen_2016_Dehumdification")

    li = []

    T_air = np.array([25.6, 28.6, 27.5, 30.0, 27.6,
                      21.7, 22.7, 24.7, 23.3, 24.0,
                      24.2, 25.1, 25.2, 25.9, 25.6]) + 273.15
    T_abs = np.array([14.9, 18.2, 17.7, 18.9, 17.3,
                      9.5, 12.6, 15.5, 14.7, 16.8,
                      17.7, 18.1, 17.8, 19.2, 18.4]) + 273.15
    m_flow_air = np.array([1.85, 1.87, 1.92, 1.89, 1.92,
                           2.04, 1.97, 1.96, 1.99, 1.94,
                           1.98, 1.94, 1.95, 1.99, 1.93])
    m_flow_abs = np.array([2.61, 2.63, 2.65, 2.66, 2.67,
                           2.93, 2.76, 2.77, 2.80, 2.82,
                           2.85, 2.90, 2.85, 2.86, 2.88])
    x_a = np.array([16.2, 20.2, 18.1, 17.7, 16.4,
                  10.8, 15.3, 15.3, 14.3, 15.2,
                  16.0, 15.2, 14.3, 15.9, 14.3])/1000
    # X_w = x/1000.0/(x/1000.0 + 1.0)
    X_s = np.array([0.2300, 0.2400, 0.2550, 0.2600, 0.2700,
                    0.2513, 0.2600, 0.2700, 0.2850, 0.2961,
                    0.3007, 0.3052, 0.3182, 0.3215, 0.3312])

    for i in range(len(T_air)):
        if not os.path.exists(os.path.join(bib_path,
                                           "Extras",
                                           "Python",
                                           "Results",
                                           "Case_{}".format(str(i + 1)))):
            os.makedirs(os.path.join(bib_path,
                                     "Extras",
                                     "Python",
                                     "Results",
                                     "Case_{}".format(str(i + 1))))
        s = si.Simulator(model_path,
                         "dymola",
                         os.path.join(bib_path,
                                      "Extras",
                                      "Python",
                                      "Results",
                                      "Case_{}".format(str(i + 1))))
        s.addParameters({"nNodes": 3})
        s.addParameters({"mNodes": 3})
        s.addParameters({"T_air": T_air[i]})
        s.addParameters({"T_abs": T_abs[i]})
        s.addParameters({"m_flow_air": m_flow_air[i]})
        s.addParameters({"m_flow_abs": m_flow_abs[i]})
        s.addParameters({"x_a": x_a[i]})
        s.addParameters({"X_s": X_s[i]})
        li.append(s)
    po = Pool(processes=mp.cpu_count()-2)
    po.map(simulateCase, li)

if __name__ == "__main__":
    main()
