within BrineGrid.Media.LiquidDesiccants.MagnesiumChloride_aqueous_solution_MgCl2_H2O.Thermodynamics;
function s
  "Calculate specific entropy s from temperature T and composition X"
  extends Modelica.Icons.Function;
  //input AbsolutePressure p "Pressure";
  input Temperature T "Temperature";
  input MassFraction[nX] X "Composition";
  output SpecificEntropy s "Specific entropy";
protected
  constant Real[4] b=Coefficients.b_s;
  constant Real[4] c=Coefficients.c_s;
  constant Real[29] a=Coefficients.a_s;
  constant Real[29] m=Coefficients.m_s;
  constant Real[29] n=Coefficients.n_s;
  constant Real[29] t=Coefficients.t_s;
  constant Temperature T_crit=reference.criticalTemperature;
  constant Temperature T_ref=reference.referenceTemperature;
  constant MolarEntropy s_crit=reference.criticalMolarEntropy;
  MolarEntropy sM_W "Molar entropy of water";
  MolarMass MM;
  MoleFraction[nX] Y;
  Real polyWater;
  Real polyBrine;
algorithm
  Y := massToMoleFractions(X=X, MMX=MMX);
  MM := molarMass_X(X=X);
  polyWater := sum(b[i]*(1 - T/T_crit)^c[i] for i in 1:size(b, 1));
  sM_W := s_crit*(1 + polyWater);
  polyBrine := sum(a[i]*Y[Desiccant]^m[i]*max(0.4 - Y[Desiccant], Modelica.Constants.small)^n[i]*(T_crit/(T - T_ref))^t[i] for i in 1:size(a, 1));
  s := (Y[Water]*sM_W + s_crit*polyBrine)/MM;
  //s := 195;

end s;
