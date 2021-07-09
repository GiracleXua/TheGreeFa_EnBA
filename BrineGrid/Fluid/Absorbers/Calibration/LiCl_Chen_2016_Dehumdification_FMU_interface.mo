within BrineGrid.Fluid.Absorbers.Calibration;
model LiCl_Chen_2016_Dehumdification_FMU_interface
  extends BaseClasses.BaseValidation_FMU(abs(
      redeclare Data.Chen_2016 data,
      flowConf=Choices.FlowConfiguration.CrossCurrent,
      redeclare model ThermalAir =
          HeatTransfer.Convection.Absorption.RandomPackings_ChenZhangYin,
      redeclare model MoistureAir =
          MoistureTransfer.Convection.Absorption.RandomPackings_ChenZhangYin));

  // interface -- input
  Modelica.Blocks.Interfaces.RealInput T_air_in "input air, K"
    annotation (Placement(transformation(extent={{-130,30},{-90,70}})),
    Dialog(group="input"));
  Modelica.Blocks.Interfaces.RealInput T_abs_in "input desiccant K"
    annotation (Placement(transformation(extent={{126,30},{86,70}})));
  Modelica.Blocks.Interfaces.RealInput x_air_in "input water in dry air kg/kg(dry air)"
    annotation (Placement(transformation(extent={{-130,-4},{-90,36}})));
  Modelica.Blocks.Interfaces.RealInput x_abs_in "input mass fraction of desiccant"
    annotation (Placement(transformation(extent={{128,-6},{88,34}})));
  Modelica.Blocks.Interfaces.RealInput m_flow_a_in "input mass flow of air, kg/s"
    annotation (Placement(transformation(extent={{-132,62},{-92,102}})));
  Modelica.Blocks.Interfaces.RealInput m_flow_abs_in "input mass flow of desiccant, kg/s"
    annotation (Placement(transformation(extent={{124,66},{84,106}})));

  // interface -- output
  Modelica.Blocks.Interfaces.RealOutput T_air_out
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-16,-104})));
  Modelica.Blocks.Interfaces.RealOutput x_air_out
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={18,-104})));

  //input x_abs_in_corrected x_abs_in "make the format of xi_abs aligned to (water, des)";
protected
  Modelica.SIunits.MassFraction xi_air=
    BrineGrid.Media.LiquidDesiccants.Functions.totalHumidityToMassFraction(x_air_in);
  Modelica.SIunits.MassFraction[Medium_a.nX] x_air_array={xi_air, 1 - xi_air}
    "Composition of moist air";
  Modelica.SIunits.MassFraction[Medium_b.nX] x_abs_array={1 - x_abs_in, x_abs_in}
    "Composition of aqueous solution";

//    Modelica.Blocks.Interfaces.RealInput T_air_internal "input air, K";
//    Modelica.Blocks.Interfaces.RealInput T_abs_internal "input desiccant K";
//    Modelica.Blocks.Interfaces.RealInput x_air_internal "input water in dry air kg/kg(dry air)";
//    Modelica.Blocks.Interfaces.RealInput x_abs_internal "input mass fraction of desiccant";
//    Modelica.Blocks.Interfaces.RealInput m_flow_a_internal "input mass flow of air, kg/s";
//    Modelica.Blocks.Interfaces.RealInput m_flow_abs_internal "input mass flow of desiccant, kg/s";

equation

//input
  T_air_in = abs.T_start_air;
  T_abs_in = abs.T_start_abs;
  x_air_array = abs.X_start_air;
  x_abs_array = abs.X_start_abs;
  m_flow_a_in = abs.m_flow_start_air;
  m_flow_abs_in = abs.m_flow_start_abs;
  m_flow_a_in = abs.m_flow_nominal_air;
  m_flow_abs_in = abs.m_flow_nominal_abs;

//output
  T_air_out = abs.air_out.T;
  x_air_out = abs.air_out.X[1]/abs.air_out.X[2];

  connect(m_flow_a_in, sou_air.m_flow_in)
    annotation (Line(points={{-112,82},{-88,82},{-88,58},{-60,58}}, color={0,0,127}));
  connect(T_air_in, sou_air.T_in)
    annotation (Line(points={{-110,50},{-86,50},{-86,54},{-62,54}}, color={0,0,127}));
  connect(x_air_in, sou_air.X_in)
    annotation (Line(points={{-110,16},{-84,16},{-84,46},{-62,46}}, color={0,0,127}));
  connect(sou_abs.m_flow_in, m_flow_abs_in)
    annotation (Line(points={{60,58},{74,58},{74,86},{104,86}}, color={0,0,127}));
  connect(sou_abs.T_in, T_abs_in)
    annotation (Line(points={{62,54},{76,54},{76,50},{106,50}}, color={0,0,127}));

  sou_abs.X_in = 1- x_abs_in
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}})),
    experiment(StopTime=3600),
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
</html>", info="<html>
<p>This model is validating the adiabatic absorber model in cross current flow configuration using lithium chloride with measured outlet data from Chen et al. 2016. </p>

<p>The correlations for the heat and mass transfer are from Chen et al. 2016.</p>

<h4>References</h4>

<dl><dt>Chen, Y., Zhang, X., Yin, Y.:</dt>
<dd><b>Experimental and theoretical analysis of liquid desiccant dehumidification process based on an advanced hybrid air-conditioning system </b></br>
</dd><dd>Applied Thermal Engineering 98, p. 387-399 (2016)</br>
</dd><dd>DOI: <a href=\"http://dx.doi.org/10.1016/j.applthermaleng.2015.12.066\">10.1016/j.applthermaleng.2015.12.066</a>
</dd></dl>
</html>"));

end LiCl_Chen_2016_Dehumdification_FMU_interface;
