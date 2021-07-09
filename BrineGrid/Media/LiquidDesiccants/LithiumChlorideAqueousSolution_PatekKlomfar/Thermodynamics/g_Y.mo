within BrineGrid.Media.LiquidDesiccants.LithiumChlorideAqueousSolution_PatekKlomfar.Thermodynamics;
function g_Y "Derivative of 'g' with respect to mole fraction"
  extends Modelica.Icons.Function;
  input Real pi;
  input Real tau;
  input Real delta;
  output MolarGibbsEnergy g_Y;
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
  g_Y := R*T*(aW[1]*log(pi) + aW[2]*log(tau) + sum(aW[i]*tau^nW[i]*pi^mW[i] for i in 3:nSumW))
         - 2*R*T*delta*(1 + 0.5*sum(aD[i]*kD[i]*0.5*tau^nD[i]*pi^mD[i]*delta^(kD[i]/2) for i in 1:nSumD));
  /*g_Y := -(R*T*(aW[1]*log(pi) + aW[2]*log(tau) + sum(aW[i]*tau^nW[i]*pi^mW[i] for i in 3:nSumW)))
         + 2*R*T*(log(delta) - 1 + 0.5*sum(aD[i]*tau^nD[i]*pi^mD[i]*delta^(kD[i]/2) for i in 1:nSumD)
         + 1/(1 - Y)*(1 + 0.5*sum(aD[i]*kD[i]/2*tau^nD[i]*pi^mD[i]*delta^(kD[i]/2) for i in 1:nSumD)));*/
end g_Y;
