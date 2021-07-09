within BrineGrid.Media.LiquidDesiccants.LithiumBromideAqueousSolution_PatekKlomfar.Thermodynamics;
function cp
  "Calculate specific heat capacity cp from temperature T and composition X"
  extends Modelica.Icons.Function;
  //input AbsolutePressure p "Pressure";
  input Temperature T "Temperature";
  input MassFraction[nX] X "Composition";
  output SpecificHeatCapacity cp "Specific heat capacity";
protected
  constant Real[5] b=Coefficients.b_cp;
  constant Real[5] c=Coefficients.c_cp;
  constant Real[5] d=Coefficients.d_cp;
  constant Real[8] a=Coefficients.a_cp;
  constant Real[8] m=Coefficients.m_cp;
  constant Real[8] n=Coefficients.n_cp;
  constant Real[8] t=Coefficients.t_cp;
  constant Temperature T_crit=reference.criticalTemperature;
  constant Temperature T_ref=reference.referenceTemperature;
  constant Temperature T_triple=reference.triplePointTemperature;
  constant MolarEntropy s_crit=reference.criticalMolarEntropy;
  constant MolarHeatCapacity cp_triple=reference.triplePointMolarHeatCapacity;
  MolarHeatCapacity cpM_W "Molar heat capacity of water";
  MolarMass MM;
  MoleFraction[nX] Y;
  Real polyWater;
  Real polyBrine;
algorithm
  Y := massToMoleFractions(X=X, MMX=MMX);
  MM := molarMass_X(X=X);
  polyWater := sum(b[i]*(1 - T/T_crit)^c[i]*(T/T_triple)^d[i] for i in 1:size(b, 1));
  cpM_W := cp_triple*polyWater;
  polyBrine := sum(a[i]*Y[Desiccant]^m[i]*max(0.4 - Y[Desiccant], Modelica.Constants.small)^n[i]*(T_crit/(T - T_ref))^t[i] for i in 1:size(a, 1));
  cp := (Y[Water]*cpM_W + cp_triple*polyBrine)/MM;
end cp;
