within BrineGrid.Media.LiquidDesiccants.LithiumBromideAqueousSolution_PatekKlomfar.Ancillary;
function dpT
  "Derivative of saturation pressure p with respect to temperature T"
  extends Modelica.Icons.Function;
  input Temperature Tsat "Saturation temperature";
  input MassFraction[nX] Xsat "Saturation composition";
  output DerPressureByTemperature dpT;
protected
  constant Real[6] b=Coefficients.b_p;
  constant Real[6] c=Coefficients.c_p;
  constant Real[8] a=Coefficients.a_p;
  constant Real[8] m=Coefficients.m_p;
  constant Real[8] n=Coefficients.n_p;
  constant Real[8] t=Coefficients.t_p;
  constant Temperature T_crit=reference.criticalTemperature;
  constant AbsolutePressure p_crit=reference.criticalPressure;
  Temperature Theta;
  Real dThetaT;
  MoleFraction[nX] Ysat;
algorithm
  Ysat := massToMoleFractions(X=Xsat, MMX=MMX);
  Theta := Tsat - sum(a[i]*Ysat[Desiccant]^m[i]*max(0.4 - Ysat[Desiccant], Modelica.Constants.small)^n[i]*(Tsat/T_crit)^t[i] for i in 1:size(a, 1));
  dThetaT := 1 - sum(a[i]*Ysat[Desiccant]^m[i]*max(0.4 - Ysat[Desiccant], Modelica.Constants.small)^n[i]*t[i]/T_crit*(Tsat/T_crit)^(t[i] - 1) for i in 1:size(a, 1));
  dpT := dThetaT*(-T_crit/Theta^2*sum(b[i]*(1 - Theta/T_crit)^c[i] for i in 1:size(b, 1))
    - T_crit/Theta*sum(b[i]*c[i]/T_crit*(1 - Theta/T_crit)^(c[i] - 1)
    for i in 1:size(b, 1)))*p_crit*exp(T_crit/Theta*sum(b[i]*(1
    - Theta/T_crit)^c[i] for i in 1:size(b, 1)));
end dpT;
