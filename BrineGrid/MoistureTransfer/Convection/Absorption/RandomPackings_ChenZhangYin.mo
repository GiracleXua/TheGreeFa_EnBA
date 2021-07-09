within BrineGrid.MoistureTransfer.Convection.Absorption;
model RandomPackings_ChenZhangYin
  "Structured packings: Convective mass transfer correlation from Chen, Zhang and Yin"
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
  Sh = 7.3492e-7*Re^(2.1576)*Sc^(0.3333)*(m_flow_in_b/m_flow_in_a)^(0.5235)*(1 - x_eq/x)^(-0.8956)*((T_b - 273.15)/(T_a - 273.15))^(0.2376);
  beta =
    BrineGrid.Fluid.Functions.CharacteristicNumbers.beta_from_SherwoodNumber_rho(
    Sh=Sh,
    L=deq,
    D=D_air,
    rho=rho_a);
  m_flow = beta*surface*(moisturePort_a.X - moisturePort_b.X);
  annotation (Documentation(info="<html>
<p>This model calculates the convective mass transfer coeffcient &beta; between moist air and aqueous solutions.
The correlation is valid for <b>random packings</b>.</p>

<h4>References</h4>

<dl><dt>Chen, Y., Zhang, X., Yin, Y.:</dt>
<dd><b>Experimental and theoretical analysis of liquid desiccant dehumidification process
based on an advanced hybrid air-conditioning system
</b><br>
Applied Thermal Engineering 98, p. 387-399 (2016)<br>
DOI: <a href=\"http://dx.doi.org/10.1016/j.applthermaleng.2015.12.066\">10.1016/j.applthermaleng.2015.12.066</a>
</dd></dl>
</html>", revisions="<html>
<ul>
<li>
January 04, 2017, by Yannick Fuerst:<br/>
First implementation.
</li>
</ul>
</html>"));
end RandomPackings_ChenZhangYin;
