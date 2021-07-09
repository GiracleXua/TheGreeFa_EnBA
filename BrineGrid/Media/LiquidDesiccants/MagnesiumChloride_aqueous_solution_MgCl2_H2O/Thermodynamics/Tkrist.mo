within BrineGrid.Media.LiquidDesiccants.MagnesiumChloride_aqueous_solution_MgCl2_H2O.Thermodynamics;
function Tkrist "Boundary of Solubility"
  extends Modelica.Icons.Function;
  input AbsolutePressure p "Pressure";
  input Temperature T "Temperature";
  input MassFraction[nX] X "Composition";
  input MassFraction[nX] Xsat "Saturation composition";
  output crystallizationTemp Tkrist;
  constant Real[5] a=Coefficients.a_k;
  constant Real[5] b=Coefficients.b_k;
  constant Real[5] c=Coefficients.c_k;
  constant Real[5] d=Coefficients.d_k;
  constant Real[5] e=Coefficients.e_k;
protected
  constant Temperature T_crit=reference.criticalTemperature;
  constant Temperature T_ref=reference.referenceTemperature;
  MolarMass MM;
  MoleFraction[nX] Y;

algorithm
 // Y := massToMoleFractions(X=X, MMX=MMX);
 //  MM := molarMass_X(X=X);

if (X[Desiccant]<= 0.209) then

 TKrist:=(a[1] + b[1]*Xsat[Desiccant] + c[1]*Xsat[Desiccant]^2 + d[1]*Xsat[Desiccant]^3 +
    e[1]*Xsat[Desiccant]^4)*T_crit;

elseif  (X[Desiccant] > 0.209) and (X[Desiccant]<= 0.297) then

  TKrist:=(a[2] + b[2]*Xsat[Desiccant] + c[2]*Xsat[Desiccant]^2 + d[2]*Xsat[Desiccant]^3 +
    e[2]*Xsat[Desiccant]^4)*T_crit;

elseif  (X[Desiccant] > 0.297) and (X[Desiccant]<= 0.345) then

  TKrist:=(a[2] + b[3]*Xsat[Desiccant] + c[3]*Xsat[Desiccant]^2 + d[3]*Xsat[Desiccant]^3 +
    e[3]*Xsat[Desiccant]^4)*T_crit;

elseif  (X[Desiccant] > 0.345) and (X[Desiccant]<= 0.474) then

  TKrist:=(a[4] + b[4]*Xsat[Desiccant] + c[4]*Xsat[Desiccant]^2 + d[4]*Xsat[Desiccant]^3 +
    e[4]*Xsat[Desiccant]^4)*T_crit;

elseif  (X[Desiccant] > 0.474) and (X[Desiccant]<= 0.563) then

  TKrist:=(a[5] + b[5]*Xsat[Desiccant] + c[5]*Xsat[Desiccant]^2 + d[5]*Xsat[Desiccant]^3 +
    e[5]*Xsat[Desiccant]^4)*T_crit;

else
  TKrist:=(a[6] + b[6]*Xsat[Desiccant] + c[6]*Xsat[Desiccant]^2 + d[6]*Xsat[Desiccant]^3 +
    e[6]*Xsat[Desiccant]^4)*T_crit;

end if;

end Tkrist;
