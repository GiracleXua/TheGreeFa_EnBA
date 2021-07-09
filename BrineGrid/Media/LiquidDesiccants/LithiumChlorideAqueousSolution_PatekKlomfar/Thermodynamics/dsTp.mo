within BrineGrid.Media.LiquidDesiccants.LithiumChlorideAqueousSolution_PatekKlomfar.Thermodynamics;
function dsTp "Derivative of specific entropy s with respect to temperature T"
  extends Modelica.Icons.Function;
  input GibbsDerivs g;
  output DerEntropyByTemperature dsTp;
algorithm
  dsTp := -g.g_TT/g.MM;
end dsTp;
