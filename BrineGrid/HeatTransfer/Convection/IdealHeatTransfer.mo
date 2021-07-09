within BrineGrid.HeatTransfer.Convection;
model IdealHeatTransfer "Ideal heat transfer without resistance"
  extends BaseClasses.PartialConvectionGeneral;
equation
  heatPort_a.T = heatPort_b.T;
  annotation (Documentation(info="<html>
<p>Convective heat transfer model without heat transfer resistances. This yields <i>T</i><sub>a</sub> = <i>T</i><sub>b</sub>.</p>
</html>", revisions="<html>
<ul>
<li>
January 04, 2017, by Yannick Fuerst:<br/>
First implementation.
</li>
</ul>
</html>"));
end IdealHeatTransfer;
