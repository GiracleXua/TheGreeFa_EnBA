within BrineGrid.HeatTransfer.Convection.General;
model ConstantHeatTransferCoefficient
  "Constant heat transfer coefficient"
  extends BaseClasses.PartialConvection;
  parameter Modelica.SIunits.CoefficientOfHeatTransfer alpha0
    "Heat transfer coefficient";

  Medium.ThermalConductivity lambda=Medium.thermalConductivity(state)
    "Thermal conductivity";
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
