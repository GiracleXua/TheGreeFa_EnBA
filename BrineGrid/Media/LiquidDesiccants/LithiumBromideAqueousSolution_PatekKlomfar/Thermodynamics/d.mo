within BrineGrid.Media.LiquidDesiccants.LithiumBromideAqueousSolution_PatekKlomfar.Thermodynamics;
function d "Calculate density d from temperature T and composition X"
  extends Modelica.Icons.Function;
  //input AbsolutePressure p "Pressure";
  input Temperature T "Temperature";
  input MassFraction[nX] X "Composition";
  output Density d "Density";
protected
  constant Real[6] b=Coefficients.b_d;
  constant Real[6] c=Coefficients.c_d;
  constant Real[2] a=Coefficients.a_d;
  constant Real[2] m=Coefficients.m_d;
  constant Real[2] t=Coefficients.t_d;
  constant Temperature T_crit=reference.criticalTemperature;
  constant Temperature T_ref=reference.referenceTemperature;
  constant MolarDensity d_crit=reference.criticalMolarDensity;
  MolarDensity dM_W "Molar density";
  MolarMass MM;
  MoleFraction[nX] Y;
  Real polyWater;
  Real polyBrine;
algorithm
  Y := massToMoleFractions(X=X, MMX=MMX);
  MM := molarMass_X(X=X);
  polyWater := sum(b[i]*(1 - T/T_crit)^c[i] for i in 1:size(b, 1));
  dM_W := d_crit*(1 + polyWater); // density of pure water at saturated liquid state
  polyBrine := sum(a[i]*Y[Desiccant]^m[i]*(T/T_crit)^t[i] for i in 1:size(a, 1));
  d := (Y[Water]*dM_W + d_crit*polyBrine)*MM;
  annotation (derivative=d_der);
end d;
