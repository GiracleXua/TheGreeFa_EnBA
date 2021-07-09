within BrineGrid.Media.LiquidDesiccants.LithiumBromideAqueousSolution_PatekKlomfar.Ancillary;
function saturationPressure
  "Calculation of the saturation pressure according to the equation of Patek and Klomfar"
  extends Modelica.Icons.Function;
  input Temperature Tsat "Saturation temperature";
  input MassFraction[nX] Xsat "Saturation composition";
  output AbsolutePressure psat "Saturation pressure";
protected
  constant Real[6] b=Coefficients.b_p;
  constant Real[6] c=Coefficients.c_p;
  constant Real[8] a=Coefficients.a_p;
  constant Real[8] m=Coefficients.m_p;
  constant Real[8] n=Coefficients.n_p;
  constant Real[8] t=Coefficients.t_p;
  constant Temperature T_crit=reference.criticalTemperature;
  constant AbsolutePressure p_crit=reference.criticalPressure;
  MoleFraction[nX] Ysat;
  Temperature Theta;
  Real polyWater;
  Real polyBrine;
algorithm
  Ysat := massToMoleFractions(X=Xsat, MMX=MMX);
  polyBrine := sum(a[i]*Ysat[Desiccant]^m[i]*max(0.4 - Ysat[Desiccant], Modelica.Constants.small)^n[i]*(Tsat/T_crit)^t[i] for i in 1:size(a, 1));
  Theta := Tsat - polyBrine;
  polyWater := sum(b[i]*(1 - Theta/T_crit)^c[i] for i in 1:size(b, 1));
  psat := p_crit*exp((T_crit/Theta)*polyWater);
end saturationPressure;
