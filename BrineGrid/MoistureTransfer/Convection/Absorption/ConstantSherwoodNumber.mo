within BrineGrid.MoistureTransfer.Convection.Absorption;
model ConstantSherwoodNumber "Constant Sherwood number"
  extends BaseClasses.PartialConvectionAbsorption;
  parameter BrineGrid.SIunits.CoefficientOfMassTransfer1 beta0=0.03
    "Start value for mass transfer coefficient";
  parameter BrineGrid.SIunits.SherwoodNumber Sh0=1 "Sherwood number";

  Medium_a.Density rho_a=Medium_a.density(state=inflow_a)
    "Density of medium a at inlet";
  Modelica.SIunits.DiffusionCoefficient D_air=
    Media.LiquidDesiccants.Functions.diffusivityWaterVaporAir(
      T=T_a)
    "Diffusion coefficient of water vapour in air at inlet";

  BrineGrid.SIunits.CoefficientOfMassTransfer1 beta(start=beta0)
    "Mass transfer coefficient";
equation
  beta = Fluid.Functions.CharacteristicNumbers.beta_from_SherwoodNumber(
    Sh=Sh0,
    L=deq,
    D=D_air);
  m_flow = beta*rho_a*surface*(moisturePort_a.X - moisturePort_b.X);
  annotation (Documentation(info="<html>
<p>Convective heat transfer model using a constant Sherwood number <i>Sh</i></p>
</html>", revisions="<html>
<ul>
<li>
January 04, 2017, by Yannick Fuerst:<br/>
First implementation.
</li>
</ul>
</html>"));
end ConstantSherwoodNumber;
