within BrineGrid.MoistureTransfer.Interfaces;
connector MoisturePorts_a
  "MoisturePort connector with filled, large icon to be used for vectors of MoisturePorts (vector dimensions must be added after dragging)"
  extends MoisturePort;
  annotation (defaultComponentName="massPorts_a",
       Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-200,-50},{200,50}},
        initialScale=0.2), graphics={
        Rectangle(
          extent={{-201,50},{200,-50}},
          lineColor={0,128,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-171,45},{-83,-45}},
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,128,255}),
        Rectangle(
          extent={{-45,45},{43,-45}},
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,128,255}),
        Rectangle(
          extent={{82,45},{170,-45}},
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,128,255})}),
    Documentation(info="<html>
<p>This model is identical to <a href=\"modelica://BrineGrid.MassTransfer.Interfaces.MoisturePort\">BrineGrid.MassTransfer.Interfaces.MoisturePort</a>,
except that the icon has been modified. It can be used to represent an array of <a href=\"modelica://BrineGrid.MassTransfer.Interfaces.MoisturePort_a\">
MoisturePort_a</a>.</p>
</html>", revisions="<html>
<ul>
<li>
January 04, 2017, by Yannick Fuerst:<br/>
First implementation.
</li>
</ul>
</html>"));
end MoisturePorts_a;
