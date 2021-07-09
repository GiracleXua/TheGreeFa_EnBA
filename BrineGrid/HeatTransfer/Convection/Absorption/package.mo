within BrineGrid.HeatTransfer.Convection;
package Absorption
  extends Modelica.Icons.VariantsPackage;










  model ConstantNusseltNumber_Absorption "constant nusselt numbe for absorption"
    extends BaseClasses.PartialConvectionAbsorption;
    parameter Modelica.SIunits.CoefficientOfHeatTransfer alpha0=10
      "Start value for heat transfer coefficient";
    parameter Modelica.SIunits.NusseltNumber Nu0=250 "Nusselt number";

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

    Modelica.SIunits.PrandtlNumber Pr "Prandtl number";
    Modelica.SIunits.ReynoldsNumber Re "Reynolds number";

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

    alpha = Fluid.Functions.CharacteristicNumbers.alpha_from_NusseltNumber(
      Nu=Nu0,
      L=deq,
      lambda=lambda_a);
    Q_flow = alpha*surface*(heatPort_a.T - heatPort_b.T);
    annotation (Documentation(revisions="<html>
<ul>
<li>
January 04, 2017, by Yannick Fuerst:<br/>
First implementation.
</li>
</ul>
</html>",   info="<html>
<p>Convective heat transfer model using a constant Nusselt number <i>Nu</i>  for absorption application</p>
</html>"));
  end ConstantNusseltNumber_Absorption;


  model Nu_EnBA_M_dempav

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
    Nu = (8.5907e03)*(Re/2300)^(3.456e-02)*Pr^(1.2052e+01)*(m_flow_in_b/m_flow_in_a)^(-3.007e-01)*(1 - x_eq/x)^(-5.926e-01)*((T_b - 273.15)/(T_a - 273.15))^(9.591e-02);
    alpha = Fluid.Functions.CharacteristicNumbers.alpha_from_NusseltNumber(
      Nu=Nu,
      lambda=lambda_a,
      L=deq);
    Q_flow = alpha*surface*(heatPort_a.T - heatPort_b.T);

  end Nu_EnBA_M_dempav;

annotation (Documentation(info="<html>
<p>This package provides models to compute the convective heat transfer in absorption processes. </p>
</html>"));
end Absorption;
