within BrineGrid.Media.LiquidDesiccants.LithiumChlorideAqueousSolution_PatekKlomfar.Thermodynamics;
record GibbsDerivs "Molar gibbs function and its derivatives"
  extends Modelica.Icons.Record;
  MolarMass MM "Molar mass of solution";
  SpecificHeatCapacity R=Modelica.Constants.R "Specific gas constant";
  Temperature T_crit=reference.criticalTemperature;
  AbsolutePressure p_crit=reference.criticalPressure;
  AbsolutePressure p;
  Real pi(unit="1")=p/p_crit "Reduced pressure";
  Temperature T;
  Real tau(unit="1")=T_crit/T "Inverse reduced temperature";
  MoleFraction[nX] Y;
  Real delta(unit="1")=Y[Desiccant]/(1 - Y[Desiccant]);

  MolarGibbsEnergy g "Molar gibbs enery of solution";
  DerGibbsByTemperature g_T "(dg/dT)@p,Y=const";
  DerGibbsByPressure g_p "(dg/dp)@T,Y=const";
  MolarGibbsEnergy g_Y "(dg/dY)@p,T=const";
  Der2GibbsByTemperatureByPressure g_Tp "(d2g/dTdp)@Y=const";
  DerGibbsByTemperature g_TY "(d2g/dTdY)@p=const";
  DerGibbsByPressure g_pY "(d2g/dpdY)@T=const";
  Der2GibbsByTemperature2 g_TT "(d2g/dT2)@p=const";
  Der2GibbsByPressure2 g_pp "(d2g/dp2)@T=const";

//   MolarGibbsEnergy w "Molar gibbs energy of pure water 'g_w' in liquid phase";
//   MolarGibbsEnergy wg "Molar gibbs energy of pure water 'g_w' in gaseous phase";
//   DerGibbsByTemperature wT "(dg_w/dT)@p=const";
//   DerGibbsByPressure wp "(dg_w/dp)@T=const";
//   Der2GibbsByTemperature2 wTT "(d2g_w/dT2)@p=const";
//   Der2GibbsByPressure2 wpp "(d2g_w/dp2)@T=const";
//   Der2GibbsByTemperatureByPressure wTp "(d2g_w/dTdp)";
//   MolarGibbsEnergy r
//     "Molar gibbs energy of solvate including the excess gibbs energy 'g_r'";
//   DerGibbsByTemperature rT "(dg_r/dT)@p,Y=const";
//   DerGibbsByPressure rp "(dg_r/dp)@T,Y=const";
//   Der2GibbsByTemperature2 rTT "(d2g_r/dT2)@p,Y=const";
//   Der2GibbsByPressure2 rpp "(d2g_r/dp2)@T,Y=const";
//   Der2GibbsByTemperatureByPressure rTp "(d2g_w/dTdp)";
//   MolarGibbsEnergy m "Molar gibbs energy of mixing 'g_m'";
//   DerGibbsByTemperature mT "(dg_m/dT)@p,Y=const";
//   DerGibbsByPressure mp "(dg_m/dp)@T,Y=const";
//   Der2GibbsByTemperature2 mTT "(d2g_m/dT2)@p,Y=const";
//   Der2GibbsByPressure2 mpp "(d2g_m/dp2)@T,Y=const";
//   Der2GibbsByTemperatureByPressure mTp "(d2g_w/dTdp)";
end GibbsDerivs;
