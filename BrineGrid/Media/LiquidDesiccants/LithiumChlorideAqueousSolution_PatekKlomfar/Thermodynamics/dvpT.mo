within BrineGrid.Media.LiquidDesiccants.LithiumChlorideAqueousSolution_PatekKlomfar.Thermodynamics;
function dvpT "Derivative of specific volume v with respect to pressure p"
  extends Modelica.Icons.Function;
  input GibbsDerivs g;
  output DerVolumeByPressure dvpT;
algorithm
  dvpT := g.g_pp/g.MM;
end dvpT;
