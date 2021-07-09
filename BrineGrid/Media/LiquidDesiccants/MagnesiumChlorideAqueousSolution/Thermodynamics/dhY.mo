within BrineGrid.Media.LiquidDesiccants.MagnesiumChlorideAqueousSolution.Thermodynamics;
function dhY "Derivative of specific enthalpy h with respect to composition Y"
  extends Modelica.Icons.Function;
  //input AbsolutePressure p "Pressure";
  input Temperature T "Temperature";
  input MassFraction[nX] X "Composition";
  output SpecificEnthalpy dhY;

protected
  constant Real a=88.79;
  constant Real b=-120.196;
  constant Real c=-16.926;
  constant Real d=52.4654;
  constant Real e=0.10826;
  constant Real f=0.46988;
  constant Temperature T_crit=reference.criticalTemperature;
  constant Temperature T_ref=Modelica.Media.Water.IF97_Utilities.BaseIF97.triple.Ttriple;
  Real cpdx;
  Real polyBrine;
algorithm
  cpdx:=((T/228 - 1)^8*f + (T/228 - 1)^1.8*e + (T/228 - 1)^0.06*d +
    (T/228 - 1)^0.04*c + (T/228 - 1)^0.02*b + a)*(1.148*exp(1.148*X[Desiccant]) - 0.005528
    *T + T^0.3264 - 7.316);
  dhY := cpdx*(T - T_ref);
end dhY;
