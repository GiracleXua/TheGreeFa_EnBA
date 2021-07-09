within BrineGrid.Media.LiquidDesiccants.LithiumChlorideAqueousSolution_PatekKlomfar.Ancillary;
function saturationPressure_Kink
  "Calculation of the saturation pressure according to the equation of Kink"
  extends Modelica.Icons.Function;
  input Temperature Tsat "Saturation temperature";
  input MassFraction[nX] Xsat "Saturation composition";
  output AbsolutePressure psat "Saturation pressure";
protected
  constant Real a(unit="degC") = 13.75775;
  constant Real b=0.05714358;
  constant Real c(unit="1/degC") = 9.127117e-6;
  constant AbsolutePressure p0=610.8;
  constant Real alpha=2.3226;
  constant Real w=0.4321;
  Temperature k;
  Temperature Theta;
  Real K;
algorithm
  K := alpha*Xsat[2]/(1 - Xsat[2] + alpha*Xsat[2]);
  Theta := Tsat/(1 + w*K^3) - 273.15;
  k := a + Theta*(b + Theta*c);
  psat := p0*exp(Theta/k);
end saturationPressure_Kink;
