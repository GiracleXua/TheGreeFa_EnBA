within BrineGrid.Media.LiquidDesiccants.LithiumBromideAqueousSolution_PatekKlomfar.Thermodynamics;
function dhT "Derivative of specific enthalpy h with respect to temperature T"
  extends Modelica.Icons.Function;
  //input AbsolutePressure p "Pressure";
  input Temperature T "Temperature";
  input MassFraction[nX] X "Composition";
  output DerEnthalpyByTemperature dhT;
protected
  constant Real[4] b=Coefficients.b_h;
  constant Real[4] c=Coefficients.c_h;
  constant Real[30] a=Coefficients.a_h;
  constant Real[30] m=Coefficients.m_h;
  constant Real[30] n=Coefficients.n_h;
  constant Real[30] t=Coefficients.t_h;
  constant Temperature T_crit=reference.criticalTemperature;
  constant Temperature T_ref=reference.referenceTemperature;
  constant MolarEnthalpy h_crit=reference.criticalMolarEnthalpy;
  DerEnthalpyByTemperature hM_W "Molar enthalpy of water";
  MolarMass MM;
  MoleFraction[nX] Y;
  Real polyWater;
  Real polyBrine;
algorithm
  Y := massToMoleFractions(X=X, MMX=MMX);
  MM := molarMass_X(X=X);
  polyWater := sum(b[i]*c[i]/T_crit*(1 - T/T_crit)^(c[i] - 1) for i in 1:size(b, 1));
  polyBrine := sum(a[i]*t[i]/(T - T_ref)*Y[Desiccant]^m[i]*max(0.4 - Y[Desiccant], Modelica.Constants.small)^n[i]*(T_crit/(T - T_ref))^t[i] for i in 1:size(a, 1));
  hM_W := h_crit*polyWater;
  dhT := (Y[Water]*hM_W + h_crit*polyBrine)/MM;
end dhT;
