import os
from pathlib import Path

import numpy as np
import pandas as pd
import math
from math import exp

import scipy
from sklearn import linear_model
# import statistics

import matplotlib.pyplot as plt

class EnBA_M_post_processing():

    """
    important: for absorber and regenerator, the formula of Nu need to be changed according to different configuration (e.g., absorption, regeneration)
    """

    def __init__(self, folder_name, file_name, postfix = '', if_cooling=True, point_exclude=[], base_path = os.path.join(os.path.expanduser("~"),"GIT","EnBA_M","BrineGrid_HDisNet", "modelica_results")):
        self.folder_name = folder_name
        self.file_name = file_name
        self.postfix = postfix
        self.base_path = base_path
        self.if_cooling = if_cooling
        self.point_exclude = point_exclude

    ## read data from calibration output
    def generate_regression_input(self, sorted_by = None, if_cooling = True, if_log=True, point_exclude = [], critera = 2,):
        
        input_path = os.path.join(self.base_path, self.folder_name, self.file_name)
        df_input_raw = pd.read_csv(filepath_or_buffer=input_path, index_col=0).drop(point_exclude)
        postfix = self.postfix

        if if_cooling:
            df_input = df_input_raw.query("(T_a_in - T_d_in) >{}".format(critera))
            print("number of cooling datapoint is {} \n".format(df_input.shape[0]))
            print("following datasets are excluded from regression: \n {}.".format(set(df_input_raw.index)-set(df_input.index)))
        
        df_input_selected = df_input[['T_a_in', 'x_a_in', 'm_a_in', 'T_d_in', "xi_d_in", 'x_d_in_equ', 'm_d_in', 'T_a_o_exp', 'T_d_o_exp', 'x_a_o_exp', 'Re', 'Pr', 'Sc', 'Nu', 'Sh']]
        try:
            df_input_selected["Nu_2"] = df_input["Nu_2"]
            df_input_selected["Sh_2"] = df_input["Sh_2"]
        except:
            print("no Nu_2 and Sh_2 in dataframe.")

        if if_log:
            df_input_selected['log_Re'] = (df_input_selected['Re']/2300).apply(math.log)
            df_input_selected['log_Pr'] = df_input_selected['Pr'].apply(math.log)
            df_input_selected['log_Sc'] = df_input_selected['Sc'].apply(math.log)
            df_input_selected['log_m_frac'] = np.vectorize(lambda x,y: math.log(y/x))(df_input_selected.m_a_in, df_input_selected.m_d_in)
            df_input_selected['log_x_frac'] = np.vectorize(lambda x,y: math.log(1-y/x))(df_input_selected.x_a_in, df_input_selected.x_d_in_equ)
            df_input_selected['log_T_frac'] = np.vectorize(lambda x,y: math.log(y/x))(df_input_selected.T_a_in-273.15, df_input_selected.T_d_in-273.15)
            
            df_input_selected['log_Nu'] = df_input_selected['Nu'].apply(math.log)
            df_input_selected['log_Sh'] = df_input_selected['Sh'].apply(math.log)
            try:
                df_input_selected['log_Nu_2'] = df_input_selected['Nu_2'].apply(math.log)
                df_input_selected['log_Sh_2'] = df_input_selected['Sh_2'].apply(math.log)
                print("logarithm for Nu_2, Sh_2 generated")
            except:
                print("no Nu_2 and Sh_2 in dataframe.")

        try:
            df_input_selected.sort_values(by=sorted_by, ascending=True, inplace = True)
        except:
            print("###### use unsorted calibration data ######")

        return df_input_selected

    # define reference function for Nu and Sh, input and output could be array or single value
    def func_Nu(self, variables, a, b, c, d, e, f, if_normalise = True):
        if if_normalise:
            Re = variables['Re'].to_numpy()/2300
        else:
            Re = variables['Re'].to_numpy()
        Pr = variables['Pr'].to_numpy()
        m_d = variables['m_d_in'].to_numpy()
        m_a = variables['m_a_in'].to_numpy()
        w_d = variables['x_d_in_equ'].to_numpy()
        w_a = variables['x_a_in'].to_numpy()
        T_d = variables['T_d_in'].to_numpy()
        T_a = variables['T_a_in'].to_numpy()
        # np.power(Re, b) * 
        Nu = a * np.power(Re, b) * np.power(Pr, c) * np.power((m_d/m_a), d) * np.power((1-w_d/w_a), e) * np.power((T_d-273.15)/(T_a-273.15), f) # adjusted for regeneration
        
        return Nu

    def func_Sh(self, variables, a, b, c, d, e, f):
        Re = variables['Re'].to_numpy()/2300
        Sc = variables['Sc'].to_numpy()
        m_d = variables['m_d_in'].to_numpy()
        m_a = variables['m_a_in'].to_numpy()
        w_d = variables['x_d_in_equ'].to_numpy()
        w_a = variables['x_a_in'].to_numpy()
        T_d = variables['T_d_in'].to_numpy()
        T_a = variables['T_a_in'].to_numpy()
        # np.power(Re, b) *
        Sh = a * np.power(Re, b) * np.power(Sc, c) * np.power((m_d/m_a), d) * \
        np.power((1-w_d/w_a), e) * np.power((T_d-273.15)/(T_a-273.15), f)
        
        return Sh

    # regression algorithmus

    def regr_via_scipy(self, df, target, p0 = [1, 1.8, 1/3, -1, 0.8, 0.4], iter_num = 2000):
        if target[0:2] == "Nu":
            results = scipy.optimize.curve_fit(self.func_Nu, df, df[target].to_numpy(), p0=p0, maxfev = iter_num)
        elif target[0:2] == "Sh":
            results = scipy.optimize.curve_fit(self.func_Sh, df, df[target].to_numpy(), p0=p0, maxfev = iter_num)
        else:
            print("Target can only be 'Nu' or 'Sh'.")
        return results[0]

    def regr_via_skl(self, df, target):
        """
        target: "Nu" or "Sh"
        """
        if target == "Nu" or target == "Nu_2":
            feature_cols = ['log_Re','log_Pr', 'log_m_frac', 'log_x_frac', 'log_T_frac']
        elif target == "Sh" or target == "Sh_2":
            feature_cols = ['log_Re','log_Sc', 'log_m_frac', 'log_x_frac', 'log_T_frac']
        else:
            raise Exception("target out of 'Nu' and 'Sc' are not allowed.")

        x = df[feature_cols]
        y = df['log_{}'.format(target)]
        
        lm = linear_model.LinearRegression()
        lm.fit(x,y)
        
        a_0 = math.exp(lm.intercept_)
        li_result = np.insert(lm.coef_, 0, a_0)

        R_squared = lm.score(x, y)
        return li_result, R_squared

    def calc_R_squared(self, data_ref, data_cal):
        # # it looks false, because only appliable for linear regression
        
        # slope, intercept, r_value, p_value, std_err = scipy.stats.linregress(data_ref, data_cal)

        # R squared: coefficient of determination = 1 - SSR/SST

        np_li_ref = np.array(data_ref)
        np_li_cal = np.array(data_cal)
        mean_ref = np.mean(np_li_ref)
        SST = np.sum((np_li_ref-mean_ref)**2)
        SSR = np.sum((np_li_ref-np_li_cal)**2)

        r_value = 1 - SSR/SST

        return r_value

    def run_regression_and_compare(self, target, num_training, sorted = True, method = "scipy", num_max_iter = 2000, if_plot = True):
        """
        target: "Nu" or "Sh"
        method: "scipy" or "scikitlearn"
        """
        if sorted:
            df_input = self.generate_regression_input(sorted_by=target, if_cooling=self.if_cooling, point_exclude = self.point_exclude,)
        else:
            df_input = self.generate_regression_input(if_cooling=self.if_cooling, point_exclude = self.point_exclude,)

        df_selected = df_input.iloc[:num_training, :] # selected data for training of regression parameter

        print("########### data selected for training are: ############ \n {}".format(df_selected))

        if method == "scipy":
            param = self.regr_via_scipy(df = df_selected, target=target, iter_num=num_max_iter)
            print("parameters for {} generated from {} regression are: {}".format(target, method, param))

        elif method == "scikitlearn":
            results_sk = self.regr_via_skl(df=df_selected, target=target)
            param = results_sk[0]
            print("parameters for {} generated from {} regression are: {}".format(target, method, param))

            R_squared_ori = results_sk[1]
            print("######### R_sqaure calculated by scikit-learn: {}. ########".format(R_squared_ori))
        else:
            raise Exception("only 'scipy' and 'scikitlearn' are currently supported.")

        if target[0:2] == "Nu":
            results_from_regr = self.func_Nu(df_input, param[0], param[1], param[2], param[3], param[4], param[5])#, param[5]

        elif target[0:2] == "Sh": 
            results_from_regr = self.func_Sh(df_input, param[0], param[1], param[2], param[3], param[4], param[5])#, param[5]
        else: 
            raise Exception("target outside of 'Nu' and 'Sh' are not allowed.")

        df_compare = pd.DataFrame(list(zip(df_input[target], results_from_regr)), columns=['simulation', 'regression'])
        df_compare["index_ori"] = df_input.index


        # # calculate R_squared
        R_squared_train = self.calc_R_squared(data_ref=df_selected[target], data_cal=results_from_regr[:num_training])

        R_squared_test = self.calc_R_squared(data_ref=df_input[target][num_training:], data_cal=results_from_regr[num_training:])

        print("R squared of training is: {}.".format(R_squared_train))
        print("R squared of testing is: {}.".format(R_squared_test))

        if if_plot:
            fig, ax = plt.subplots(figsize=(20,10))

            ax.plot(df_compare["simulation"][0:num_training], color = 'blue', linestyle="-", marker = 'o', markersize = 20, label = '{} aus Iteration (Ref)'.format(target))
            ax.plot(df_compare["simulation"][num_training:], color = 'blue',linestyle="-.", marker = '*', markersize = 20, label = '{} aus Iteration (Ref)'.format(target))
            ax.plot(df_compare['regression'][0:num_training], color = 'red', linestyle="-", marker = 'o', markersize = 20, label = '{} aus Regression (Training)'.format(target))
            ax.plot(df_compare['regression'][num_training:], color = 'red',linestyle="-.", marker = '*', markersize = 20, label = '{} aus Regression (Test)'.format(target))

            ax.tick_params(labelsize = 20)

            # ax.set_xticks(np.arange(0,df_compare.shape[0]))
            ax.set_xlabel("Datensätze", size = 25, labelpad = 15)
            ax.set_ylabel(target, size = 25, labelpad = 15)

            ax.set_title('Regression von {}-Zahl (Anzahl der Trainingsdatensätze: {}, methode: {})'.format(target, num_training, method), size = 30, pad = 20)

            plt.xticks(df_compare.index, [str(i) for i in df_compare.index_ori])
            plt.legend(fontsize = 20)#loc = "upper left",
            plt.savefig(os.path.join(self.base_path, self.folder_name, "{0}_{1}_{2}_{3}_{4}.png".format(self.folder_name, target, method, num_training, sorted)), dpi = 300, tranparent=False)

        return df_compare, R_squared_train, R_squared_test

    def run_regression_generate_results(self, method, \
                                        Nu_num_training, Nu_if_sorted, \
                                        Sh_num_training, Sh_if_sorted, \
                                        physical_Nu_Sh = False, if_plot=False, max_iter=50000):

        df_export = self.generate_regression_input(if_log = False, if_cooling=self.if_cooling, point_exclude = self.point_exclude,)
        
        if physical_Nu_Sh:
            result_Nu = self.run_regression_and_compare(target="Nu_2", sorted=Nu_if_sorted, method=method, num_training=Nu_num_training, num_max_iter=max_iter, if_plot=if_plot)
        
            result_Sh = self.run_regression_and_compare(target="Sh_2", sorted=Sh_if_sorted, method=method, num_training=Sh_num_training, num_max_iter=max_iter, if_plot=if_plot)
            if_physic = "physic"
        else:
            result_Nu = self.run_regression_and_compare(target="Nu", sorted=Nu_if_sorted, method=method, num_training=Nu_num_training, num_max_iter=max_iter, if_plot=if_plot)
        
            result_Sh = self.run_regression_and_compare(target="Sh", sorted=Sh_if_sorted, method=method, num_training=Sh_num_training, num_max_iter=max_iter, if_plot=if_plot)
            if_physic = "data"


        df_export["Nu_reg"] = result_Nu[0].set_index("index_ori")["regression"]
        df_export["Sh_reg"] = result_Sh[0].set_index("index_ori")["regression"]

        output_filename = os.path.join(self.base_path, self.folder_name, "{0}_{1}_{2}_{3}_{4}.xlsx".format(self.folder_name, Nu_num_training, Sh_num_training, method, if_physic))
        df_export.to_excel(output_filename)

        print("Finished! output as {} \n".format(output_filename))
        print("R square Nu training: {}, test: {}. \n".format(result_Nu[1], result_Nu[2]))
        print("R square Sh training: {}, test: {}. \n".format(result_Sh[1], result_Sh[2]))
        return df_export

if __name__ == "__main__":
    # obj_regression = EnBA_M_post_processing(folder_name = "Sep_29_teststand", file_name = "final_output_teststand.csv")

    # obj_regression = EnBA_M_post_processing(folder_name = "Sep_29_dempav", file_name = "final_output_dempav.csv")

    # obj_regression = EnBA_M_post_processing(folder_name = "Okt_1_teststand", file_name = "final_output.csv")
    
    obj_regression = EnBA_M_post_processing(folder_name = "Chen_fomular_Nu_Sh_Mar_06", file_name = "cleaned.csv") #, point_exclude=[17,6]

    # df_compare = obj_regression.run_regression_and_compare(target="Nu", sorted=True, method="scikitlearn", num_training=20, num_max_iter=20000, if_plot=True)
    # print(df_compare)

    obj_regression.run_regression_generate_results(method="scipy", Nu_num_training=30, Nu_if_sorted=True, Sh_num_training=30, Sh_if_sorted=True, physical_Nu_Sh=False, if_plot=True, max_iter=100000)

    print("post processing finished")