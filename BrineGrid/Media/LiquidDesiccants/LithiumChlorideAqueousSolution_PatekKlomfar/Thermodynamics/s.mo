within BrineGrid.Media.LiquidDesiccants.LithiumChlorideAqueousSolution_PatekKlomfar.Thermodynamics;
function s "Calculate specific entropy s from gibbs energy"
  extends Modelica.Icons.Function;
  input GibbsDerivs g;
  output SpecificEntropy s;
algorithm
  s := -g.g_T/g.MM;
end s;
