within BrineGrid.HeatTransfer.Interfaces;
connector HeatPorts_b
  "HeatPort connector with filled, large icon to be used for vectors of HeatPorts (vector dimensions must be added after dragging)"
  extends Modelica.Thermal.HeatTransfer.Interfaces.HeatPort;
  annotation (defaultComponentName="heatPorts_b",
       Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-200,-50},{200,50}},
        initialScale=0.2), graphics={
        Rectangle(
          extent={{-200,50},{200,-51}},
          lineColor={191,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-170,44},{-82,-46}},
          lineColor={191,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-44,44},{44,-46}},
          lineColor={191,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{82,45},{170,-45}},
          lineColor={191,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}),
    Documentation(info="<html>
<p>This model is identical to <a href=\"modelica://Modelica.Thermal.HeatTransfer.Interfaces.HeatPort\">Modelica.Thermal.HeatTransfer.Interfaces.HeatPort</a>,
except that the icon has been modified. It can be used to represent an array of <a href=\"modelica://Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a\">
HeatPort_b</a>.</p>
</html>", revisions="<html>
<ul>
<li>
January 04, 2017, by Yannick Fuerst:<br/>
First implementation.
</li>
</ul>
</html>"));
end HeatPorts_b;
