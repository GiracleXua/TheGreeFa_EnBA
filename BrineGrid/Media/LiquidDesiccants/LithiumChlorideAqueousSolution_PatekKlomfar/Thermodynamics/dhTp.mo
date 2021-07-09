within BrineGrid.Media.LiquidDesiccants.LithiumChlorideAqueousSolution_PatekKlomfar.Thermodynamics;
function dhTp "Derivative of specific enthalpy h with respect to temperature T"
  extends Modelica.Icons.Function;
  input GibbsDerivs g;
  output DerEnthalpyByTemperature dhTp;
algorithm
  dhTp := -g.T*g.g_TT/g.MM;
end dhTp;
