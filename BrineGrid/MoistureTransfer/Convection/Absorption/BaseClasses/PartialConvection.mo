within BrineGrid.MoistureTransfer.Convection.Absorption.BaseClasses;
partial model PartialConvection
  "Base class for convective mass transfer"
  replaceable package MediumOne =
      BrineGrid.Media.Interfaces.PartialCondensingFluid
    "First medium model" annotation(Dialog(tab="Internal Interface",enable=false));
  replaceable package MediumTwo =
      BrineGrid.Media.Interfaces.PartialCondensingFluid
    "Second medium model" annotation(Dialog(tab="Internal Interface",enable=false));
  input MediumOne.ThermodynamicState state_one
    "Thermodynamic state of first medium";
  input MediumTwo.ThermodynamicState state_two
    "Thermodynamic state of second medium";
  input Modelica.SIunits.Diameter deq "Equivalent diameter";
  input Modelica.SIunits.Area surface "Surface area";
  input Modelica.SIunits.Velocity v_one "Velocity of first medium";
  input Modelica.SIunits.Velocity v_two "Velocity of second medium";
  input Modelica.SIunits.MassFlowRate m_flow_one
    "Mass flow rate of first medium";
  input Modelica.SIunits.MassFlowRate m_flow_two
    "Mass flow rate of second medium";
  output Modelica.SIunits.MassFlowRate m_flow
    "Mass flow rates of transported medium";
  output BrineGrid.SIunits.SherwoodNumber Sh "Sherwood number";

  MediumOne.Temperature T_one=MediumOne.temperature(state=state_one)
    "Temperature of medium one";
  MediumOne.AbsolutePressure p_one=MediumOne.pressure(state=state_one)
    "Total pressure of medium one";
  MediumTwo.Temperature T_two=MediumTwo.temperature(state=state_two)
    "Temperature of medium two";
  MediumTwo.MassFraction X_two=MediumTwo.massFraction(state=state_two)
    "Mass fraction of medium two";
  MoistureTransfer.Interfaces.MoisturePort_a moisturePort_a annotation (Placement(
        transformation(extent={{90,-10},{110,10}}), iconTransformation(extent={
            {90,-10},{110,10}})));
  MoistureTransfer.Interfaces.MoisturePort_b moisturePort_b annotation (Placement(
        transformation(extent={{-110,-10},{-90,10}}), iconTransformation(extent=
           {{-110,-10},{-90,10}})));
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
<p>Partial model for convective mass transfer models. </p>
</html>"));
end PartialConvection;
