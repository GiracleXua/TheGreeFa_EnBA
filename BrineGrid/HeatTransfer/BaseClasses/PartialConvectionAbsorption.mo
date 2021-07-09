within BrineGrid.HeatTransfer.BaseClasses;
partial model PartialConvectionAbsorption
  "Base class for convective heat transfer"
  extends PartialConvectionGeneral(
    redeclare replaceable package Medium_a =
      Media.Interfaces.PartialCondensingFluid);
  replaceable package Medium_b=Media.Interfaces.PartialCondensingFluid
    "Medium model for medium b" annotation(Dialog(tab="Internal Interface",enable=false));
  parameter Real a(unit="m2/m3") "Specific area" annotation(Dialog(tab="Internal Interface",enable=false));
  parameter Real epsilon(min=0, max=1) "Void fraction" annotation(Dialog(tab="Internal Interface",enable=false));

  input Modelica.SIunits.MassFlowRate m_flow_in_b
    "Mass flow rates of medium b at inflow";
  input Medium_b.ThermodynamicState inflow_b
    "Thermodynamic state of medium b at inflow";

  Medium_a.MassFraction[Medium_a.nX] X_a=inflow_a.X
    "Composition of medium a at inlet";
  Medium_b.AbsolutePressure p_b=Medium_b.pressure(state=inflow_b)
    "Pressure of medium b at inlet";
  Medium_b.Temperature T_b=Medium_b.temperature(state=inflow_b)
    "Temperature of medium b at inlet";
    //heatPort_b.T
  Medium_b.MassFraction[Medium_b.nX] X_b=inflow_b.X
    "Composition of medium b at inlet";
  annotation (Documentation(
        revisions="<html>
<ul>
<li>
January 04, 2017, by Yannick Fuerst:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>Partial model for convective heat transfer models used in absorption processes. </p>
</html>"));
end PartialConvectionAbsorption;
