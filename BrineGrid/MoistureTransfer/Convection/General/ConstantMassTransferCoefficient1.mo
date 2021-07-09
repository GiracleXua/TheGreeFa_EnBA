within BrineGrid.MoistureTransfer.Convection.General;
model ConstantMassTransferCoefficient1
  "Constant mass transfer coefficient in m/s"
  extends BaseClasses.PartialConvection;
  parameter BrineGrid.SIunits.CoefficientOfMassTransfer1 beta0=0.03
    "Mass transfer coefficient";

  Medium.Density rho=Medium.density(state=state) "Density of medium";
  Modelica.SIunits.DiffusionCoefficient D=
    Media.LiquidDesiccants.Functions.diffusionCoefficientWaterAir(p=p, T=T)
    "Diffusion coefficient of water vapour in air";
equation
  m_flow = beta0*rho*surface*(moisturePort_a.X - moisturePort_b.X);
  Sh = Fluid.Functions.CharacteristicNumbers.SherwoodNumber(
    beta=beta0,
    L=deq,
    D=D);
  annotation (Documentation(info="<html>
<p>Convective mass transfer model using a constant heat transfer coefficient &beta; in m/s.</p>
</html>", revisions="<html>
<ul>
<li>
January 04, 2017, by Yannick Fuerst:<br/>
First implementation.
</li>
</ul>
</html>"));
end ConstantMassTransferCoefficient1;
