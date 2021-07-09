within BrineGrid.HeatTransfer.Convection.Absorption;
model RandomPackings_ChenZhangYin
  "Structured packings: Convective heat transfer correlation from Chen, Zhang and Yin"
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
  Nu = 4.7756e-5*Re^(1.7936)*Pr^(0.3333)*(m_flow_in_b/m_flow_in_a)^(-1.001)*(1 - x_eq/x)^(0.8198)*((T_b - 273.15)/(T_a - 273.15))^(0.3846);
  alpha = Fluid.Functions.CharacteristicNumbers.alpha_from_NusseltNumber(
    Nu=Nu,
    lambda=lambda_a,
    L=deq);
  Q_flow = alpha*surface*(heatPort_a.T - heatPort_b.T);
  annotation (Documentation(info="<html>
<p>This model calculates the convective heat transfer coeffcient &alpha; between moist air and lithium chloride aqueous solutions.
The correlation is valid for <b>random packings</b>.</p>

<h4>References</h4>

<dl><dt>Chen, Y., Zhang, X., Yin, Y.:</dt>
<dd><b>Experimental and theoretical analysis of liquid desiccant dehumidification process
based on an advanced hybrid air-conditioning system</b><br>
Applied Thermal Engineering 98, p. 387-399 (2016)<br>
DOI: <a href=\"http://dx.doi.org/10.1016/j.applthermaleng.2015.12.066\">10.1016/j.applthermaleng.2015.12.066</a>
</dd></dl>
</html>",      revisions="<html>
<ul>
<li>
January 04, 2017, by Yannick Fuerst:<br/>
First implementation.
</li>
</ul>
</html>"));
end RandomPackings_ChenZhangYin;
