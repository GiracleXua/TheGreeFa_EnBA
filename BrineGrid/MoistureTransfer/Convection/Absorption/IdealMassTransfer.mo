within BrineGrid.MoistureTransfer.Convection.Absorption;
model IdealMassTransfer "Ideal mass transfer without resistance"
  extends BaseClasses.PartialConvectionAbsorption;
equation
  moisturePort_a.X = moisturePort_b.X;
  annotation (Documentation(info="<html>
<p>Convective mass transfer model without mass transfer resistances. This yields <i>X</i><sub>i,a</sub> = <i>X</i><sub>i,b</sub>.</p>
</html>", revisions="<html>
<ul>
<li>
January 04, 2017, by Yannick Fuerst:<br/>
First implementation.
</li>
</ul>
</html>"));
end IdealMassTransfer;
