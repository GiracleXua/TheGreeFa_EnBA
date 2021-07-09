within BrineGrid.Media.LiquidDesiccants.MagnesiumChloride_aqueous_solution_MgCl2_H2O.Thermodynamics;
function d "Calculate density d from temperature T and composition X"
  extends Modelica.Icons.Function;
  //input AbsolutePressure p "Pressure";
  input Temperature T "Temperature";
  input MassFraction[nX] X "Composition";
  output Density d "Density";

  //constant Temperature T_crit=reference.criticalTemperature;
protected
  constant Temperature T_ref=reference.referenceTemperature;
  constant MolarDensity d_crit=reference.criticalMolarDensity;

 constant Real d1= 0.108;
 constant Real d2= 8.68E-4;
 constant Real d3= 0.6802;
 constant Real d4= 4.928E-4;

  MolarDensity dM_W "Molar density";
  MolarMass MM;
  MoleFraction[nX] Y;
  Real polyWater;
  Real polyBrine;

  Real d_red;
  Real tau;
  Real rho;
  constant Real rho_crit = 322;
  constant Real T_crit =   647.022;

algorithm
  Y := massToMoleFractions(X=X, MMX=MMX);
  MM := molarMass_X(X=X);

  tau  := 1-(T/T_crit);
  rho := rho_crit*(1+1.9937718430*tau^(1/3)+1.0985211604*tau^(2/3)-0.5094492996*tau^(5/3)-1.7619124270*tau^(16/3)
  -44.9005480267*tau^(43/3) -723692.2618632*tau^(110/3));

  d_red := (d1 + d2 * T)* X[Desiccant]^2 + (d3 + d4 * T)* X[Desiccant] + 1;
  d := (d_red * rho);

  annotation (
  smoothOrder=2,
      Inline=true);
end d;
