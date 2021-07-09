within BrineGrid.MoistureTransfer.Convection;
model ConstantMassTransferCoefficient2
  "Constant mass transfer coefficient in kg/(m2.s)"
  extends BaseClasses.PartialConvectionGeneral;
  parameter BrineGrid.SIunits.CoefficientOfMassTransfer2 beta0=0.03
    "Mass transfer coefficient";
equation
  m_flow = beta0*surface*(moisturePort_a.X - moisturePort_b.X);
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
