within BrineGrid.MoistureTransfer.Convection.General;
model ConstantMassTransferCoefficient3
  "Constant mass transfer coefficient in mol/(m2.s.mole fraction)"
  extends BaseClasses.PartialConvection;
  parameter BrineGrid.SIunits.CoefficientOfMassTransfer4 beta0=0.03
    "Mass transfer coefficient in mol/(m2.s.mole fraction)";

  Medium.Density rho=Medium.density(state=state) "Density of medium";
  Modelica.SIunits.DiffusionCoefficient D=
    Media.LiquidDesiccants.Functions.diffusionCoefficientWaterAir(p=p, T=T)
    "Diffusion coefficient of water vapour in air";
  Modelica.SIunits.MolarMass MM=Medium.molarMass(state=state);
equation
  m_flow = beta0*MM*surface*(moisturePort_a.X - moisturePort_b.X);
  Sh =Fluid.Functions.CharacteristicNumbers.SherwoodNumber_rho2(
    beta=beta0,
    L=deq,
    D=D,
    rho=rho);
  annotation (Documentation(info="<html>
<p>Convective mass transfer model using a constant heat transfer coefficient &beta; in mol/(m2.s.mole fraction).</p>
</html>", revisions="<html>
<ul>
<li>
January 04, 2017, by Yannick Fuerst:<br/>
First implementation.
</li>
</ul>
</html>"));
end ConstantMassTransferCoefficient3;
