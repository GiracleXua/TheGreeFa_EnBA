within BrineGrid.Media.LiquidDesiccants.LithiumChlorideAqueousSolution_PatekKlomfar.Thermodynamics;
function dvTp "Derivative of specific volume v with respect to temperature T"
  extends Modelica.Icons.Function;
  input GibbsDerivs g;
  output DerVolumeByTemperature dvTp;
algorithm
  dvTp := g.g_Tp/g.MM;
end dvTp;
