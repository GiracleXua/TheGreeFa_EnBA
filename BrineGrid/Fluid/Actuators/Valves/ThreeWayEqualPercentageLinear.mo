within BrineGrid.Fluid.Actuators.Valves;
model ThreeWayEqualPercentageLinear
  "Three way valve with equal percentage and linear characteristics"
    extends BaseClasses.PartialThreeWayValve(
      redeclare TwoWayEqualPercentage res1(R=R, delta0=delta0),
      redeclare TwoWayLinear res3);
  parameter Real R = 50 "Rangeability, R=50...100 typically";
  parameter Real delta0 = 0.01
    "Range of significant deviation from equal percentage law";

equation
  connect(inv.y, res3.y) annotation (Line(points={{-62.6,46},{20,46},{20,46},{
          20,-50},{12,-50}},
                         color={0,0,127}));
  connect(y_actual, inv.u2) annotation (Line(points={{50,70},{84,70},{84,32},{-68,
          32},{-68,41.2}},
                         color={0,0,127}));
  connect(y_actual, res1.y) annotation (Line(points={{50,70},{84,70},{84,32},{
          -50,32},{-50,12}},
        color={0,0,127}));
  annotation (                       Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={Text(
          extent={{-72,24},{-34,-20}},
          lineColor={255,255,255},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="%%")}),
defaultComponentName="val",
Documentation(info="<html>
<p>
Three way valve with equal percentage characteristics
between <code>port_1</code> and <code>port_2</code>
and linear opening characteristic between <code>port_1</code> and <code>port_2</code>.
Such opening characteristics were typical for valves from Landis &amp; Gyr (now
Siemens).
</p><p>
This model is based on the partial valve models
<a href=\"modelica://BrineGrid.Fluid.Actuators.BaseClasses.PartialThreeWayValve\">
BrineGrid.Fluid.Actuators.BaseClasses.PartialThreeWayValve</a> and
<a href=\"modelica://BrineGrid.Fluid.Actuators.BaseClasses.PartialTwoWayValve\">
BrineGrid.Fluid.Actuators.BaseClasses.PartialTwoWayValve</a>.
See
<a href=\"modelica://BrineGrid.Fluid.Actuators.BaseClasses.PartialThreeWayValve\">
BrineGrid.Fluid.Actuators.BaseClasses.PartialThreeWayValve</a>
for the implementation of the three way valve
and see
<a href=\"modelica://BrineGrid.Fluid.Actuators.BaseClasses.PartialTwoWayValve\">
BrineGrid.Fluid.Actuators.BaseClasses.PartialTwoWayValve</a>
for the implementation of the regularization near the origin.
</p>
</html>",
revisions="<html>
<ul>
<li>
February 20, 2012 by Michael Wetter:<br/>
Renamed parameter <code>dp_nominal</code> to <code>dpValve_nominal</code>,
and added new parameter <code>dpFixed_nominal</code>.
See
<a href=\"modelica://BrineGrid.Fluid.Actuators.UsersGuide\">
BrineGrid.Fluid.Actuators.UsersGuide</a>.
</li>
<li>
February 14, 2012 by Michael Wetter:<br/>
Added filter to approximate the travel time of the actuator.
</li>
<li>
March 25, 2011, by Michael Wetter:<br/>
Added homotopy method.
</li>
<li>
June 16, 2008 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end ThreeWayEqualPercentageLinear;
