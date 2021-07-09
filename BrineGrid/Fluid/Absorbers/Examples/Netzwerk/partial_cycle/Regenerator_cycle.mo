within BrineGrid.Fluid.Absorbers.Examples.Netzwerk.partial_cycle;
model Regenerator_cycle
  extends Modelica.Icons.Example
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(
          preserveAspectRatio=false)));

  replaceable package Medium_a =
     Media.LiquidDesiccants.Air
    "Medium model for moist air"
    annotation(choicesAllMatching=true,Dialog(group="Medium"));
  replaceable package Medium_b =
    Media.LiquidDesiccants.MagnesiumChlorideAqueousSolution
    "Medium model for aqueous solution"
    annotation(choicesAllMatching=true,Dialog(group="Medium"));
    //Media.LiquidDesiccants.LithiumChlorideAqueousSolution_PatekKlomfar
    //MagnesiumChlorideAqueousSolution
  parameter String solvent = "magnesium chloride";

    //-------------air parameter---------//
  parameter Modelica.SIunits.Temperature T_air=273.15 + 35
    "Air inlet temperature";
  parameter Modelica.SIunits.MassFraction x_a=0.07
    "Water load of inlet air (humidity ratio), kg water/kg dry air";
  parameter Modelica.SIunits.MassFraction X_w=
    Media.LiquidDesiccants.Functions.totalHumidityToMassFraction(x=x_a)
    "Mass fraction of water in inlet air, kg/kg moist air";
  final parameter Modelica.SIunits.MassFraction[Medium_a.nX] X_air={X_w, 1 - X_w}
    "Composition of moist air";
  parameter Modelica.SIunits.MassFlowRate m_flow_air=1.85
    "Mass flow rate of inlet air";

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal_air=m_flow_air
    "Nominal mass flow rate of moist air";
  parameter Modelica.SIunits.AbsolutePressure dp_nominal_air=50
    "Nominal pressure drop on the air side";
    //---------------//

    //----------desiccant parameter---------//
  parameter Modelica.SIunits.Temperature T_abs=273.15 + 30
    "Aqueous solution inlet temperature";
  parameter Modelica.SIunits.Temperature T_abs_init = 273.15 + 30;

  parameter Modelica.SIunits.Temperature T_abs_cool = 273.15 + 60;

  parameter Modelica.SIunits.MassFraction X_s=0.1
    "Mass fraction of desiccant";
  final parameter Modelica.SIunits.MassFraction[Medium_b.nX] X_abs={1 - X_s, X_s}
    "Composition of aqueous solution";

  parameter Modelica.SIunits.MassFraction X_s_init=0.1
    "Mass fraction of desiccant";
  final parameter Modelica.SIunits.MassFraction[Medium_b.nX] X_abs_init={1 - X_s_init, X_s_init}
    "Composition of aqueous solution";
  parameter Modelica.SIunits.MassFlowRate m_flow_abs=1.61
    "Mass flow rate of aqueous solutio at inlet";

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal_abs=m_flow_abs
    "Nominal mass flow rate of aqueous solution";
  parameter Modelica.SIunits.AbsolutePressure dp_nominal_abs=50
    "Nominal pressure drop on the desiccant side";
  parameter Integer nNodes=10
    "Discretization of the desiccant flow";
  parameter Integer mNodes=10
    "Discretization of the air flow";
    //-----end desiccant parameter----//

  parameter Modelica.SIunits.Volume V = 0.5
  "Volume of the desiccant container";

    // The start values don't need to be defined using parameter, can be passed by the value of components, that
    // connected with the absorber.
    //----Air side & absorber---------//
  Adiabatic.AdiabaticAbsorber Regenerator(
    allowFlowReversal=true,
    redeclare Data.Chen_2016 data,
    flowConf=BrineGrid.Fluid.Absorbers.Choices.FlowConfiguration.CounterCurrent,
    p_start_abs=Medium_b.reference_p,
    final m_flow_nominal_abs=m_flow_nominal_abs,
    final m_flow_nominal_air=m_flow_nominal_air,
    final dp_nominal_abs=dp_nominal_abs,
    final dp_nominal_air=dp_nominal_air,
    final T_start_abs=T_abs_init,
    final T_start_air=T_air,
    final X_start_abs=X_abs_init,
    final X_start_air=X_air,
    final m_flow_start_abs=m_flow_abs,
    final m_flow_start_air=m_flow_air,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial,
    final nSeg=nNodes,
    final show_T=true,
    final mSeg=mNodes,
    redeclare final package Medium_a = Medium_a,
    redeclare final package Medium_b = Medium_b,
    redeclare model ThermalAir =
        HeatTransfer.Convection.Absorption.ConstantNusseltNumber_Absorption (
          Nu0=14),
    redeclare model MoistureAir =
        MoistureTransfer.Convection.Absorption.ConstantSherwoodNumber (Sh0=13))
    annotation (Placement(transformation(extent={{-260,12},{-190,82}})));

  Sources.MassFlowSource_T sou_air(
    use_T_in=false,
    redeclare final package Medium = Medium_a,
    final m_flow=m_flow_air,
    final T=T_air,
    final X=X_air,
    final nPorts=1)
                   "air source"
    annotation (Placement(transformation(extent={{-348,108},{-304,152}})));
  Sources.FixedBoundary sin_air(
      redeclare final package Medium = Medium_a,
      final nPorts=1) "air sink"
    annotation (Placement(transformation(extent={{-344,-34},{-306,4}})));

  //----------absorber circuit component----------//
  Buildings.Fluid.Movers.FlowControlled_m_flow DesPumpe(
    redeclare package Medium = Medium_b,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    p_start=Medium_b.reference_p,
    T_start=T_abs_init,
    X_start=X_abs_init,
    allowFlowReversal=true,
    m_flow_nominal=m_flow_nominal_abs,
    show_T=true,
    inputType=Buildings.Fluid.Types.InputType.Constant,
    addPowerToMedium=false,
    constantMassFlowRate=m_flow_abs)
                            "dessicant pump in absorber circuit" annotation (
      Placement(transformation(
        extent={{-19,-19},{19,19}},
        rotation=-90,
        origin={-177,207})));
  Buildings.Fluid.HeatExchangers.Heater_T DesHeater(
    redeclare package Medium = Medium_b,
    allowFlowReversal=true,
    m_flow_nominal=m_flow_nominal_abs,
    dp_nominal=50,
    linearizeFlowResistance=true,
    T_start=T_abs_init,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial) annotation (
      Placement(transformation(
        extent={{-28,-28},{28,28}},
        rotation=90,
        origin={38,194})));

  MixingVolumes.MixingVolumeAbsorption DesContainer(
    redeclare package Medium = Medium_b,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    p_start=Medium_b.reference_p,
    T_start=T_abs_init,
    X_start=X_abs_init,
    m_flow_nominal=m_flow_nominal_abs,
    allowFlowReversal=true,
    V=V,
    nPorts=3) annotation (
      Placement(transformation(
        extent={{-19,-19},{19,19}},
        rotation=90,
        origin={13,-33})));

  //----input via real expression---//
  Modelica.Blocks.Sources.RealExpression cooling_temp_input(y=T_abs_cool)
    annotation (Placement(transformation(extent={{-72,120},{-20,172}})));

  Modelica.Blocks.Sources.RealExpression T_abs_input(y=T_abs)
    annotation (Placement(transformation(extent={{-110,-90},{-74,-52}})));
  Sources.FixedBoundary                 sin_abs(redeclare package Medium =
        Medium_b,
    T=T_abs_init,
    X=X_abs_init, nPorts=1)
    annotation (Placement(transformation(extent={{90,-88},{62,-60}})));

  //---temp sensor----//
  Buildings.Fluid.Sensors.TemperatureTwoPort TempSen_AbsOut(
    redeclare package Medium = Medium_b,
    m_flow_nominal=m_flow_nominal_abs,
    T_start=T_abs_init)     annotation (Placement(transformation(extent={{-80,
            -146},{-44,-110}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort TempSen_AbsIn(
    redeclare package Medium = Medium_b,
    m_flow_nominal=m_flow_nominal_abs,
    T_start=T_abs_init)
                   annotation (Placement(transformation(extent={{-82,310},{-38,
            268}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TempSen_Container_Out(
    redeclare package Medium = Medium_b,
    allowFlowReversal=true,
    m_flow_nominal=m_flow_nominal_abs,
    T_start=T_abs_init)
                   annotation (Placement(transformation(
        extent={{-16,-18},{16,18}},
        rotation=90,
        origin={38,106})));

  //----concentration sensor-------//
  Sensors.MassFractionTwoPort conc_Absorber_out(
    redeclare final package Medium = Medium_b,
    m_flow_nominal=m_flow_nominal_abs,
    initType=Modelica.Blocks.Types.Init.InitialState,
    substanceName=solvent,
    X_start=X_s_init)     annotation (Placement(transformation(
        extent={{-17,17},{17,-17}},
        rotation=180,
        origin={-129,-127})));
  Sensors.MassFractionTwoPort conc_absorber_in(
    redeclare final package Medium = Medium_b,
    m_flow_nominal=m_flow_nominal_abs,
    initType=Modelica.Blocks.Types.Init.InitialState,
    substanceName=solvent,
    X_start=X_s_init)     annotation (Placement(transformation(
        extent={{-18,-18},{18,18}},
        rotation=180,
        origin={-118,288})));
  Sensors.MassFractionTwoPort conc_container_out(
    redeclare final package Medium = Medium_b,
    m_flow_nominal=m_flow_nominal_abs,
    initType=Modelica.Blocks.Types.Init.InitialState,
    substanceName=solvent,
    X_start=X_s_init)     annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={38,40})));

  //--others---//
  Buildings.Fluid.FixedResistances.PressureDrop preDro_des(
    redeclare package Medium = Medium_b,
    allowFlowReversal=true,
    m_flow_nominal=m_flow_nominal_abs,
    show_T=true,
    dp_nominal=50)                                  annotation (Placement(transformation(
        extent={{-14,-11},{14,11}},
        rotation=90,
        origin={-177,140})));

equation
  connect(sou_air.ports[1], Regenerator.port_a_in) annotation (Line(points={{-304,
          130},{-242,130},{-242,75.6364},{-242.5,75.6364}}, color={0,127,255}));
  connect(sin_air.ports[1], Regenerator.port_a_out) annotation (Line(points={{-306,
          -15},{-242.5,-15},{-242.5,27.9091}},      color={0,127,255}));
  connect(Regenerator.port_b_in, preDro_des.port_a) annotation (Line(points={{-207.5,
          75.6364},{-207.5,126},{-177,126}}, color={0,127,255}));
  connect(DesPumpe.port_b, preDro_des.port_b)
    annotation (Line(points={{-177,188},{-177,154}},
                                                  color={0,127,255}));
  connect(TempSen_AbsOut.port_b,DesContainer. ports[1]) annotation (Line(points={{-44,
          -128},{32,-128},{32,-38.0667}},      color={0,127,255}));
  connect(T_abs_input.y,DesContainer. TWat) annotation (Line(points={{-72.2,-71},
          {3.88,-71},{3.88,-55.8}},       color={0,0,127}));
  connect(DesContainer.ports[2], sin_abs.ports[1]) annotation (Line(points={{32,-33},
          {48,-33},{48,-74},{62,-74}},           color={0,127,255}));
  connect(Regenerator.port_b_out, conc_Absorber_out.port_b) annotation (Line(
        points={{-207.5,28.5455},{-207.5,-127},{-146,-127}}, color={0,127,255}));
  connect(conc_Absorber_out.port_a, TempSen_AbsOut.port_a) annotation (Line(
        points={{-112,-127},{-110,-127},{-110,-128},{-80,-128}},
                                                          color={0,127,255}));
  connect(conc_absorber_in.port_a, TempSen_AbsIn.port_a)
    annotation (Line(points={{-100,288},{-98,288},{-98,289},{-82,289}},
                                                 color={0,127,255}));
  connect(conc_absorber_in.port_b, DesPumpe.port_a) annotation (Line(points={{-136,
          288},{-177,288},{-177,226}},
                                     color={0,127,255}));
  connect(TempSen_Container_Out.port_a, conc_container_out.port_b)
    annotation (Line(points={{38,90},{38,60}},   color={0,127,255}));
  connect(conc_container_out.port_a,DesContainer. ports[3]) annotation (Line(
        points={{38,20},{38,-4},{32,-4},{32,-27.9333}},        color={0,127,255}));
  connect(cooling_temp_input.y,DesHeater. TSet) annotation (Line(points={{-17.4,
          146},{15.6,146},{15.6,160.4}}, color={0,0,127}));
  connect(DesHeater.port_a, TempSen_Container_Out.port_b)
    annotation (Line(points={{38,166},{38,122}}, color={0,127,255}));
  connect(TempSen_AbsIn.port_b,DesHeater. port_b)
    annotation (Line(points={{-38,289},{38,289},{38,222}}, color={0,127,255}));
  annotation (Diagram(coordinateSystem(extent={{-420,-340},{420,340}})), Icon(coordinateSystem(
          extent={{-420,-340},{420,340}})),
    experiment(
      StopTime=10000,
      Interval=10,
      __Dymola_Algorithm="Dassl"));
end Regenerator_cycle;
