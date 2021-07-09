within BrineGrid.HeatTransfer.Interfaces;
connector HeatPorts_a
  "HeatPort connector with filled, large icon to be used for vectors of HeatPorts (vector dimensions must be added after dragging)"
  extends Modelica.Thermal.HeatTransfer.Interfaces.HeatPort;
  annotation (defaultComponentName="heatPorts_a",
       Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-200,-50},{200,50}},
        initialScale=0.2), graphics={
        Rectangle(
          extent={{-201,50},{200,-50}},
          lineColor={191,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-171,45},{-83,-45}},
          lineColor={191,0,0},
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-45,45},{43,-45}},
          lineColor={191,0,0},
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{82,45},{170,-45}},
          lineColor={191,0,0},
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid)}),
    Documentation(info="<html>
<p>This model is identical to <a href=\"modelica://Modelica.Thermal.HeatTransfer.Interfaces.HeatPort\">Modelica.Thermal.HeatTransfer.Interfaces.HeatPort</a>,
except that the icon has been modified. It can be used to represent an array of <a href=\"modelica://Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a\">
HeatPort_a</a>.</p>
</html>", revisions="<html>
<ul>
<li>
January 04, 2017, by Yannick Fuerst:<br/>
First implementation.
</li>
</ul>
</html>"));
end HeatPorts_a;
