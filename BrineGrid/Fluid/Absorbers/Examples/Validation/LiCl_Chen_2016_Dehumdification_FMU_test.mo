within BrineGrid.Fluid.Absorbers.Examples.Validation;
model LiCl_Chen_2016_Dehumdification_FMU_test
  extends BaseClasses.BaseValidation(
    T_air=T_a,
    T_abs=T_des,
    x=x_a,
    X_w=Media.LiquidDesiccants.Functions.totalHumidityToMassFraction(x=x),
    X_s=xi_s,
    m_flow_air=mflow_air,
    m_flow_abs=mflow_abs,
    abs(
      redeclare Data.Chen_2016                                          data,
      flowConf=Choices.FlowConfiguration.CrossCurrent,
      redeclare model ThermalAir =
        HeatTransfer.Convection.Absorption.RandomPackings_ChenZhangYin,
      redeclare model MoistureAir =
        MoistureTransfer.Convection.Absorption.RandomPackings_ChenZhangYin));
  parameter Real T_a=273.15 + 25.6;
  parameter Real T_des=273.15 + 14.9;
  parameter Real x_a=0.0162;
  parameter Real X_w=Media.LiquidDesiccants.Functions.totalHumidityToMassFraction(x=x);
  parameter Real xi_s=0.23;
  parameter Real mflow_air=1.85;
  parameter Real mflow_abs=2.61;

  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}})),
    experiment(StopTime=1000),
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
end LiCl_Chen_2016_Dehumdification_FMU_test;
