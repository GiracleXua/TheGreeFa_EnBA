within BrineGrid.Media.LiquidDesiccants.MagnesiumChloride_aqueous_solution_MgCl2_H2O.Ancillary;
function dynamicViscosity
  "Calculation of dynamic viscosity from temperature T and composition X"
  extends Modelica.Icons.Function;
  input Temperature T "Temperature";
  input MassFraction[nX] X "Composition";
  output DynamicViscosity eta "Dynamic viscosity";
  //constant Temperature T_crit=BrineGrid.Media.Interfaces.PartialGeneralBrineMedia.reference.criticalTemperature;
 // constant Real[4] n=MagnesiumChlorideAqueousSolution.Ancillary.Coefficients.adjustedDynamicViscosity;
protected
  Real Theta;
  Real Zeta;

  constant Real dv1= 0.911;
 constant Real dv2= 12.88;
 constant Real dv3= 1.770;
 constant Real dv4= -1.415;
 MolarMass MM;

 Real visc_water;
 Real visc_rel;
 // Real visc;

algorithm
 // MM := Interfaces.PartialGeneralBrineMediaMgCl2_H2O.molarMass_X(X=X);

  visc_water  := 1000*((4.2844e-5) + (0.157*((T-273.15 + 64.993)^2) - 91.296)^(-1));

  visc_rel    := exp(0.911 + 12.88*X[Desiccant]^1.77 - 1.415*T/647);
  eta := visc_rel*(visc_water/1000);

end dynamicViscosity;
