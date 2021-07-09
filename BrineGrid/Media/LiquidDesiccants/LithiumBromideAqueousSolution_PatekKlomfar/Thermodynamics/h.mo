within BrineGrid.Media.LiquidDesiccants.LithiumBromideAqueousSolution_PatekKlomfar.Thermodynamics;
function h "Calculate specific enthalpy h from temperature T and composition X"
  extends Modelica.Icons.Function;
  //input AbsolutePressure p "Pressure";
  input Temperature T "Temperature";
  input MassFraction[nX] X "Composition";
  output SpecificEnthalpy h "Specific enthalpy";
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
  MolarEnthalpy hM_W "Molar enthalpy of water at Saturation";
  MolarMass MM;
  MoleFraction[nX] Y;
  Real polyWater;
  Real polyBrine;
algorithm
  Y := massToMoleFractions(X=X, MMX=MMX);
  MM := molarMass_X(X=X);
  polyWater := sum(b[i]*(1 - T/T_crit)^c[i] for i in 1:size(b, 1));
  hM_W := h_crit*(1 + polyWater);
  polyBrine := sum(a[i]*Y[Desiccant]^m[i]*(0.4 - Y[Desiccant])^n[i]*(T_crit/(T - T_ref))^t[i] for i in 1:size(a, 1));
  h := (Y[Water]*hM_W + h_crit*polyBrine)/MM; // equation (4) in J.Patek for LiBr
  annotation (
    derivative = h_der,
    inverse=T(h, X));
end h;
