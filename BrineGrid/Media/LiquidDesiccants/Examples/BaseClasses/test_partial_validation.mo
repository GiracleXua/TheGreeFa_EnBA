within BrineGrid.Media.LiquidDesiccants.Examples.BaseClasses;
partial model test_partial_validation
  extends Modelica.Icons.Example;
  replaceable package Medium =
    BrineGrid.Media.Examples.PartialGeneralBrineMedia   constrainedby
    BrineGrid.Media.Examples.PartialGeneralBrineMedia;
  parameter Medium.Temperature T = 450;
  parameter Medium.AbsolutePressure p = 101325;
  parameter Medium.MoleFraction[Medium.nX] Y={0.9, 0.1};
  final parameter Medium.MassFraction[Medium.nX] X = Medium.moleToMassFractions(moleFractions = Y, MMX=Medium.MMX);

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

  Medium.MolarMass MM; // kg/mol
  Modelica.SIunits.MolarEnthalpy h;
  Modelica.SIunits.MolarEntropy s;
  Modelica.SIunits.MolarDensity d;
  Modelica.SIunits.MolarHeatCapacity cp; // J/(mol * K)

protected
  parameter Medium.SpecificEnthalpy h_start = Medium.specificEnthalpy_pTX(p,T,X_start);
  parameter Medium.MassFraction[Medium.nX] X_start=Medium.X_default;

equation
  state = Medium.setState_pTX(p=p, T=T, X=X);
  MM = Medium.molarMass(state = state);
  cp = Medium.specificHeatCapacityCp(state = state)*MM; // J/(kg*K)
  h = Medium.specificEnthalpy(state = state)*MM;
  s = Medium.specificEntropy(state = state)*MM;
  d = Medium.density(state = state)/MM; // (mol/m3)
  eta = Medium.dynamicViscosity(state = state);
  lambda = Medium.thermalConductivity(state=state);

  sat_TX = Medium.setSat_TX(Tsat=T, Xsat = X);
  psat = Medium.saturationPressure(Tsat=T, Xsat=X);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(
          preserveAspectRatio=false)));
end test_partial_validation;
