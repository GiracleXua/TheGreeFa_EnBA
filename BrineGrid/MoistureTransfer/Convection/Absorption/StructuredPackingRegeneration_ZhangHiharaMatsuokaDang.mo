within BrineGrid.MoistureTransfer.Convection.Absorption;
model StructuredPackingRegeneration_ZhangHiharaMatsuokaDang
  "Structured packing: Convective mass transfer correlation from Zhang, Hihara, Matsuoka and Dang for regeneration"
  extends BaseClasses.PartialConvectionAbsorption;
  parameter BrineGrid.SIunits.CoefficientOfMassTransfer2 beta0=0.03
    "Start value for mass transfer coefficient in kg/(m2.s)";

  Medium_a.Density rho_a=Medium_a.density(state=inflow_a)
    "Density of medium a at inlet";
  Medium_b.Density rho_b=Medium_b.density(state=inflow_b)
    "Density of medium b at inlet";
  Medium_a.DynamicViscosity eta_a=Medium_a.dynamicViscosity(state=inflow_a)
    "Dynamic viscosity of medium a at inlet";
  Medium_b.DynamicViscosity eta_b=Medium_b.dynamicViscosity(state=inflow_b)
    "Dynamic viscosity of medium b at inlet";
  Modelica.SIunits.DiffusionCoefficient D_air=
    Media.LiquidDesiccants.Functions.diffusionCoefficientWaterAir(
      p=p_a,
      T=T_a)
    "Diffusion coefficient of water vapour in air at inlet";
  Modelica.SIunits.DiffusionCoefficient D_abs=Medium_b.diffusionCoefficient(state=inflow_b)
    "Diffusion coefficient of water in LiCl solution";

  BrineGrid.SIunits.CoefficientOfMassTransfer2 beta(start=beta0)
    "Mass transfer coefficient in kg/(m2.s)";
  BrineGrid.SIunits.SherwoodNumber Sh "Sherwood number";
  Modelica.SIunits.ReynoldsNumber Re_a "Reynolds number of medium a";
  Modelica.SIunits.SchmidtNumber Sc_a "Schmidt number of medium a";
  Modelica.SIunits.ReynoldsNumber Re_b "Reynolds number of medium b";
  Modelica.SIunits.SchmidtNumber Sc_b "Schmidt number of medium b";
equation
  Re_a = BrineGrid.Fluid.Functions.CharacteristicNumbers.ReynoldsNumber_m_flow(
    m_flow=m_flow_in_a/epsilon,
    eta=eta_a,
    L=deq,
    A=crossArea);
  Re_b = BrineGrid.Fluid.Functions.CharacteristicNumbers.ReynoldsNumber_m_flow(
    m_flow=m_flow_in_b/epsilon,
    eta=eta_b,
    L=deq,
    A=crossArea);
  Sc_a = BrineGrid.Fluid.Functions.CharacteristicNumbers.SchmidtNumber(
    eta=eta_a,
    rho=rho_a,
    D=D_air);
  Sc_b = BrineGrid.Fluid.Functions.CharacteristicNumbers.SchmidtNumber(
    eta=eta_b,
    rho=rho_b,
    D=D_abs);
  Sh = 0.0038*Re_a^(0.39)*Sc_a^(0.33)*Re_b^(0.39)*Sc_b^(0.33);
  beta = Sh*D_air*rho_a/deq;
  m_flow = beta*surface*(moisturePort_a.X - moisturePort_b.X);
  annotation (Documentation(info="<html>
<p>This model calculates the convective mass transfer coeffcient &beta; between moist air and aqueous solutions.
The correlation is valid for</p>
<ul>
<li>structured packings,</li>
<li>regeneration processes and</li>
<li>lithium chloride as desiccant. </li>
</ul>

<p><br><span style=\"color: #ff0000;\">This correlation is not yet validated.</span></p>

<h4>References</h4>
<dl><dt>Zhang, L., Hihara, E., Matsuoka, F., Dang, C.:</dt>
<dd><b>Experimental analysis of mass transfer in adiabatic structured packing dehumidifier/regenerator with liquid desiccant</b><br>
International Journal of Heat and Mass Transfer 53, p. 2856-2863 (2010)<br>
DOI: <a href=\"http://dx.doi.org/10.1016/j.ijheatmasstransfer.2010.02.012\">10.1016/j.ijheatmasstransfer.2010.02.012</a>
</dd></dl>
</html>", revisions="<html>
<ul>
<li>
January 04, 2017, by Yannick Fuerst:<br/>
First implementation.
</li>
</ul>
</html>"));
end StructuredPackingRegeneration_ZhangHiharaMatsuokaDang;
