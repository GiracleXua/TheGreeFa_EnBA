within BrineGrid.Media.LiquidDesiccants.LithiumBromideAqueousSolution_PatekKlomfar;
function saturationTemperature_der
  "Derivative of saturationTemperature with respect to time (NOT IMPLEMENTED)"
  extends Modelica.Icons.Function;
  input AbsolutePressure psat "Saturation pressure";
  input MassFraction[nX] Xsat "Saturation composition";
  input SaturationProperties sat "Saturation property record";
  input Real psat_der(final unit="Pa/s")
    "Derivative of saturation pressure with respect to time";
  input Real[nX] Xsat_der(final unit="1/s")
    "Derivative to saturation composition with respect to time";
  output Real Tsat_der(unit="K/s")
    "Derivative of saturation temperature with respect to time";
algorithm
  Tsat_der := 1;
  annotation (Inline=true);
end saturationTemperature_der;
