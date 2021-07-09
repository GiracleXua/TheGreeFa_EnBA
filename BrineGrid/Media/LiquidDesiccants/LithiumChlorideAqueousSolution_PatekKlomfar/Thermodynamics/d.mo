within BrineGrid.Media.LiquidDesiccants.LithiumChlorideAqueousSolution_PatekKlomfar.Thermodynamics;
function d "Calculate density d from gibbs energy"
  extends Modelica.Icons.Function;
  input GibbsDerivs g;
  output Density d;
algorithm
  d := 1/v(g);
end d;
