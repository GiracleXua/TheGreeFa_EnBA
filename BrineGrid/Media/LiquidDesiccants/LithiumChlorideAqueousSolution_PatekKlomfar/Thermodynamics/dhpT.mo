within BrineGrid.Media.LiquidDesiccants.LithiumChlorideAqueousSolution_PatekKlomfar.Thermodynamics;
function dhpT "Derivative of specific enthalpy h with respect to pressure p"
  extends Modelica.Icons.Function;
  input GibbsDerivs g;
  output DerEnthalpyByPressure dhpT;
algorithm
  dhpT := (g.g_p - g.T*g.g_Tp)/g.MM;
end dhpT;
