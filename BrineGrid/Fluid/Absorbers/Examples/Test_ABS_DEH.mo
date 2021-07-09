within BrineGrid.Fluid.Absorbers.Examples;
package Test_ABS_DEH "test the absorber and regenerator model"
  extends Modelica.Icons.ExamplesPackage;
  model Regenerator_model
  //Media.LiquidDesiccants.MagnesiumChlorideAqueousSolution,
    extends Validation.BaseClasses.BaseValidation(
      redeclare final package Medium_b =
          Media.LiquidDesiccants.MagnesiumChlorideAqueousSolution,
      T_air=273.15 + 33.05,
      T_abs=273.15 + 37.91,
      x_a=0.01034,
      X_s=0.313,
      m_flow_air=0.0197,
      m_flow_abs=0.02667,
      mNodes=5,
      nNodes=5,
      abs(
        redeclare Data.Mg_teststand data,
        flowConf=BrineGrid.Fluid.Absorbers.Choices.FlowConfiguration.CounterCurrent,
        energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial,
        redeclare model ThermalAir =
            HeatTransfer.Convection.Absorption.ConstantNusseltNumber_Absorption(Nu0 = Nu),
        redeclare model MoistureAir =
            MoistureTransfer.Convection.Absorption.ConstantSherwoodNumber(Sh0 = Sh)));

    parameter Real simulation_id = 4;
    parameter Modelica.SIunits.NusseltNumber Nu = 4;
    parameter Modelica.SIunits.NusseltNumberOfMassTransfer Sh = 5;
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(
            preserveAspectRatio=false)),
      experiment(
        StopTime=1800,
        __Dymola_NumberOfIntervals=100,
        __Dymola_Algorithm="Dassl"));
  end Regenerator_model;

  model exothermal_model
  //Media.LiquidDesiccants.MagnesiumChlorideAqueousSolution,
    extends Validation.BaseClasses.BaseValidation(
      redeclare final package Medium_b =
          Media.LiquidDesiccants.LithiumChlorideAqueousSolution_PatekKlomfar,
      T_air=273.15 + 25.9,
      T_abs=273.15 + 25.9,
      x_a=0.018,
      X_s=0.30,
      m_flow_air=1.85,
      m_flow_abs=2.61,
      mNodes=5,
      nNodes=5,
      abs(
        redeclare Data.Chen_2016 data,
        flowConf=BrineGrid.Fluid.Absorbers.Choices.FlowConfiguration.CounterCurrent,
        redeclare model ThermalAir =
            HeatTransfer.Convection.Absorption.RandomPackings_ChenZhangYin,
        redeclare model MoistureAir =
            MoistureTransfer.Convection.Absorption.RandomPackings_ChenZhangYin));

    parameter Real simulation_id = 4;
    //parameter Modelica.SIunits.NusseltNumber Nu = 10;
    //parameter Modelica.SIunits.NusseltNumberOfMassTransfer Sh = 10;
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(
            preserveAspectRatio=false)));

  end exothermal_model;

  model Calibration_MgCl2 "calibration model for MgCl2"
    extends Validation.BaseClasses.BaseValidation(
      redeclare final package Medium_b =
          Media.LiquidDesiccants.MagnesiumChlorideAqueousSolution,
      T_air=273.15 + 25.6,
      T_abs=273.15 + 14.9,
      x_a=0.0162,
      X_s=0.23,
      m_flow_air=1.85,
      m_flow_abs=2.61,
      mNodes = 3,
      nNodes = 3,
      abs(
        redeclare Data.Mg_dempav                                         data,
        flowConf=BrineGrid.Fluid.Absorbers.Choices.FlowConfiguration.CounterCurrent,
        redeclare model ThermalAir =
            HeatTransfer.Convection.Absorption.ConstantNusseltNumber_Absorption
            (                                                                    Nu0=Nu),
        redeclare model MoistureAir =
            MoistureTransfer.Convection.Absorption.ConstantSherwoodNumber (Sh0=Sh)));

    parameter Real simulation_id = 4;
    parameter Modelica.SIunits.NusseltNumber Nu = 10;
    parameter Modelica.SIunits.NusseltNumberOfMassTransfer Sh = 10;

    annotation (
      Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
              100,100}})),
      experiment(StopTime=500, Interval=0.5),
      __Dymola_experimentSetupOutput,
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
</html>",   info="<html>
<p>This model is validating the adiabatic absorber model in cross current flow configuration using lithium chloride with measured outlet data from Chen et al. 2016. </p>

<p>The correlations for the heat and mass transfer are from Chen et al. 2016.</p>

<h4>References</h4>

<dl><dt>Chen, Y., Zhang, X., Yin, Y.:</dt>
<dd><b>Experimental and theoretical analysis of liquid desiccant dehumidification process based on an advanced hybrid air-conditioning system </b></br>
</dd><dd>Applied Thermal Engineering 98, p. 387-399 (2016)</br>
</dd><dd>DOI: <a href=\"http://dx.doi.org/10.1016/j.applthermaleng.2015.12.066\">10.1016/j.applthermaleng.2015.12.066</a>
</dd></dl>
</html>"));

  end Calibration_MgCl2;

  model BrineGrid_heating_part1 "heating of the TCF source"
    extends Modelica.Icons.Example;

    replaceable package Medium_d =
        Media.LiquidDesiccants.LithiumChlorideAqueousSolution_PatekKlomfar;
    //parameter Modelica.SIunits.MassFlowRate m_d = 1.2;
    parameter Modelica.SIunits.Temperature T_d_in_1 = 10 + 273.15;
    parameter Modelica.SIunits.Temperature T_d_in_2 = 30 + 273.15;
    parameter Modelica.SIunits.MassFraction[Medium_d.nX] xi_d_1 = {0.7, 0.3};
    parameter Modelica.SIunits.MassFraction [Medium_d.nX] xi_d_2 = {0.7, 0.3};
    parameter Modelica.SIunits.MassFlowRate m_flow_nominal_des = 1;

    Sources.MassFlowSource_T sou_des_1(
      redeclare final package Medium = Medium_d,
      use_m_flow_in=true,
      use_T_in=false,
      final T=T_d_in_1,
      final X=xi_d_1,
      final nPorts=1) annotation (Placement(transformation(extent={{-24,38},{-4,58}})));
    Sources.MassFlowSource_T sou_des_2(
      redeclare final package Medium = Medium_d,
      use_m_flow_in=true,
      final T=T_d_in_2,
      final X=xi_d_2,
      final nPorts=1) annotation (Placement(transformation(extent={{-24,-30},{-4,-10}})));
    MixingVolumes.MixingVolumeAbsorption tank(
      redeclare package Medium = Medium_d,
      energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
      m_flow_nominal = m_flow_nominal_des,
      V=200,
      nPorts=2) annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=-90,
          origin={52,14})));

    Modelica.Blocks.Sources.Step step(
      height=2,
      offset=1,
      startTime=20) annotation (Placement(transformation(extent={{-86,46},{-66,66}})));
    Modelica.Blocks.Sources.Constant const(k=1)
      annotation (Placement(transformation(extent={{-88,-22},{-68,-2}})));

    Modelica.Thermal.HeatTransfer.Components.ThermalConductor thermalConductor(G=50)
      annotation (Placement(transformation(extent={{76,42},{96,62}})));
    Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=283.15)
      annotation (Placement(transformation(extent={{42,74},{62,94}})));
    Modelica.Blocks.Sources.RealExpression realExpression(y=293.15)
      annotation (Placement(transformation(extent={{26,44},{46,64}})));
  equation
    connect(sou_des_1.ports[1], tank.ports[1])
      annotation (Line(points={{-4,48},{18,48},{18,16},{42,16}}, color={0,127,255}));
    connect(sou_des_2.ports[1], tank.ports[2])
      annotation (Line(points={{-4,-20},{18,-20},{18,12},{42,12}}, color={0,127,255}));
    connect(step.y, sou_des_1.m_flow_in)
      annotation (Line(points={{-65,56},{-24,56}},                   color={0,0,127}));
    connect(const.y, sou_des_2.m_flow_in)
      annotation (Line(points={{-67,-12},{-24,-12}},                     color={0,0,127}));
    connect(tank.heatPort, thermalConductor.port_a)
      annotation (Line(points={{52,24},{64,24},{64,52},{76,52}}, color={191,0,0}));
    connect(fixedTemperature.port, thermalConductor.port_b)
      annotation (Line(points={{62,84},{112,84},{112,52},{96,52}}, color={191,0,0}));
    connect(realExpression.y, tank.TWat)
      annotation (Line(points={{47,54},{52,54},{52,26},{56.8,26}}, color={0,0,127}));
  end BrineGrid_heating_part1;

  model test_WaterCooler_T "change medium to liquid desiccant"
    extends Modelica.Icons.Example;

    replaceable package MediumD =
        BrineGrid.Media.LiquidDesiccants.MagnesiumChlorideAqueousSolution;
    //Buildings.Media.Antifreeze.PropyleneGlycolWater (property_T=293.15, X_a=0.40);
    //BrineGrid.Media.LiquidDesiccants.LithiumChlorideAqueousSolution_PatekKlomfar,
    extends Buildings.Fluid.HeatExchangers.Examples.BaseClasses.Heater(
      redeclare package Medium = MediumD,
      m_flow_nominal=V*1000/3600,
      Q_flow_nominal=1000,
      vol(energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
          V=V/1000),
      mov(energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
          nominalValuesDefineDefaultPressureCurve=true),
      TOut(y=273.15 + 22 - 5*cos(time/86400*2*Modelica.Constants.pi)));

    Buildings.Fluid.HeatExchangers.SensibleCooler_T coo(
      redeclare package Medium = MediumD,
      m_flow_nominal=m_flow_nominal,
      dp_nominal=1000,
      T_start=289.15,
      energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
      QMin_flow=-Q_flow_nominal) "Cooler"
      annotation (Placement(transformation(extent={{-20,-50},{0,-30}})));

    Buildings.Controls.SetPoints.Table tab(table=[
      0, 273.15 + 10;
      1, 273.15 + 30])
      "Table to compute temperature set points"
      annotation (Placement(transformation(extent={{-30,20},{-10,40}})));
  equation
      connect(coo.port_b, THeaOut.port_a) annotation (Line(
          points={{0,-40},{20,-40}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(conPI.y, tab.u) annotation (Line(
          points={{-39,30},{-32,30}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(tab.y,coo. TSet) annotation (Line(
          points={{-9,30},{-6,30},{-6,-20},{-32,-20},{-32,-32},{-22,-32}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(mov.port_b,coo. port_a) annotation (Line(points={{-50,-40},{-35,-40},
              {-20,-40}}, color={0,127,255}));

  end test_WaterCooler_T;

  model MixingVolume_DES

    extends Modelica.Icons.Example;
    package Medium_d =
        BrineGrid.Media.LiquidDesiccants.LithiumBromideAqueousSolution_PatekKlomfar;
    //BrineGrid.Media.LiquidDesiccants.LithiumBromideAqueousSolution_PatekKlomfar;
    //BrineGrid.Media.LiquidDesiccants.MagnesiumChlorideAqueousSolution;
    //BrineGrid.Media.LiquidDesiccants.MagnesiumChloride_aqueous_solution_MgCl2_H2O;
    //BrineGrid.Media.LiquidDesiccants.LithiumChlorideAqueousSolution_PatekKlomfar;

    parameter Modelica.SIunits.PressureDifference dp_nominal = 1000;

    parameter Modelica.SIunits.MassFlowRate m_flow_nominal = 5;

    parameter Modelica.SIunits.Temperature T_d_in_1 = 313.15;
    parameter Modelica.SIunits.MassFraction[Medium_d.nX] x_d_in_1 = {0.7, 0.3};

    Sources.Boundary_pT bou(
      redeclare package Medium = Medium_d,
      nPorts=1)
      annotation (Placement(transformation(extent={{112,-30},{92,-10}})));
    MixingVolumes.MixingVolumeAbsorption volMasExcCon(
      energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
      massDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
      T_start=293.15,
      allowFlowReversal=false,
      V=1,
      redeclare package Medium = Medium_d,
      m_flow_nominal = m_flow_nominal,
      nPorts=2)
      annotation (Placement(transformation(extent={{34,-10},{54,10}})));
    Modelica.Blocks.Sources.RealExpression realExpression(y=328.15)
      annotation (Placement(transformation(extent={{-14,40},{6,60}})));
    Modelica.Blocks.Sources.Step Input_flow_temperature(
      height=20,
      offset=313.15,
      startTime=2000) annotation (Placement(transformation(extent={{-126,-22},{-106,-2}})));
    Buildings.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow(Q_flow(displayUnit="kW") = 100000)
      annotation (Placement(transformation(extent={{-40,12},{-20,32}})));
    Sources.Boundary_pT source(
      redeclare package Medium = Medium_d,
      use_T_in=true,
      T=T_d_in_1,
      X=x_d_in_1,
      nPorts=1) annotation (Placement(transformation(extent={{-90,-24},{-70,-4}})));
    Buildings.Fluid.Movers.FlowControlled_m_flow pump(
        redeclare package Medium = Medium_d,
      energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial,
        T_start=T_d_in_1,
        X_start=x_d_in_1,
        m_flow_nominal = m_flow_nominal,
      inputType=Buildings.Fluid.Types.InputType.Constant,
      constantMassFlowRate=m_flow_nominal)
      annotation (Placement(transformation(extent={{-48,-4},{-28,-24}})));
  equation
    connect(volMasExcCon.ports[1], bou.ports[1])
      annotation (Line(points={{42,-10},{72,-10},{72,-20},{92,-20}},
                                                              color={0,127,255}));
    connect(realExpression.y, volMasExcCon.TWat)
      annotation (Line(points={{7,50},{20,50},{20,4.8},{32,4.8}},        color={0,0,127}));
    connect(fixedHeatFlow.port, volMasExcCon.heatPort)
      annotation (Line(points={{-20,22},{6,22},{6,0},{34,0}},       color={191,0,0}));
    connect(source.ports[1], pump.port_a)
      annotation (Line(points={{-70,-14},{-48,-14}}, color={0,127,255}));
    connect(pump.port_b, volMasExcCon.ports[2])
      annotation (Line(points={{-28,-14},{4,-14},{4,-10},{46,-10}}, color={0,127,255}));
    connect(Input_flow_temperature.y, source.T_in)
      annotation (Line(points={{-105,-12},{-100,-12},{-100,-10},{-92,-10}}, color={0,0,127}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-140,-100},{140,100}})),
                                                                   Diagram(coordinateSystem(
            preserveAspectRatio=false, extent={{-140,-100},{140,100}})),
      experiment(
        StopTime=5000,
        __Dymola_NumberOfIntervals=2000,
        __Dymola_Algorithm="Dassl"));
  end MixingVolume_DES;

  model Regenerator_model_ref
  //Media.LiquidDesiccants.MagnesiumChlorideAqueousSolution,
    extends Validation.BaseClasses.BaseValidation(
      redeclare final package Medium_b =
          Media.LiquidDesiccants.LithiumBromideAqueousSolution_PatekKlomfar,
      T_air=273.15 + 30.4,
      T_abs=273.15 + 65,
      x_a=0.0183,
      X_s=0.34,
      m_flow_air=0.890,
      m_flow_abs=6.124,
      mNodes=5,
      nNodes=5,
      abs(
        redeclare Data.Chen_2016 data,
        flowConf=BrineGrid.Fluid.Absorbers.Choices.FlowConfiguration.CounterCurrent,
        energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial,
        redeclare model ThermalAir =
            HeatTransfer.Convection.Absorption.ConstantNusseltNumber_Absorption(Nu0 = Nu),
        redeclare model MoistureAir =
            MoistureTransfer.Convection.Absorption.ConstantSherwoodNumber(Sh0 = Sh)));

    parameter Real simulation_id = 4;
    parameter Modelica.SIunits.NusseltNumber Nu = 4;
    parameter Modelica.SIunits.NusseltNumberOfMassTransfer Sh = 5;
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(
            preserveAspectRatio=false)),
      experiment(
        StopTime=1800,
        __Dymola_NumberOfIntervals=100,
        __Dymola_Algorithm="Dassl"));
  end Regenerator_model_ref;
end Test_ABS_DEH;
