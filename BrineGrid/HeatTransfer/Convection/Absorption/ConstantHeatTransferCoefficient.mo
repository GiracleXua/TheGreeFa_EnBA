within BrineGrid.HeatTransfer.Convection.Absorption;
model ConstantHeatTransferCoefficient
  "Constant heat transfer coefficient"
  extends BaseClasses.PartialConvectionAbsorption;
  parameter Modelica.SIunits.CoefficientOfHeatTransfer alpha0 = 3
    "Heat transfer coefficient";
equation
  Q_flow = alpha0*surface*(heatPort_a.T - heatPort_b.T);
  annotation (Documentation(revisions="<html>
<ul>
<li>
January 04, 2017, by Yannick Fuerst:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>Convective heat transfer model using a constant heat transfer coefficient &alpha;.</p>
</html>"));
end ConstantHeatTransferCoefficient;
