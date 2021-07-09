within BrineGrid.Media.LiquidDesiccants.LithiumBromideAqueousSolution_PatekKlomfar.Thermodynamics;
function ddY "Derivative of density d with respect to composition Y"
  extends Modelica.Icons.Function;
  //input AbsolutePressure p "Pressure";
  input Temperature T "Temperature";
  input MassFraction[nX] X "Mass fractions of composition";
  output Density ddY;
protected
  constant Temperature T_crit=reference.criticalTemperature;
  constant Temperature T_ref=reference.referenceTemperature;
  constant MolarDensity d_crit=reference.criticalMolarDensity;
  constant Real[6] b=Coefficients.b_d;
  constant Real[6] c=Coefficients.c_d;
  constant Real[2] a=Coefficients.a_d;
  constant Real[2] m=Coefficients.m_d;
  constant Real[2] t=Coefficients.t_d;
  MolarMass MM;
  MoleFraction[nX] Y;
  MolarDensity dM_W "Molar density";
  Real polyBrine;
  Real polyWater;
algorithm
  Y := massToMoleFractions(X=X, MMX=MMX);
  MM := molarMass_X(X=X);
  polyBrine := sum(a[i]*m[i]*Y[Desiccant]^(m[i] - 1)*(T/T_crit)^t[i] for i in 1:size(a, 1));
  polyWater := sum(b[i]*(1 - T/T_crit)^c[i] for i in 1:size(b, 1));
  dM_W := d_crit*(1 + polyWater);
  ddY := (-dM_W + d_crit*polyBrine)*MM;
end ddY;
