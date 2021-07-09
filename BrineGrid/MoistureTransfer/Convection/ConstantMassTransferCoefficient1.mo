within BrineGrid.MoistureTransfer.Convection;
model ConstantMassTransferCoefficient1
  "Constant mass transfer coefficient in m/s"
  extends BaseClasses.PartialConvectionGeneral;
  parameter BrineGrid.SIunits.CoefficientOfMassTransfer1 beta0=0.03
    "Mass transfer coefficient";

  Medium_a.Density rho_a=Medium_a.density(state=inflow_a)
    "Density of medium a at inlet";
equation
  m_flow = beta0*rho_a*surface*(moisturePort_a.X - moisturePort_b.X);
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
