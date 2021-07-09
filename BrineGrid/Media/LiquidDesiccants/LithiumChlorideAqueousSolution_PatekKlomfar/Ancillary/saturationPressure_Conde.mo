within BrineGrid.Media.LiquidDesiccants.LithiumChlorideAqueousSolution_PatekKlomfar.Ancillary;
function saturationPressure_Conde
  "Calculation of the saturation pressure according to the equation of Conde"
  extends Modelica.Icons.Function;
  input Temperature Tsat "Saturation temperature";
  input MassFraction[nX] Xsat "Saturation composition";
  output AbsolutePressure psat "Saturation pressure";
protected
  constant Temperature T_crit=reference.criticalTemperature;
  constant AbsolutePressure p_crit=reference.criticalPressure;
  constant Real[10] a=Coefficients.reducedSaturationPressure;
  constant Real[6] b=Coefficients.saturationPressure;
  AbsolutePressure psat_v;
  Real Theta;
  Real pi;
  Real pi25;
  Real f;
  Real A;
  Real B;
  Real tau;
algorithm
  Theta := Tsat/T_crit;
  tau := 1 - Theta;
  A := 2 - (1 + (Xsat[Desiccant]/a[1])^a[2])^a[3];
  B := (1 + (Xsat[Desiccant]/a[4])^a[5])^a[6] - 1;
  f := A + B*Theta;
  pi25 := 1 - (1 + (Xsat[Desiccant]/a[7])^a[8])^a[9] - a[10]*exp(-(Xsat[
    Desiccant] - 0.1)^2/0.005);
  pi := pi25*f;
  psat_v := p_crit*exp((b[1]*tau + b[2]*tau^(1.5) + b[3]*tau^(3) + b[4]*tau^(
    3.5) + b[5]*tau^(4) + b[6]*tau^(7.5))/(1 - tau));
  psat := psat_v*pi;
end saturationPressure_Conde;
