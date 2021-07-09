within BrineGrid.MoistureTransfer.Interfaces;
connector MoisturePort_b "Moisture port connector at outlet"
  extends MoisturePort;
  annotation (defaultComponentName="massPort_b", Icon(graphics={
                  Rectangle(
          extent={{-100,100},{100,-100}},
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),        Rectangle(
          extent={{-60,60},{60,-60}},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None)}), Diagram(graphics={
                  Rectangle(
          extent={{-50,50},{50,-50}},
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),        Rectangle(
          extent={{-28,28},{28,-28}},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None)}),
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
end MoisturePort_b;
