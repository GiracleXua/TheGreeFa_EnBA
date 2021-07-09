within BrineGrid.Fluid.Absorbers.BaseClasses;
model Splitter
  "Partial heat exchanger duct and pipe manifold"
  replaceable package Medium =
      Modelica.Media.Interfaces.PartialMedium "Medium in the component"
      annotation (choicesAllMatching = true);
  parameter Boolean allowFlowReversal = true
    "= true to allow flow reversal, false restricts to design direction (port_a -> port_b)"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);
  parameter Integer nPar(min=1) "Number of parallel pipes in each register";

  Modelica.Fluid.Fittings.MultiPort mulPor(
      redeclare package Medium = Medium,
      final nPorts_b=nPar)
    annotation (Placement(transformation(extent={{0,-10},{8,10}})));

  Modelica.Fluid.Interfaces.FluidPort_a port_a(
        redeclare package Medium = Medium,
        m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0))
    "Fluid connector a for medium (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Modelica.Fluid.Interfaces.FluidPort_b[nPar] port_b(
        redeclare each package Medium = Medium,
        each m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0))
    "Fluid connector b for medium (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{110,-10},{90,10}})));
equation
  connect(port_a, mulPor.port_a) annotation (Line(points={{-100,0},{-50,0},{0,0}}, color={0,127,255}));
  connect(mulPor.ports_b, port_b) annotation (Line(
      points={{8,0},{100,0}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={
        Rectangle(
          extent={{-96,2},{0,-2}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{0,62},{100,58}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{0,2},{100,-2}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{0,-58},{100,-62}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-2,-62},{2,62}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-84,-48},{84,-120}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid)}),
            Documentation(info="",
revisions=""));
end Splitter;
