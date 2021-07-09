within BrineGrid.MoistureTransfer.Convection.General;
model ConstantSherwoodNumber "Constant Sherwood number"
  extends BaseClasses.PartialConvection;
  parameter BrineGrid.SIunits.CoefficientOfMassTransfer1 beta0=0.03
    "Start value for mass transfer coefficient";
  parameter BrineGrid.SIunits.SherwoodNumber Sh0=1 "Sherwood number";

  BrineGrid.SIunits.CoefficientOfMassTransfer1 beta(start=beta0)
    "Mass transfer coefficient";
  Medium.Density rho=Medium.density(state=state) "Density of medium";
  Modelica.SIunits.DiffusionCoefficient D=BrineGrid.Media.LiquidDesiccants.Functions.diffusionCoefficientWaterAir(
                                                                                       p=p, T=T)
    "Diffusion coefficient of water vapour in air";
equation
  beta = Fluid.Functions.CharacteristicNumbers.beta_from_SherwoodNumber(
    Sh=Sh0,
    L=deq,
    D=D);
  m_flow = beta*rho*surface*(moisturePort_a.X - moisturePort_b.X);
  Sh = Sh0;
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
