within BrineGrid.Fluid.Absorbers.Examples.Netzwerk;
model whole_system
  extends Modelica.Icons.Example;
  Adiabatic.AdiabaticAbsorber Absorber
    annotation (Placement(transformation(extent={{-238,-14},{-184,40}})));
  Buildings.Fluid.Movers.FlowControlled_m_flow BrinePumpe annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-150,76})));
  Adiabatic.AdiabaticAbsorber Desorber
    annotation (Placement(transformation(extent={{254,-104},{204,-54}})));
  Buildings.Fluid.FixedResistances.PressureDrop res1 annotation (Placement(transformation(
        extent={{-6,6},{6,-6}},
        rotation=90,
        origin={216,-16})));
  Buildings.Fluid.Movers.FlowControlled_m_flow BrinePump annotation (Placement(transformation(
        extent={{8,8},{-8,-8}},
        rotation=-90,
        origin={216,6})));
  Buildings.Fluid.MixingVolumes.MixingVolume Container1(nPorts=4) annotation (Placement(
        transformation(
        extent={{15,-15},{-15,15}},
        rotation=-90,
        origin={135,-29})));
  Buildings.Fluid.Sensors.DensityTwoPort concen_Sen
    annotation (Placement(transformation(extent={{-108,182},{-88,202}})));
  Buildings.Fluid.Sensors.RelativeHumidityTwoPort senRelHum annotation (Placement(transformation(
        extent={{-8,-8},{8,8}},
        rotation=90,
        origin={-320,34})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTem annotation (Placement(transformation(
        extent={{-7,-7},{7,7}},
        rotation=90,
        origin={-319,65})));
  Buildings.Fluid.Storage.StratifiedEnhancedInternalHex Storage
    annotation (Placement(transformation(extent={{124,238},{88,274}})));
  HeatPumps.Carnot_y heaPum annotation (Placement(transformation(
        extent={{16,16},{-16,-16}},
        rotation=0,
        origin={158,212})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTem1 annotation (Placement(transformation(
        extent={{-7,-7},{7,7}},
        rotation=180,
        origin={197,223})));
  Movers.FlowControlled_m_flow PumpCoolingWater
    annotation (Placement(transformation(extent={{108,138},{138,108}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTem2 annotation (Placement(transformation(
        extent={{-7,-7},{7,7}},
        rotation=180,
        origin={63,123})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTem3 annotation (Placement(transformation(
        extent={{-13,-13},{13,13}},
        rotation=270,
        origin={9,215})));
  Modelica.Blocks.Sources.Constant const1
    annotation (Placement(transformation(extent={{182,82},{162,102}})));
  MixingVolumes.MixingVolume vol1(nPorts=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={278,192})));
  MixingVolumes.MixingVolume vol2(nPorts=1) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={102,202})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTem4 annotation (Placement(transformation(
        extent={{-8,-8},{8,8}},
        rotation=0,
        origin={210,194})));
  Buildings.Fluid.Sensors.RelativeHumidityTwoPort senRelHum1 annotation (Placement(transformation(
        extent={{-8,8},{8,-8}},
        rotation=90,
        origin={276,-60})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTem5 annotation (Placement(transformation(
        extent={{-7,7},{7,-7}},
        rotation=90,
        origin={277,-29})));
  Movers.FlowControlled_m_flow fan5
    annotation (Placement(transformation(extent={{248,-114},{278,-144}})));
  Modelica.Blocks.Sources.Constant const2
    annotation (Placement(transformation(extent={{-244,-138},{-252,-130}})));
  Modelica.Blocks.Sources.Constant const3
    annotation (Placement(transformation(extent={{-6,-6},{6,6}},
        rotation=90,
        origin={262,-184})));
  Movers.FlowControlled_m_flow fan4
    annotation (Placement(transformation(extent={{-262,-100},{-282,-120}})));
  Sources.Boundary_pT bou(redeclare package Medium =
        Modelica.Media.Air.MoistAir,                                              nPorts=1)
    annotation (Placement(transformation(extent={{334,-78},{314,-58}})));
  Sources.Boundary_pT bou1(redeclare package Medium =
        Modelica.Media.Air.MoistAir,                                               nPorts=1)
    annotation (Placement(transformation(extent={{354,-158},{334,-138}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTem6 annotation (Placement(transformation(
        extent={{-7,7},{7,-7}},
        rotation=180,
        origin={293,-129})));
  Buildings.Fluid.Sensors.RelativeHumidityTwoPort senRelHum2 annotation (Placement(transformation(
        extent={{8,8},{-8,-8}},
        rotation=180,
        origin={320,-148})));
  Buildings.Fluid.Sensors.RelativeHumidityTwoPort senRelHum3 annotation (Placement(transformation(
        extent={{-8,-8},{8,8}},
        rotation=90,
        origin={-292,-80})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTem7 annotation (Placement(transformation(
        extent={{-7,-7},{7,7}},
        rotation=90,
        origin={-291,-49})));
  Buildings.Fluid.FixedResistances.PressureDrop res2 annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=180,
        origin={-274,102})));
  Buildings.Fluid.FixedResistances.PressureDrop res3 annotation (Placement(transformation(
        extent={{6,-6},{-6,6}},
        rotation=270,
        origin={-224,-66})));
  Buildings.Fluid.Sensors.DensityTwoPort concen_Sen1
    annotation (Placement(transformation(extent={{-140,-76},{-116,-52}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTem8
    annotation (Placement(transformation(extent={{-92,-70},{-74,-52}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTem9
    annotation (Placement(transformation(extent={{-142,180},{-118,204}})));
  Buildings.Fluid.Sensors.DensityTwoPort concen_Sen2 annotation (Placement(transformation(
        extent={{-9,-9},{9,9}},
        rotation=90,
        origin={-53,73})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTem10 annotation (Placement(transformation(
        extent={{-9,-9},{9,9}},
        rotation=90,
        origin={-49,111})));
  Buildings.Fluid.Sensors.DensityTwoPort concen_Sen3
    annotation (Placement(transformation(extent={{22,58},{40,76}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTem11
    annotation (Placement(transformation(extent={{46,58},{64,76}})));
  Buildings.Fluid.FixedResistances.PressureDrop res4 annotation (Placement(transformation(
        extent={{-7,-7},{7,7}},
        rotation=90,
        origin={95,27})));
  Buildings.Fluid.HeatExchangers.ConstantEffectiveness hex annotation (Placement(transformation(
        extent={{-19,-19},{19,19}},
        rotation=90,
        origin={-37,167})));
  Modelica.Blocks.Sources.Constant const4
    annotation (Placement(transformation(extent={{-100,66},{-120,86}})));
  Modelica.Blocks.Sources.Constant const5
    annotation (Placement(transformation(extent={{172,2},{194,24}})));
  Buildings.Fluid.FixedResistances.PressureDrop res6
                                                    annotation (Placement(transformation(
        extent={{-12,-10},{12,10}},
        rotation=0,
        origin={-168,44})));
  Buildings.Fluid.MixingVolumes.MixingVolume Container2(nPorts=4) annotation (Placement(
        transformation(
        extent={{17,17},{-17,-17}},
        rotation=-90,
        origin={-69,33})));
  Buildings.Fluid.Sensors.DensityTwoPort concen_Sen4
    annotation (Placement(transformation(extent={{-9,-9},{9,9}},
        rotation=-90,
        origin={-7,-65})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTem12
    annotation (Placement(transformation(extent={{-11,-11},{11,11}},
        rotation=-90,
        origin={-7,-107})));
  Buildings.Fluid.FixedResistances.PressureDrop res5 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-8,-10})));
  Buildings.Fluid.Movers.FlowControlled_m_flow AbsPump annotation (Placement(transformation(
        extent={{-13,-13},{13,13}},
        rotation=0,
        origin={37,-127})));
  Modelica.Blocks.Sources.Constant const6
    annotation (Placement(transformation(extent={{-11,-11},{11,11}},
        rotation=-90,
        origin={39,-75})));
  Buildings.ThermalZones.Detailed.MixedAir mixedAir(nPorts=2)
    annotation (Placement(transformation(extent={{-304,-28},{-348,16}})));
equation
  connect(res1.port_a, Desorber.port_b_in)
    annotation (Line(points={{216,-22},{216.5,-22},{216.5,-58.5455}},      color={238,46,47}));
  connect(Container1.ports[1], Desorber.port_b_out)
    annotation (Line(points={{120,-33.5},{120,-92.1818},{216.5,-92.1818}},
                                                                   color={238,46,47}));
  connect(res1.port_b, BrinePump.port_a)
    annotation (Line(points={{216,-10},{216,-2}}, color={238,46,47}));
  connect(BrinePump.port_b, Container1.ports[2])
    annotation (Line(points={{216,14},{216,32},{120,32},{120,-30.5}}, color={238,46,47}));
  connect(senTem.port_a, senRelHum.port_b)
    annotation (Line(points={{-319,58},{-320,58},{-320,42}}, color={0,127,255}));
  connect(Storage.portHex_b, heaPum.port_a2)
    annotation (Line(points={{124,241.6},{136,241.6},{136,221.6},{142,221.6}}, color={0,0,0}));
  connect(heaPum.port_b2, senTem1.port_b)
    annotation (Line(points={{174,221.6},{186,221.6},{186,223},{190,223}}, color={0,0,0}));
  connect(Storage.portHex_a, senTem1.port_a)
    annotation (Line(points={{124,249.16},{212,249.16},{212,223},{204,223}}, color={0,0,0}));
  connect(PumpCoolingWater.port_b, Storage.port_a) annotation (Line(points={{138,123},{220,123},{
          220,124},{306,124},{306,256},{124,256}}, color={0,0,0}));
  connect(senTem2.port_a, PumpCoolingWater.port_a)
    annotation (Line(points={{70,123},{108,123}}, color={0,0,0}));
  connect(senTem3.port_a, Storage.port_b)
    annotation (Line(points={{9,228},{28.5,228},{28.5,256},{88,256}}, color={0,0,0}));
  connect(const1.y, PumpCoolingWater.m_flow_in)
    annotation (Line(points={{161,92},{144,92},{144,105},{122.7,105}}, color={0,0,0}));
  connect(vol2.ports[1], heaPum.port_b1)
    annotation (Line(points={{112,202},{128,202},{128,202.4},{142,202.4}}, color={0,0,0}));
  connect(heaPum.port_a1, senTem4.port_a)
    annotation (Line(points={{174,202.4},{188,202.4},{188,194},{202,194}}, color={0,0,0}));
  connect(senTem4.port_b, vol1.ports[1])
    annotation (Line(points={{218,194},{244,194},{244,192},{268,192}}, color={0,0,0}));
  connect(senTem5.port_a, senRelHum1.port_b)
    annotation (Line(points={{277,-36},{277,-52},{276,-52}}, color={0,127,255}));
  connect(Desorber.port_a_in, senTem5.port_b) annotation (Line(points={{241.5,
          -58.5455},{242,-58.5455},{242,-14},{277,-14},{277,-22}},
                                color={0,127,255}));
  connect(fan5.port_a, Desorber.port_a_out)
    annotation (Line(points={{248,-129},{248,-92.6364},{241.5,-92.6364}},
                                                                   color={0,127,255}));
  connect(const3.y, fan5.m_flow_in)
    annotation (Line(points={{262,-177.4},{262.7,-177.4},{262.7,-147}},
                                                                      color={0,0,127}));
  connect(const2.y, fan4.m_flow_in) annotation (Line(points={{-252.4,-134},{-264,-134},{-264,-122},
          {-271.8,-122}},color={0,0,127}));
  connect(senRelHum1.port_a, bou.ports[1])
    annotation (Line(points={{276,-68},{314,-68}},                     color={0,127,255}));
  connect(fan5.port_b, senTem6.port_b)
    annotation (Line(points={{278,-129},{286,-129}},                       color={0,127,255}));
  connect(senTem6.port_a, senRelHum2.port_a)
    annotation (Line(points={{300,-129},{306,-129},{306,-148},{312,-148}}, color={0,127,255}));
  connect(senRelHum2.port_b, bou1.ports[1])
    annotation (Line(points={{328,-148},{334,-148}}, color={0,127,255}));
  connect(senTem7.port_a, senRelHum3.port_b)
    annotation (Line(points={{-291,-56},{-292,-56},{-292,-72}}, color={0,127,255}));
  connect(senRelHum3.port_a, fan4.port_b)
    annotation (Line(points={{-292,-88},{-292,-110},{-282,-110}}, color={0,127,255}));
  connect(Absorber.port_a_in, res2.port_a)
    annotation (Line(points={{-224.5,35.0909},{-224.5,102},{-268,102}}, color={0,127,255}));
  connect(res2.port_b, senTem.port_b)
    annotation (Line(points={{-280,102},{-319,102},{-319,72}}, color={0,127,255}));
  connect(Absorber.port_a_out, res3.port_b) annotation (Line(points={{-224.5,-1.72727},{-224.5,
          -19.5},{-224,-19.5},{-224,-60}},
                                 color={0,127,255}));
  connect(res3.port_a, fan4.port_a)
    annotation (Line(points={{-224,-72},{-224,-110},{-262,-110}},
                                                               color={0,127,255}));
  connect(concen_Sen1.port_b, senTem8.port_a)
    annotation (Line(points={{-116,-64},{-116,-61},{-92,-61}},        color={238,46,47}));
  connect(senTem9.port_b, concen_Sen.port_a)
    annotation (Line(points={{-118,192},{-108,192}},               color={238,46,47}));
  connect(senTem9.port_a, BrinePumpe.port_a)
    annotation (Line(points={{-142,192},{-150,192},{-150,86}}, color={238,46,47}));
  connect(senTem10.port_a, concen_Sen2.port_b)
    annotation (Line(points={{-49,102},{-49,94},{-53,94},{-53,82}},
                                               color={238,46,47}));
  connect(concen_Sen3.port_b, senTem11.port_a)
    annotation (Line(points={{40,67},{46,67}},                 color={238,46,47}));
  connect(senTem11.port_b, res4.port_b)
    annotation (Line(points={{64,67},{95,67},{95,34}},   color={238,46,47}));
  connect(res4.port_a, Container1.ports[3])
    annotation (Line(points={{95,20},{95,-27.5},{120,-27.5}},
                                                            color={238,46,47}));
  connect(senTem10.port_b, hex.port_a1)
    annotation (Line(points={{-49,120},{-49,127},{-48.4,127},{-48.4,148}}, color={255,0,0}));
  connect(concen_Sen.port_b, hex.port_b1)
    annotation (Line(points={{-88,192},{-70,192},{-70,186},{-48.4,186}}, color={255,0,0}));
  connect(senTem3.port_b, hex.port_a2)
    annotation (Line(points={{9,202},{-25.6,202},{-25.6,186}}, color={0,0,0}));
  connect(hex.port_b2, senTem2.port_b)
    annotation (Line(points={{-25.6,148},{-25.6,123},{56,123}}, color={0,0,0}));
  connect(const4.y, BrinePumpe.m_flow_in)
    annotation (Line(points={{-121,76},{-138,76}}, color={0,0,127}));
  connect(const5.y, BrinePump.m_flow_in)
    annotation (Line(points={{195.1,13},{200,13},{200,6},{206.4,6}}, color={0,0,127}));
  connect(Absorber.port_b_in, res6.port_a) annotation (Line(points={{-197.5,35.0909},{-196.75,
          35.0909},{-196.75,44},{-180,44}}, color={238,46,47}));
  connect(res6.port_b, BrinePumpe.port_b)
    annotation (Line(points={{-156,44},{-150,44},{-150,66}}, color={238,46,47}));
  connect(concen_Sen2.port_a, Container2.ports[1])
    annotation (Line(points={{-53,64},{-53,55},{-52,55},{-52,27.9}}, color={238,46,47}));
  connect(Container2.ports[2], senTem8.port_b)
    annotation (Line(points={{-52,31.3},{-54,31.3},{-54,-61},{-74,-61}}, color={238,46,47}));
  connect(concen_Sen1.port_a, Absorber.port_b_out)
    annotation (Line(points={{-140,-64},{-197.5,-64},{-197.5,-1.23636}}, color={238,46,47}));
  connect(concen_Sen4.port_a,res5. port_a)
    annotation (Line(points={{-7,-56},{-8,-56},{-8,-20}},
                                                      color={238,46,47}));
  connect(concen_Sen4.port_b, senTem12.port_a)
    annotation (Line(points={{-7,-74},{-6,-74},{-6,-96},{-7,-96}}, color={238,46,47}));
  connect(Container2.ports[3], res5.port_b)
    annotation (Line(points={{-52,34.7},{-52,8},{-8,8},{-8,0}}, color={238,46,47}));
  connect(senTem12.port_b, AbsPump.port_a)
    annotation (Line(points={{-7,-118},{-8,-118},{-8,-127},{24,-127}}, color={238,46,47}));
  connect(Container2.ports[4], concen_Sen3.port_a)
    annotation (Line(points={{-52,38.1},{-8,38.1},{-8,67},{22,67}}, color={238,46,47}));
  connect(AbsPump.port_b, Container1.ports[4])
    annotation (Line(points={{50,-127},{94,-127},{94,-24.5},{120,-24.5}}, color={238,46,47}));
  connect(const6.y, AbsPump.m_flow_in)
    annotation (Line(points={{39,-87.1},{39,-98.55},{37,-98.55},{37,-111.4}}, color={0,0,127}));
  connect(senRelHum.port_a, mixedAir.ports[1]) annotation (Line(points={{-320,26},{-290,26},{-290,
          -14},{-309.5,-14},{-309.5,-19.2}}, color={0,127,255}));
  connect(mixedAir.ports[2], senTem7.port_b) annotation (Line(points={{-309.5,-14.8},{-309.5,-20},
          {-291,-20},{-291,-42}}, color={0,127,255}));
  annotation (Diagram(coordinateSystem(extent={{-360,-200},{360,280}}),
        graphics={Text(
          extent={{14,18},{72,-8}},
          lineColor={28,108,200},
          textString="Control!!!"), Text(
          extent={{-312,150},{-234,104}},
          lineColor={28,108,200},
          textStyle={TextStyle.Bold},
          textString="Greenhouse
")}),                                                                    Icon(coordinateSystem(
          extent={{-360,-200},{360,280}})));
end whole_system;
