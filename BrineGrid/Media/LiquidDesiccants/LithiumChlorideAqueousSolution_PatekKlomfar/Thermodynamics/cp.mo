within BrineGrid.Media.LiquidDesiccants.LithiumChlorideAqueousSolution_PatekKlomfar.Thermodynamics;
function cp "Calculate specific heat capacity cp from gibbs energy"
  extends Modelica.Icons.Function;
  input GibbsDerivs g;
  output SpecificHeatCapacity cp;
algorithm
  cp := dhTp(g);
end cp;
