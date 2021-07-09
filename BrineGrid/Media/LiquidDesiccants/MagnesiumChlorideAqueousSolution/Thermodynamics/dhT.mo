within BrineGrid.Media.LiquidDesiccants.MagnesiumChlorideAqueousSolution.Thermodynamics;
function dhT "Derivative of specific enthalpy h with respect to temperature T"
  extends Modelica.Icons.Function;
  //input AbsolutePressure p "Pressure";
  input Temperature T "Temperature";
  input MassFraction[nX] X "Composition";
  output DerEnthalpyByTemperature dhT;
protected
  constant Temperature T_crit=reference.criticalTemperature;
  constant Temperature T_ref=reference.referenceTemperature;
  Modelica.SIunits.SpecificHeatCapacity cp_W "Specific heat capacity of water";
  Modelica.SIunits.AbsolutePressure psat_W=
      Modelica.Media.Water.IF97_Utilities.BaseIF97.Basic.psat(T);
  Real polyBrine;
algorithm
   cp_W := Modelica.Media.Water.IF97_Utilities.cp_pT(
    psat_W,
    T,
    1);
  polyBrine := exp(1.148*X[Desiccant])+(-7.316-0.005528*T+T^0.3264)*X[Desiccant];
  dhT := cp_W*polyBrine;
end dhT;
