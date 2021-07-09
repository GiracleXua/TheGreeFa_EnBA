import sys
import os
import time
from pathlib import Path

import math
import pandas as pd
import numpy as np

from calibration_MgCl2_class import Calibration_H_M_transfer

import multiprocessing as mp

def run_calib_LiCl(prefix_output):
    bib_path = os.path.join(os.path.expanduser("~"),"GIT","EnBA_M","BrineGrid_HDisNet")
    model_path = 'BrineGrid.Fluid.Absorbers.Examples.Validation.'
    
    # run chen2016
    model_name = 'Calibration_Chen_2016'
    print("*****start {}******".format(model_name))

    df = pd.read_excel("../exp_data/Chen2016.xlsx").drop(columns = ["Unnamed: 0"])
    print(df)

    # generate object for calibration class

    Nu_1 = 5.023
    Sh_1 = 4.846
    max_iter = 1
    
    LiCl_obj = Calibration_H_M_transfer(t_stop=3600, exchange_area=450*1.5*0.75*0.75, d_e=0.01, cross_area=1.5*0.75, max_iter = max_iter, Nu_1 = Nu_1, Sh_1 = Sh_1,  bib_path=bib_path, model_path = model_path, nNodes=8, mNodes=8, model_name=model_name, prefix_outputfolder=prefix_output)

    output_path = LiCl_obj.get_output_folder()

    # # run multiple calibration
    # LiCl_obj.mp_run(df=df)
    # # run single calibration
    LiCl_obj.run_calibration(input_dataset=df.iloc[9,:])

    df_output = LiCl_obj.read_results(path=output_path)
    df_output.to_csv(path_or_buf=os.path.join(output_path, 'final_output.csv'))

    print('{} finished'.format(model_name))
    return

def run_calib_MgCl2(prefix_output, config="teststand"):

    # # run MgCl2
    if config == "teststand":
        model_name2 = 'Calibration_MgCl2_teststand' #'Calibration_MgCl2_teststand'
        print("*****start {}******".format(model_name2))

        bib_path = os.path.join(os.path.expanduser("~"),"GIT","EnBA_M","BrineGrid_HDisNet")
        model_path = 'BrineGrid.Fluid.Absorbers.Examples.Validation.'

        df2 = pd.read_excel("../exp_data/teststand_output_cool.xlsx",index_col = 0).head(30)
        print(df2)

        # # generate object for calibration class
        MgCl2_obj = Calibration_H_M_transfer(t_stop=3600, exchange_area=1.27, d_e=0.22, cross_area = 0.425*0.09, bib_path=bib_path, model_path = model_path, nNodes=8, mNodes=8, model_name=model_name2, prefix_outputfolder=prefix_output)

    if config == "dempav":
        model_name2 = 'Calibration_MgCl2_dempav' #'Calibration_MgCl2_teststand'
        print("*****start {}******".format(model_name2))

        bib_path = os.path.join(os.path.expanduser("~"),"GIT","EnBA_M","BrineGrid_HDisNet")
        model_path = 'BrineGrid.Fluid.Absorbers.Examples.Validation.'

        df2 = pd.read_excel("../exp_data/dempav_results_Aug_final_2020.xlsx",index_col = 0).head(30)
        print(df2)

        # # generate object for calibration class
        MgCl2_obj = Calibration_H_M_transfer(t_stop=3600, exchange_area=3.248, d_e=0.0254, cross_area = 0.06514, bib_path=bib_path, model_path = model_path, nNodes=8, mNodes=8, model_name=model_name2, prefix_outputfolder=prefix_output)

    output_path = MgCl2_obj.get_output_folder()
    
    print(output_path)
    # try:
    MgCl2_obj.run_calibration(input_dataset=df2.iloc[0,:])
        # MgCl2_obj.mp_run(df=df2)
    # except:
    #     print('Calibration for {} didn\'t completely finished.'.format(model_name2))

    df_output = MgCl2_obj.read_results(path=output_path)
    df_output.to_csv(path_or_buf=os.path.join(output_path, 'final_output.csv'))

    print('{} finished'.format(model_name2))
    return

def generate_full_results(output_folder_name, ):

    model_name2 = 'Calibration_MgCl2_dempav' #'Calibration_MgCl2_teststand'
    print("*****start {}******".format(model_name2))

    bib_path = os.path.join(os.path.expanduser("~"),"GIT","EnBA_M","BrineGrid_HDisNet")
    model_path = 'BrineGrid.Fluid.Absorbers.Examples.Validation.'

    # # generate object for calibration class
    MgCl2_obj = Calibration_H_M_transfer(t_stop=3600, exchange_area=3.248, d_e=0.0254, cross_area = 0.06514, void_fraction = 0.712, bib_path=bib_path, model_path = model_path, nNodes=8, mNodes=8, model_name=model_name2)

    output_path = os.path.join(MgCl2_obj.bib_path, "modelica_results",output_folder_name)

    df_output = MgCl2_obj.read_results(path=output_path)
    df_output = MgCl2_obj.calc_Nu_Sh_physic(df_output)
    df_output.to_csv(path_or_buf=os.path.join(output_path, 'full_final_output.csv'))

    return

def parameter_study_Nu(Nu):

    prefix_output = "Aug_26_2020_"

    model_name = 'Calibration_MgCl2'
    print("*****start {}******".format(model_name))

    bib_path = os.path.join(os.path.expanduser("~"),"GIT","EnBA_M","BrineGrid_HDisNet")
    model_path = 'BrineGrid.Fluid.Absorbers.Examples.Validation.'

    df2 = pd.read_excel("../exp_data/dempav_results_Aug_final_2020.xlsx").drop(columns = ["Unnamed: 0"])
    print(df2)

    # # generate object for calibration class
    MgCl2_obj = Calibration_H_M_transfer(t_stop=3600, exchange_area=6.5, d_e=0.288, cross_area = math.pi*0.288**2/4, bib_path=bib_path, model_path = model_path, nNodes=8, mNodes=8, model_name=model_name, prefix_outputfolder=prefix_output)

    ###### define inputdata ######
    sim_index = "Nu_" + str(Nu)
    input_data = df2.iloc[0,:]

    base_path = os.path.join(MgCl2_obj.get_output_folder(), sim_index)
    print(base_path)

    # run simulation
    MgCl2_obj.run_simulation(input_data = input_data, Nu0=Nu, \
        Sh0 = 639, model_name = model_path+model_name, \
            bib_path = bib_path, output_path = base_path)

    # read results:
    results = MgCl2_obj.readResults(path = base_path, mat_name = model_name)
    T_a_out = results.values("abs.air_out.T")[1][-1]
    x_a_out = results.values("abs.air_out.X[1]")[1][-1]
    ##### add temperatur and concentration for desiccant ###

    ###################
    pd.DataFrame([[sim_index, T_a_out, x_a_out]], columns=["idx", "T_a_o", "x_a_o"]).to_csv(base_path+"/output.csv")

    return

def mp_run_ps(path_0, target_file): # parameter study

    # multiprocessing
    po = mp.Pool(processes=4)
    po.map(parameter_study_Nu, np.linspace(10, 100, 4, dtype=int, endpoint=True))
    po.close()
    po.join()

    df_results = pd.DataFrame()
    for path in Path(path_0).rglob(target_file):
        df_results = pd.concat([df_results, pd.read_csv(path, index_col=0)], axis = 0)

    df_results.to_excel(os.path.join(path_0, "results_sum.xlsx"))

    return

if __name__ == "__main__":
    start_code = time.time()

    # parameter study
    # # run mp
    # mp_run_ps(path_0=os.path.join(os.path.expanduser("~"),"GIT","EnBA_M","BrineGrid_HDisNet","modelica_results", "Aug_26_2020_Calibration_MgCl2"),target_file="output.csv")

    # # single run
    # parameter_study_Nu(100)

    # generate table for regression comparison
    generate_full_results("Jan2021_dempav_1Calibration_MgCl2")

    # run_calib_MgCl2("Nov_5_2020_teststand_")

    end_code = time.time()
    print('finished! Duration: {}'.format(pd.Timedelta(pd.offsets.Second(int(end_code - start_code)))))

