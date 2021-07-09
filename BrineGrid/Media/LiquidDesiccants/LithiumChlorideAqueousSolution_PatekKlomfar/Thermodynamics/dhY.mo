within BrineGrid.Media.LiquidDesiccants.LithiumChlorideAqueousSolution_PatekKlomfar.Thermodynamics;
function dhY "Derivative of specific enthalpy h with respect to composition Y"
  extends Modelica.Icons.Function;
  input GibbsDerivs g;
  output SpecificEnthalpy dhY;
algorithm
  dhY := -g.T*g.g_TY/g.MM;
end dhY;
