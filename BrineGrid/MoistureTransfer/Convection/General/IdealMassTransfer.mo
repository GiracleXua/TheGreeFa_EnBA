within BrineGrid.MoistureTransfer.Convection.General;
model IdealMassTransfer "Ideal mass transfer without resistance"
  extends BaseClasses.PartialConvection;
equation
  moisturePort_a.X = moisturePort_b.X;
  Sh = Modelica.Constants.eps;
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
