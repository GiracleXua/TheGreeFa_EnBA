within BrineGrid.Fluid.Absorbers.BaseClasses;
partial model PartialCooledAbsorber
  extends Adiabatic.AdiabaticAbsorber;
  replaceable package Medium_c = Modelica.Media.Interfaces.PartialMedium
    "Medium model for cooling fluid" annotation(choicesAllMatching=true,Dialog(group="Medium"));

  // Geometry
  parameter Boolean coolingIsCircular=false
    "= true if cross sectional area is circular" annotation(Dialog(tab="General", group="Cooling"),Evaluate=true);
  parameter Modelica.SIunits.Length coolingLength=1.0
    "Total length of cooling fluid flow channel" annotation(Dialog(tab="General", group="Cooling"));
  parameter Modelica.SIunits.Diameter coolingDiameter=1.0
    "Diameter of cooling fluid flow channel" annotation(Dialog(tab="General", group="Cooling", enable=coolingIsCircular));

  // Inititalization
  parameter Modelica.SIunits.AbsolutePressure p_start_cool=Medium_a.reference_p
    "Start value of cooling fluid pressure" annotation (dialog(tab="Initialization",group="Pressure"));
  parameter Modelica.SIunits.Temperature T_start_cool=Medium_a.reference_T
    "Start value of cooling fluid temperature" annotation (Dialog(tab="Initialization",group="Temperature"),Evaluate=true);
  parameter Modelica.SIunits.MassFraction[Medium_c.nX] X_start_cool=Medium_c.X_default
    "Start value of cooling fluid composition" annotation (dialog(tab="Initialization",group="Composition",enable=Medium_a.nXi>0));
  parameter Modelica.SIunits.MassFlowRate m_flow_start_cool
    "Start value of cooling fluid mass flow rate" annotation (dialog(tab="Initialization",group="Mass flow"),Evaluate=true);

  // Assumptions
  parameter BrineGrid.Fluid.Absorbers.Choices.FlowConfigurationCooling flowConfCool=Choices.FlowConfigurationCooling.DirectCurrent
    "Flow configuration of cooling fluid and aqueous solution" annotation (
      Dialog(tab="Assumptions", group="Discretization"), Evaluate=true);

  // Nominal
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal_cool(min=0)
    "Nominal mass flow rate of cooling fluid" annotation(Dialog(tab="Flow", group = "Nominal condition"));
  parameter Modelica.SIunits.Pressure dp_nominal_cool(min=0, displayUnit="Pa")
    "Nominal pressure drop in cooling fluid flow" annotation(Dialog(tab="Flow", group = "Nominal condition"));

  // Internal properties
  Medium_c.ThermodynamicState cool_in=Medium_c.setState_phX(port_c_in.p,
      noEvent(actualStream(port_c_in.h_outflow)),
      noEvent(actualStream(port_c_in.Xi_outflow)))
    "Medium properties in port_c_in";
  Medium_c.ThermodynamicState cool_out=Medium_c.setState_phX(port_c_out.p,
      noEvent(actualStream(port_c_out.h_outflow)),
      noEvent(actualStream(port_c_out.Xi_outflow)))
    "Medium properties in port_c_out";

  BrineGrid.Fluid.FixedResistances.PressureDrop[absPar] preDroCool(
    redeclare each final package Medium = Medium_c,
    each final from_dp=from_dp,
    each final show_T=show_T,
    each final m_flow_nominal=m_flow_nominal_cool,
    each final dp_nominal=dp_nominal_cool,
    each final allowFlowReversal=allowFlowReversal,
    each final linearized=linearizeFlowResistance,
    each final homotopyInitialization=homotopyInitialization,
    each final deltaM=deltaM) "Flow resistance of cooling fluid" annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={30,-84})));
  BrineGrid.Fluid.MixingVolumes.MixingVolume[nNodesAbs,absPar] volCool(
    redeclare each final package Medium = Medium_c,
    each energyDynamics=energyDynamics,
    each massDynamics=massDynamics,
    each final V=data.volume/nNodesAbs/absPar,
    each final m_flow_nominal=m_flow_nominal_cool,
    each prescribedHeatFlowRate=true,
    each p_start=p_start_cool,
    each T_start=T_start_cool,
    each X_start=X_start_cool,
    each final m_flow_small=m_flow_small,
    each final allowFlowReversal=allowFlowReversal,
    each nPorts=2) "Volumes of cooling fluid" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-4,-86})));

  replaceable model ThermalCool =
      BrineGrid.HeatTransfer.Convection.IdealHeatTransfer
    constrainedby BrineGrid.HeatTransfer.BaseClasses.PartialConvectionGeneral
    "Model to calculate the cooling heat transfer" annotation (Dialog(tab="Assumptions",group="Heat and mass transfer"), choicesAllMatching=true);

  ThermalCool[nNodesAbs,absPar] thermal_cool(
    each final deq=data.deq,
    redeclare each final package Medium_a = Medium_c,
    each final surface=data.surface/nNodesAir/airPar,
    each final crossArea=if dirCur or couCur then
      data.crossArea else data.height*data.width,
    each final inflow_a=cool_in,
    each final m_flow_in_a=port_c_in.m_flow)
    "Heat transfer within cooling fluid" annotation (Placement(transformation(
          extent={{38,-52},{18,-32}}, rotation=0)));

  Splitter floDis_cool_out(
    nPar=absPar,
    allowFlowReversal=allowFlowReversal,
    redeclare package Medium = Medium_c)
    "Mass flow distributor of cooling fluid outflow"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-68,-76})));
  Splitter floDis_cool_in(
    nPar=absPar,
    allowFlowReversal=allowFlowReversal,
    redeclare package Medium = Medium_c)
    "Mass flow distributor of cooling fluid inflow"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={70,-84})));
  Modelica.Fluid.Interfaces.FluidPort_b port_c_out(
    redeclare package Medium = Medium_c,
    p(start=p_start_cool),
    h_outflow(start=h_start_cool),
    Xi_outflow(start=X_start_cool[1:Medium_c.nXi]),
    m_flow(start=m_flow_start_cool, min=if allowFlowReversal then -Modelica.Constants.inf
           else 0)) "Cooling fluid flowing out of the absorber" annotation (Placement(transformation(extent={{-100,
            -86},{-80,-66}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_c_in(
    redeclare package Medium = Medium_c,
    p(start=p_start_cool),
    h_outflow(start=h_start_cool),
    Xi_outflow(start=X_start_cool[1:Medium_c.nXi]),
    m_flow(start=m_flow_start_cool, min=if allowFlowReversal then -Modelica.Constants.inf
           else 0)) "Cooling fluid flowing in the absorber" annotation (Placement(transformation(extent={{78,-94},
            {98,-74}})));
protected
  final parameter Medium_c.SpecificEnthalpy h_start_cool=Medium_c.specificEnthalpy(
    Medium_c.setState_pTX(
      p_start_cool,
      T_start_cool,
      X_start_cool));
  final parameter Boolean dirCurCool=flowConfCool == Choices.FlowConfigurationCooling.DirectCurrent;
  final parameter Boolean couCurCool=flowConfCool == Choices.FlowConfigurationCooling.CounterCurrent;
equation
  for j in 1:absPar loop
    connect(preDroCool[j].port_b, volCool[1, j].ports[1]) annotation (Line(points={{20,-84},{20,-70},
            {-2,-70},{-2,-76}},
                            color={0,127,255}));
    if nNodesAbs > 1 then
      for i in 1:(nNodesAbs - 1) loop
        connect(volCool[i, j].ports[2], volCool[i + 1, j].ports[1]);
      end for;
    end if;
    connect(volCool[nNodesAbs, j].ports[2], floDis_cool_out.port_b[j]) annotation (Line(points={{-6,-76},
            {-6,-70},{-32,-70},{-32,-76},{-58,-76}},
                                color={0,127,255}));
  end for;
  if dirCurCool then
    connect(thermal_cool.heatPort_b, vol_abs.heatPort) annotation (Line(points={{38,-42},{38,-46},{
            70,-46},{70,34},{40,34},{40,30}},                    color={191,0,0}));
  elseif couCurCool then
    for i in 1:nNodesAbs loop
      for j in 1:absPar loop
        connect(thermal_cool[i, j].heatPort_b, vol_abs[nNodesAbs + 1 - i, j].heatPort);
      end for;
    end for;
  else
    assert(false, "Invalid choice for flowConfCooling");
  end if;
  connect(volCool.heatPort, thermal_cool.heatPort_a) annotation (Line(points={{6,-86},{6,-42},{18,
          -42}},                                                                                         color={191,0,0}));
  connect(floDis_cool_in.port_b, preDroCool.port_a) annotation (Line(points={{60,-84},{40,-84}},     color={0,127,255}));
  connect(floDis_cool_out.port_a, port_c_out) annotation (Line(points={{-78,-76},{-90,-76}},
                                        color={0,127,255}));
  connect(floDis_cool_in.port_a, port_c_in) annotation (Line(points={{80,-84},{88,-84}},
                                              color={0,127,255}));
  connect(port_a_out, port_a_out)
    annotation (Line(points={{-60,-36},{-60,-36},{-60,-36}}, color={0,127,255}));
  annotation (Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={Line(
          points={{-100,20},{70,20},{-70,-60},{100,-60}},
          color={28,108,200},
          thickness=0.5,
          pattern=LinePattern.Dash),
        Text(
          extent={{64,-76},{100,-90}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="cool")}),
    Documentation(revisions="<html>
<ul>
<li>
January 04, 2017, by Yannick Fuerst:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>This partial model is based on <a href=\"modelica://BrineGrid.Fluid.Absorption.BaseClasses.PartialAbsorber\">PartialAbsorber</a>. It adds definitions for internally cooled absorbers.</p>
</html>"));
end PartialCooledAbsorber;
