within BrineGrid.Fluid.Absorbers.Examples.Validation.BaseClasses;
partial model BaseValidation
  extends Modelica.Icons.Example;

  replaceable package Medium_a =
    Media.LiquidDesiccants.Air "Medium model for moist air";
  replaceable package Medium_b =
    Media.LiquidDesiccants.MagnesiumChlorideAqueousSolution
    "Medium model for desiccant";
  //Media.LiquidDesiccants.LithiumChlorideAqueousSolution_PatekKlomfar
  //Media.LiquidDesiccants.MagnesiumChlorideAqueousSolution

  parameter Modelica.SIunits.Temperature T_air=273.15 + 25.6
    "Air inlet temperature";
  parameter Modelica.SIunits.Temperature T_abs=273.15 + 14.9
    "Aqueous solution inlet temperature";
  parameter Modelica.SIunits.MassFraction x_a=0.0162
    "Water load of inlet air (humidity ratio), kg water/kg dry air";
  parameter Modelica.SIunits.MassFraction X_w=
    Media.LiquidDesiccants.Functions.totalHumidityToMassFraction(x=x_a)
    "Mass fraction of water in inlet air, kg/kg moist air";
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
    "Discretization of the desiccant flow";
  parameter Integer mNodes=2
    "Discretization of the air flow";
  //parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial;

  BrineGrid.Fluid.Sources.FixedBoundary sin_air(
    redeclare final package Medium = Medium_a,
    final nPorts=1)
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
  BrineGrid.Fluid.Sources.FixedBoundary sin_abs(
    final nPorts=1,
    redeclare final package Medium = Medium_b)
    annotation (Placement(transformation(extent={{60,-60},{40,-40}})));
  BrineGrid.Fluid.Sources.MassFlowSource_T sou_air(
    redeclare final package Medium = Medium_a,
    final m_flow=m_flow_air,
    final T=T_air,
    final X=X_air,
    final nPorts=1)
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  BrineGrid.Fluid.Sources.MassFlowSource_T sou_abs(
    final m_flow=m_flow_abs,
    final T=T_abs,
    final X=X_abs,
    final nPorts=1,
    redeclare final package Medium = Medium_b)
    annotation (Placement(transformation(extent={{60,40},{40,60}})));
  BrineGrid.Fluid.Absorbers.Adiabatic.AdiabaticAbsorber abs(
    final m_flow_nominal_abs=m_flow_nominal_abs,
    final m_flow_nominal_air=m_flow_nominal_air,
    final dp_nominal_abs=dp_nominal_abs,
    final dp_nominal_air=dp_nominal_air,
    final T_start_abs=T_abs,
    final T_start_air=T_air,
    final X_start_abs=X_abs,
    final X_start_air=X_air,
    final m_flow_start_abs=m_flow_abs,
    final m_flow_start_air=m_flow_air,
    final nSeg=nNodes,
    final show_T=true,
    final mSeg=mNodes,
    redeclare final package Medium_a = Medium_a,
    redeclare final package Medium_b = Medium_b)
    annotation (Placement(transformation(extent={{-30,-30},{30,30}})));
equation
  connect(abs.port_b_in, sou_abs.ports[1]) annotation (Line(points={{15,24.5455},
          {15,24.5455},{15,42},{15,50},{40,50}},
                                        color={0,127,255}));
  connect(abs.port_b_out, sin_abs.ports[1]) annotation (Line(points={{15,
          -15.8182},{15,-15.8182},{15,-42},{15,-50},{40,-50}},
                                            color={0,127,255}));
  connect(sin_air.ports[1], abs.port_a_out) annotation (Line(points={{-40,-50},
          {-15,-50},{-15,-16.3636}},
                               color={0,127,255}));
  connect(sou_air.ports[1], abs.port_a_in)
    annotation (Line(points={{-40,50},{-15,50},{-15,24.5455}},
                                                          color={0,127,255}));
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
end BaseValidation;
