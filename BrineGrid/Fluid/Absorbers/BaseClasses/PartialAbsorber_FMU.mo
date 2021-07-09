within BrineGrid.Fluid.Absorbers.BaseClasses;
partial model PartialAbsorber_FMU "partial absorber model for FMU usage"

  replaceable package Medium_a =
    BrineGrid.Media.Interfaces.PartialCondensingFluid
    "Medium model for moist air"
    annotation(choicesAllMatching=true,Dialog(group="Medium"));
  replaceable package Medium_b =
    BrineGrid.Media.Interfaces.PartialCondensingFluid
    "Medium model for aqueous solution"
    annotation(choicesAllMatching=true,Dialog(group="Medium"));
  parameter Boolean allowFlowReversal=true
    "= true to allow flow in both directions, false determines flow from port_a to port_b"
    annotation (Dialog(tab="Assumptions",group="Other"),Evaluate=true);

// variable type changed for FMU
  input Modelica.SIunits.Temperature T_start_abs=
    Medium_b.reference_T
    "Start value of absorbent temperature"
    annotation (Dialog(tab="Initialization",group="Temperature"),Evaluate=true);
  input Modelica.SIunits.Temperature T_start_air=
    Medium_a.reference_T
    "Start value of air temperature"
    annotation (Dialog(tab="Initialization",group="Temperature"),Evaluate=true);

  input Modelica.SIunits.MassFlowRate m_flow_start_abs
    "Start value of absorbent mass flow rate"
    annotation (dialog(tab="Initialization",group="Mass flow"),Evaluate=true);
  input Modelica.SIunits.MassFlowRate m_flow_start_air
    "Start value of air mass flow rate"
    annotation (dialog(tab="Initialization",group="Mass flow"),Evaluate=true);

  // Inititalization
  parameter Modelica.SIunits.AbsolutePressure p_start_abs=
    Medium_b.reference_p
    "Start value of absorbent pressure"
    annotation (dialog(tab="Initialization",group="Pressure"));
  parameter Modelica.SIunits.AbsolutePressure p_start_air=
    Medium_a.reference_p
    "Start value of air pressure"
    annotation (dialog(tab="Initialization",group="Pressure"));
  input Modelica.SIunits.MassFraction[Medium_b.nX] X_start_abs=
    Medium_b.X_default
    "Start value of absorbent composition"
    annotation (dialog(tab="Initialization",group="Composition",enable=AbsorbentFluid.nXi>0));
  input Modelica.SIunits.MassFraction[Medium_b.nX] X_start_air=
    Medium_a.X_default
    "Start value of air composition"
    annotation (dialog(tab="Initialization",group="Composition",enable=Medium_aFluid.nXi>0));

  // Nominal
  input Modelica.SIunits.MassFlowRate m_flow_nominal_abs(min=0)
    "Nominal mass flow rate of aqueous solution"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.Pressure dp_nominal_abs(min=0, displayUnit="Pa")
    "Nominal pressure drop in aqueous solution flow"
    annotation(Dialog(group = "Nominal condition"));
  input Modelica.SIunits.MassFlowRate m_flow_nominal_air(min=0)
    "Nominal mass flow rate of moist air"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.Pressure dp_nominal_air(min=0, displayUnit="Pa")
    "Nominal pressure drop in moist air flow"
    annotation(Dialog(group = "Nominal condition"));



  // Geometry
  replaceable parameter GeneralAdiabaticData data "Geometry data of absorber"
    annotation (
    Dialog(tab="General", group="Geometry"),
    choicesAllMatching=true,
    Placement(transformation(extent={{-28,-52},{-8,-32}})));
  parameter BrineGrid.Fluid.Absorbers.Choices.FlowConfiguration flowConf=Choices.FlowConfiguration.DirectCurrent
    "Flow configuration of air and aqueous solution"
    annotation (Dialog(tab="General", group="Geometry"), Evaluate=true);
  parameter Integer nSeg(min=1)=1
    "Discretisation in flow direction of absorbent"
    annotation(Dialog(tab="General", group="Geometry"),Evaluate=true);
  parameter Integer mSeg(min=1)=1
    "Discretisation in flow direction of air (enabled for cross flow)"
    annotation(Dialog(tab="General", group="Geometry", enable=flowConf ==
          BrineGrid.Fluid.Absorbers.Choices.FlowConfiguration.CrossCurrent and
          not data.isCircular),                                                                                                                                 Evaluate=true);


  // Assumptions
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=
    Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Formulation of energy balance"
     annotation(Evaluate=true, Dialog(tab="Assumptions", group="Dynamics"));
  parameter Modelica.Fluid.Types.Dynamics massDynamics=energyDynamics
    "Formulation of mass balance"
    annotation(Evaluate=true, Dialog(tab="Assumptions", group="Dynamics"));
  final parameter Modelica.Fluid.Types.Dynamics substanceDynamics=energyDynamics
    "Formulation of substance balance";
  final parameter Modelica.Fluid.Types.Dynamics traceDynamics=energyDynamics
    "Formulation of trace substance balance";

  // Advanced
  parameter Boolean show_T = false
    "= true, if actual temperature at port is computed"
    annotation(Dialog(tab="Advanced",group="Diagnostics"));
  parameter Boolean homotopyInitialization = true
    "= true, to use homotopy method"
    annotation(Evaluate=true, Dialog(tab="Advanced"));
  parameter Modelica.SIunits.MassFlowRate m_flow_small(min=0)=
    1E-4*abs(m_flow_nominal_air)
    "Small mass flow rate for regularization of zero flow"
    annotation(Dialog(tab = "Advanced"));
  parameter Boolean from_dp = false
    "= true, use m_flow = f(dp) else dp = f(m_flow)"
    annotation (Evaluate=true, Dialog(enable = computeFlowResistance, tab="Advanced"));
  parameter Boolean linearizeFlowResistance = false
    "= true, use linear relation between m_flow and dp for any flow rate"
    annotation(Dialog(enable = computeFlowResistance, tab="Advanced"));
  parameter Real deltaM = 0.3
    "Fraction of nominal flow rate where flow transitions laminar"
    annotation(Dialog(enable = computeFlowResistance, tab="Advanced"));

  // Thermodynamic state of media at ports
  Medium_b.ThermodynamicState abs_in=Medium_b.setState_phX(
    p=port_b_in.p,
    h=noEvent(actualStream(port_b_in.h_outflow)),
    X=noEvent(actualStream(port_b_in.Xi_outflow)))
    "Thermodynamic state of desiccant at inlet";
  Medium_b.ThermodynamicState abs_out=Medium_b.setState_phX(
    p=port_b_out.p,
    h=noEvent(actualStream(port_b_out.h_outflow)),
    X=noEvent(actualStream(port_b_out.Xi_outflow)))
    "Thermodynamic state of desiccant at outlet";
  Medium_a.ThermodynamicState air_in=Medium_a.setState_phX(
      p=port_a_in.p,
      h=noEvent(actualStream(port_a_in.h_outflow)),
      X=noEvent(actualStream(port_a_in.Xi_outflow)))
    "Thermodynamic state of moist air at inlet";
  Medium_a.ThermodynamicState air_out=Medium_a.setState_phX(
      p=port_a_out.p,
      h=noEvent(actualStream(port_a_out.h_outflow)),
      X=noEvent(actualStream(port_a_out.Xi_outflow)))
    "Thermodynamic state of moist air at outlet";

  BrineGrid.Fluid.FixedResistances.PressureDrop[absPar] preDro_abs(
    redeclare each final package Medium = Medium_b,
    each final from_dp=from_dp,
    each final show_T=show_T,
    each final m_flow_nominal=m_flow_nominal_abs,
    each final dp_nominal=dp_nominal_abs,
    each final allowFlowReversal=allowFlowReversal,
    each final linearized=linearizeFlowResistance,
    each final homotopyInitialization=homotopyInitialization,
    each final deltaM=deltaM) "Flow resistance of aqueous solution" annotation (
     Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={60,50})));
  BrineGrid.Fluid.MixingVolumes.MixingVolumeAbsorption[nNodesAbs,absPar]
    vol_abs(
    redeclare each final package Medium = Medium_b,
    each energyDynamics=energyDynamics,
    each massDynamics=massDynamics,
    each final V=data.volume/nNodesAbs/absPar,
    each prescribedHeatFlowRate=true,
    each final m_flow_small=m_flow_small,
    each final allowFlowReversal=allowFlowReversal,
    each nPorts=2,
    each final m_flow_nominal=m_flow_nominal_abs,
    each p_start=p_start_abs,
    each T_start=T_start_abs,
    each X_start=X_start_abs) "Volumes of aqueous solution"
                                                 annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={40,20})));
  BrineGrid.Fluid.FixedResistances.PressureDrop[airPar] preDro_air(
    redeclare each final package Medium = Medium_a,
    each final from_dp=from_dp,
    each final show_T=show_T,
    each final allowFlowReversal=allowFlowReversal,
    each final linearized=linearizeFlowResistance,
    each final homotopyInitialization=homotopyInitialization,
    each final deltaM=deltaM,
    each final m_flow_nominal=m_flow_nominal_air,
    each final dp_nominal=dp_nominal_air) "Flow resistance of moist air"
                                                             annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-60,50})));
  BrineGrid.Fluid.MixingVolumes.MixingVolumeAbsorption[nNodesAir,airPar]
    vol_air(
    redeclare each final package Medium = Medium_a,
    each energyDynamics=energyDynamics,
    each massDynamics=massDynamics,
    each final V=data.volume/nNodesAir/airPar,
    each prescribedHeatFlowRate=true,
    each final m_flow_small=m_flow_small,
    each final allowFlowReversal=allowFlowReversal,
    each nPorts=2,
    each p_start=p_start_air,
    each T_start=T_start_air,
    each X_start=X_start_air,
    each final m_flow_nominal=m_flow_nominal_air) "Volumes of moist air"
                                          annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={-40,20})));
  ThermalAbs[nNodesAbs,absPar] thermal_abs(
    each final deq=data.deq,
    each final a=data.a,
    each final epsilon=data.epsilon,
    redeclare each final package Medium_a = Medium_a,
    redeclare each final package Medium_b = Medium_b,
    each final surface=data.surface/nNodesAbs/absPar,
    each final crossArea=data.crossArea,
    each final inflow_a=air_in,
    each final inflow_b=abs_in,
    each final m_flow_in_a=port_a_in.m_flow,
    each final m_flow_in_b=port_b_in.m_flow)
    "Heat transfer within aqueous solution" annotation (Placement(
        transformation(extent={{10,40},{30,60}}, rotation=0)));
  ThermalAir[nNodesAir,airPar] thermal_air(
    each final deq=data.deq,
    each final a=data.a,
    each final epsilon=data.epsilon,
    redeclare each final package Medium_a = Medium_a,
    redeclare each final package Medium_b = Medium_b,
    each final surface=data.surface/nNodesAir/airPar,
    each final crossArea=if dirCur or couCur then
      data.crossArea else data.height*data.width,
    each final inflow_a=air_in,
    each final inflow_b=abs_in,
    each final m_flow_in_a=port_a_in.m_flow,
    each final m_flow_in_b=port_b_in.m_flow)
    "Heat transfer within moist air" annotation (Placement(transformation(
          extent={{-6,40},{-26,60}},  rotation=0)));
  MoistureAbs[nNodesAbs,absPar] moisture_abs(
    each final deq=data.deq,
    each final a=data.a,
    each final epsilon=data.epsilon,
    redeclare each final package Medium_a = Medium_a,
    redeclare each final package Medium_b = Medium_b,
    each final surface=data.surface/nNodesAbs/absPar,
    each final crossArea=data.crossArea,
    each final inflow_a=air_in,
    each final inflow_b=abs_in,
    each final m_flow_in_a=port_a_in.m_flow,
    each final m_flow_in_b=port_b_in.m_flow)
    "Mass transfer within aqueous solution" annotation (Placement(
        transformation(extent={{10,-20},{30,0}}, rotation=0)));
  MoistureAir[nNodesAir, airPar] moisture_air(
    each final deq=data.deq,
    each final a=data.a,
    each final epsilon=data.epsilon,
    redeclare each final package Medium_a = Medium_a,
    redeclare each final package Medium_b = Medium_b,
    each final surface=data.surface/nNodesAir/airPar,
    each final crossArea=if dirCur or couCur then
      data.crossArea else data.height*data.width,
    each final inflow_a=air_in,
    each final inflow_b=abs_in,
    each final m_flow_in_a=port_a_in.m_flow,
    each final m_flow_in_b=port_b_in.m_flow) "Mass transfer within moist air"
    annotation (Placement(
        transformation(extent={{-6,-20},{-26,0}},    rotation=0)));

  // declare models, although these already used before, but could be declared later in Modelica
  replaceable model ThermalAir =
    BrineGrid.HeatTransfer.Convection.Absorption.IdealHeatTransfer
    constrainedby
    BrineGrid.HeatTransfer.BaseClasses.PartialConvectionAbsorption
    "Model to calculate the gaseous heat transfer"
    annotation (Dialog(tab="Assumptions",group="Heat and mass transfer"), choicesAllMatching=true);
  replaceable model MoistureAir =
    BrineGrid.MoistureTransfer.Convection.Absorption.IdealMassTransfer
    constrainedby
    BrineGrid.MoistureTransfer.BaseClasses.PartialConvectionGeneral
    "Model to calculate the gaseous mass transfer"
    annotation (Dialog(tab="Assumptions",group="Heat and mass transfer"), choicesAllMatching=true);
  replaceable model ThermalAbs =
    BrineGrid.HeatTransfer.Convection.Absorption.IdealHeatTransfer
    constrainedby BrineGrid.HeatTransfer.BaseClasses.PartialConvectionGeneral
    "Model to calculate the liquid heat transfer"
    annotation (Dialog(tab="Assumptions",group="Heat and mass transfer"), choicesAllMatching=true);
  replaceable model MoistureAbs =
    BrineGrid.MoistureTransfer.Convection.Absorption.IdealMassTransfer
    constrainedby
    BrineGrid.MoistureTransfer.BaseClasses.PartialConvectionGeneral
    "Model to calculate the liquid mass transfer"
    annotation (Dialog(tab="Assumptions",group="Heat and mass transfer"), choicesAllMatching=true);

  Modelica.Blocks.Sources.RealExpression[nNodesAbs,absPar] TAbs(y=
        thermal_abs.heatPort_b.T)
    annotation (Placement(transformation(extent={{10,70},{30,90}})));
  Modelica.Blocks.Sources.RealExpression[nNodesAir,airPar] TAir(y=
        thermal_air.heatPort_b.T)
    annotation (Placement(transformation(extent={{-8,70},{-28,90}})));
  Splitter floDis_air_in(
    redeclare package Medium = Medium_a,
    nPar=airPar,
    allowFlowReversal=allowFlowReversal) "Mass flow distributor of air inflow"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-60,80})));
  Splitter floDis_air_out(
    redeclare package Medium = Medium_a,
    nPar=airPar,
    allowFlowReversal=allowFlowReversal) "Mass flow distributor of air inflow"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={-60,-10})));
  Splitter floDis_abs_in(
    redeclare package Medium = Medium_b,
    nPar=absPar,
    allowFlowReversal=allowFlowReversal) "Mass flow distributor of absorbent inflow"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={60,80})));
  Splitter floDis_abs_out(
    redeclare package Medium = Medium_b,
    nPar=absPar,
    allowFlowReversal=allowFlowReversal) "Mass flow distributor of absorbent inflow"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={60,-10})));
  Modelica.Fluid.Interfaces.FluidPort_a port_b_in(
    redeclare package Medium=Medium_b,
    p(start=p_start_abs),
    h_outflow(start=h_start_abs),
    Xi_outflow(start=X_start_abs[1:Medium_b.nXi]),
    m_flow(
        start=m_flow_start_abs,
        min=if allowFlowReversal then -Modelica.Constants.inf else 0))
    "Absorbent entering the absorber"
    annotation (Placement(transformation(extent={{50,90},{70,110}}),
        iconTransformation(extent={{50,90},{70,110}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b_out(
    redeclare package Medium=Medium_b,
    p(start=p_start_abs),
    h_outflow(start=h_start_abs),
    Xi_outflow(start=X_start_abs[1:Medium_b.nXi]),
    m_flow(
        start=m_flow_start_abs,
        min=if allowFlowReversal then -Modelica.Constants.inf else 0))
    "Absorbent leaving the absorber"
    annotation (Placement(transformation(extent={{52,-110},{72,-90}}), iconTransformation(extent={{
            52,-110},{72,-90}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a_in(
    redeclare package Medium = Medium_a,
    p(start=p_start_air),
    h_outflow(start=h_start_air),
    Xi_outflow(start=X_start_air[1:Medium_a.nXi]),
    m_flow(start=m_flow_start_air, min=if allowFlowReversal then -Modelica.Constants.inf
           else 0)) "Moist air entering the absorber"
    annotation (Placement(transformation(extent={{-70,90},{-50,110}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_a_out(
    redeclare package Medium = Medium_a,
    p(start=p_start_air),
    h_outflow(start=h_start_air),
    Xi_outflow(start=X_start_air[1:Medium_a.nXi]),
    m_flow(start=m_flow_start_air, min=if allowFlowReversal then -Modelica.Constants.inf
           else 0)) "Moist air leaving the absorber"
    annotation (Placement(transformation(extent={{-76,-110},{-56,-90}}), iconTransformation(extent=
            {{-76,-110},{-56,-90}})));
protected
  final parameter Medium_b.SpecificEnthalpy h_start_abs=Medium_b.specificEnthalpy(
    Medium_b.setState_pTX(
      p_start_abs,
      T_start_abs,
      X_start_abs));
  final parameter Medium_a.SpecificEnthalpy h_start_air=Medium_a.specificEnthalpy(
    Medium_a.setState_pTX(
      p_start_air,
      T_start_air,
      X_start_air));
  final parameter Boolean croCur=flowConf == Choices.FlowConfiguration.CrossCurrent;
  // == it's a condition
  final parameter Boolean dirCur=flowConf == Choices.FlowConfiguration.DirectCurrent;
  final parameter Boolean couCur=flowConf == Choices.FlowConfiguration.CounterCurrent;
  final parameter Integer absPar=if croCur then mSeg else 1;
  final parameter Integer airPar=if croCur then nSeg else 1;
  final parameter Integer nNodesAbs=nSeg;
  final parameter Integer nNodesAir=if croCur then mSeg else nSeg;
  // only at cross current could be a different configurations at different flow directions
equation
  assert((data.isCircular and (couCur or dirCur)) or not data.isCircular,
    "The circular absorber supports only direct and counter current flow");

  // air flow discretisation
  for j in 1:airPar loop
    connect(preDro_air[j].port_b, vol_air[1, j].ports[1]) annotation (Line(
          points={{-60,40},{-60,40},{-60,22},{-50,22}}, color={0,127,255}));
    if nNodesAir > 1 then
      // discrete the vol_air
      for i in 1:(nNodesAir - 1) loop
        connect(vol_air[i, j].ports[2], vol_air[i + 1, j].ports[1]);
      end for;
    end if;
    connect(vol_air[nNodesAir, j].ports[2], floDis_air_out.port_b[j]) annotation (Line(points={{-50,18},
            {-60,18},{-60,0}},                                                                                                        color={0,
            127,255}));
  end for;

  // absorbent flow discretisation
  for j in 1:absPar loop
    connect(preDro_abs[j].port_b, vol_abs[1, j].ports[1]) annotation (Line(points={{60,40},{60,22},{50,22}}, color={0,127,255}));
    if nNodesAbs > 1 then
      for i in 1:(nNodesAbs - 1) loop
        // discrete vol_abs
        connect(vol_abs[i, j].ports[2], vol_abs[i + 1, j].ports[1]);
      end for;
    end if;
    connect(vol_abs[nNodesAbs, j].ports[2], floDis_abs_out.port_b[j]) annotation (Line(points={{50,18},
            {60,18},{60,0}},                                                                                              color={0,127,255}));
  end for;

  // for flow configuration
  if dirCur then
    connect(thermal_air.heatPort_b, thermal_abs.heatPort_b) annotation (Line(points={{-6,50},{10,50}},         color={191,0,0}));
    connect(moisture_air.moisturePort_b, moisture_abs.moisturePort_b) annotation (Line(points={{-6,-10},
            {10,-10}},                                                                                                       color={85,170,255}));
  elseif couCur then
    for i in 1:nNodesAbs loop
      for j in 1:absPar loop
        connect(thermal_abs[i, j].heatPort_b, thermal_air[nNodesAbs + 1 - i, j].heatPort_b);
        connect(moisture_abs[i, j].moisturePort_b, moisture_air[nNodesAbs + 1 - i, j].moisturePort_b);
      end for;
    end for;
  elseif croCur then
    for i in 1:nNodesAbs loop
      for j in 1:nNodesAir loop
        connect(thermal_abs[i, j].heatPort_b, thermal_air[j, i].heatPort_b);
        connect(moisture_abs[i, j].moisturePort_b, moisture_air[j, i].moisturePort_b);
      end for;
    end for;
  else
    assert(false, "Invalid choice for flowConf");
  end if;

  // connect pressuredrop and distribution
  connect(floDis_air_in.port_b, preDro_air.port_a) annotation (Line(points={{-60,70},{-60,60}}, color={0,127,255}));
  connect(floDis_abs_in.port_b, preDro_abs.port_a) annotation (Line(points={{60,70},
          {60,60}},                                                                                   color={0,127,255}));

  //desiccant H&M connect with reservoir
  connect(thermal_abs.heatPort_a, vol_abs.heatPort) annotation (Line(points={{30,50},{40,50},{40,30}}, color={191,0,0}));
  connect(moisture_abs.moisturePort_a, vol_abs.moisturePort) annotation (Line(points={{30,-10},{40,-10},{40,10}}, color={85,170,255}));
  connect(TAbs.y, vol_abs.TWat) annotation (Line(points={{31,80},{35.2,80},{35.2,32}}, color={0,0,127}));

  //air H&M connect with reservoir
  connect(thermal_air.heatPort_a, vol_air.heatPort) annotation (Line(
        points={{-26,50},{-40,50},{-40,30}},                   color={191,0,0}));
  connect(moisture_air.moisturePort_a, vol_air.moisturePort) annotation (Line(points={{-26,-10},{
          -40,-10},{-40,10}},                                                                                        color={85,170,255}));
  connect(TAir.y, vol_air.TWat) annotation (Line(points={{-29,80},{-35.2,80},{-35.2,32}},
                color={0,0,127}));

  //import
  connect(floDis_air_in.port_a, port_a_in) annotation (Line(points={{-60,90},{-60,90},{-60,100}}, color={0,127,255}));
  connect(floDis_abs_in.port_a, port_b_in) annotation (Line(points={{60,90},{60,
          90},{60,100}},         color={0,127,255}));

  //outport
  connect(floDis_air_out.port_a, port_a_out) annotation (Line(points={{-60,-20},{-60,-58},{-60,-100},
          {-66,-100}},                                color={0,127,255}));
  connect(floDis_abs_out.port_a, port_b_out) annotation (Line(points={{60,-20},{60,-60},{60,-100},{
          62,-100}},           color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-120,-100},{120,120}}),
                   graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(points={{-60,80},{60,80}}, color={0,0,0}),
        Line(points={{-60,80},{-70,60}}, color={0,0,0}),
        Line(points={{-60,80},{-50,60}}, color={0,0,0}),
        Line(points={{-60,80},{-60,60}}, color={0,0,0}),
        Line(points={{60,80},{50,60}}, color={0,0,0}),
        Line(points={{60,80},{70,60}}, color={0,0,0}),
        Line(points={{60,80},{60,60}}, color={0,0,0}),
        Line(points={{-20,80},{-30,60}}, color={0,0,0}),
        Line(points={{-20,80},{-10,60}}, color={0,0,0}),
        Line(points={{-20,80},{-20,60}}, color={0,0,0}),
        Line(points={{20,80},{10,60}}, color={0,0,0}),
        Line(points={{20,80},{30,60}}, color={0,0,0}),
        Line(points={{20,80},{20,60}}, color={0,0,0}),
        Line(points={{-80,40},{-60,30},{-80,20},{-60,10},{-80,0},{-60,-10},{-80,
              -20},{-60,-30},{-80,-40},{-60,-50},{-80,-60},{-60,-70},{-80,-80}},
            color={0,0,0}),
        Line(points={{60,40},{80,30},{60,20},{80,10},{60,0},{80,-10},{60,-20},{
              80,-30},{60,-40},{80,-50},{60,-60},{80,-70},{60,-80}},
                                                                  color={0,0,0}),
        Line(points={{-10,40},{10,30},{-10,20},{10,10},{-10,0},{10,-10},{-10,
              -20},{10,-30},{-10,-40},{10,-50},{-10,-60},{10,-70},{-10,-80}},
                                                                         color={
              0,0,0}),
        Line(points={{-46,40},{-26,30},{-46,20},{-26,10},{-46,0},{-26,-10},{-46,
              -20},{-26,-30},{-46,-40},{-26,-50},{-46,-60},{-26,-70},{-46,-80}},
            color={0,0,0}),
        Line(points={{26,40},{46,30},{26,20},{46,10},{26,0},{46,-10},{26,-20},{
              46,-30},{26,-40},{46,-50},{26,-60},{46,-70},{26,-80}},
                                                                  color={0,0,0}),
        Text(
          extent={{-100,110},{100,150}},
          lineColor={28,108,200},
          textString="%name"),
        Line(
          points={{53,26},{53,-54},{61,-34},{53,-54},{45,-34}},
          color={255,0,0},
          thickness=0.5),
        Line(
          points={{-52,26},{-52,-54},{-44,-34},{-52,-54},{-60,-34}},
          color={28,108,200},
          thickness=0.5),
        Text(
          extent={{56,56},{92,42}},
          lineColor={255,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="abs"),
        Text(
          extent={{-92,56},{-56,42}},
          lineColor={28,108,200},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="air")}),
      Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,-100},{120,120}})),
    Documentation(revisions="<html>
<ul>
<li>
February 21, 2017, by Yannick Fuerst:<br/>
Adapted to geometric data record.
</li>
<li>
January 04, 2017, by Yannick Fuerst:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>Partial model for adiabatic and internally cooled absorber models. </p>
</html>"));
end PartialAbsorber_FMU;
