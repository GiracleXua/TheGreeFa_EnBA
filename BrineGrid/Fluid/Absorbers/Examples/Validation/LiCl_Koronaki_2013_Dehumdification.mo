within BrineGrid.Fluid.Absorbers.Examples.Validation;
model LiCl_Koronaki_2013_Dehumdification
  extends BaseClasses.BaseValidation(
    T_air=(71.2 + 459.67)*5/9,
    T_abs=(62.2 + 459.67)*5/9,
    x=0.0112,
    X_w=Media.LiquidDesiccants.Functions.totalHumidityToMassFraction(x=x),
    X_s=0.31,
    m_flow_air=0.000471947443*m_flow_air_imperial*d_air,
    m_flow_abs=6.30901964e-5*m_flow_abs_imperial*d_abs,
    nNodes=15,
    abs(
      redeclare Data.Koronaki_2013                                          data,
      flowConf=Choices.FlowConfiguration.CounterCurrent,
      redeclare model ThermalAir =
        HeatTransfer.Convection.Absorption.StructuredPackings_ChungGhoshHines,
      redeclare model MoistureAir =
        MoistureTransfer.Convection.Absorption.StructuredPackings_ChungGhoshHines));

  final parameter Modelica.SIunits.Density d_air=
    Medium_a.density(state=Medium_a.setState_pTX(p=Medium_a.p_default, T=T_air, X=X_air))
    "Density of inlet air";
  final parameter Modelica.SIunits.Density d_abs=
    Medium_b.density(state=Medium_b.setState_pTX(p=Medium_b.p_default, T=T_abs, X=X_abs))
    "Density of aqueous solution";
  parameter Real m_flow_air_imperial=40.0
    "Mass flow rate of inlet air in imperial units";
  parameter Real m_flow_abs_imperial=4.0
    "Mass flow rate of aqueous solutio at inlet in imperial units";
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})),
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
<p>This model is validating the adiabatic absorber model in counter current flow configuration using lithium chloride with measured outlet data from Koronaki et al. 2013. </p>

<p>The correlations for the heat and mass transfer are from Chung et al. 1996.</p>

<h4>References</h4>

<dl><dt>Koronaki, I. P., Christodoulaki, R. I., Papaefthimiou, V. D., Rogdakis, E. D.:</dt>
<dd><b>Thermodynamic analysis of a counter flow adiabatic dehumidifier with different liquid desiccant materials </b></br>
</dd><dd>Applied Thermal Engineering 50, p. 361-373 (2013)</br>
</dd><dd>DOI: <a href=\"http://dx.doi.org/10.1016/j.applthermaleng.2012.06.043\">10.1016/j.applthermaleng.2012.06.043</a>
</dd></dl>

<dl><dt>Chung, T.-W., Ghosh, T. K., Hines, A. L.:</dt>
<dd><b>Comparison between Random and Structured Packings for Dehumidification of Air by Lithium Chloride Solutions in a Packed Column and Their Heat and Mass Transfer Correlations</b><br>
Industrial and Engineering Chemistry Research 35, p. 192-198 (1996)<br>
DOI: <a href=\"http://dx.doi.org/10.1021/ie940652u\">10.1021/ie940652u</a>
</dd></dl>
</html>"));
end LiCl_Koronaki_2013_Dehumdification;
