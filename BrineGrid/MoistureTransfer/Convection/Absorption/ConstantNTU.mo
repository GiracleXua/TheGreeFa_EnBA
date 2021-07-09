within BrineGrid.MoistureTransfer.Convection.Absorption;
model ConstantNTU "Constant number of transfer units"
  extends BaseClasses.PartialConvectionAbsorption;
  parameter BrineGrid.SIunits.CoefficientOfMassTransfer2 beta0=0.03
    "Start value for mass transfer coefficient";
  parameter Real NTU "Number of transfer units";

  BrineGrid.SIunits.CoefficientOfMassTransfer2 beta(start=beta0)
    "Mass transfer coefficient";
equation
  beta = NTU*m_flow_in_a/surface;
  m_flow = beta*surface*(moisturePort_a.X - moisturePort_b.X);
  annotation (Documentation(info="<html>
<p>Convective heat transfer model using a constant Number of Transfer Units <i>NTU</i></p>
</html>", revisions="<html>
<ul>
<li>
January 04, 2017, by Yannick Fuerst:<br/>
First implementation.
</li>
</ul>
</html>"));
end ConstantNTU;
