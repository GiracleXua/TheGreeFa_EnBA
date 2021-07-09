within BrineGrid.HeatTransfer.Convection.General.BaseClasses;
partial model PartialConvection "Base class for convective heat transfer"
  replaceable package Medium =
      Modelica.Media.Interfaces.PartialMedium
    "Medium model flowing between port a and b" annotation(Dialog(tab="Internal Interface",enable=false));
  input Medium.ThermodynamicState state
    "Thermodynamic states in control volume";
  input Modelica.SIunits.Diameter deq "Equivalent diameter";
  input Modelica.SIunits.Area surface "Surface area";
  input Modelica.SIunits.Length length "Length";
  input Modelica.SIunits.Velocity v "Velocity";
  output Modelica.SIunits.HeatFlowRate Q_flow "Heat flow rate";

  Medium.Temperature T=Medium.temperature(state=state);
  Medium.AbsolutePressure p=Medium.pressure(state=state) "Total pressure";

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort_a annotation (Placement(transformation(extent={{90,-10},
            {110,10}}), iconTransformation(extent={{90,-10},{110,10}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b heatPort_b annotation (Placement(transformation(extent={{-110,
            -10},{-90,10}}), iconTransformation(extent={{-110,-10},{-90,10}})));
equation
  heatPort_a.Q_flow + heatPort_b.Q_flow = 0;
  Q_flow = heatPort_a.Q_flow;
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
          lineColor={255,0,0},
          textString="Q_flow"),
        Line(points={{-60,20},{80,20}}, color={191,0,0}),
        Line(points={{-60,-20},{80,-20}}, color={191,0,0}),
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
        Line(points={{60,-30},{80,-20}}, color={191,0,0}),
        Line(points={{60,-10},{80,-20}}, color={191,0,0}),
        Line(points={{60,10},{80,20}}, color={191,0,0}),
        Line(points={{60,30},{80,20}}, color={191,0,0})}), Documentation(info="<html>
<p>Partial model for convective heat transfer models. </p>
</html>", revisions="<html>
<ul>
<li>
January 04, 2017, by Yannick Fuerst:<br/>
First implementation.
</li>
</ul>
</html>"));
end PartialConvection;
