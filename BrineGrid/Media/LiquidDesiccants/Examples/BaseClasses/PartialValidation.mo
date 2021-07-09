within BrineGrid.Media.LiquidDesiccants.Examples.BaseClasses;
partial model PartialValidation
  extends Modelica.Icons.Example;
  replaceable package Medium =
      BrineGrid.Media.Examples.PartialGeneralBrineMedia   constrainedby
    BrineGrid.Media.Examples.PartialGeneralBrineMedia
    "Medium model"
    annotation (choicesAllMatching=true);
  parameter Medium.Temperature T=350;
  parameter Medium.AbsolutePressure p=101325;

  parameter BrineGrid.Media.LiquidDesiccants.Types.Molality b = 1;
  //final parameter Medium.MassFraction X[2] = BrineGrid.Media.LiquidDesiccants.Functions.MolalityToMassFraction(b=b, MMX = Medium.MMX);
  parameter Medium.MoleFraction[Medium.nX] Y={0.8, 0.2};
  final parameter Medium.MassFraction[Medium.nX] X=Medium.moleToMassFractions(moleFractions=Y, MMX=Medium.MMX);

  Medium.BaseProperties base(
    p(start=p),
    T(start=T),
    h(start=h_start),
    X(start=X_start),
    preferredMediumStates=true);
  Medium.ThermodynamicState state;
  Medium.DynamicViscosity eta;
  Medium.ThermalConductivity lambda;
  Medium.AbsolutePressure psat;
  Medium.SaturationProperties sat_TX;
  // Molar properties for validation
  Medium.MolarMass MM;
  Medium.MolarMass[Medium.nX] MMX = Medium.MMX;
  Modelica.SIunits.MolarEnthalpy h;
  Modelica.SIunits.SpecificEnthalpy h_spec;
  Modelica.SIunits.MolarEntropy s;
  Modelica.SIunits.MolarDensity d;
  Modelica.SIunits.MolarHeatCapacity cp;
protected
  parameter Medium.SpecificEnthalpy h_start=Medium.specificEnthalpy_pTX(
      p,
      T,
      X_start) "Start value of specific enthalpy";
  parameter Medium.MassFraction[Medium.nX] X_start=Medium.X_default
    "Start value of composition";
equation
  state = Medium.setState_pTX(p=p, T=T, X=X);
  MM = Medium.molarMass(state=state);
  cp = Medium.specificHeatCapacityCp(state=state);
  h_spec = BrineGrid.Media.LiquidDesiccants.Functions.MolarEnthalpyToSpecificEnthalpy(
   h_molar = h, MMX = MMX, Y=Y);
  //for solution, the molar mass of water should be considered
  h = Medium.specificEnthalpy(state=state)*MM;
  s = Medium.specificEntropy(state=state)*MM;
  d = Medium.density(state=state)/MM;
  eta = Medium.dynamicViscosity(state=state);
  lambda = Medium.thermalConductivity(state=state);

  sat_TX = Medium.setSat_TX(Tsat=T, Xsat=X);
  psat = Medium.saturationPressure(Tsat=T, Xsat=X);

  base.T = T;
  base.p = p;
  base.X[1] = X[1];
  annotation (Documentation(revisions="<html>
<ul>
<li>
January 04, 2017, by Yannick Fuerst:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>Partial model for the aqueous solution validation model. </p>
</html>"));
end PartialValidation;
