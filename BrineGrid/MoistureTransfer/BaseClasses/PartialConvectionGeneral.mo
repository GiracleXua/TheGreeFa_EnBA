within BrineGrid.MoistureTransfer.BaseClasses;
partial model PartialConvectionGeneral
  "Base class for convective mass transfer within a fluid"
  parameter Modelica.SIunits.Area crossArea "Cross sectional area" annotation(Dialog(tab="Internal Interface",enable=false));
  parameter Modelica.SIunits.Diameter deq "Equivalent diameter" annotation(Dialog(tab="Internal Interface",enable=false));
  parameter Modelica.SIunits.Area surface "Surface area" annotation(Dialog(tab="Internal Interface",enable=false));
  replaceable package Medium_a=Modelica.Media.Interfaces.PartialMedium
    "Medium model for medium a" annotation(Dialog(tab="Internal Interface",enable=false));

  input Modelica.SIunits.MassFlowRate m_flow_in_a
    "Mass flow rates of medium a at inflow";
  input Medium_a.ThermodynamicState inflow_a
    "Thermodynamic state of medium a at inflow";
  output Modelica.SIunits.MassFlowRate m_flow
    "Mass flow rate";

  Medium_a.AbsolutePressure p_a=Medium_a.pressure(state=inflow_a)
    "Pressure of medium a at inlet";
  Medium_a.Temperature T_a=Medium_a.temperature(state=inflow_a)
    "Temperature of medium a at inlet";
  MoistureTransfer.Interfaces.MoisturePort_a moisturePort_a annotation (Placement(transformation(extent={{90,-10},{110,10}}),
        iconTransformation(extent={{90,-10},{110,10}})));
  MoistureTransfer.Interfaces.MoisturePort_b moisturePort_b annotation (Placement(transformation(extent={{-110,-10},{-90,10}}),
        iconTransformation(extent={{-110,-10},{-90,10}})));
equation
  moisturePort_a.m_flow + moisturePort_b.m_flow = 0;
  m_flow = moisturePort_a.m_flow;
  annotation ( Icon(coordinateSystem(
          preserveAspectRatio=false,extent={{-100,-100},{100,100}}), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-90,80},{-60,-80}},
          lineColor={0,0,0},
          fillColor={192,192,192},
          fillPattern=FillPattern.Backward),
        Line(points={{100,0},{100,0}}, color={0,127,255}),
        Line(points={{100,0},{100,0}}, color={0,127,255}),
        Line(points={{100,0},{100,0}}, color={0,127,255}),
        Text(
          extent={{-35,42},{-5,20}},
          lineColor={28,108,200},
          textString="m_flow"),
        Line(points={{-60,20},{80,20}}, color={0,128,255}),
        Line(points={{-60,-20},{80,-20}}, color={0,128,255}),
        Line(points={{-40,80},{-40,-80}}, color={0,0,0}),
        Line(points={{0,80},{0,-80}}, color={0,0,0}),
        Line(points={{40,80},{40,-80}}, color={0,0,0}),
        Line(points={{80,80},{80,-80}}, color={0,0,0}),
        Line(points={{-40,-80},{-50,-60}}, color={0,0,0}),
        Line(points={{-40,-80},{-30,-60}}, color={0,0,0}),
        Line(points={{0,-80},{-10,-60}},color={0,0,0}),
        Line(points={{0,-80},{10,-60}}, color={0,0,0}),
        Line(points={{40,-80},{30,-60}}, color={0,0,0}),
        Line(points={{40,-80},{50,-60}}, color={0,0,0}),
        Line(points={{80,-80},{70,-60}}, color={0,0,0}),
        Line(points={{80,-80},{90,-60}}, color={0,0,0}),
        Line(points={{60,-30},{80,-20}}, color={0,128,255}),
        Line(points={{60,-10},{80,-20}}, color={0,128,255}),
        Line(points={{60,10},{80,20}}, color={0,128,255}),
        Line(points={{60,30},{80,20}}, color={0,128,255})}), Documentation(
        revisions="<html>
<ul>
<li>
January 04, 2017, by Yannick Fuerst:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>Partial model for general convective mass transfer models. </p>
</html>"));
end PartialConvectionGeneral;
