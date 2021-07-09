within BrineGrid.Media.LiquidDesiccants.MagnesiumChlorideAqueousSolution;
function saturationPressure_der
  "Derivative of saturationPressure with respect to time (NOT IMPLEMENTED)"
  extends Modelica.Icons.Function;
  input Temperature Tsat "Saturation temperature";
  input MassFraction[nX] Xsat "Saturation composition";
  input SaturationProperties sat "Saturation property record";
  input Real Tsat_der(final unit="K/s")
    "Derivative of saturation temperature with respect to time";
  input Real[nX] Xsat_der(final unit="1/s")
    "Derivative to saturation composition with respect to time";
  output Real psat_der(unit="Pa/s")
    "Derivative of saturation pressure with respect to time";
algorithm
  psat_der := 1;
end saturationPressure_der;
