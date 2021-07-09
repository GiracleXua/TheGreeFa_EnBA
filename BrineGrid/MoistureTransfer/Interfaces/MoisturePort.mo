within BrineGrid.MoistureTransfer.Interfaces;
connector MoisturePort
  "Interface for one-dimensional moisture transport"
  flow Modelica.SIunits.MassFlowRate m_flow
    "Mass flow rate from of water vapor";
  Modelica.SIunits.MassFraction X "Absolute moisture";
  annotation (Documentation(revisions="<html>
<ul>
<li>
January 04, 2017, by Yannick Fuerst:<br/>
First implementation.
</li>
</ul>
</html>"));
end MoisturePort;
