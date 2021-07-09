within BrineGrid.Fluid.Absorbers.Examples.Netzwerk.partial_cycle;
package Others
  extends Modelica.Icons.ExamplesPackage;
  model test_CFD
    extends Modelica.Icons.Example;
    Adiabatic.AdiabaticAbsorber Absorber
      annotation (Placement(transformation(extent={{18,-4},{72,50}})));
    Buildings.Fluid.Sensors.RelativeHumidityTwoPort senRelHum annotation (Placement(transformation(
          extent={{-8,-8},{8,8}},
          rotation=90,
          origin={-64,44})));
    Buildings.Fluid.Sensors.TemperatureTwoPort senTem annotation (Placement(transformation(
          extent={{-7,-7},{7,7}},
          rotation=90,
          origin={-63,75})));
    Movers.FlowControlled_m_flow fan4
      annotation (Placement(transformation(extent={{-4,-62},{-24,-82}})));
    Buildings.Fluid.Sensors.RelativeHumidityTwoPort senRelHum3 annotation (Placement(transformation(
          extent={{-8,-8},{8,8}},
          rotation=90,
          origin={-66,-52})));
    Buildings.Fluid.Sensors.TemperatureTwoPort senTem7 annotation (Placement(transformation(
          extent={{-7,-7},{7,7}},
          rotation=90,
          origin={-65,-23})));
    Buildings.Fluid.FixedResistances.PressureDrop res2 annotation (Placement(transformation(
          extent={{-6,-6},{6,6}},
          rotation=180,
          origin={-16,94})));
    Buildings.Fluid.FixedResistances.PressureDrop res3 annotation (Placement(transformation(
          extent={{6,-6},{-6,6}},
          rotation=270,
          origin={32,-36})));
    Buildings.ThermalZones.Detailed.MixedAir mixedAir(nPorts=2)
      annotation (Placement(transformation(extent={{-72,30},{-112,-10}})));
  equation
    connect(senTem.port_a,senRelHum. port_b)
      annotation (Line(points={{-63,68},{-64,68},{-64,52}},    color={0,127,255}));
    connect(senTem7.port_a,senRelHum3. port_b)
      annotation (Line(points={{-65,-30},{-66,-30},{-66,-44}},    color={0,127,255}));
    connect(senRelHum3.port_a,fan4. port_b)
      annotation (Line(points={{-66,-60},{-66,-72},{-24,-72}},      color={0,127,255}));
    connect(Absorber.port_a_in,res2. port_a)
      annotation (Line(points={{31.5,45.0909},{31.5,94},{-10,94}},        color={0,127,255}));
    connect(res2.port_b,senTem. port_b)
      annotation (Line(points={{-22,94},{-63,94},{-63,82}},      color={0,127,255}));
    connect(Absorber.port_a_out,res3. port_b) annotation (Line(points={{31.5,8.27273},{31.5,-9.5},{
            32,-9.5},{32,-30}},    color={0,127,255}));
    connect(res3.port_a,fan4. port_a)
      annotation (Line(points={{32,-42},{32,-72},{-4,-72}},      color={0,127,255}));
    connect(senRelHum.port_a, mixedAir.ports[1])
      annotation (Line(points={{-64,36},{-64,22},{-77,22}}, color={0,127,255}));
    connect(senTem7.port_b, mixedAir.ports[2])
      annotation (Line(points={{-65,-16},{-64,-16},{-64,18},{-77,18}}, color={0,127,255}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-200,-180},{180,140}})),
        Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-200,-180},{180,140}})));
  end test_CFD;

  model tempo
    Buildings.Fluid.HeatExchangers.HeaterCooler_u hea(redeclare package Medium = Medium_w)
                                           annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=90,
          origin={-12,22})));
    Modelica.Thermal.HeatTransfer.Components.ThermalConductor wall(G=1.6e5/5)
      annotation (Placement(transformation(
          origin={16,-48},
          extent={{-8,-10},{8,10}},
          rotation=180)));
    Modelica.Thermal.HeatTransfer.Sources.FixedTemperature T_ambient(T=313.15)
      annotation (Placement(transformation(extent={{54,-55},{40,-41}})));
    Modelica.Blocks.Sources.RealExpression realExpression(y=2)
      annotation (Placement(transformation(extent={{-58,-16},{-38,4}})));
    Buildings.Fluid.FixedResistances.PressureDrop res3(
      redeclare package Medium = Medium_w,
      m_flow_nominal=m_flow_nominal,
      show_T=true,
      dp_nominal=10000,
      linearized=true) "Flow resistance to decouple pressure state from boundary"
      annotation (Placement(transformation(extent={{52,64},{68,80}})));
    Buildings.Fluid.Sources.Boundary_pT bou3(
      redeclare package Medium = Medium_w,
      p=Medium_w.reference_p,
      T=T_w_0,
      nPorts=1)
      "Fixed pressure boundary condition, required to set a reference pressure"
      annotation (Placement(transformation(extent={{94,64},{80,78}})));
  equation
    connect(T_ambient.port,wall. port_a)
      annotation (Line(points={{40,-48},{24,-48}}, color={191,0,0}));
    connect(res3.port_a, DesContainer.ports[1]) annotation (Line(points={{52,72},
            {31.3333,72},{31.3333,92}},    color={0,127,255}));
    connect(res3.port_b,bou3. ports[1]) annotation (Line(points={{68,72},{76,72},
            {76,71},{80,71}},color={0,127,255}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(
            preserveAspectRatio=false)));
  end tempo;

  model HeatingSystem "Simple model of a heating system"
    extends Modelica.Icons.Example;
     replaceable package Medium =
        Modelica.Media.Water.StandardWater
       constrainedby Modelica.Media.Interfaces.PartialMedium;

    Modelica.Fluid.Vessels.OpenTank tank(
      redeclare package Medium = Medium,
      crossArea=0.01,
      height=2,
      level_start=1,
      nPorts=2,
      massDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
      use_HeatTransfer=true,
      portsData={Modelica.Fluid.Vessels.BaseClasses.VesselPortsData(diameter=
          0.01),Modelica.Fluid.Vessels.BaseClasses.VesselPortsData(diameter=
          0.01)},
      redeclare model HeatTransfer =
          Modelica.Fluid.Vessels.BaseClasses.HeatTransfer.IdealHeatTransfer (k=10),
      ports(each p(start=1.1e5)),
      T_start=Modelica.SIunits.Conversions.from_degC(20))
                annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
    Modelica.Fluid.Machines.ControlledPump pump(
      redeclare package Medium = Medium,
      N_nominal=1500,
      use_T_start=true,
      T_start=Modelica.SIunits.Conversions.from_degC(40),
      m_flow_start=0.01,
      m_flow_nominal=0.1,
      control_m_flow=true,
      allowFlowReversal=false,
      p_a_start=110000,
      p_b_start=130000,
      p_a_nominal=110000,
      p_b_nominal=130000,
      use_m_flow_set=false)
      annotation (Placement(transformation(extent={{-50,10},{-30,30}})));
    Modelica.Fluid.Valves.ValveIncompressible valve(
      redeclare package Medium = Medium,
      CvData=Modelica.Fluid.Types.CvTypes.OpPoint,
      m_flow_nominal=0.01,
      show_T=true,
      allowFlowReversal=false,
      dp_start=18000,
      dp_nominal=10000)
      annotation (Placement(transformation(extent={{58,-80},{38,-60}})));
  protected
    Modelica.Blocks.Interfaces.RealOutput m_flow
      annotation (Placement(transformation(extent={{-6,34},{6,46}})));
  public
    Modelica.Fluid.Sensors.MassFlowRate sensor_m_flow(redeclare package Medium = Medium)
      annotation (Placement(transformation(extent={{-20,10},{0,30}})));
    Modelica.Thermal.HeatTransfer.Sources.FixedTemperature T_ambient(T=system.T_ambient)
      annotation (Placement(transformation(extent={{-14,-27},{0,-13}})));
    Modelica.Thermal.HeatTransfer.Components.ThermalConductor wall(G=1.6e3/20)
      annotation (Placement(transformation(
          origin={10,-48},
          extent={{8,-10},{-8,10}},
          rotation=90)));
    Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow burner(
                                                       Q_flow=1.6e3,
      T_ref=343.15,
      alpha=-0.5)
      annotation (Placement(transformation(extent={{16,30},{36,50}})));
    inner Modelica.Fluid.System system(
        m_flow_small=1e-4, energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
                          annotation (Placement(transformation(extent={{-90,70},{
              -70,90}})));
    Modelica.Fluid.Pipes.DynamicPipe heater(
      redeclare package Medium = Medium,
      use_T_start=true,
      T_start=Modelica.SIunits.Conversions.from_degC(80),
      length=2,
      redeclare model HeatTransfer =
          Modelica.Fluid.Pipes.BaseClasses.HeatTransfer.IdealFlowHeatTransfer,
      diameter=0.01,
      nNodes=1,
      redeclare model FlowModel =
          Modelica.Fluid.Pipes.BaseClasses.FlowModels.DetailedPipeFlow,
      use_HeatTransfer=true,
      modelStructure=Modelica.Fluid.Types.ModelStructure.a_v_b,
      p_a_start=130000)
      annotation (Placement(transformation(extent={{30,10},{50,30}})));

    Modelica.Fluid.Pipes.DynamicPipe radiator(
      use_T_start=true,
      redeclare package Medium = Medium,
      length=10,
      T_start=Modelica.SIunits.Conversions.from_degC(40),
      redeclare model HeatTransfer =
          Modelica.Fluid.Pipes.BaseClasses.HeatTransfer.IdealFlowHeatTransfer,
      diameter=0.01,
      nNodes=1,
      redeclare model FlowModel =
          Modelica.Fluid.Pipes.BaseClasses.FlowModels.DetailedPipeFlow,
      use_HeatTransfer=true,
      modelStructure=Modelica.Fluid.Types.ModelStructure.a_v_b,
      p_a_start=110000,
      state_a(p(start=110000)),
      state_b(p(start=110000)))
      annotation (Placement(transformation(extent={{20,-80},{0,-60}})));

  protected
    Modelica.Blocks.Interfaces.RealOutput T_forward
      annotation (Placement(transformation(extent={{74,34},{86,46}})));
    Modelica.Blocks.Interfaces.RealOutput T_return
      annotation (Placement(transformation(extent={{-46,-56},{-58,-44}})));
  public
    Modelica.Fluid.Sensors.Temperature sensor_T_forward(redeclare package
        Medium =
          Medium)
      annotation (Placement(transformation(extent={{50,30},{70,50}})));
    Modelica.Fluid.Sensors.Temperature sensor_T_return(redeclare package Medium =
          Medium)
      annotation (Placement(transformation(extent={{-20,-60},{-40,-40}})));
  protected
    Modelica.Blocks.Interfaces.RealOutput tankLevel
                                   annotation (Placement(transformation(extent={{-56,34},
              {-44,46}})));
  public
    Modelica.Blocks.Sources.Step handle(
      startTime=2000,
      height=0.9,
      offset=0.1) annotation (Placement(transformation(extent={{26,-27},{40,-13}})));
    Modelica.Fluid.Pipes.DynamicPipe pipe(
      redeclare package Medium = Medium,
      use_T_start=true,
      T_start=Modelica.SIunits.Conversions.from_degC(80),
      redeclare model HeatTransfer =
          Modelica.Fluid.Pipes.BaseClasses.HeatTransfer.IdealFlowHeatTransfer,
      diameter=0.01,
      redeclare model FlowModel =
          Modelica.Fluid.Pipes.BaseClasses.FlowModels.DetailedPipeFlow,
      length=10,
      p_a_start=130000)
      annotation (Placement(transformation(extent={{-10,-10},{10,10}},
                                                                     rotation=-90,
          origin={80,-20})));

  equation
  tankLevel = tank.level;
    connect(sensor_m_flow.m_flow, m_flow) annotation (Line(points={{-10,31},
            {-10,40},{0,40}}, color={0,0,127}));
    connect(sensor_m_flow.port_b, heater.port_a)
                                              annotation (Line(points={{0,20},{0,
            20},{30,20}}, color={0,127,255}));
    connect(T_ambient.port, wall.port_a) annotation (Line(
          points={{0,-20},{10,-20},{10,-40}}, color={191,0,0}));
    connect(sensor_T_forward.T, T_forward) annotation (Line(points={{67,40},{
            80,40}}, color={0,0,127}));
    connect(radiator.port_a, valve.port_b) annotation (Line(points={{20,-70},{38,-70}},
                            color={0,127,255}));
    connect(sensor_T_return.port, radiator.port_b)
                                              annotation (Line(points={{-30,-60},
            {-30,-70},{0,-70}}, color={0,127,255}));
    connect(tank.ports[2], pump.port_a) annotation (Line(
        points={{-68,30},{-68,20},{-50,20}}, color={0,127,255}));
    connect(handle.y, valve.opening) annotation (Line(
        points={{40.7,-20},{48,-20},{48,-62}}, color={0,0,127}));
    connect(pump.port_b, sensor_m_flow.port_a)
                                              annotation (Line(
        points={{-30,20},{-20,20}}, color={0,127,255}));
    connect(sensor_T_return.T, T_return) annotation (Line(
        points={{-37,-50},{-52,-50}}, color={0,0,127}));
    connect(burner.port, heater.heatPorts[1])
                                            annotation (Line(
        points={{36,40},{40.1,40},{40.1,24.4}}, color={191,0,0}));
    connect(wall.port_b, radiator.heatPorts[1]) annotation (Line(
        points={{10,-56},{10,-65.6},{9.9,-65.6}}, color={191,0,0}));
    connect(sensor_T_forward.port, heater.port_b)
                                                annotation (Line(
        points={{60,30},{60,20},{50,20}}, color={0,127,255}));
    connect(heater.port_b, pipe.port_a) annotation (Line(
        points={{50,20},{80,20},{80,-10}}, color={0,127,255}));
    connect(pipe.port_b, valve.port_a) annotation (Line(
        points={{80,-30},{80,-70},{58,-70}}, color={0,127,255}));
    connect(radiator.port_b, tank.ports[1]) annotation (Line(
        points={{0,-70},{-72,-70},{-72,30}}, color={0,127,255}));
    annotation (Documentation(info="<html>
<p>
Simple heating system with a closed flow cycle.
After 2000s of simulation time the valve fully opens. A simple idealized control is embedded
into the respective components, so that the heating system can be regulated with the valve:
the pump controls the pressure, the burner controls the temperature.
</p>
<p>
One can investigate the temperatures and flows for different settings of <code>system.energyDynamics</code>
(see Assumptions tab of the system object).</p>
<ul>
<li>With <code>system.energyDynamics==Types.Dynamics.FixedInitial</code> the states need to find their steady values during the simulation.</li>
<li>With <code>system.energyDynamics==Types.Dynamics.SteadyStateInitial</code> (default setting) the simulation starts in steady-state.</li>
<li>With <code>system.energyDynamics==Types.Dynamics.SteadyState</code> all but one dynamic states are eliminated.
    The left state <code>tank.m</code> is to account for the closed flow cycle. It is constant as outflow and inflow are equal
    in a steady-state simulation.</li>
</ul>
<p>
Note that a closed flow cycle generally causes circular equalities for the mass flow rates and leaves the pressure undefined.
This is why the tank.massDynamics, i.e., the tank level determining the port pressure, is modified locally to Types.Dynamics.FixedInitial.
</p>
<p>
Also note that the tank is thermally isolated against its ambient. This way the temperature of the tank is also
well defined for zero flow rate in the heating system, e.g., for valveOpening.offset=0 at the beginning of a simulation.
The pipe however is assumed to be perfectly isolated.
If steady-state values shall be obtained with the valve fully closed, then a thermal
coupling between the pipe and its ambient should be defined as well.
</p>
<p>
Moreover it is worth noting that the idealized direct connection between the heater and the pipe, resulting in equal port pressures,
is treated as high-index DAE, as opposed to a nonlinear equation system for connected pressure loss correlations. A pressure loss correlation
could be additionally introduced to model the fitting between the heater and the pipe, e.g., to adapt different diameters.
</p>

<img src=\"modelica://Modelica/Resources/Images/Fluid/Examples/HeatingSystem.png\" border=\"1\"
     alt=\"HeatingSystem.png\">
</html>"),   experiment(StopTime=6000),
      __Dymola_Commands(file(ensureSimulated=true)=
          "modelica://Modelica/Resources/Scripts/Dymola/Fluid/HeatingSystem/plotResults.mos"
          "plotResults"));
  end HeatingSystem;
end Others;
