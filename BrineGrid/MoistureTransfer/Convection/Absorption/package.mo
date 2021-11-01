within BrineGrid.MoistureTransfer.Convection;
package Absorption
  extends Modelica.Icons.VariantsPackage;


















  model Sh_EnBA_M_dempav

    extends BaseClasses.PartialConvectionAbsorption;
    parameter BrineGrid.SIunits.CoefficientOfMassTransfer2 beta0=0.03
      "Start value for mass transfer coefficient in kg/(m2.s)";

    Medium_a.Density rho_a=Medium_a.density(state=inflow_a)
      "Density of medium a at inlet";
    Medium_a.DynamicViscosity eta_a=Medium_a.dynamicViscosity(state=inflow_a)
      "Dynamic viscosity of medium a at inlet";
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

    BrineGrid.SIunits.CoefficientOfMassTransfer2 beta(start=beta0)
      "Mass transfer coefficient in kg/(m2.s)";
    BrineGrid.SIunits.SherwoodNumber Sh "Sherwood number";
    Modelica.SIunits.SchmidtNumber Sc "Schmidt number";
    Modelica.SIunits.ReynoldsNumber Re "Reynolds number";
    Real [6] param_sh = {37.50582832, 1.65375097, 0.3333, 0.75740064, 1.30987467, 0.10190975};

  equation
    Sc = BrineGrid.Fluid.Functions.CharacteristicNumbers.SchmidtNumber(
      eta=eta_a,
      rho=rho_a,
      D=D_air);
    Re = BrineGrid.Fluid.Functions.CharacteristicNumbers.ReynoldsNumber_m_flow(
      m_flow=m_flow_in_a/epsilon,
      eta=eta_a,
      L=deq,
      A=crossArea);
    Sh = (param_sh[1])*(Re/2300)^(param_sh[2])*Sc^(param_sh[3])*(m_flow_in_b/m_flow_in_a)^(param_sh[4])*(1 - x_eq/x)^(param_sh[5])*((T_b - 273.15)/(T_a - 273.15))^(param_sh[6]);
    beta =
      BrineGrid.Fluid.Functions.CharacteristicNumbers.beta_from_SherwoodNumber_rho(
      Sh=Sh,
      L=deq,
      D=D_air,
      rho=rho_a);
    m_flow = beta*surface*(moisturePort_a.X - moisturePort_b.X);

  end Sh_EnBA_M_dempav;

annotation (Documentation(info="<html>
<p>This package provides models to compute the convective mass transfer in absorption processes. </p>
</html>"));
end Absorption;
