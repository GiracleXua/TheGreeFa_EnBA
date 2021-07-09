within BrineGrid.MoistureTransfer.Convection.General;
model ConstantMassTransferCoefficient2
  "Constant mass transfer coefficient in kg/(m2.s)"
  extends BaseClasses.PartialConvection;
  parameter BrineGrid.SIunits.CoefficientOfMassTransfer2 beta0=0.03
    "Mass transfer coefficient";

  Medium.Density rho=Medium.density(state=state) "Density of medium";
  Modelica.SIunits.DiffusionCoefficient D=
    Media.LiquidDesiccants.Functions.diffusionCoefficientWaterAir(p=p, T=T)
    "Diffusion coefficient of water vapour in air";
equation
  m_flow = beta0*surface*(moisturePort_a.X - moisturePort_b.X);
  Sh =Fluid.Functions.CharacteristicNumbers.SherwoodNumber_rho1(
    beta=beta0,
    L=deq,
    D=D,
    rho=rho);
  annotation (Documentation(info="<html>
<p>Convective mass transfer model using a constant heat transfer coefficient &beta; in kg/(m2.s).</p>
</html>", revisions="<html>
<ul>
<li>
January 04, 2017, by Yannick Fuerst:<br/>
First implementation.
</li>
</ul>
</html>"));
end ConstantMassTransferCoefficient2;
