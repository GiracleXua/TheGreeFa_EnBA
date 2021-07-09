within BrineGrid.Media.LiquidDesiccants.LithiumChlorideAqueousSolution_PatekKlomfar.Thermodynamics;
function g_TY
  "Second derivative of 'g' with respect to temperature and mole fraction"
  extends Modelica.Icons.Function;
  input Real pi;
  input Real tau;
  input Real delta;
  output DerGibbsByTemperature g_TY;
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
  g_TY := -(R*(aW[1]*log(pi) + aW[2]*log(tau) - aW[2]
          + sum(aW[i]*tau^nW[i]*pi^mW[i] for i in 3:nSumW)))
          + 2*R*(log(delta) - 1
          + 0.5*sum(aD[i]*(1 - nD[i])*tau^nD[i]*pi^mD[i]*delta^(kD[i]/2) for i in 1:nSumD))
          + 2*Y*R*(-1/((Y - 1)*Y)
          - 0.5*sum(aD[i]*kD[i]/(2*(Y - 1)*Y)*(1 - nD[i])*tau^nD[i]*pi^mD[i]*delta^(kD[i]/2) for i in 1:nSumD));
end g_TY;
