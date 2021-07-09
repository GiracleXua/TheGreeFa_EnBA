within BrineGrid.HeatTransfer.Convection;
model ConstantNusseltNumber "Constant Nusselt number"
  extends BaseClasses.PartialConvectionGeneral;
  parameter Modelica.SIunits.CoefficientOfHeatTransfer alpha0=30
    "Start value for heat transfer coefficient";
  parameter Modelica.SIunits.NusseltNumber Nu0=250 "Nusselt number";

  Medium_a.ThermalConductivity lambda_a=Medium_a.thermalConductivity(state=inflow_a)
    "Thermal conductivity of medium a at inlet";
  Modelica.SIunits.CoefficientOfHeatTransfer alpha(start=alpha0)
    "Coefficient of heat transfer";
equation
  alpha = Fluid.Functions.CharacteristicNumbers.alpha_from_NusseltNumber(
    Nu=Nu0,
    L=deq,
    lambda=lambda_a);
  Q_flow = alpha*surface*(heatPort_a.T - heatPort_b.T);
  annotation (Documentation(info="<html>
<p>
Convective heat transfer model using a constant Nusselt number <i>Nu</i>
</p>
</html>", revisions="<html>
<ul>
<li>
January 04, 2017, by Yannick Fuerst:<br/>
First implementation.
</li>
</ul>
</html>"));
end ConstantNusseltNumber;
