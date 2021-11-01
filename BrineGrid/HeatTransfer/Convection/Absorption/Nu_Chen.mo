within BrineGrid.HeatTransfer.Convection.Absorption;
model Nu_Chen

  extends BaseClasses.PartialConvectionAbsorption;
  parameter Modelica.SIunits.CoefficientOfHeatTransfer alpha0=10
    "Start value for heat transfer coefficient";

  Medium_a.Density rho_a=Medium_a.density(state=inflow_a)
    "Density of medium a at inlet";
  Medium_a.DynamicViscosity eta_a=Medium_a.dynamicViscosity(state=inflow_a)
    "Dynamic viscosity of medium a at inlet";
  Medium_a.ThermalConductivity lambda_a=Medium_a.thermalConductivity(state=inflow_a)
    "Thermal conductivity of medium a at inlet";
  Medium_a.SpecificHeatCapacity cp_a=Medium_a.specificHeatCapacityCp(state=inflow_a)
    "Specific isobaric heat capacity of medium a at inlet";
  Modelica.SIunits.DiffusionCoefficient D_air=
    Media.LiquidDesiccants.Functions.diffusionCoefficientWaterAir(
      p=p_a,
      T=T_a)
    "Diffusion coefficient of water vapour in air at inlet";
  Medium_a.AbsolutePressure psat=Medium_b.saturationPressure(
    Tsat=T_b,
    Xsat=X_b) "Saturation pressure of moist air above desiccant";
  Medium_a.MassFraction x_eq=
    Media.LiquidDesiccants.Constants.k_mair*psat/(p_a - psat)
    "Equilibrium absolute humdity of medium a";
  Medium_a.MassFraction x=
    Media.LiquidDesiccants.Functions.massFractionToTotalHumidity(X=X_a[1])
    "Absolute humidity of medium a at inlet";

  Modelica.SIunits.CoefficientOfHeatTransfer alpha(start=alpha0)
    "Heat transfer coefficient";
  Modelica.SIunits.NusseltNumber Nu "Nusselt number";
  Modelica.SIunits.PrandtlNumber Pr "Prandtl number";
  Modelica.SIunits.ReynoldsNumber Re "Reynolds number";
  Real [6] param_Nu = {1.77227729e+2, 3.36292149, 0.3333, -1.55954852, 1.41535675e-1, 8.64910060e-1};
equation
  Pr = Fluid.Functions.CharacteristicNumbers.PrandtlNumber(
    eta=eta_a,
    cp=cp_a,
    lambda=lambda_a);
  Re = BrineGrid.Fluid.Functions.CharacteristicNumbers.ReynoldsNumber_m_flow(
    m_flow=m_flow_in_a/epsilon,
    eta=eta_a,
    L=deq,
    A=crossArea);

  Nu = (param_Nu[1])*(Re/2300)^(param_Nu[2])*Pr^(param_Nu[3])*(m_flow_in_b/m_flow_in_a)^(param_Nu[4])*(1-x_eq/x)^(param_Nu[5])*((T_b - 273.15)/(T_a - 273.15))^(param_Nu[6]);
  alpha = Fluid.Functions.CharacteristicNumbers.alpha_from_NusseltNumber(
    Nu=Nu,
    lambda=lambda_a,
    L=deq);
  Q_flow = alpha*surface*(heatPort_a.T - heatPort_b.T);

end Nu_Chen;
