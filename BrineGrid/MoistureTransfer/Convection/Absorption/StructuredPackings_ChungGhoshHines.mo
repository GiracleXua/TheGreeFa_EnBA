within BrineGrid.MoistureTransfer.Convection.Absorption;
model StructuredPackings_ChungGhoshHines
  "Structured packings: Convective mass transfer correlation from Chung, Ghosh and Hines"
  extends BaseClasses.PartialConvectionAbsorption;
  parameter BrineGrid.SIunits.CoefficientOfMassTransfer4 beta0=0.03
    "Start value for mass transfer coefficient in mol/(m2.s.mole fraction)";

  Medium_a.Density rho_a=Medium_a.density(state=inflow_a)
    "Density of medium a at inlet";
  Medium_a.DynamicViscosity eta_a=Medium_a.dynamicViscosity(state=inflow_a)
    "Dynamic viscosity of medium a at inlet";
  Modelica.SIunits.DiffusionCoefficient D_air=
    Media.LiquidDesiccants.Functions.diffusionCoefficientWaterAir(
      p=p_a,
      T=T_a)
    "Diffusion coefficient of water vapour in air at inlet";
  Medium_a.MolarMass MM_a=Medium_a.molarMass(state=inflow_a)
    "Molar mass of medium one";

  BrineGrid.SIunits.CoefficientOfMassTransfer4 beta(start=beta0)
    "Mass transfer coefficient in mol/(m2.s.mole fraction)";
  BrineGrid.SIunits.SherwoodNumber Sh "Sherwood number";
  Modelica.SIunits.SchmidtNumber Sc "Schmidt number";
  Modelica.SIunits.ReynoldsNumber Re "Reynolds number";
equation
  Re = BrineGrid.Fluid.Functions.CharacteristicNumbers.ReynoldsNumber_m_flow(
    m_flow=m_flow_in_a/epsilon,
    eta=eta_a,
    L=deq,
    A=crossArea);
  Sc = BrineGrid.Fluid.Functions.CharacteristicNumbers.SchmidtNumber(
    eta=eta_a,
    rho=rho_a,
    D=D_air);
  Sh = 2.25e-4*X_b[1]^(-0.75)*(m_flow_in_b/m_flow_in_a)^(0.10)*Sc^(0.333)*Re;
  beta = Sh*D_air*rho_a/(BrineGrid.Media.LiquidDesiccants.Constants.MM_steam*deq);
  m_flow = beta*MM_a*surface*(moisturePort_a.X - moisturePort_b.X);
  annotation (Documentation(info="<html>
<p>This model calculates the convective mass transfer coeffcient &beta; between moist air and aqueous solutions.
The correlation is valid for <b>structured packings</b>.</p>

<p><br><span style=\"color: #ff0000;\">This correlation is not yet validated.</span></p>

<h4>References</h4>

<dl><dt>Chung, T.-W., Ghosh, T. K., Hines, A. L.:</dt>
<dd><b>Comparison between Random and Structured Packings for Dehumidification of Air by Lithium Chloride Solutions in a Packed Column and Their Heat and Mass Transfer Correlations</b><br>
Industrial and Engineering Chemistry Research 35, p. 192-198 (1996)<br>
DOI: <a href=\"http://dx.doi.org/10.1021/ie940652u\">10.1021/ie940652u</a>
</dd></dl>
</html>", revisions="<html>
<ul>
<li>
January 04, 2017, by Yannick Fuerst:<br/>
First implementation.
</li>
</ul>
</html>"));
end StructuredPackings_ChungGhoshHines;
