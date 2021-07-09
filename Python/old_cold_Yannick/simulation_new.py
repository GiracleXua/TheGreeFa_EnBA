import buildingspy.simulate.Simulator as si
from multiprocessing import Pool
import numpy as np
# import pandas as pd
import os

# set up simulation-model
def simulateCase(s):
    s.setStopTime(500)
    s.setTimeOut(3600)
    s.setSolver("dassl")
    s.showProgressBar(False)
    s.printModelAndTime()
    s.exitSimulator(False)
    s.simulate()

# not unterstood yet
def simulateTranslatedModel(s):
    s.setStopTime(7200)
    s.setTimeOut(3600)
    s.setSolver("dassl")
    s.showProgressBar(False)
    s.printModelAndTime()
    s.simulate_translated()


def main():
    # 1. orientate the modelica model
    bib_path = os.path.join(os.path.expanduser("~"), "git", "EnBA_M", "BrineGrid_HDisNet")
    output_dir = os.path.join(bib_path, "Extras", "Python", "Results")
    model_name = ("BrineGrid.Fluid.Absorbers.Examples."
                  "Validation.LiCl_Chen_2016_Dehumdification")
    
    # 2. list for simulator interation: for multiprocessing
    List_inter = []

    # 3.
    T_air = np.array([25.5, 26.5])
    T_abs = np.array([14.9, 18.2])
    m_flow_air = np.array([1.85, 1.95])
    m_flow_abs = np.array([2.61, 3.61])
    x = np.array([16.2, 20.2]) # absolute humidity of air --> not sure
    X_w = x/1000.0 / (x/1000.0 + 1.0)
    X_s = np.array([0.23, 0.24])

    # 4. generate pool of simulation model
    for i in range(len(T_air)):
        # specify output_path
        output_path = os.path.join(output_dir, "Case_{}".format(str(i+1)))
        if not os.path.exists(output_path):
            os.mkdir(output_path)
        
        # declare simulator
        s = si.Simulator(modelName = model_name,
                        simulator="dymola",
                        outputDirectory=output_path,
                        packagePath = os.path.join(bib_path, "BrineGrid"))

        # set parameter
        s.addParameters({"nNodes": 3})
        s.addParameters({"mNodes": 3})
        s.addParameters({"T_air": T_air[i]+273.15})
        s.addParameters({"T_abs": T_abs[i]+273.15})
        s.addParameters({"m_flow_air": m_flow_air[i]})
        s.addParameters({"m_flow_abs": m_flow_abs[i]})
        s.addParameters({"X_w": X_w[i]})
        s.addParameters({"X_s": X_s[i]})

        List_inter.append(s)
    
    # multiprocessing
    po = Pool(processes=4)
    po.map(simulateCase, List_inter)    
    
    return

if __name__ == "__main__":
    main()