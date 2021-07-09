within BrineGrid.Media.LiquidDesiccants.Examples;
model Test_StaticPipe
  Modelica.Fluid.Sources.MassFlowSource_T boundary(
    redeclare package Medium = MagnesiumChlorideAqueousSolution,
    m_flow=0.1,
    T=303.15,
    nPorts=1)
    annotation (Placement(transformation(extent={{-66,-10},{-46,10}})));
  Modelica.Fluid.Sources.FixedBoundary boundary1(
    use_p=true,
    redeclare package Medium = MagnesiumChlorideAqueousSolution,
    p=200000,
    T=303.15,
    nPorts=1) annotation (Placement(transformation(extent={{72,-10},{52,10}})));
  inner Modelica.Fluid.System system(p_ambient=200000, T_ambient=303.15)
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Modelica.Fluid.Pipes.StaticPipe pipe(
    redeclare package Medium = MagnesiumChlorideAqueousSolution,
    length=1,
    diameter=0.01,
    m_flow_start=0)
    annotation (Placement(transformation(extent={{-30,-10},{-10,10}})));
  Modelica.Fluid.Sources.MassFlowSource_T boundary2(
    redeclare package Medium = MagnesiumChlorideAqueousSolution,
    m_flow=0.1,
    nPorts=1,
    T=303.15,
    X={0.6,0.4})
    annotation (Placement(transformation(extent={{-64,-42},{-44,-22}})));
  Modelica.Fluid.Pipes.StaticPipe pipe1(
    redeclare package Medium = MagnesiumChlorideAqueousSolution,
    length=1,
    diameter=0.01,
    m_flow_start=0)
    annotation (Placement(transformation(extent={{14,-10},{34,10}})));
equation
  connect(boundary.ports[1], pipe.port_a)
    annotation (Line(points={{-46,0},{-30,0}}, color={0,127,255}));
  connect(pipe.port_b, pipe1.port_a)
    annotation (Line(points={{-10,0},{14,0}}, color={0,127,255}));
  connect(boundary2.ports[1], pipe1.port_a) annotation (Line(points={{-44,-32},
          {4,-32},{4,0},{14,0}}, color={0,127,255}));
  connect(pipe1.port_b, boundary1.ports[1])
    annotation (Line(points={{34,0},{52,0}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Test_StaticPipe;
