within BrineGrid.Media.LiquidDesiccants.LithiumChlorideAqueousSolution_PatekKlomfar.Thermodynamics;
function dTph "Derivative of temperature T with respect to pressure p"
  extends Modelica.Icons.Function;
  input GibbsDerivs g;
  output DerTemperatureByPressure dTph;
algorithm
  dTph := dhpT(g)/dhTp(g);
end dTph;
