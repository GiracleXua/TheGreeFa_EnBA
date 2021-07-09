within BrineGrid.Fluid.Absorbers.Examples.Netzwerk.partial_cycle;
model Abs_cycle_GH
  extends Modelica.Icons.Example;
  BrineGrid.Fluid.Absorbers.Adiabatic.AdiabaticAbsorber
                              Absorber
    annotation (Placement(transformation(extent={{72,-16},{18,38}})));
  Buildings.Fluid.Movers.FlowControlled_m_flow BrinePumpe annotation (Placement(transformation(
        extent={{-18,18},{18,-18}},
        rotation=-90,
        origin={28,124})));
  Buildings.Fluid.Sensors.DensityTwoPort concen_Sen
    annotation (Placement(transformation(extent={{-40,172},{-60,192}})));
  Buildings.Fluid.Sensors.RelativeHumidityTwoPort senRelHum annotation (Placement(transformation(
        extent={{-8,8},{8,-8}},
        rotation=90,
        origin={156,26})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTem annotation (Placement(transformation(
        extent={{-7,7},{7,-7}},
        rotation=90,
        origin={157,57})));
  BrineGrid.Fluid.Movers.FlowControlled_m_flow ventilator
    annotation (Placement(transformation(extent={{76,-102},{110,-136}})));
  Buildings.Fluid.Sensors.RelativeHumidityTwoPort senRelHum3 annotation (Placement(transformation(
        extent={{-8,8},{8,-8}},
        rotation=90,
        origin={156,-90})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTem7 annotation (Placement(transformation(
        extent={{-7,7},{7,-7}},
        rotation=90,
        origin={157,-59})));
  Buildings.Fluid.FixedResistances.PressureDrop res2 annotation (Placement(transformation(
        extent={{6,-6},{-6,6}},
        rotation=180,
        origin={80,84})));
  Buildings.Fluid.FixedResistances.PressureDrop res3 annotation (Placement(transformation(
        extent={{6,6},{-6,-6}},
        rotation=270,
        origin={58,-88})));
  Buildings.Fluid.Sensors.DensityTwoPort concen_Sen1
    annotation (Placement(transformation(extent={{6,-88},{-18,-64}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTem8
    annotation (Placement(transformation(extent={{-54,-84},{-72,-66}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTem9
    annotation (Placement(transformation(extent={{4,170},{-20,194}})));
  Buildings.Fluid.Sensors.DensityTwoPort concen_Sen2 annotation (Placement(transformation(
        extent={{-9,9},{9,-9}},
        rotation=90,
        origin={-99,75})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTem10 annotation (Placement(transformation(
        extent={{-9,9},{9,-9}},
        rotation=90,
        origin={-99,113})));
  Buildings.Fluid.HeatExchangers.ConstantEffectiveness hex annotation (Placement(transformation(
        extent={{-19,19},{19,-19}},
        rotation=90,
        origin={-111,163})));
  Buildings.Fluid.FixedResistances.PressureDrop res6
                                                    annotation (Placement(transformation(
        extent={{12,-10},{-12,10}},
        rotation=-90,
        origin={30,74})));
  Buildings.Fluid.MixingVolumes.MixingVolume DES_tank(nPorts=2) annotation (
      Placement(transformation(
        extent={{17,17},{-17,-17}},
        rotation=-90,
        origin={-129,-15})));
  Buildings.ThermalZones.Detailed.MixedAir GH(nPorts=2)
    annotation (Placement(transformation(extent={{164,-36},{208,8}})));
equation
  connect(senTem.port_a,senRelHum. port_b)
    annotation (Line(points={{157,50},{157,34},{156,34}},    color={0,127,255}));
  connect(senTem7.port_a,senRelHum3. port_b)
    annotation (Line(points={{157,-66},{157,-82},{156,-82}},    color={0,127,255}));
  connect(senRelHum3.port_a, ventilator.port_b) annotation (Line(points={{156,-98},
          {156,-119},{110,-119}}, color={0,127,255}));
  connect(Absorber.port_a_in,res2. port_a)
    annotation (Line(points={{58.5,33.0909},{58.5,84},{74,84}},         color={0,127,255}));
  connect(Absorber.port_a_out,res3. port_b) annotation (Line(points={{58.5,-3.72727},
          {58.5,-43.5},{58,-43.5},{58,-82}},
                                 color={0,127,255}));
  connect(res3.port_a, ventilator.port_a) annotation (Line(points={{58,-94},{58,
          -119},{76,-119}}, color={0,127,255}));
  connect(concen_Sen1.port_b,senTem8. port_a)
    annotation (Line(points={{-18,-76},{-18,-75},{-54,-75}},          color={238,46,47}));
  connect(senTem9.port_b,concen_Sen. port_a)
    annotation (Line(points={{-20,182},{-40,182}},                 color={238,46,47}));
  connect(senTem9.port_a,BrinePumpe. port_a)
    annotation (Line(points={{4,182},{28,182},{28,142}},       color={238,46,47}));
  connect(senTem10.port_a,concen_Sen2. port_b)
    annotation (Line(points={{-99,104},{-99,84}},
                                               color={238,46,47}));
  connect(senTem10.port_b,hex. port_a1)
    annotation (Line(points={{-99,122},{-99,144},{-99.6,144}},             color={255,0,0}));
  connect(concen_Sen.port_b,hex. port_b1)
    annotation (Line(points={{-60,182},{-99.6,182}},                     color={255,0,0}));
  connect(DES_tank.ports[1], senTem8.port_b) annotation (Line(points={{-112,-18.4},
          {-100,-18.4},{-100,-75},{-72,-75}}, color={238,46,47}));
  connect(concen_Sen1.port_a,Absorber. port_b_out)
    annotation (Line(points={{6,-76},{31.5,-76},{31.5,-3.23636}},        color={238,46,47}));
  connect(senRelHum.port_a, GH.ports[1]) annotation (Line(points={{156,18},{156,
          -22},{169.5,-22},{169.5,-27.2}}, color={0,127,255}));
  connect(GH.ports[2], senTem7.port_b) annotation (Line(points={{169.5,-22.8},{169.5,
          -30},{157,-30},{157,-52}}, color={0,127,255}));
  connect(Absorber.port_b_in, res6.port_a) annotation (Line(points={{31.5,33.0909},
          {31.5,47.5455},{30,47.5455},{30,62}}, color={238,46,47}));
  connect(res6.port_b, BrinePumpe.port_b)
    annotation (Line(points={{30,86},{28,86},{28,106}}, color={238,46,47}));
  connect(DES_tank.ports[2], concen_Sen2.port_a) annotation (Line(points={{-112,
          -11.6},{-99,-11.6},{-99,66}}, color={238,46,47}));
  connect(res2.port_b, senTem.port_b)
    annotation (Line(points={{86,84},{157,84},{157,64}}, color={0,127,255}));
  annotation (Diagram(coordinateSystem(extent={{-160,-180},{220,220}}),
        graphics={                  Text(
          extent={{150,-12},{72,-58}},
          lineColor={28,108,200},
          textStyle={TextStyle.Bold},
          textString="Greenhouse
")}), Icon(coordinateSystem(extent={{-160,-180},{220,220}})));
end Abs_cycle_GH;
