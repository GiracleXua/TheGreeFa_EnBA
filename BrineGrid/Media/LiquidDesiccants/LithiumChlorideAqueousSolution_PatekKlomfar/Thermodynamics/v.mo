within BrineGrid.Media.LiquidDesiccants.LithiumChlorideAqueousSolution_PatekKlomfar.Thermodynamics;
function v "Calculate specific volume v from gibbs energy"
  extends Modelica.Icons.Function;
  input GibbsDerivs g;
  output SpecificVolume v;
algorithm
  v := g.g_p/g.MM;
end v;
