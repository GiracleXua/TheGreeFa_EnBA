within BrineGrid.MoistureTransfer.Sources;
model FixedMoistureFlow "Fixed moisture flow boundary condition"
  parameter Boolean use_m_flow_in=false
    "Get the moisture flow from the input connector" annotation(Evaluate=true, HideResult=true);
  parameter Modelica.SIunits.MassFlowRate m_flow=0.0
    "Fixed moisture flow at moisturePort" annotation(Dialog(enable=not use_m_flow_in));

  Modelica.Blocks.Interfaces.RealInput m_flow_in(
    final quantity="MassFlowRate",
    final unit="kg/s",
    displayUnit="kg/s",
    min = 0) if use_m_flow_in "Moisture flow" annotation (Placement(transformation(extent={{-140,
            -20},{-100,20}}), iconTransformation(extent={{-140,-20},{-100,20}})));
  MoistureTransfer.Interfaces.MoisturePort_b moisturePort annotation (Placement(transformation(extent={{90,-10},{110,10}}, rotation=0)));
protected
  Modelica.Blocks.Interfaces.RealInput m_flow_in_internal
    "Needed to connect to conditional connector";
equation
  connect(m_flow_in, m_flow_in_internal);
  if not use_m_flow_in then
    m_flow_in_internal + m_flow = 0;
  end if;
  moisturePort.m_flow + m_flow = 0;
  annotation (defaultComponentName="bou",
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
            100,100}}), graphics={
        Line(
          points={{-100,20},{46,20}},
          color={0,128,255},
          thickness=0.5),
        Polygon(
          points={{40,0},{40,40},{70,20},{40,0}},
          lineColor={0,128,255},
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{70,40},{90,-40}},
          lineColor={0,128,255},
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{40,-40},{40,0},{70,-20},{40,-40}},
          lineColor={0,128,255},
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-100,-20},{48,-20}},
          color={0,128,255},
          thickness=0.5),
        Text(
          extent={{-150,150},{150,110}},
          textString="%name",
          lineColor={0,0,255}),
        Text(
          extent={{-150,-109},{150,-150}},
          lineColor={0,0,0},
          textString=if use_m_flow_in then "m_flow=%m_flow_in" else "m_flow=%m_flow")}),
    Documentation(info="<html>
<p>
This model allows a specified amount of mass flow to be \"injected\"
into a system at a given port. The constant amount of mass
flow rate <code>m_flow</code> is given as a parameter. The mass flows into the
component to which the component <code>FixedMoistureFlow</code> is connected,
if the parameter m_flow is positive.
</p>
</html>",
        revisions="<html>
<ul>
<li>
January 04, 2017, by Yannick Fuerst:<br/>
First implementation.
</li>
</ul>
</html>"), Icon(defaultComponentName="bou"),Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
            100,100}})));
end FixedMoistureFlow;
