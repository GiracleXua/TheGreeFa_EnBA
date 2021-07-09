within BrineGrid;
package Example "to play with the model"
  extends Modelica.Icons.ExamplesPackage;

  model test_heat_transfer_dynamic

    replaceable package MediumLD =
        Buildings.Media.Water;
        //Buildings.Media.Air;
        //BrineGrid.Media.LiquidDesiccants.LithiumChlorideAqueousSolution_PatekKlomfar;

    Buildings.Fluid.MixingVolumes.MixingVolume vol(
      redeclare package Medium=MediumLD,
      V = V,
      m_flow_nominal = m_LiCl_nominal,
      energyDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial)
      annotation (Placement(transformation(extent={{48,-10},{68,10}})));

    parameter Modelica.SIunits.Volume V = 5;
    parameter Modelica.SIunits.MassFlowRate m_LiCl_nominal = V/3600;
    parameter Modelica.SIunits.HeatFlowRate Q_flow = -2000;

    Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon(G=10000/30)
      "Thermal conductance with ambient"
      annotation (Placement(transformation(extent={{-18,-10},{2,10}})));
    Modelica.Thermal.HeatTransfer.Sources.FixedTemperature TOut(T = 353.15)
      "Outside temperature"
      annotation (Placement(transformation(extent={{-66,-10},{-46,10}})));
    Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow preHea(Q_flow=Q_flow)
      "Prescribed heat flow"
      annotation (Placement(transformation(extent={{-10,26},{10,46}})));

  equation
    connect(TOut.port, theCon.port_a) annotation (Line(points={{-46,0},{-18,0}}, color={191,0,0}));
    connect(theCon.port_b, vol.heatPort) annotation (Line(points={{2,0},{48,0}}, color={191,0,0}));
    connect(preHea.port, vol.heatPort)
      annotation (Line(points={{10,36},{24,36},{24,0},{48,0}}, color={191,0,0}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(
            preserveAspectRatio=false)));
  end test_heat_transfer_dynamic;

  model test_fmu_chen2016

    BrineGrid.Fluid.Absorbers.Calibration.LiCl_Chen_2016_Dehumdification_FMU_interface
      liCl_Chen_2016_Dehumdification_FMU_interface
      annotation (Placement(transformation(extent={{-30,-20},{44,52}})));
    Modelica.Blocks.Sources.Constant const(k=298.75)
      annotation (Placement(transformation(extent={{-90,22},{-70,42}})));
    Modelica.Blocks.Sources.Constant const1(k=288.05)
      annotation (Placement(transformation(extent={{98,4},{78,24}})));
    Modelica.Blocks.Sources.Constant const2(k=0.0162)
      annotation (Placement(transformation(extent={{-90,-14},{-70,6}})));
    Modelica.Blocks.Sources.Constant const3(k=0.23)
      annotation (Placement(transformation(extent={{100,-36},{80,-16}})));
    Modelica.Blocks.Sources.Constant const4(k=1.85)
      annotation (Placement(transformation(extent={{-90,54},{-70,74}})));
    Modelica.Blocks.Sources.Constant const5(k=2.61)
      annotation (Placement(transformation(extent={{98,42},{78,62}})));
  equation

    connect(liCl_Chen_2016_Dehumdification_FMU_interface.m_flow_abs_in, const5.y)
      annotation (Line(points={{45.48,46.96},{61.74,46.96},{61.74,52},{77,52}}, color={0,0,127}));
    connect(liCl_Chen_2016_Dehumdification_FMU_interface.T_abs_in, const1.y)
      annotation (Line(points={{46.22,34},{62,34},{62,14},{77,14}}, color={0,0,127}));
    connect(liCl_Chen_2016_Dehumdification_FMU_interface.x_abs_in, const3.y)
      annotation (Line(points={{46.96,21.04},{46.96,-4.48},{79,-4.48},{79,-26}}, color={0,0,127}));
    connect(const4.y, liCl_Chen_2016_Dehumdification_FMU_interface.m_flow_a_in)
      annotation (Line(points={{-69,64},{-56,64},{-56,45.52},{-34.44,45.52}}, color={0,0,127}));
    connect(const.y, liCl_Chen_2016_Dehumdification_FMU_interface.T_air_in)
      annotation (Line(points={{-69,32},{-54,32},{-54,34},{-33.7,34}}, color={0,0,127}));
    connect(const2.y, liCl_Chen_2016_Dehumdification_FMU_interface.x_air_in)
      annotation (Line(points={{-69,-4},{-54,-4},{-54,21.76},{-33.7,21.76}}, color={0,0,127}));
    annotation (                                                         experiment(StopTime=500));
  end test_fmu_chen2016;

  package test_SpaceCooling

    model System1_SpaceCooling
      extends Modelica.Icons.Example;
      replaceable package MediumA = Buildings.Media.Air "Medium for air";

      parameter Modelica.SIunits.Volume V = 6*10*3 "Room volume";
      parameter Modelica.SIunits.MassFlowRate mA_flow_nominal=V*6/3600 "nominal mass flow rate";
      parameter Modelica.SIunits.HeatFlowRate QRooInt_flow = 1000 "Internal heat gains of the room";

      Buildings.Fluid.MixingVolumes.MixingVolume vol(
        redeclare package Medium = MediumA,
        m_flow_nominal=mA_flow_nominal,
        V = V, energyDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial,
        mSenFac = 3)
        annotation (Placement(transformation(extent={{50,-26},{80,4}})));

      Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon(G=10000/30)
        "Thermal conductance with ambient"
        annotation (Placement(transformation(extent={{-18,-10},{2,10}})));
      Modelica.Thermal.HeatTransfer.Sources.FixedTemperature TOut(T = 263.15)
        "Outside temperature"
        annotation (Placement(transformation(extent={{-66,-10},{-46,10}})));
      Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow preHea(Q_flow=QRooInt_flow)
        "Prescribed heat flow"
        annotation (Placement(transformation(extent={{-10,26},{10,46}})));
    equation
      connect(TOut.port, theCon.port_a)
        annotation (Line(points={{-46,0},{-18,0}}, color={191,0,0}));
      connect(theCon.port_b, vol.heatPort)
        annotation (Line(points={{2,0},{16,0},{16,-11},{50,-11}}, color={191,0,0}));
      connect(preHea.port, vol.heatPort)
        annotation (Line(points={{10,36},{36,36},{36,-11},{50,-11}}, color={191,0,0}));
      annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(
              preserveAspectRatio=false)),
        experiment(
          StopTime=10800,
          Interval=0.5,
          __Dymola_Algorithm="Dassl"));
    end System1_SpaceCooling;

    model System2
      "First part of the system model, consisting of the room with heat transfer"
      extends Modelica.Icons.Example;
      replaceable package MediumA = Buildings.Media.Air "Medium for air";
      //replaceable package MediumW =
        //  BrineGrid.Media.LiquidDesiccants.MagnesiumChlorideAqueousSolution "Medium for water";
      replaceable package MediumW = Buildings.Media.Water "Medium for water";

      //////////////////////////////////
      parameter Modelica.SIunits.Volume V=6*10*3 "Room volume";

      // heat recovery effectiveness
      parameter Real eps = 0.8 "Heat recovery effectiveness";

      // Air temperatures at design conditions
      parameter Modelica.SIunits.Temperature TASup_nominal = 273.15+18
        "Nominal air temperature supplied to room";
      parameter Modelica.SIunits.Temperature TRooSet = 273.15+24
        "Nominal room air temperature";
      parameter Modelica.SIunits.Temperature TOut_nominal = 273.15+30
        "Design outlet air temperature";
      parameter Modelica.SIunits.Temperature THeatRecLvg=
        TOut_nominal - eps*(TOut_nominal - TRooSet)
        "Air temperature leaving the heat recovery";
      ////////////////////////////////

      // Cooling loads an air mass flow rates
      parameter Modelica.SIunits.HeatFlowRate QRooInt_flow=1000
        "internal heat gains of the Room";
      parameter Modelica.SIunits.HeatFlowRate QRooC_flow_nominal=
        -QRooInt_flow-10E3/30*(TOut_nominal-TRooSet)
        "Nominal cooling load of the room";

      parameter Modelica.SIunits.MassFlowRate mA_flow_nominal=
        1.3*QRooC_flow_nominal/1006/(TASup_nominal-TRooSet)
        "Nominal air mass flow rate, increased by factor 1.3 to allow for recovery after temperature setback";
      parameter Modelica.SIunits.TemperatureDifference dTFan = 2
        "Estimated temperature raise across fan that needs to be made up by the cooling coil";
      parameter Modelica.SIunits.HeatFlowRate QCoiC_flow_nominal=4*
        (QRooC_flow_nominal + mA_flow_nominal*(TASup_nominal-THeatRecLvg-dTFan)*1006)
        "Cooling load of coil, taking into account economizer, and increased due to latent heat removal";
      /////////////////////////////////////////////////////////

      // Water temperatures and mass flow rates
      parameter Modelica.SIunits.Temperature TWSup_nominal = 273.15+16
        "Water supply temperature";
      parameter Modelica.SIunits.Temperature TWRet_nominal = 273.15+12
        "Water return temperature";
      parameter Modelica.SIunits.MassFlowRate mW_flow_nominal=
        QCoiC_flow_nominal/(TWRet_nominal-TWSup_nominal)/4200
        "Nominal water mass flow rate";

      ////////////////////////////////

      Buildings.Fluid.MixingVolumes.MixingVolume vol(
        redeclare package Medium = MediumA,
        m_flow_nominal=mA_flow_nominal,
        V=V,
        energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
        mSenFac=3,
        nPorts=2)
        annotation (Placement(transformation(extent={{76,20},{96,40}})));
      Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon(G=10000/30)
        "Thermal conductance with the ambient"
        annotation (Placement(transformation(extent={{36,40},{56,60}})));




      Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow preHea(Q_flow=
            QRooInt_flow) "Prescribed heat flow"
        annotation (Placement(transformation(extent={{36,70},{56,90}})));

      Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
        pAtmSou=Buildings.BoundaryConditions.Types.DataSource.Parameter,
        TDryBulSou=Buildings.BoundaryConditions.Types.DataSource.Parameter,
        TDryBul=TOut_nominal,
        filNam=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
        "Weather data reader"
         annotation (Placement(transformation(extent={{-94,40},{-74,60}})));
      Buildings.BoundaryConditions.WeatherData.Bus weaBus annotation (Placement(transformation(extent={{
                -58,40},{-38,60}}), iconTransformation(extent={{-232,-14},{-212,6}})));
      Buildings.HeatTransfer.Sources.PrescribedTemperature prescribedTemperature
        annotation (Placement(transformation(extent={{-6,42},{14,62}})));
      Buildings.Fluid.Sources.Outside out(nPorts=2, redeclare package Medium=MediumA)
        annotation (Placement(transformation(extent={{-88,-8},{-72,8}})));


      Buildings.Fluid.HeatExchangers.ConstantEffectiveness hex(
        redeclare package Medium1 = MediumA,
        redeclare package Medium2 = MediumA,
        m1_flow_nominal=mA_flow_nominal,
        m2_flow_nominal=mA_flow_nominal,
        dp1_nominal=200,
        dp2_nominal=200,
        eps=eps)
        annotation (Placement(transformation(extent={{-56,-10},{-36,10}})));
      Buildings.Fluid.HeatExchangers.WetCoilCounterFlow cooCoi(
        redeclare package Medium1 = MediumW,
        redeclare package Medium2 = MediumA,
        m1_flow_nominal=mW_flow_nominal,
        m2_flow_nominal=mA_flow_nominal,
        dp1_nominal=6000,
        dp2_nominal=200,
        UA_nominal = -QCoiC_flow_nominal/
           Buildings.Fluid.HeatExchangers.BaseClasses.lmtd(
           T_a1=THeatRecLvg,
           T_b1=TASup_nominal,
           T_a2=TWSup_nominal,
           T_b2=TWRet_nominal),
        show_T=true,
        energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial) "Cooling Coil"
        annotation (Placement(transformation(extent={{-2,10},{18,-10}})));
      Buildings.Fluid.Movers.FlowControlled_m_flow fan(
        redeclare package Medium = MediumA,
        m_flow_nominal = mA_flow_nominal,
        energyDynamics = Modelica.Fluid.Types.Dynamics.SteadyState) "supply air fan"
        annotation (Placement(transformation(extent={{54,-4},{74,16}})));

      Buildings.Fluid.Sensors.TemperatureTwoPort senTemHXOut(
        redeclare package Medium = MediumA,
        m_flow_nominal = mA_flow_nominal)
        annotation (Placement(transformation(extent={{-28,-2},{-14,12}})));
      Buildings.Fluid.Sensors.TemperatureTwoPort senTemSupAir(
        redeclare package Medium = MediumA,
        m_flow_nominal = mA_flow_nominal)
        annotation (Placement(transformation(extent={{30,2},{40,12}})));

      Buildings.Fluid.Sources.Boundary_pT SinkWat(nPorts=1, redeclare package Medium = MediumW)
        "sink for water circuit"
        annotation (Placement(transformation(extent={{-48,-56},{-32,-40}})));

      Buildings.Fluid.Sources.MassFlowSource_T SouWat(
        nPorts=1,
        redeclare package Medium = MediumW,
        use_m_flow_in = true,
        T=TWSup_nominal) "source for water circuit"
        annotation (Placement(transformation(extent={{8,-88},{28,-68}})));
      Buildings.Controls.OBC.CDL.Continuous.Sources.Constant mWat_flow(k=mW_flow_nominal)
        "Water flow rate"
        annotation (Placement(transformation(extent={{-52,-88},{-32,-68}})));
      Buildings.Controls.OBC.CDL.Continuous.Sources.Constant mAir_flow(k=mA_flow_nominal)
        "Fan air flow rate"
        annotation (Placement(transformation(extent={{20,22},{32,34}})));
    equation
      connect(theCon.port_b, vol.heatPort) annotation (Line(
          points={{56,50},{66,50},{66,30},{76,30}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(preHea.port, vol.heatPort) annotation (Line(
          points={{56,80},{66,80},{66,30},{76,30}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(weaDat.weaBus, weaBus) annotation (Line(
          points={{-74,50},{-48,50}},
          color={255,204,51},
          thickness=0.5), Text(
          string="%second",
          index=1,
          extent={{6,3},{6,3}},
          horizontalAlignment=TextAlignment.Left));
      connect(prescribedTemperature.port, theCon.port_a)
        annotation (Line(points={{14,52},{26,52},{26,50},{36,50}}, color={191,0,0}));
      connect(weaBus.TDryBul, prescribedTemperature.T) annotation (Line(
          points={{-48,50},{-28,50},{-28,52},{-8,52}},
          color={255,204,51},
          thickness=0.5), Text(
          string="%first",
          index=-1,
          extent={{-6,3},{-6,3}},
          horizontalAlignment=TextAlignment.Right));
      connect(out.weaBus, weaDat.weaBus) annotation (Line(
          points={{-88,0.16},{-88,50},{-74,50}},
          color={255,204,51},
          thickness=0.5));
      connect(out.ports[1], hex.port_a1)
        annotation (Line(points={{-72,1.6},{-58,1.6},{-58,6},{-56,6}}, color={0,127,255}));
      connect(out.ports[2], hex.port_b2)
        annotation (Line(points={{-72,-1.6},{-58,-1.6},{-58,-6},{-56,-6}},
                                                                         color={0,127,255}));
      connect(vol.ports[1], hex.port_a2)
        annotation (Line(points={{84,20},{84,-28},{-28,-28},{-28,-6},{-36,-6}}, color={0,127,255}));
      connect(fan.port_b, vol.ports[2])
        annotation (Line(points={{74,6},{88,6},{88,20}}, color={0,127,255}));
      connect(cooCoi.port_a2, senTemHXOut.port_b)
        annotation (Line(points={{18,6},{-6,6},{-6,5},{-14,5}}, color={0,127,255}));
      connect(senTemHXOut.port_a, hex.port_b1)
        annotation (Line(points={{-28,5},{-32,5},{-32,6},{-36,6}}, color={0,127,255}));
      connect(cooCoi.port_b2, senTemSupAir.port_a)
        annotation (Line(points={{-2,6},{24,6},{24,7},{30,7}}, color={0,127,255}));
      connect(senTemSupAir.port_b, fan.port_a)
        annotation (Line(points={{40,7},{48,7},{48,6},{54,6}}, color={0,127,255}));
      connect(SinkWat.ports[1], cooCoi.port_a1)
        annotation (Line(points={{-32,-48},{-8,-48},{-8,-6},{-2,-6}}, color={0,127,255}));
      connect(SouWat.ports[1], cooCoi.port_b1)
        annotation (Line(points={{28,-78},{40,-78},{40,-6},{18,-6}}, color={0,127,255}));
      connect(mWat_flow.y, SouWat.m_flow_in)
        annotation (Line(points={{-30,-78},{-10,-78},{-10,-70},{6,-70}}, color={0,0,127}));
      connect(mAir_flow.y, fan.m_flow_in)
        annotation (Line(points={{33.2,28},{64,28},{64,18}}, color={0,0,127}));
      annotation (Documentation(info="<html>
</html>",     revisions="<html>
<ul>
<li>
January 28, 2015 by Michael Wetter:<br/>
Added thermal mass of furniture directly to air volume.
This avoids an index reduction.
</li>
<li>
December 22, 2014 by Michael Wetter:<br/>
Removed <code>Modelica.Fluid.System</code>
to address issue
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/311\">#311</a>.
</li>
<li>
January 11, 2012, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
        __Dymola_Commands(file=
         "modelica://Buildings/Resources/Scripts/Dymola/Examples/Tutorial/SpaceCooling/System1.mos"
            "Simulate and plot"),
        experiment(
          StopTime=10800,
          Interval=5,
          Tolerance=1e-06,
          __Dymola_Algorithm="Dassl"));
    end System2;
  end test_SpaceCooling;

  package basic_test
    model test_vessel_water
      extends Modelica.Icons.Example;

      parameter Modelica.SIunits.Volume Vol = 0.02;
      //package Medium_new = Buildings.Media.Antifreeze.PropyleneGlycolWater(property_T=293.15, X_a=0.40);   //Buildings.Media.Water;
      package Medium_new =
          BrineGrid.Media.LiquidDesiccants.LithiumChlorideAqueousSolution_PatekKlomfar;

      Modelica.Thermal.HeatTransfer.Components.ThermalConductor thermalConductor(G=5000/20)
        annotation (Placement(transformation(extent={{-20,-8},{0,12}})));
      Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=273.15)
        annotation (Placement(transformation(extent={{-68,-8},{-48,12}})));
      Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow(Q_flow=4500)
        annotation (Placement(transformation(extent={{-38,38},{-18,58}})));
      Modelica.Fluid.Sources.FixedBoundary boundary1(
        redeclare package Medium = Medium_new, nPorts=1)
        annotation (Placement(transformation(extent={{90,-56},{70,-36}})));

      Modelica.Blocks.Sources.RealExpression realExpression(y=293.15)
        annotation (Placement(transformation(extent={{-20,68},{0,88}})));
      Buildings.Fluid.MixingVolumes.MixingVolume vol(
        nPorts=2,
        energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
        m_flow_nominal=1,
        V=Vol,
        redeclare package Medium = Medium_new)
        annotation (Placement(transformation(extent={{34,-8},{54,12}})));
      Modelica.Fluid.Sources.FixedBoundary boundary0(redeclare package Medium = Medium_new, nPorts=1)
        annotation (Placement(transformation(extent={{-6,-48},{14,-28}})));
    equation
      connect(fixedTemperature.port, thermalConductor.port_a)
        annotation (Line(points={{-48,2},{-20,2}}, color={191,0,0}));
      connect(vol.ports[1], boundary1.ports[1])
        annotation (Line(points={{42,-8},{60,-8},{60,-46},{70,-46}}, color={0,127,255}));
      connect(thermalConductor.port_b, vol.heatPort)
        annotation (Line(points={{0,2},{34,2}}, color={191,0,0}));
      connect(fixedHeatFlow.port, vol.heatPort)
        annotation (Line(points={{-18,48},{20,48},{20,2},{34,2}}, color={191,0,0}));
      connect(boundary0.ports[1], vol.ports[2])
        annotation (Line(points={{14,-38},{28,-38},{28,-8},{46,-8}}, color={0,127,255}));
      annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(
              preserveAspectRatio=false)));
    end test_vessel_water;
  end basic_test;

  model NotDifferentiableExample
    Real position(start = 0);
    Real velocity;

    function ParticlePath
      input Real t;
      input Real amplitude;
      output Real y;
    algorithm
      y :=amplitude*sin(t);
      //y :=y*sin(t);
    end ParticlePath;

  equation
    velocity = der(position);
    position = ParticlePath(time, 2)
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(
            preserveAspectRatio=false)));

  end NotDifferentiableExample;
end Example;
