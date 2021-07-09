within BrineGrid.HeatTransfer.Convection;
model ConstantHeatTransferCoefficient
  "Constant heat transfer coefficient"
  extends BaseClasses.PartialConvectionGeneral;
  parameter Modelica.SIunits.CoefficientOfHeatTransfer alpha0
    "Heat transfer coefficient";
equation
  Q_flow = alpha0*surface*(heatPort_a.T - heatPort_b.T);
  annotation (Documentation(info="<html>
<p>Convective heat transfer model using a constant heat transfer coefficient &alpha;.</p>
</html>", revisions="<html>
<ul>
<li>
January 04, 2017, by Yannick Fuerst:<br/>
First implementation.
</li>
</ul>
</html>"));
end ConstantHeatTransferCoefficient;
