within BrineGrid.Media.LiquidDesiccants.LithiumChlorideAqueousSolution_PatekKlomfar.Ancillary;
function dynamicViscosity_Conde
  "Calculation of dynamic viscosity according to the equation of Conde"
  extends Modelica.Icons.Function;
  input Temperature T "Temperature";
  input MassFraction[nX] X "Composition";
  output DynamicViscosity eta "Dynamic viscosity";
protected
  constant Temperature T_crit=reference.criticalTemperature;
  constant Real[4] n=Coefficients.adjustedDynamicViscosity;
  Real Theta;
  Real Zeta;
algorithm
  Theta := T/T_crit;
  Zeta := X[Desiccant]/((1 - X[Desiccant])^(1/0.6));
  eta := dynamicViscosity_water(T=T)*exp(n[1]*Zeta^(3.6) + n[2]*Zeta + n[3]*
    Zeta/Theta + n[4]*Zeta^2);
end dynamicViscosity_Conde;
