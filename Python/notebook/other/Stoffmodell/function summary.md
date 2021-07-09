# functions for MgCl2(aq) thermodynamic state (for implementation in Modelica)

## 1. soluability.

$para_{sol} = [5.543, 1.834*10^{-2}, -6.093*10^{-4}, 1.858*10^{-5}, -2.124*10^{-7}, 8.969*10^{-10}]$

$T = [1, T, T^{2}, T^{3}, T^{4}, T^{5}]$

$x = para_{sol} * T$

## 2. density.
already implemented (density of water using IF97 of MODELICA)\
$\rho = \rho_w * \rho_{rel}$

## 3. Vapor pressure
already implemented (vapor pressure of water using IF97 of MODELICA)\
$p_{sat} = \alpha * p_{sat,w}$

## 4. Viscosity
current model not completed, but it is firstly not important. will be completed if needed

## 5. heat capacity
already implemented, but need to be validated.\

update: validated, function ok, disagreement because of state function for water \
$c_{p} = c_{p,w} * c_{p,rel}$ 

## 6. Enthalpy

Theory: reference enthalpy @ 25°C + integration of heat capacity cp with respect to T

Implementation: multivariante non-linear-regression for modelica

$h_{solution} = -1052.5261563 + 3.75550823*T + -5.11934879*10^2*x + 4.78672511*10^{-4}* T^2 + T*x*-4.44122366 + x^2*8.36881428*10^2 $
