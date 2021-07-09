# TheGreeFa_EnBA - Repository for joint project EnBA and TheGreeFa

The project is still onging. Models were developed by following cooperation partners:
 * Fachgebiet Digiale Architekt Nachhaltigkeit of TU-Berlin,
 * Hermann-Rietschel-Insititute of TU-Berlin,  
 * Watergy GmbH

The repository consists mainly of following parts:
  * BrineGrid: Modelica model for simulation of the absorber and desorber
  * Data_input: necessary data for the simulation, i.e. experimental measurements and literature dataset
  * Python: python code and script for pre- and post-processing of the simulation
  * results of the simulation and analysis


To know more about the project, please visit our project website:
  * TheGreeFa: http://thegreefa.eu/
  * EnBA: http://www.energienetz-berlin-adlershof.de/

## How to use:

### Dependencies

TEASER is currently tested against Python 3.8. Older versions of Python may still work, but are no longer actively supported.
Using a Python distribution is recommended as they already contain (or easily support installation of) many Python packages (e.g. SciPy, NumPy, pip, PyQT, etc.) that are used in the code. Two examples of those distributions are:

1. https://winpython.github.io/ WinPython comes along with a lot of Python
packages (e.g. SciPy, NumPy, pip, PyQT, etc.)..
2. http://conda.pydata.org/miniconda.html Conda is an open source package
management  system and environment management system for installing multiple
versions of software  packages and their dependencies and switching easily
between them.

In addition, The code requires some specific Python packages:

1. pandas: popular data analysis library
  install on a python-enabled command line with `pip install -U pandas`
2. CoolProp: thermodynamic calculation of different gas and fluids
  install on a python-enabled command line with `pip install -U CoolProp`
3. psychrolib: psychrometrics of moist air
  install on a python-enabled command line with `pip install -U psychrolib`
4. psychrochart: plot psychrometric charts in python
  install on a python-enabled command line with `pip install -U psychrochart`
5. buildingspy: python modelica interface
  install on a python-enabled command line with `pip install -U buildingspy`

### Related publications
to be filled.