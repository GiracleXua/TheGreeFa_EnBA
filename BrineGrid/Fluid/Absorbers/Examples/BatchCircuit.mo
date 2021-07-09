within BrineGrid.Fluid.Absorbers.Examples;
model BatchCircuit
  extends Modelica.Icons.Example;
  replaceable package Medium_b =
    BrineGrid.Media.LiquidDesiccants.LithiumChlorideAqueousSolution_PatekKlomfar
    "Medium model for absorbent";
                                                                      //(saturationPressureModel=BrineGrid.Media.Choices.SaturationPressureModel.Conde)
  replaceable package Medium_a =
    BrineGrid.Media.LiquidDesiccants.Air
                       "Medium model for moist air";

  parameter Modelica.SIunits.Temperature T_air=273.15 + 25.6
    "Air inlet temperature";
  parameter Modelica.SIunits.Temperature T_abs=273.15 + 14.9
    "Aqueous solution inlet temperature";
  parameter Modelica.SIunits.MassFraction x=0.0162
    "Water load of inlet air";
  final parameter Modelica.SIunits.MassFraction X_w=
    Media.LiquidDesiccants.Functions.totalHumidityToMassFraction(x=x)
    "Mass fraction of water in inlet air";
  final parameter Modelica.SIunits.MassFraction[Medium_a.nX] X_air={X_w, 1 - X_w}
    "Composition of moist air";
  parameter Modelica.SIunits.MassFraction X_s=0.23
    "Mass fraction of desiccant";
  final parameter Modelica.SIunits.MassFraction[Medium_b.nX] X_abs={1 - X_s, X_s}
    "Composition of aqueous solution";
  parameter Modelica.SIunits.MassFlowRate m_flow_air=1.85
    "Mass flow rate of inlet air";
  parameter Modelica.SIunits.MassFlowRate m_flow_abs=2.61
    "Mass flow rate of aqueous solutio at inlet";
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal_air=m_flow_air
    "Nominal mass flow rate of moist air";
  parameter Modelica.SIunits.AbsolutePressure dp_nominal_air=50
    "Nominal pressure drop on the air side";
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal_abs=m_flow_abs
    "Nominal mass flow rate of aqueous solution";
  parameter Modelica.SIunits.AbsolutePressure dp_nominal_abs=50
    "Nominal pressure drop on the desiccant side";
  parameter Integer nNodes=2
    "Discretization of the air flow";
  parameter Integer mNodes=2
    "Discretization of the desiccant flow";

  BrineGrid.Fluid.Sources.FixedBoundary sin_air(redeclare package Medium =
        Medium_a, nPorts=1)
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
  BrineGrid.Fluid.Absorbers.Adiabatic.AdiabaticAbsorber abs(
    redeclare package Medium_b = Medium_b,
    redeclare package Medium_a = Medium_a,
    m_flow_nominal_abs=m_flow_nominal_abs,
    m_flow_nominal_air=m_flow_nominal_air,
    dp_nominal_abs=dp_nominal_abs,
    dp_nominal_air=dp_nominal_air,
    T_start_abs=T_abs,
    T_start_air=T_air,
    X_start_abs=X_abs,
    X_start_air=X_air,
    m_flow_start_abs=m_flow_abs,
    m_flow_start_air=m_flow_air,
    nSeg=nNodes,
    show_T=true,
    redeclare Data.Chen_2016 data,
    flowConf=Choices.FlowConfiguration.CrossCurrent,
    mSeg=mNodes,
    redeclare model ThermalAir =
        HeatTransfer.Convection.Absorption.RandomPackings_ChenZhangYin,
    redeclare model MoistureAir =
        MoistureTransfer.Convection.Absorption.RandomPackings_ChenZhangYin,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    annotation (Placement(transformation(extent={{-30,-30},{30,30}})));

  BrineGrid.Fluid.Sources.MassFlowSource_T sou_air(
    redeclare package Medium = Medium_a,
    m_flow=m_flow_air,
    T=T_air,
    X=X_air,
    nPorts=1) annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Modelica.Blocks.Sources.Constant const(k=m_flow_abs)
    annotation (Placement(transformation(extent={{90,70},{70,90}})));
  Modelica.Fluid.Machines.ControlledPump pump(
    redeclare package Medium = Medium_b,
    m_flow_nominal=m_flow_abs,
    use_m_flow_set=true,
    redeclare function flowCharacteristic =
        Modelica.Fluid.Machines.BaseClasses.PumpCharacteristics.quadraticFlow (
          V_flow_nominal={0,0.25,0.5}, head_nominal={100,60,0}),
    p_a_nominal=200000,
    p_b_nominal=100000)
    annotation (Placement(transformation(extent={{60,40},{40,60}})));
  MixingVolumes.MixingVolume vol(
    redeclare package Medium = Medium_b,
    T_start=T_abs,
    X_start=X_abs,
    m_flow_nominal=m_flow_abs,
    nPorts=3,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    V(displayUnit="m3") = 1)
    annotation (Placement(transformation(extent={{40,-50},{60,-70}})));
  Storage.ExpansionVessel exp(
    redeclare package Medium = Medium_b,
    T_start=T_abs,
    X_start=X_abs,
    V_start=1e-4)
    annotation (Placement(transformation(extent={{40,-40},{60,-20}})));
equation
  connect(sin_air.ports[1], abs.port_a_out) annotation (Line(points={{-40,-50},
          {-18,-50},{-18,-30}}, color={0,127,255}));
  connect(sou_air.ports[1], abs.port_a_in)
    annotation (Line(points={{-40,50},{-18,50},{-18,30}}, color={0,127,255}));
  connect(abs.port_b_in, pump.port_b)
    annotation (Line(points={{18,30},{18,50},{40,50}}, color={0,127,255}));
  connect(const.y, pump.m_flow_set) annotation (Line(points={{69,80},{70,80},{
          55,80},{55,58.2}},
                          color={0,0,127}));
  connect(abs.port_b_out, vol.ports[1]) annotation (Line(points={{18,-30},{18,-30},{18,-44},{18,-50},
          {47.3333,-50}},                        color={0,127,255}));
  connect(vol.ports[2], pump.port_a) annotation (Line(points={{50,-50},{80,-50},
          {80,50},{60,50}}, color={0,127,255}));
  connect(exp.port_a, vol.ports[3]) annotation (Line(points={{50,-40},{50,-50},{52.6667,-50}},
                          color={0,127,255}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})),
    experiment(StopTime=7200),
    __Dymola_experimentSetupOutput,
    Documentation(revisions="<html>
<ul>
<li>April 26, 2017, by Yannick Fuerst:<br>First implementation. </li>
</ul>
</html>", info="<html>
<p>Example of an absorber unit with a closed liquid desiccant circuit consisting of a storage volume and an expansion vessel.
As pump model <a href=modelica://Modelica.Fluid.Machines.ControlledPump>Modelica.Fluid.Machines.ControlledPump</a> is
chosen. <a href=modelica://BrineGrid.Fluid.Movers.FlowControlled_m_flow>BrineGrid.Fluid.Movers.FlowControlled_m_flow</a>
yields a high order DAE and index reduction fails. The storage volume needs a steady-state mass balance for the same
reason. To consider changes in density of the liquid desiccant, the expansion vessel is required. Dehumidification of
moist air changes the composition of the liquid desiccant, which on the other hand changes the density significantly.</p>
</html>"));
end BatchCircuit;
