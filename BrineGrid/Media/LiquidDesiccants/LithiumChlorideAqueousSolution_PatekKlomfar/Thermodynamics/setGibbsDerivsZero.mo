within BrineGrid.Media.LiquidDesiccants.LithiumChlorideAqueousSolution_PatekKlomfar.Thermodynamics;
function setGibbsDerivsZero
  extends Modelica.Icons.Function;
  input AbsolutePressure p;
  input Temperature T;
  input MassFraction[nX] X;
  output GibbsDerivs gibbs;
protected
  constant Temperature T_crit=reference.criticalTemperature;
  constant AbsolutePressure p_crit=reference.criticalPressure;
  MoleFraction[nX] Y=massToMoleFractions(X, MMX);
  MolarMass MM=molarMass_X(X);
  Real pi(unit="1") = p/p_crit "Reduced pressure";
  Real tau(unit="1") = T_crit/T "Inverse reduced temperature";
  Real delta(unit="1") = Y[Desiccant]/(1 - Y[Desiccant]);
algorithm
  gibbs.p := p;
  gibbs.T := T;
  gibbs.Y := Y;
  gibbs.MM := MM;
  gibbs.pi := pi;
  gibbs.tau := tau;
  gibbs.delta := delta;
  gibbs.g := g(
    pi=pi,
    tau=tau,
    delta=delta);
end setGibbsDerivsZero;
