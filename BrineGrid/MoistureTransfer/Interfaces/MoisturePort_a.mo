within BrineGrid.MoistureTransfer.Interfaces;
connector MoisturePort_a "Moisture port connector at inlet"
  extends MoisturePort;
  annotation (defaultComponentName="massPort_a",Icon(graphics={     Rectangle(
          extent={{-100,100},{100,-100}},
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0})}),             Diagram(graphics={
                                   Rectangle(
          extent={{-50,50},{50,-50}},
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0})}),
    Documentation(info="<html>
<p>This connector is used for 1-dimensional mass flow between components.
The variables in the connector are</p>
<pre>
   Xi      Composition.
   m_flow  mass flow rate in kg/s.
</pre>
<p>Note: The two connector classes <a href=\"modelica://BrineGrid.MassTransfer.Interfaces.MoisturePort_a\">MoisturePort_a</a> and
<a href=\"modelica://BrineGrid.MassTransfer.Interfaces.MoisturePort_b\">MoisturePort_b</a> are identical with the only exception of the different
<b>icon layout</b>.</p></html>", revisions="<html>
<ul>
<li>
January 04, 2017, by Yannick Fuerst:<br/>
First implementation.
</li>
</ul>
</html>"));
end MoisturePort_a;
