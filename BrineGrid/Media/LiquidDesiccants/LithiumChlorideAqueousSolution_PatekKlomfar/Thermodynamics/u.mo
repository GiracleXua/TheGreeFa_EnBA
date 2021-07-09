within BrineGrid.Media.LiquidDesiccants.LithiumChlorideAqueousSolution_PatekKlomfar.Thermodynamics;
function u "Calculate specific internal energy u from gibbs energy"
  extends Modelica.Icons.Function;
  input GibbsDerivs g;
  output SpecificInternalEnergy u;
algorithm
  u := h(g) - g.p/d(g);
end u;
