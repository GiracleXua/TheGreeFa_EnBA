# -*- coding: utf-8 -*-
"""
Created on Tue Dec 08 10:36:17 2015

@author: yafuerst
"""
import os
import sys
from psychrometrics import psychrometric_chart as psy

# abspath = os.path.abspath(__file__)
# dname = os.path.dirname(abspath)
# os.chdir(dname)


chart = psy.psychrometricChart(
    x_min=0.0,
    x_max=0.025,
    h_min=-20000.0,
    h_max=80000.0,
    T_min=253.15,
    T_max=353.15)

def main():
    chart.generateFigure(size_x=6, size_y=8)
    chart.plotChange_xT(T1=301.15, x1=0.015, T2=321.15, x2=0.008, shape="og", color="g")
    chart.plotChange_xT(T1=321.15, x1=0.008, T2=301.15, x2=0.008, shape="og", color="g")
    chart.plotChange_xT(T1=301.15, x1=0.008, T2=291.15, x2=0.008, shape="og", color="g")
    chart.plotChange_xT(T1=297.15, x1=0.009, T2=317.15, x2=0.009, shape="or", color="r")
    chart.plotChange_xT(T1=317.15, x1=0.009, T2=333.15, x2=0.009, shape="or", color="r")
    chart.plotChange_xT(T1=333.15, x1=0.009, T2=313.15, x2=0.016, shape="or", color="r")
    chart.plotPoint_xphi(x=0.005, phi=0.4, shape="Dr")
    chart.plotPoint_Tphi(T=293.15, phi=0.4, shape="Dr")
    chart.saveFig(name="example1", dataType="pdf")

if __name__ == "__main__":
    print(__name__)
    print(sys.path)
    main()

