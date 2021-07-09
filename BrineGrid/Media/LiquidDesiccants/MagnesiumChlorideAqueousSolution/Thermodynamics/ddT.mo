within BrineGrid.Media.LiquidDesiccants.MagnesiumChlorideAqueousSolution.Thermodynamics;
function ddT "Derivative of density d with respect to temperature T"
  extends Modelica.Icons.Function;
  //input AbsolutePressure p "Pressure";
  input Temperature T "Temperature";
  input MassFraction[nX] X "Mass fractions of composition";
  output DerDensityByTemperature ddT;
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
  Real polyBrine;
  Real polyWater;
algorithm
  Y := massToMoleFractions(X=X, MMX=MMX);
  MM := molarMass_X(X=X);
  polyBrine := sum(a[i]*t[i]/T_crit*Y[Desiccant]^m[i]*(T/T_crit)^(t[i] - 1) for i in 1:size(a, 1));
  polyWater := sum(b[i]*c[i]/T_crit*(1 - T/T_crit)^(c[i] - 1) for i in 1:size(b, 1));
  ddT := (-Y[Water]*d_crit*polyWater + d_crit*polyBrine)*MM;
end ddT;
