import pandas as pd
import numpy as np

from psychrochart import PsychroChart , load_config
import psychrolib as psylib
psylib.SetUnitSystem(psylib.SI)

from CoolProp.HumidAirProp import HAPropsSI
import matplotlib.pyplot as plt

# from thermodynamics import *

# currently only functions
# dependency: psychrochart (install using: "pip install psychrochart")
# to do
# 1. buil a class
# 2. able to declare the chart template at the __init__.
# 3. random seed of color generation
# 4. optimize function plot_with_des_point_df with on/off at plotting 3rd point


# adapted function by rotem for color distinction
def plot_psy_from_df_rotem(df_data, chart_template = 'ashrae', alpha = 0.6, save_fig_name = False, ncol = 2, use_line_highlight = False):
    
    # df_data is a pandas dataframe, for example, read directly from table of expertiment data.
    
    # pre-configuration
    # Get a pre-configured style dict
    config_ashrae = load_config(chart_template)
    config_ashrae['chart_params']['with_constant_wet_temp'] = False
    config_ashrae['chart_params']['constant_temp_label'] = None
    config_ashrae['chart_params']['constant_h_label'] = None
    config_ashrae['chart_params']['constant_v_label'] = None
    config_ashrae['chart_params']['constant_humid_label'] = None
    config_ashrae['chart_params']['constant_rh_label'] = None

    chart_customized_ashrae = PsychroChart(config_ashrae, use_line_highlight = use_line_highlight)
    
    # Plot the chart
    ax = chart_customized_ashrae.plot()
    points = {}
    connectors = []
    run=0#ROTEMS CODE - first run need to be out of the loop#######################################
    array_colors=[]#ROTEMS CODE - the 2D array that contains the different colors values####################################
    for i in df_data.index:
        
        # inlet
        air_in = 'air_in_{}'.format(i)
        T_air_in = df_data.loc[i, "T_a_in"]
        rh_air_in = df_data.loc[i, "RH_a_in"]        
        
        # outlet
        air_out = 'air_out_{}'.format(i)
        T_air_out = df_data.loc[i, "T_a_o_exp"]
        rh_air_out = df_data.loc[i, "RH_a_o_exp"]
        
        # color
        #Rotem's Code strats:##################################################################################
        if (run==0):#the color of the first sample does not need to be sorted
            col=np.random.rand(3)
            color = np.append(col, alpha)
            array_colors.append(col)#stacking the different colors in a 2D list
        else:#for all the samples after the first sample:
            x=0
            similar=0
            while(x==0):#this loop will keep running until it will find a color that is different enough from all the other colors before 
                col=np.random.rand(3)
                color = np.append(col, alpha)
                for k in range(len(array_colors)):#this loop runs on all the colors that were used so far 
                    similar=0
                    for j in range(3):#this loop runs on the three different color values
#**************************IF YOU RUN A PROGRAMM WITH MORE THAN 24 VALUES YOU WILL NEED TO MAKE THE VALUES IN******************** 
#**************************(0.25+/-array_colors[k][j]))SMALLER THAN 0.25, OTHERWISE IT WILL NOT STOP RUNNING*********************
                        if (color[j]<(0.25+array_colors[k][j])) and (color[j]>(array_colors[k][j]-0.25)):
                            similar+=1#a test value for color who is too similar to a previews colors 
                    if similar==3: break
                        
                if (similar>=3):#if the tested color has three color values whom are close to some of the colors before, so the
                    #loop will keep running another time with a new color
                    x=0
                    similar=0
                else:#if the similar value is not 3 ,so the tested color is different enough from all the colors before
                    x=1
                    array_colors.append(col)
                    print(color)
        run=1#so the first run will be confirmed out of the loop
        #Rotem's Code ends:##################################################################################
        
        # plot points
        point = {air_in: {'label': 'air_in_{}'.format(i),
                           'style': {'color': color,
                                     'marker': 'X', 'markersize': 15},
                           'xy': (T_air_in-273.15, rh_air_in)},
              air_out: {
                  'label': 'air_out_{}'.format(i),
                  'style': {'color': color,
                            'marker': 'o', 'markersize': 10},
                  'xy': (T_air_out-273.15, rh_air_out)}                      
                    }
        # plot connectors
        # here the color CANNOT be specified by string e.g. red...
        
        connector = {'start': air_in,
                       'end': air_out,
                       'style': {'color': color,
                                 "linewidth": 2, "linestyle": "-."}}
        points.update(point)
        connectors.append(connector)
        
    # add points and conncection to chart
    chart_customized_ashrae.plot_points_dbt_rh(points, connectors)

    # Add a legend
    chart_customized_ashrae.plot_legend(markerscale=.7, frameon=False, fontsize=8, labelspacing=1.2, ncol = ncol)
    
    if save_fig_name:
        ax.get_figure().savefig(save_fig_name)
    
    return ax.get_figure()

# plot the equivalent state of the air over the surface of desiccant
def plot_with_des_point_df(df_data, chart_template = 'ashrae', alpha = 0.6, ncol = 3, save_fig_name = False, use_line_highlight = False, if_legend = True):
    
    # pre-configuration
    # Get a pre-configured style dict
    config_ashrae = load_config(chart_template)

    # customize configuration:
    config_ashrae['chart_params']['with_constant_wet_temp'] = False
    config_ashrae['chart_params']['constant_temp_label'] = None
    config_ashrae['chart_params']['constant_h_label'] = None
    config_ashrae['chart_params']['constant_v_label'] = None
    config_ashrae['chart_params']['constant_humid_label'] = None
    config_ashrae['chart_params']['constant_rh_label'] = None

    chart_customized_ashrae = PsychroChart(config_ashrae, use_line_highlight = use_line_highlight)
    # Plot the chart
    ax = chart_customized_ashrae.plot()
    
    points = {}
    connectors = []
    for i in df_data.index:
        
        # inlet
        air_in = 'air_in_{}'.format(i)
        T_air_in = df_data.loc[i, "T_a_in"]
        rh_air_in = df_data.loc[i, "RH_a_in"]        
        
        # outlet
        air_out = 'air_out_{}'.format(i)
        T_air_out = df_data.loc[i, "T_a_o_exp"]
        rh_air_out = df_data.loc[i, "RH_a_o_exp"]
        
        # des inlet
        des_in = 'des_in_{}'.format(i)
        T_des_in = df_data.loc[i, "T_d_in"]
        rh_des_in = df_data.loc[i, "RH_d_in_equ"]
        
        # color
        color = np.append(np.random.rand(3), alpha)
        print(color)
        
        # plot points
        point = {air_in: {'label': 'air_in_{}'.format(i),
                           'style': {'color': color,
                                     'marker': 'X', 'markersize': 15},
                           'xy': (T_air_in-273.15, rh_air_in)},
                  air_out: {
                      'label': 'air_out_{}'.format(i),
                      'style': {'color': color,
                                'marker': 'o', 'markersize': 10},
                      'xy': (T_air_out-273.15, rh_air_out)},
                 des_in: {
                     'label':'des_in_{}_equ'.format(i),
                     'style': {'color': color,
                                'marker': '+', 'markersize': 20},
                      'xy': (T_des_in-273.15, rh_des_in)}
                }
        
        # plot connectors
        # here the color CANNOT be specified by string e.g. red...
        connector = {'start': air_in,
                       'end': air_out,
                       'style': {'color': color,
                                 "linewidth": 2, "linestyle": "-."}}
        
        # add into dict and list
        points.update(point)
        connectors.append(connector)
        
    # add points and conncection to chart
    chart_customized_ashrae.plot_points_dbt_rh(points, connectors)

    # Add a legend
    if if_legend:
        if chart_template == 'ashrae':
            chart_customized_ashrae.plot_legend(markerscale=.7, frameon=False, fontsize=8, labelspacing=1.2, ncol = ncol)
        if chart_template == 'minimal':
            chart_customized_ashrae.plot_legend(markerscale=1.2, frameon=False, fontsize=10, labelspacing=1.2, ncol = ncol)
        else:
            chart_customized_ashrae.plot_legend(markerscale=.7, frameon=False, fontsize=8, labelspacing=1.2, ncol = ncol)
    plt.tight_layout()
    if save_fig_name:
        ax.get_figure().savefig(save_fig_name)
    
    return ax.get_figure()