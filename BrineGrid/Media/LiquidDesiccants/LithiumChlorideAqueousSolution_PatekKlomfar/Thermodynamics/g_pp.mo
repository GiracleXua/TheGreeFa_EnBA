within BrineGrid.Media.LiquidDesiccants.LithiumChlorideAqueousSolution_PatekKlomfar.Thermodynamics;
function g_pp "Second derivative of 'g' with respect to pressure"
  extends Modelica.Icons.Function;
  input Real pi;
  input Real tau;
  input Real delta;
  output Der2GibbsByPressure2 g_pp;
protected
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
  Temperature T=T_crit/tau;
  AbsolutePressure p=pi*p_crit;
  MoleFraction Y=delta/(1 + delta);
algorithm
  g_pp := (1 - Y)*R*T/p^2*(sum(aW[i]*mW[i]*(mW[i] - 1)*tau^nW[i]*pi^mW[i] for i in 3:nSumW) - aW[1])
          + Y*R*T/p^2*sum(aD[i]*mD[i]*(mD[i] - 1)*tau^nD[i]*pi^mD[i]*delta^(kD[i]/2) for i in 1:nSumD);
end g_pp;
