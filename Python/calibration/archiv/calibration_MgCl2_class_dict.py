# io
import os
from pathlib import Path

# mathematics
import numpy as np
import pandas as pd
import math
from math import exp

# tools
import matplotlib.pyplot as plt
from multiprocessing import Pool
import time

# modelica interface
import buildingspy.simulate.Simulator as si
import buildingspy.io.outputfile as buipy_io

# thermal
# import  CoolProp.CoolProp as CP
# from CoolProp.HumidAirProp import HAPropsSI
# import psychrolib as psylib
# psylib.SetUnitSystem(psylib.SI)

# package:
from thermodynamics import *

class Calibration_H_M_transfer():

    """
    ToDo:
    - print model setting: use tabula

    Done:
    done - from exp to general format for input-table (of calibration)
    done - x of air and desiccant should be aligned / extinguished
    """

    def __init__(self,\
        t_stop, \
        exchange_area, \
        d_e, \
        cross_area ,\
        void_fraction = 1,\
        flow_config = 'counter',\
        type_desiccant = "MgCl2",\
        max_iter = 15, delta_T =0.2, delta_x = 0.001, \
        header_of_input = '', \
        nNodes = 5, mNodes = 5,\
        bib_path = os.path.join(os.path.expanduser("~"),"GIT","BrineGrid_HDisNet"), \
        model_path = 'BrineGrid.Fluid.Absorbers.Examples.Validation.', \
        model_name = 'Calibration_Chen_2016',\
        prefix_outputfolder = "",\
        if_Nu_Sh_const = True,
        if_use_alpha_beta = False,
    ):
        """
        cross_area: cross area of air flow
        d_e: charateristic length of air flow

        """
        self.t_stop = t_stop
        
        self.bib_path = bib_path
        self.model_path = model_path
        self.model_name = model_name
        self.prefix_outputfolder = prefix_outputfolder
        self.output_dir = os.path.join(bib_path, 'modelica_results', prefix_outputfolder + model_name)
        if not os.path.exists(self.output_dir):
            os.makedirs(self.output_dir)

        self.type_desiccant = type_desiccant
        self.exchange_area = exchange_area
        self.cross_area = cross_area
        self.void_fraction = void_fraction
        self.d_e = d_e
        self.flow_configeration = flow_config
        self.nNodes = nNodes
        self.mNodes = mNodes

        # only specify if want to run single test simulation
        self.header_of_input = header_of_input

        self.max_iter = max_iter
        self.delta_T = delta_T
        self.delta_x = delta_x
        self.if_Nu_Sh_const = if_Nu_Sh_const
        self.if_use_alpha_beta = if_use_alpha_beta

        # add tabula to show model setting
        print('model setting: ')
        return

    ########################begin configuration of modelica interface##################################

    # set up simulation-model
    def simulateCase(self, s, exit = True):
        s.setStopTime(self.t_stop)
        s.setTimeOut(7200)
        s.setSolver("dassl")
        s.showProgressBar(False)
        s.printModelAndTime()
        s.exitSimulator(exit)
        s.simulate()

    # not unterstood yet， not be used
    def simulateTranslatedModel(self, s):
        s.setStopTime(7200)
        s.setTimeOut(3600)
        s.setSolver("dassl")
        s.showProgressBar(False)
        s.printModelAndTime()
        s.simulate_translated()

    def read_exp_data(self, data_path):
        data = pd.read_csv(data_path, index_col=0)
        return data

    def run_simulation(self, input_data, \
                    Nu0=5, Sh0=2, \
                    nNodes = 6, mNodes = 6, \
                    alpha0 = 3, beta0 = 0.03,\
                    model_name = 'BrineGrid.Fluid.Absorbers.Examples.Validation.Calibration_Chen_2016', \
                    bib_path = os.path.join(os.path.expanduser("~"),"GIT","BrineGrid_HDisNet"),\
                    output_path = './calibration_test/', \
                    exit=True, if_Nu_Sh_const = True, if_use_alpha_beta = False,):

        if not os.path.exists(output_path):
            os.makedirs(output_path)
            
        # generate simulator    
        s = si.Simulator(modelName=model_name,
                        simulator="dymola",
                        outputDirectory=output_path,
                        packagePath=os.path.join(bib_path, "BrineGrid"))
        
        # set parameter
        s.addParameters({"nNodes": nNodes})
        s.addParameters({"mNodes": mNodes})
        s.addParameters({"T_air": input_data['T_a_in']})
        s.addParameters({"T_abs": input_data['T_d_in']})
        s.addParameters({"m_flow_air": input_data['m_a_in']})
        s.addParameters({"m_flow_abs": input_data['m_d_in']})
        s.addParameters({"x_a": input_data['x_a_in']})
        s.addParameters({"X_s": input_data['xi_d_in']})
        if if_Nu_Sh_const:
            s.addParameters({"Nu":Nu0})
            s.addParameters({"Sh":Sh0})
        if if_use_alpha_beta:
            s.addParameters({"alpha": alpha0})
            s.addParameters({"beta": beta0})
        # run
        print('running simulation...')
        self.simulateCase(s, exit=exit)
        
        return

    def get_output_folder(self):
        path_output = self.output_dir
        return path_output

        # read simulation results
    def readResults(self, path, mat_name):
        res = buipy_io.Reader(path + "/{}.mat".format(mat_name), "dymola")
        return res

    def read_multiple_mat_results(self):
        
        return

    def plot_sim_results(self):
        return

    ########################end modelica interface##################################

    def single_simulation(self, input_param, d_e, ex_area, \
                            delta_T, delta_x, \
                            header_of_input = '', Nu_input = None, Sh_input = None, \
                            bib_path = os.path.join(os.path.expanduser("~"), "git", "EnBA_M", "BrineGrid_HDisNet"),\
                            model_path = "BrineGrid.Fluid.Absorbers.Examples.Validation", \
                            model_name = 'Calibration_Chen_2016', \
                            output_foldername = "results_of_", \
                            nNodes=5, mNodes=5, if_Nu_Sh_const = True, if_use_alpha_beta = False, ):

        output_dir_iter = os.path.join(self.output_dir, output_foldername)
        
        # initialize variables
        Nu = Sh = alpha = beta = 0

        if not if_use_alpha_beta:
            if len(header_of_input) != 0: # read Nu Sh from input table
                Nu = input_param["Nu"+header_of_input]
                Sh = input_param["Sh"+header_of_input]
            elif Nu_input is not None and Sh_input is not None: # use input variables
                Nu = Nu_input,
                Sh = Sh_input
            else:
                raise ValueError('no input of Nu and Sh, check input')
        else:
            alpha = input_param["alpha"+header_of_input]
            beta = input_param["beta"+header_of_input]

        self.run_simulation(input_data=input_param, \
                        Nu0=Nu, Sh0=Sh, \
                        alpha0=alpha, beta0 = beta,\
                        nNodes=nNodes, mNodes=mNodes, \
                        model_name = model_path+model_name,\
                        bib_path = bib_path,\
                        output_path=output_dir_iter, if_Nu_Sh_const=if_Nu_Sh_const, \
                        if_use_alpha_beta=if_use_alpha_beta)

        result = self.readResults(path=output_dir_iter, \
                            mat_name=model_name)

        T_a_out_sim = result.values("abs.air_out.T")[1][-1]
        x_a_out_sim = air_mf_to_hr(result.values("abs.air_out.X[1]")[1][-1]) 
        # in dymola, it is not humidity ratio, but mass fration, therefore need to be transfered.
        x_a_out_sim = x_a_out_sim / (1-x_a_out_sim)
        T_d_out_sim = result.values("abs.abs_out.T")[1][-1]
        xi_d_out_sim = result.values("abs.abs_out.X[2]")[1][-1]

        if if_use_alpha_beta is not True:
            # only read Nu and Sh from modelica results when not directly using alpha and beta as model input
            if if_Nu_Sh_const:
                Nu_read = result.values('abs.thermal_air[1, 1].Nu0')[1][-1]
                Sh_read = result.values('abs.moisture_air[1, 1].Sh0')[1][-1]

            else:
                Nu_read = result.values('abs.thermal_air[1, 1].Nu')[1][-1]
                Sh_read = result.values('abs.moisture_air[1, 1].Sh')[1][-1]
                
                Pr_read = result.values('abs.thermal_air[1, 1].Pr')[1][-1]
                Sc_read = result.values('abs.moisture_air[1, 1].Sc')[1][-1]

                x_eq_read = result.values('abs.thermal_air[1, 1].x_eq')[1][-1]
                Re_read = result.values('abs.thermal_air[1, 1].Re')[1][-1]

                input_param['Re_read'] = Re_read
                input_param['x_eq_read'] = x_eq_read
                input_param['Pr_read'] = Pr_read
                input_param['Sc_read'] = Sc_read
        
            input_param['Nu_read'] = Nu_read
            input_param['Sh_read'] = Sh_read
              
        input_param["T_a_o_sim_reg"] = T_a_out_sim
        input_param["x_a_o_sim_reg"] = x_a_out_sim
        input_param["T_d_o_sim_reg"] = T_d_out_sim
        input_param["xi_d_o_sim_reg"] = xi_d_out_sim

        input_param.to_csv(path_or_buf=(os.path.join(output_dir_iter, 'results.csv')))

        return

    def Nu_Sh_iteration(self, input_param, d_e, ex_area, \
                        max_iter_number, \
                        delta_T, delta_x, flow_config = "counter", \
                        bib_path = os.path.join(os.path.expanduser("~"), "git", "BrineGrid_HDisNet"),\
                        model_path = "BrineGrid.Fluid.Absorbers.Examples.Validation",\
                        model_name = 'Calibration_Chen_2016', \
                        output_foldername = "results_of_", \
                        nNodes=5, mNodes=5):

        """
        d_e: equivalent parameter
        ex_area: exchange area between air and textil elemnt
        """

        output_dir_iter = os.path.join(self.output_dir, output_foldername)

        if not os.path.exists(output_dir_iter):
            os.makedirs(output_dir_iter)
        output_path_1 = os.path.join(output_dir_iter, "Case_1_calibr")
        output_path_2 = os.path.join(output_dir_iter, "Case_2_calibr")

        # simulation index
        sim_index = input_param.name
        print('running simulation {}.'.format(sim_index))

        # input param should include exp_data
        T_a_in_exp = input_param["T_a_in"]
        T_a_out_exp = input_param["T_a_o_exp"]
        x_a_in_exp = input_param["x_a_in"]
        x_a_out_exp = input_param["x_a_o_exp"]
        m_a_in_exp = input_param["m_a_in"]

        T_d_in_exp = input_param["T_d_in"]
        T_d_out_exp = input_param["T_d_o_exp"]
        print('check temperature of desiccant outlet: {}.'.format(T_d_out_exp))
        xi_d_in_exp = input_param["xi_d_in"]
        m_d_in_exp = input_param["m_d_in"]
        try:
            xi_d_out_exp = input_param['xi_d_o_exp']
        except:
            print('!!!no experimental data of desiccant outlet concentration, instead using values calculated from energy balance!!!')
            xi_d_out_exp = calc_xi_des_out(m_a=m_a_in_exp, m_des_in = m_d_in_exp, x_a_in = x_a_in_exp, x_a_out = x_a_out_exp, xi_des_in = xi_d_in_exp)

        # estimation of Nu_0, Sh_0 according to exp_data
            # Nu_0
        Nu_0 = calc_Nu(d_e = d_e, m_a = m_a_in_exp, T_a_in = T_a_in_exp, T_a_out = T_a_out_exp, T_des_in = T_d_in_exp, T_des_out = T_d_out_exp, exchange_area = ex_area, flow = flow_config)
            # Sh_0
        Sh_0 = calc_Sh(d_e = d_e, m_a = m_a_in_exp, m_des_in = m_d_in_exp, x_a_in = x_a_in_exp, x_a_out = x_a_out_exp, T_des_in = T_d_in_exp, T_des_out = T_d_out_exp, xi_des_in = xi_d_in_exp, exchange_area = ex_area, T_a_in = T_a_in_exp, T_a_out = T_a_out_exp,  flow = flow_config)

        # generate Nu, Sh
        Nu_1 = Nu_0 - 1
        Nu_2 = Nu_0 + 5

        Sh_1 = Sh_0 - 1
        Sh_2 = Sh_0 + 5
        
        # list to save the iteration process (intermediate output)
        list_Nu_1 = []
        list_Sh_1 = []
        list_Nu_2 = []
        list_Sh_2 = []
        
        list_T_a = []
        list_x_a = []
        list_T_d = []
        list_xi_d = []
        
        number_of_run = 1
            
        while True:
            
            print('********running the calibration Nr.{}.********'.format(number_of_run))      
            
            # run first simulation
            self.run_simulation(input_data=input_param, \
                        Nu0=Nu_1, Sh0=Sh_1, \
                        nNodes=nNodes, mNodes=mNodes, \
                        model_name = model_path+model_name,\
                        bib_path = bib_path,\
                        output_path=output_path_1)
            result_1 = self.readResults(path=output_path_1, \
                                mat_name=model_name)

            massfr_m_a_out_1 = air_mf_to_hr(result_1.values("abs.air_out.X[1]")[1][-1])
            sim_results_1 = {
            'T_a_out_sim_1': result_1.values("abs.air_out.T")[1][-1],
            'x_a_out_sim_1': massfr_m_a_out_1 / (1-massfr_m_a_out_1),
            'T_d_out_sim_1': result_1.values("abs.abs_out.T")[1][-1],
            'xi_d_out_sim_1': result_1.values("abs.abs_out.X[2]")[1][-1]}

            # compare first result with input param

            # run second simulation
            self.run_simulation(input_data=input_param, \
                        Nu0=Nu_2, Sh0=Sh_2, \
                        nNodes=nNodes, mNodes=mNodes, \
                        model_name = model_path+model_name,\
                        bib_path = bib_path,\
                        output_path=output_path_2)

            result_2 = self.readResults(path=output_path_2, \
                                mat_name=model_name)
            massfr_m_a_out_2 = air_mf_to_hr(result_2.values("abs.air_out.X[1]")[1][-1])
            sim_results_2 = {
            'T_a_out_sim_2' :result_2.values("abs.air_out.T")[1][-1], # unit K (SI unit),
            'x_a_out_sim_2': massfr_m_a_out_2 / (1-massfr_m_a_out_2),
            'T_d_out_sim_2' :result_2.values("abs.abs_out.T")[1][-1],
            'xi_d_out_sim_2' :result_2.values("abs.abs_out.X[2]")[1][-1]}

            delta_T_sim_exp_1 = sim_results_1['T_a_out_sim_1'] - sim_results_1['T_a_out_exp']
            delta_x_sim_exp_1 = sim_results_1['x_a_out_sim_1'] - sim_results_1['x_a_out_exp']
            
            delta_T_sim_exp_2 = sim_results_2['T_a_out_sim_2'] - sim_results_2['T_a_out_exp']
            delta_x_sim_exp_2 = sim_results_2['x_a_out_sim_2'] - sim_results_2['x_a_out_exp']
            
            delta_T_sim_exp = min(abs(delta_T_sim_exp_1), abs(delta_T_sim_exp_2))
            delta_x_sim_exp = min(abs(delta_x_sim_exp_1), abs(delta_x_sim_exp_2))
            
            ### newton's method to calibrate the Nu and Sh ###
            # y1 = f(x1), y2 = f(x2) --> gradient: k = (y2 - y1)/(x2 - x1)
            # x_3 = x1 - 
            # keep Nu_1 & Sh_1 closer to the target value
            if abs(delta_T_sim_exp_1) > abs(delta_T_sim_exp_2):
                Nu_1, Nu_2 = Nu_2, Nu_1
                T_a_out_sim_1, T_a_out_sim_2 = T_a_out_sim_2, T_a_out_sim_1
                
            if abs(delta_x_sim_exp_1) > abs(delta_x_sim_exp_2):
                Sh_1, Sh_2 = Sh_2, Sh_1
                x_a_out_sim_1, x_a_out_sim_2 = x_a_out_sim_2, x_a_out_sim_1
            
            list_T_a.append(T_a_out_sim_1)
            list_x_a.append(x_a_out_sim_1)
            list_T_d.append(T_d_out_sim_1)
            list_xi_d.append(xi_d_out_sim_1)
            
            print('current Nu_1 is {}, Nu_2 is {}.'.format(Nu_1, Nu_2))
            
            list_Nu_1.append(Nu_1)
            list_Sh_1.append(Sh_1)
            list_Nu_2.append(Nu_2)
            list_Sh_2.append(Sh_2)  
            
            print('difference of T and x at {}.th simulation is: T: {}, x: {}'.format(number_of_run, delta_T_sim_exp, delta_x_sim_exp))
            
            if delta_T_sim_exp <= delta_T and delta_x_sim_exp <= delta_x:
                print('criteria filled at {}.th simulation'.format(number_of_run))
                break
            else:
                Nu_inter = Nu_2 - 5
                number_of_run += 1
            # else:
            #     Nu_inter = Nu_2 - (T_a_out_sim_2 - T_a_out_exp)/(T_a_out_sim_2 - T_a_out_sim_1) * \
            #     (Nu_2 - Nu_1)
            #     print('Nu_inter: {}'.format(Nu_inter))

            #     Sh_inter = Sh_2 - (x_a_out_sim_2 - x_a_out_exp)/(x_a_out_sim_2 - x_a_out_sim_1) * \
            #     (Sh_2 - Sh_1)
            #     print('Sh_inter: {}'.format(Sh_inter))
            
            #     Nu_1 = Nu_2
            #     Nu_2 = Nu_inter
            #     Sh_1 = Sh_2
            #     Sh_2 = Sh_inter

            #     number_of_run += 1
                if number_of_run == self.max_iter:
                    print('reached max iterations, calibration not converge, check parameter')
                    break
        
        # postprocessing and export
        
        # export calibration process
        df_export = pd.DataFrame(zip(list_Nu_2, list_Sh_2, list_T_a, list_x_a), columns=['Nu', 'Sh', 'T_a_o(K)', 'x_a_o(kg/kg)'])
        df_export.to_csv(path_or_buf=(os.path.join(output_dir_iter, 'calibration.csv')), index = False)
        
        # export final results
        input_param['Nu'] = list_Nu_2[-1]
        input_param['Sh'] = list_Sh_2[-1]
        input_param['T_a_o_sim_new'] = list_T_a[-1]
        input_param['x_a_o_sim_new'] = list_x_a[-1]
        input_param['T_d_o_sim_new'] = list_T_d[-1]
        input_param['xi_d_o_sim_new'] = list_xi_d[-1]
        
        input_param.to_csv(path_or_buf=(os.path.join(output_dir_iter, 'results.csv')))   

        return

    # enable multiprocessing
    def run_single_simulation(self, input_dataset):
        self.single_simulation(input_param=input_dataset,  d_e = self.d_e, ex_area = self.exchange_area, \
                        delta_T = self.delta_T, delta_x = self.delta_x,\
                        nNodes=self.nNodes, mNodes=self.mNodes, \
                        header_of_input = self.header_of_input, \
                        bib_path= self.bib_path,\
                        model_path = self.model_path,\
                        model_name = self.model_name, \
                        output_foldername= "results_of_{}".format(input_dataset.name), \
                        if_Nu_Sh_const=self.if_Nu_Sh_const, if_use_alpha_beta = self.if_use_alpha_beta)
        return
        
    # enable multiprocessing
    def run_calibration(self, input_dataset):        
        self.Nu_Sh_iteration(input_param = input_dataset, \
                        d_e = self.d_e, ex_area = self.exchange_area, \
                        max_iter_number = self.max_iter, \
                        delta_T = self.delta_T, delta_x = self.delta_x,\
                        nNodes=self.nNodes, mNodes=self.mNodes, \
                        flow_config = self.flow_configeration, \
                        bib_path= self.bib_path,\
                        model_path = self.model_path,\
                        model_name = self.model_name, \
                        output_foldername= "results_of_{}".format(input_dataset.name))
        return
    
    def mp_run(self, df, mode = "calibration", num_core=4):
        po = Pool(processes=num_core)
        if mode == "calibration":
            po.map(self.run_calibration, [df.loc[i,:] for i in df.index])
        elif mode == "simulation":
            po.map(self.run_single_simulation, [df.loc[i,:] for i in df.index])
        else:
            raise Exception("attribute can only be 'simulation' or 'calibration'. ")

        po.close()
        po.join()
        return 

    
    def read_results(self, path, mode = "calibration", target_file="results.csv"):

        # read existing columns from all output-table (calibration ouput)
        df_calibr_results = pd.DataFrame()
        for path in Path(path).rglob(target_file):
            df_calibr_results = pd.concat([df_calibr_results, pd.read_csv(path).set_index(['Unnamed: 0'])], axis = 1)
        df_calibr_results = df_calibr_results.T

        # add some more columns
        if mode == "calibration":        
            # concentration of desiccant outlet
            df_calibr_results['xi_d_out'] = \
            np.vectorize(calc_xi_des_out)(df_calibr_results["m_a_in"], \
                                        df_calibr_results.m_d_in, \
                                        df_calibr_results.x_a_in, \
                                        df_calibr_results.x_a_o_exp, \
                                        df_calibr_results.xi_d_in)
            
            # air humidity ratio in equilibrium with desiccant
            df_calibr_results['x_d_in_equ'] = \
            np.vectorize(calc_x_des_equ)(df_calibr_results.T_d_in, \
                                        df_calibr_results.xi_d_in,
                                        type_desiccant=self.type_desiccant)
            
            # Re
            df_calibr_results['Re'] = \
            np.vectorize(calc_Re)(df_calibr_results.m_a_in, \
                                df_calibr_results.T_a_in, \
                                df_calibr_results.x_a_in, \
                                self.d_e, \
                                self.cross_area*self.void_fraction,\
                                )
                
            # Pr
            df_calibr_results['Pr'] = \
            np.vectorize(calc_Pr)(df_calibr_results.T_a_in, \
                                df_calibr_results.x_a_in, \
                                )
            
            # Sc 
            df_calibr_results['Sc'] = \
            np.vectorize(calc_Sc)(df_calibr_results.T_a_in, \
                                df_calibr_results.x_a_in, \
                                )

            # performance analysis
            df_calibr_results['epsilon_w'] = \
                np.vectorize(calc_epsilon_w)(df_calibr_results.x_a_in, 
                                            df_calibr_results.x_a_o_exp, 
                                            df_calibr_results.T_d_in,
                                            df_calibr_results.xi_d_in,
                                            LD=self.type_desiccant)
            df_calibr_results["epsilon_T"] = \
                np.vectorize(calc_epsilon_T)(df_calibr_results.T_a_in, 
                                            df_calibr_results.T_a_o_exp, 
                                            df_calibr_results.T_d_in)                                
            df_calibr_results["epsilon_h"] = \
                np.vectorize(calc_epsilon_h)(df_calibr_results.T_a_in,
                                            df_calibr_results.x_a_in,
                                            df_calibr_results.T_a_o_exp,
                                            df_calibr_results.x_a_o_exp,
                                            df_calibr_results.T_d_in,
                                            df_calibr_results.xi_d_in,
                                            LD = self.type_desiccant)

        if mode == "simulation":        
            # concentration of desiccant outlet
            df_calibr_results['xi_d_out_cal'] = \
            np.vectorize(calc_xi_des_out)(df_calibr_results["m_a_in"], \
                                        df_calibr_results.m_d_in, \
                                        df_calibr_results.x_a_in, \
                                        df_calibr_results.x_a_o_exp, \
                                        df_calibr_results.xi_d_in)
            
            # air humidity ratio in equilibrium with desiccant
            df_calibr_results['x_d_in_equ_cal'] = \
            np.vectorize(calc_x_des_equ)(df_calibr_results.T_d_in, \
                                        df_calibr_results.xi_d_in,
                                        type_desiccant=self.type_desiccant)
            
            # Re
            df_calibr_results['Re_cal'] = \
            np.vectorize(calc_Re)(df_calibr_results.m_a_in, \
                                df_calibr_results.T_a_in, \
                                df_calibr_results.x_a_in, \
                                self.d_e, \
                                self.cross_area*self.void_fraction,\
                                )
                
            # Pr
            df_calibr_results['Pr_cal'] = \
            np.vectorize(calc_Pr)(df_calibr_results.T_a_in, \
                                df_calibr_results.x_a_in, \
                                )
            
            # Sc 
            df_calibr_results['Sc_cal'] = \
            np.vectorize(calc_Sc)(df_calibr_results.T_a_in, \
                                df_calibr_results.x_a_in, \
                                )

        return df_calibr_results
