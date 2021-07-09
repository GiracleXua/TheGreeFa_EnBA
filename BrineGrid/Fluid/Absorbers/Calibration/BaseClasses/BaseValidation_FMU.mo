within BrineGrid.Fluid.Absorbers.Calibration.BaseClasses;
partial model BaseValidation_FMU
  "Base validation model with changing some parameter to input for generating FMU"
  extends Modelica.Icons.Example;

  replaceable package Medium_a =
    Media.LiquidDesiccants.Air "Medium model for moist air";
  replaceable package Medium_b =
    Media.LiquidDesiccants.LithiumChlorideAqueousSolution_PatekKlomfar
    "Medium model for absorbent";
  replaceable package Medium_c =
    Media.LiquidDesiccants.MagnesiumChlorideAqueousSolution
    "Medium model for alternative absorbent";

  parameter Modelica.SIunits.AbsolutePressure dp_nominal_air=50
    "Nominal pressure drop on the air side";

  parameter Modelica.SIunits.AbsolutePressure dp_nominal_abs=50
    "Nominal pressure drop on the desiccant side";
  parameter Integer nNodes=2
    "Discretization of the desiccant flow";
  parameter Integer mNodes=2
    "Discretization of the air flow";

//   Modelica.SIunits.Temperature T_air
//     "Air inlet temperature";
//   Modelica.SIunits.Temperature T_abs
//     "Aqueous solution inlet temperature";
//   Modelica.SIunits.MassFraction x
//     "Water load of inlet air, kg water/kg dry air";
//
//   Modelica.SIunits.MassFraction X_s
//     "Mass fraction of desiccant";
//
//   Modelica.SIunits.MassFlowRate m_flow_air
//     "Mass flow rate of inlet air";
//   Modelica.SIunits.MassFlowRate m_flow_abs
//     "Mass flow rate of aqueous solutio at inlet";

  BrineGrid.Fluid.Sources.FixedBoundary sin_air(
    redeclare final package Medium = Medium_a,
    final nPorts=1)
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
  BrineGrid.Fluid.Sources.FixedBoundary sin_abs(
    final nPorts=1, redeclare final package Medium =
        Medium_b)
    annotation (Placement(transformation(extent={{60,-60},{40,-40}})));
  BrineGrid.Fluid.Sources.MassFlowSource_T sou_air(
    redeclare final package Medium = Medium_a,
    use_m_flow_in=true,
    use_T_in=true,
    use_X_in=true,
    final nPorts=1)
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  BrineGrid.Fluid.Sources.MassFlowSource_T sou_abs(
    use_m_flow_in=true,
    use_T_in=true,
    use_X_in=true,
    final nPorts=1,
    redeclare final package Medium = Medium_b)
    annotation (Placement(transformation(extent={{60,40},{40,60}})));
  BrineGrid.Fluid.Absorbers.Adiabatic.AdiabaticAbsorber_FMU abs(
    final dp_nominal_abs=dp_nominal_abs,
    final dp_nominal_air=dp_nominal_air,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final nSeg=nNodes,
    final show_T=true,
    final mSeg=mNodes,
    redeclare final package Medium_a = Medium_a,
    redeclare final package Medium_b = Medium_b)
    annotation (Placement(transformation(extent={{-30,-30},{30,30}})));

// protected
//   Modelica.SIunits.MassFraction X_w=
//     Media.LiquidDesiccants.Functions.totalHumidityToMassFraction(x=x)
//     "Mass fraction of water in inlet air, kg/kg moist air";
//
//   Modelica.SIunits.MassFraction[Medium_a.nX] X_air={X_w, 1 - X_w}
//   "Composition of moist air";
//
//   Modelica.SIunits.MassFraction[Medium_b.nX] X_abs={1 - X_s, X_s}
//     "Composition of aqueous solution";
//
//   Modelica.SIunits.MassFlowRate m_flow_nominal_air=m_flow_air
//     "Nominal mass flow rate of moist air";
//
//   Modelica.SIunits.MassFlowRate m_flow_nominal_abs=m_flow_abs
//     "Nominal mass flow rate of aqueous solution";

equation
  connect(abs.port_b_in, sou_abs.ports[1]) annotation (Line(points={{15,24.5455},{15,24.5455},{15,
          42},{15,50},{40,50}},         color={0,127,255}));
  connect(abs.port_b_out, sin_abs.ports[1]) annotation (Line(points={{15.5,-30},{15.5,-30},{15.5,
          -42},{15.5,-50},{40,-50}},        color={0,127,255}));
  connect(sin_air.ports[1], abs.port_a_out) annotation (Line(points={{-40,-50},{-16.5,-50},{-16.5,
          -30}},               color={0,127,255}));
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
end BaseValidation_FMU;
