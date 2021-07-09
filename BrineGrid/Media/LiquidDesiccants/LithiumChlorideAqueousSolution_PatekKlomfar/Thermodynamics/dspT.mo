within BrineGrid.Media.LiquidDesiccants.LithiumChlorideAqueousSolution_PatekKlomfar.Thermodynamics;
function dspT "Derivative of specific entropy s with respect to pressure p"
  extends Modelica.Icons.Function;
  input GibbsDerivs g;
  output DerEntropyByPressure dsTp;
algorithm
  dsTp := -g.g_Tp/g.MM;
end dspT;
