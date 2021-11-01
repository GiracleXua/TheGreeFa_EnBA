import sys
import os
import time
from pathlib import Path

import math
import pandas as pd
import numpy as np

from calibration_MgCl2_class import Calibration_H_M_transfer

import multiprocessing as mp

######## Chen LiCl################
def run_calib_LiCl(prefix_output, file_name):
    bib_path = os.path.join(os.path.expanduser("~"),"GIT", 'TheGreeFa_EnBA')
    model_path = 'BrineGrid.Fluid.Absorbers.Examples.Validation.'
    
    # run chen2016
    model_name = 'Calibration_Chen_2016'
    print("*****start {}******".format(model_name))

    df = pd.read_excel(os.path.join(bib_path, "Data_input", "measurement", "actual_data_converted/{}".format(file_name)), index_col=0)
    print(df)

    # generate object for calibration class
    
    LiCl_obj = Calibration_H_M_transfer(t_stop=3600, exchange_area=450*1.5*0.75*0.75, d_e=0.01, type_desiccant='LiCl',\
        cross_area=1.5*0.75, void_fraction = 0.9,bib_path=bib_path, model_path = model_path, nNodes=8, mNodes=8, \
            model_name=model_name, prefix_outputfolder=prefix_output, flow_config = 'cross')

    output_path = LiCl_obj.get_output_folder()

    # # run multiple calibration
    LiCl_obj.mp_run(df=df, num_core=mp.cpu_count()-2)
    # # run single calibration
    # LiCl_obj.run_calibration(input_dataset=df.iloc[9,:])

    df_output = LiCl_obj.read_results(path=output_path)
    df_output.to_csv(path_or_buf=os.path.join(output_path, 'final_output.csv'))

    print('{} finished'.format(model_name))
    return

def run_Chen2016_sim(prefix_output, file_name):
    model_name2 = 'Calibration_Chen_2016'
    print("*****start {}******".format(model_name2))

    bib_path = os.path.join(os.path.expanduser("~"),"GIT",'TheGreeFa_EnBA')
    model_path = 'BrineGrid.Fluid.Absorbers.Examples.Validation.'

    df2 = pd.read_csv(os.path.join(bib_path, "Data_input", "measurement", "actual_data_converted/{}".format(file_name)),index_col = 0)#.iloc[0:2, :]
    print('shape of the input table {}. \n'.format(df2.shape))

    # # generate object for calibration class
    Chen_obj = Calibration_H_M_transfer(t_stop=1800, exchange_area=450*1.5*0.75*0.75, type_desiccant='LiCl',\
        d_e=0.01, cross_area = 1.5*0.75, void_fraction = 0.9, bib_path=bib_path, model_path = model_path, flow_config = 'cross', \
        header_of_Nu_Sh= '_2', nNodes=8, mNodes=8, model_name=model_name2, prefix_outputfolder=prefix_output)

    output_path = Chen_obj.get_output_folder()
    
    print("output path is: {}.".format(output_path))
    
    # Chen_obj.run_single_simulation(input_dataset=df2.iloc[0,:])
    Chen_obj.mp_run(df=df2, mode="simulation", num_core=mp.cpu_count()-4)

    df_output = Chen_obj.read_results(path=output_path, mode="simulation")
    df_output.to_csv(path_or_buf=os.path.join(output_path, 'final_output.csv'))

    print('{} finished'.format(model_name2))
    return

def run_Chen_fomular_NuSh(prefix_output, file_name):
    # run simulation using implemented formular for Nu&Sh in Modelica #
    model_name = 'Validation_new_formular_Chen_2016'
    print("*****start {}******".format(model_name))

    bib_path = os.path.join(os.path.expanduser("~"),"GIT",'TheGreeFa_EnBA')
    model_path = 'BrineGrid.Fluid.Absorbers.Examples.Validation.'

    df2 = pd.read_excel(os.path.join(bib_path, "Data_input", "measurement", "actual_data_converted/{}".format(file_name)),index_col = 0)
    print(df2)

    # # generate object for calibration class
    LiCl2_obj = Calibration_H_M_transfer(t_stop=1800, exchange_area=450*1.5*0.75*0.75, type_desiccant='LiCl',\
        d_e=0.01, cross_area = 1.5*0.75, void_fraction = 0.9, bib_path=bib_path, model_path = model_path, flow_config = 'cross', \
        nNodes=10, mNodes=10, model_name=model_name, prefix_outputfolder=prefix_output, if_Nu_Sh_const=False)

    output_path = LiCl2_obj.get_output_folder()
    
    print("output path is: {}.".format(output_path))
    
    # LiCl2_obj.run_single_simulation(input_dataset=df2.iloc[0,:])
    LiCl2_obj.mp_run(df=df2, mode="simulation", num_core=mp.cpu_count()-2)

    df_output = LiCl2_obj.read_results(path=output_path, mode="simulation")
    df_output.to_csv(path_or_buf=os.path.join(output_path, 'final_output.csv'))

    print('{} finished'.format(model_name))
    return

################## MgCl2 ##########################################################

###dempav###
def run_calib_MgCl2_dempav(prefix_output, file_name):
    # # run MgCl2
    model_name = 'Calibration_MgCl2_dempav'
    print("*****start {}******".format(model_name))

    bib_path = os.path.join(os.path.expanduser("~"),"GIT",'TheGreeFa_EnBA')
    model_path = 'BrineGrid.Fluid.Absorbers.Examples.Validation.'

    df = pd.read_excel(os.path.join(bib_path, "Data_input", "measurement", "actual_data_converted/{}".format(file_name)),index_col = 0) .query('T_a_in - T_a_o_exp > 2')
    print(df)
    
    # # generate object for calibration class
    MgCl2_obj = Calibration_H_M_transfer(t_stop=3600, exchange_area=6.5, d_e=0.04, cross_area = 0.065, \
        void_fraction = 0.95, delta_T = 0.5, bib_path=bib_path, model_path = model_path, \
            nNodes=8, mNodes=8, model_name=model_name, prefix_outputfolder=prefix_output)
    
    output_path = MgCl2_obj.get_output_folder()
    print("output path is: {}.".format(output_path))
    
    try:
        MgCl2_obj.run_calibration(input_dataset=df.iloc[8,:]) # single simulation
        # MgCl2_obj.mp_run(df=df, num_core=8) #mp.cpu_count()- 4
    except:
        print('Calibration for {} + {} didn\'t completely finished.'.format(model_name, file_name))

    df_output = MgCl2_obj.read_results(path=output_path)
    df_output.to_csv(path_or_buf=os.path.join(output_path, 'final_output.csv'))

    print('{} (dempav) finished'.format(model_name))
    return

def run_MgCl2_dempav_sim_Nu_Sh(prefix_output, file_name):
    # # run MgCl2
    model_name2 = 'Validation_MgCl2_dempav'
    print("*****start {}******".format(model_name2))

    bib_path = os.path.join(os.path.expanduser("~"),"GIT", 'TheGreeFa_EnBA')
    model_path = 'BrineGrid.Fluid.Absorbers.Examples.Validation.'

    df2 = pd.read_excel(os.path.join(bib_path, "Data_input", "measurement", "actual_data_converted/{}".format(file_name)).format(file_name),index_col = 0)
    print(df2)

    # # generate object for calibration class
    MgCl2_obj = Calibration_H_M_transfer(t_stop=3600, exchange_area=3.248, d_e=0.0254, cross_area = 0.065, void_fraction = 0.712, bib_path=bib_path, model_path = model_path, nNodes=8, mNodes=8, model_name=model_name2, prefix_outputfolder=prefix_output, if_Nu_Sh_const=False)

    output_path = MgCl2_obj.get_output_folder()
    
    print("output path is: {}.".format(output_path))
    
    # MgCl2_obj.run_single_simulation(input_dataset=df2.iloc[0,:])
    MgCl2_obj.mp_run(df=df2, mode="simulation", num_core=mp.cpu_count()-2)

    df_output = MgCl2_obj.read_results(path=output_path, mode="simulation")
    df_output.to_csv(path_or_buf=os.path.join(output_path, 'final_output.csv'))

    print('{} finished'.format(model_name2))
    return

def run_MgCl2_sim_alpha_beta(prefix_output, file_name):
    """
    both for dempav and teststand
    """
    # # run MgCl2
    model_name2 = 'Validation_MgCl2_teststand_chtc' # 'Validation_MgCl2_dempav_chtc'
    print("*****start {}******".format(model_name2))

    bib_path = os.path.join(os.path.expanduser("~"),"GIT",'TheGreeFa_EnBA')
    model_path = 'BrineGrid.Fluid.Absorbers.Examples.Validation.'

    df2 = pd.read_excel(os.path.join(bib_path, "Data_input", "measurement", "actual_data_converted/{}".format(file_name)),index_col = 0)
    print(df2)

    # # generate object for calibration class
    # MgCl2_obj = Calibration_H_M_transfer(t_stop=1800, exchange_area=6.495, d_e=0.0399, cross_area = 0.065, void_fraction = 0.95, bib_path=bib_path, model_path = model_path, nNodes=8, mNodes=8, model_name=model_name2, prefix_outputfolder=prefix_output, header_of_input='0', if_Nu_Sh_const=False, if_use_alpha_beta = True)

    MgCl2_obj = Calibration_H_M_transfer(t_stop=1800, exchange_area=1.274, d_e=0.0399, cross_area = 0.038, void_fraction = 0.95, bib_path=bib_path, model_path = model_path, nNodes=8, mNodes=8, model_name=model_name2, prefix_outputfolder=prefix_output, header_of_input='', if_Nu_Sh_const=False, if_use_alpha_beta = True)

    output_path = MgCl2_obj.get_output_folder()
    
    print("output path is: {}.".format(output_path))
    
    # MgCl2_obj.run_single_simulation(input_dataset=df2.iloc[0,:])
    MgCl2_obj.mp_run(df=df2, mode="simulation", num_core=6)

    df_output = MgCl2_obj.read_results(path=output_path, mode="simulation")
    df_output.to_csv(path_or_buf=os.path.join(output_path, 'final_output.csv'))

    print('{} finished'.format(model_name2))
    return

def run_MgCl2_dempav_sim_with_ChenFormular(prefix_output, file_name):
    # # run MgCl2
    model_name2 = 'Validation_MgCl2_dempav'
    print("*****start {}******".format(model_name2))

    bib_path = os.path.join(os.path.expanduser("~"),"GIT",'TheGreeFa_EnBA')
    model_path = 'BrineGrid.Fluid.Absorbers.Examples.Validation.'

    df2 = pd.read_excel(os.path.join(bib_path, "Data_input", "measurement", "actual_data_converted/{}".format(file_name)),index_col = 0) .query('T_a_in - T_a_o_exp > 2')
    print(df2)

    # # generate object for calibration class
    MgCl2_obj = Calibration_H_M_transfer(t_stop=3600, exchange_area=3.248, d_e=0.0254, cross_area = 0.065, void_fraction = 0.712, \
        bib_path=bib_path, model_path = model_path, nNodes=8, mNodes=8, model_name=model_name2, \
            prefix_outputfolder=prefix_output, if_Nu_Sh_const=False)

    output_path = MgCl2_obj.get_output_folder()
    
    print("output path is: {}.".format(output_path))
    
    # MgCl2_obj.run_single_simulation(input_dataset=df2.iloc[0,:])
    MgCl2_obj.mp_run(df=df2, mode="simulation", num_core=mp.cpu_count()-2)

    df_output = MgCl2_obj.read_results(path=output_path, mode="simulation")
    df_output.to_csv(path_or_buf=os.path.join(output_path, 'final_output.csv'))

    print('{} finished'.format(model_name2))
    return

### test stand ###
def run_calib_MgCl2_teststand(prefix_output, file_name):
    # # run MgCl2
    model_name2 = 'Calibration_MgCl2_teststand'
    print("*****start {}******".format(model_name2))

    bib_path = os.path.join(os.path.expanduser("~"),"GIT",'TheGreeFa_EnBA')
    model_path = 'BrineGrid.Fluid.Absorbers.Examples.Validation.'

    df2 = pd.read_excel("../exp_data/{}".format(file_name),index_col = 0)
    print(df2)

    # # generate object for calibration class
    MgCl2_obj = Calibration_H_M_transfer(t_stop=3600, exchange_area=1.27, d_e=0.0254, cross_area = 0.425*0.09, void_fraction = 0.92, bib_path=bib_path, model_path = model_path, nNodes=8, mNodes=8, model_name=model_name2, prefix_outputfolder=prefix_output)
    output_path = MgCl2_obj.get_output_folder()
    
    print("output path is: {}.".format(output_path))
    try:
    #     #MgCl2_obj.run_calibration(input_dataset=df2.iloc[0,:])
        MgCl2_obj.mp_run(df=df2, num_core=mp.cpu_count()-2)
    except:
         print('Calibration for {} + {} didn\'t completely finished.'.format(model_name2, file_name))

    df_output = MgCl2_obj.read_results(path=output_path)
    df_output.to_csv(path_or_buf=os.path.join(output_path, 'final_output.csv'))

    print('{} finished'.format(model_name2))
    return

def run_MgCl2_teststand_sim(prefix_output, file_name):
    # # run MgCl2
    model_name2 = 'Validation_MgCl2_teststand'
    print("*****start {}******".format(model_name2))

    bib_path = os.path.join(os.path.expanduser("~"),"GIT",'TheGreeFa_EnBA')
    model_path = 'BrineGrid.Fluid.Absorbers.Examples.Validation.'

    df2 = pd.read_excel("../exp_data/{}".format(file_name),index_col = 0)
    print(df2)

    # # generate object for calibration class
    MgCl2_obj = Calibration_H_M_transfer(t_stop=3600, exchange_area=1.27, d_e=0.0254, cross_area = 0.425*0.09, void_fraction = 0.92, bib_path=bib_path, model_path = model_path, nNodes=8, mNodes=8, model_name=model_name2, prefix_outputfolder=prefix_output, if_Nu_Sh_const=False)
    output_path = MgCl2_obj.get_output_folder()
    
    print("output path is: {}.".format(output_path))
    
    # MgCl2_obj.run_single_simulation(input_dataset=df2.iloc[0,:])
    MgCl2_obj.mp_run(df=df2, mode="simulation", num_core=mp.cpu_count()-2)

    df_output = MgCl2_obj.read_results(path=output_path, mode="simulation")
    df_output.to_csv(path_or_buf=os.path.join(output_path, 'final_output.csv'))

    print('{} finished'.format(model_name2))
    return

### ZHAW ###
def run_calib_MgCl2_ZHAW(prefix_output, file_name):
    # # run MgCl2
    model_name = 'Validation_ZHAW'
    print("*****start {}******".format(model_name))

    bib_path = os.path.join(os.path.expanduser("~"),"GIT",'TheGreeFa_EnBA')
    model_path = 'BrineGrid.Fluid.Absorbers.Examples.Validation.'

    df = pd.read_excel("../exp_data/actual_data/{}".format(file_name),index_col = 0)
    print(df)

    # # generate object for calibration class
    MgCl2_obj = Calibration_H_M_transfer(t_stop=1800, exchange_area=103.1, d_e=0.015, cross_area = 0.196, void_fraction = 0.91, \
        bib_path=bib_path, model_path = model_path, nNodes=8, mNodes=8, model_name=model_name, prefix_outputfolder=prefix_output)
    output_path = MgCl2_obj.get_output_folder()
    
    print("output path is: {}.".format(output_path))
    # try:
        # # MgCl2_obj.run_calibration(input_dataset=df.loc[20,:]) # single simulation
        # MgCl2_obj.mp_run(df=df, num_core=mp.cpu_count()-2, mode='calibration')
    # except:
    #      print('Calibration for {} + {} didn\'t completely finished.'.format(model_name, file_name))

    df_output = MgCl2_obj.read_results(path=output_path)
    df_output.to_csv(path_or_buf=os.path.join(output_path, 'final_output.csv'))

    print('{} finished'.format(model_name))
    return

################### Parameter Study #########################################################

def parameter_study_Nu(Nu):

    prefix_output = "Aug_26_2020_"

    model_name = 'Calibration_MgCl2'
    print("*****start {}******".format(model_name))

    bib_path = os.path.join(os.path.expanduser("~"),"GIT",'TheGreeFa_EnBA')
    model_path = 'BrineGrid.Fluid.Absorbers.Examples.Validation.'

    df2 = pd.read_excel("../exp_data/dempav_results_Aug_final_2020.xlsx")
    print(df2)

    # # generate object for calibration class
    MgCl2_obj = Calibration_H_M_transfer(t_stop=3600, exchange_area=6.5, d_e=0.288, cross_area = math.pi*0.288**2/4, bib_path=bib_path, model_path = model_path, nNodes=8, mNodes=8, model_name=model_name, prefix_outputfolder=prefix_output)

    ###### define inputdata ######
    sim_index = "Nu_" + str(Nu)
    base_path = os.path.join(MgCl2_obj.get_output_folder(), sim_index)

    input_data = df2.iloc[0,:]

    # run simulation
    MgCl2_obj.run_simulation(input_data = input_data, Nu0=Nu, \
        Sh0 = 639, model_name = model_path+model_name, \
            bib_path = bib_path, output_path = base_path)

    # read results:
    results = MgCl2_obj.readResults(path = base_path, mat_name = model_name)
    T_a_out = results.values("abs.air_out.T")[1][-1]
    x_a_out = results.values("abs.air_out.X[1]")[1][-1]
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
    
    ############# Chen2016 #################

    # run_calib_LiCl('2021_oct_corrected_')
    # run_Chen2016_sim('Sim_using_itered_NuSh_', 'regression_chen.csv')
    # run_Chen_fomular_NuSh(prefix_output='Chen_regress_fomular_Nu_Sh_2021Nov_2_', file_name='Chen2016.xlsx')

    #################### dempav ##########################
    # run_calib_MgCl2_dempav("2021_oct_dempav_3_", "dempav_T_des_corrected.xlsx")
    # run_MgCl2_dempav_sim_with_ChenFormular("Dempav_regress_fomular_Nu_Sh_2021Nov_", "dempav_T_des_corrected.xlsx")
    # run_MgCl2_dempav_sim("2021_Jan_dempav_regression_test", "dempav_results_Aug_final_2020.xlsx")
    # run_MgCl2_sim_alpha_beta("2021_Mar_teststand_cooling_5_a_b_", "teststand_cool_5_a_b.xlsx")
    # print("teststand finished")

    ########## ZHAW ################
    # run_calib_MgCl2_ZHAW('2021_ZHAW_', 'ZHAW_data.xlsx')

    #################### teststand #########################
    # run_calib_MgCl2_teststand("2021Jan_teststand_", "teststand_output_cool.xlsx")
    # run_MgCl2_teststand_sim("2021_Jan_teststand_regeneration_", "regeneration.xlsx")
    # print("teststand finished")

    end_code = time.time()
    print('finished! Duration: {}'.format(pd.Timedelta(pd.offsets.Second(int(end_code - start_code)))))

