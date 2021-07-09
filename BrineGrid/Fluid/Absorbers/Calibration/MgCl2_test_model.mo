within BrineGrid.Fluid.Absorbers.Calibration;
model MgCl2_test_model
  extends BaseClasses.BaseValidation_Calibration(
    T_air=273.15 + 25.6,
    T_abs=273.15 + 14.9,
    x=0.0162,
    X_w=Media.LiquidDesiccants.Functions.totalHumidityToMassFraction(x=x),
    X_s=0.23,
    m_flow_air=1.85,
    m_flow_abs=2.61,
    abs(
      redeclare Data.Mg_dempav data,
      flowConf=Choices.FlowConfiguration.CounterCurrent,
      redeclare model ThermalAir =
          HeatTransfer.Convection.Absorption.ConstantNusseltNumber_Absorption (Nu0=Nu),
      redeclare model MoistureAir =
          MoistureTransfer.Convection.Absorption.ConstantSherwoodNumber (Sh0=Sh)));

  parameter Modelica.SIunits.NusseltNumber Nu = 250;
  parameter Modelica.SIunits.NusseltNumberOfMassTransfer Sh = 1;

  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}})),
    experiment(StopTime=3600),
    __Dymola_experimentSetupOutput,
    Documentation(revisions="<html>
<ul>
<li>Apr. 20, 2020, by Guangxu Wang</li>
<p>first implementation</p>
<li>February 21, 2017, by Yannick Fuerst:<br>Adapted to geometric data record. </li>
<li>January 04, 2017, by Yannick Fuerst:<br>First implementation. </li>
</ul>
</html>", info="<html>
<p>This model is validating the adiabatic absorber model for MgCl2</p>
<p>The correlations is still under development.</p>
<p><b>References</b> </p>
<dl><dt>Chen, Y., Zhang, X., Yin, Y.:</dt>
<dd><h4>Experimental and theoretical analysis of liquid desiccant dehumidification process based on an advanced hybrid air-conditioning system </h4></dd>
<dd>Applied Thermal Engineering 98, p. 387-399 (2016) </dd>
<dd>DOI: <a href=\"http://dx.doi.org/10.1016/j.applthermaleng.2015.12.066\">10.1016/j.applthermaleng.2015.12.066</a> </dd>
</dl></html>"));

end MgCl2_test_model;
