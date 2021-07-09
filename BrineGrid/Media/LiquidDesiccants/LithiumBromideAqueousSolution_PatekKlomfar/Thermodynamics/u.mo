within BrineGrid.Media.LiquidDesiccants.LithiumBromideAqueousSolution_PatekKlomfar.Thermodynamics;
function u
  "Calculate specific internal energy u from temperature T and composition X"
  extends Modelica.Icons.Function;
  input AbsolutePressure p "Pressure";
  input Temperature T "Temperature";
  input MassFraction[nX] X "Composition";
  output SpecificInternalEnergy u "Specific internal energy";
algorithm
  u := h(T=T, X=X) - p/d(T=T, X=X);
end u;
