within BrineGrid.Media.LiquidDesiccants.LithiumChlorideAqueousSolution_PatekKlomfar.Thermodynamics;
function dvY "Derivative of specific volume v with respect to composition Y"
  extends Modelica.Icons.Function;
  input GibbsDerivs g;
  output Modelica.SIunits.SpecificVolume dvY;
algorithm
  dvY := g.g_pY/g.MM;
end dvY;
