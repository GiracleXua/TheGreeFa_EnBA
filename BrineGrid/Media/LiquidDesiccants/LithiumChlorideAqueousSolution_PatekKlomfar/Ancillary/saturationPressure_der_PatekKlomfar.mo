within BrineGrid.Media.LiquidDesiccants.LithiumChlorideAqueousSolution_PatekKlomfar.Ancillary;
function saturationPressure_der_PatekKlomfar
  "Derivative of 'saturationPressure_PatekKlomfar'"
  extends Modelica.Icons.Function;
  input Temperature Tsat "Saturation temperature";
  input MassFraction[nX] Xsat "Saturation composition";
  input Real Tsat_der(unit="K/s") "Derivative of saturation temperature";
  input Real[nX] Xsat_der(unit "1/s") "Derivative of saturation composition";
  output Real psat_der(unit="Pa/s") "Derivative of saturation pressure";
algorithm
  psat_der := 0;
  annotation (Inline=true);
end saturationPressure_der_PatekKlomfar;
