within BrineGrid.Media.LiquidDesiccants.LithiumChlorideAqueousSolution_PatekKlomfar.Thermodynamics;
function mu "Calculate molar chemical potential mu of water in solution"
  extends Modelica.Icons.Function;
  input Temperature T "Temperature";
  input AbsolutePressure p "Pressure";
  input MassFraction[:] X "Composition";
  output MolarEnergy mu;
protected
  MassFraction[nX] Xfull=if size(X, 1) == nX then X else cat(
        1,
        X,
        {1 - sum(X)});
  MoleFraction[nX] Y=massToMoleFractions(Xfull, MMX);
  constant SpecificHeatCapacity R=Modelica.Constants.R "Specific gas constant";
  constant Temperature T_crit=reference.criticalTemperature;
  constant AbsolutePressure p_crit=reference.criticalPressure;
  constant Integer nSumW=size(GibbsCoeff.aWL, 1);
  constant Real[nSumW] aW=GibbsCoeff.aWL;
  constant Real[nSumW] nW=GibbsCoeff.nWL;
  constant Real[nSumW] mW=GibbsCoeff.mWL;
  constant Integer nSumD=size(GibbsCoeff.aD, 1);
  constant Real[nSumD] aD=GibbsCoeff.aD;
  constant Real[nSumD] nD=GibbsCoeff.nD;
  constant Real[nSumD] mD=GibbsCoeff.mD;
  constant Real[nSumD] kD=GibbsCoeff.kD;
  Real pi(unit="1")=p/p_crit "Reduced pressure";
  Real tau(unit="1")=T_crit/T "Inverse reduced temperature";
  Real delta(unit="1")=Y[Desiccant]/(1 - Y[Desiccant]);
algorithm
  mu := R*T*(aW[1]*log(pi) + aW[2]*log(tau) + sum(aW[i]*tau^nW[i]*pi^mW[i] for i in 3:nSumW))
        - 2*R*T*delta*(1 + 0.5*sum(aD[i]*kD[i]*0.5*tau^nD[i]*pi^mD[i]*delta^(kD[i]/2) for i in 1:nSumD));
end mu;
