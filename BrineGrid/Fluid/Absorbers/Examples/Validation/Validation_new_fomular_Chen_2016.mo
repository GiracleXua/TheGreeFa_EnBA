within BrineGrid.Fluid.Absorbers.Examples.Validation;
model Validation_new_fomular_Chen_2016
  extends BaseClasses.BaseValidation(
    redeclare final package Medium_b =
        Media.LiquidDesiccants.LithiumChlorideAqueousSolution_PatekKlomfar,
    T_air=273.15 + 25.6,
    T_abs=273.15 + 14.9,
    x_a=0.0162,
    X_s=0.23,
    m_flow_air=1.85,
    m_flow_abs=2.61,
    mNodes = 5,
    nNodes = 5,
    abs(
      redeclare Data.Chen_2016                                          data,
      flowConf=BrineGrid.Fluid.Absorbers.Choices.FlowConfiguration.CrossCurrent,
      energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial,
      redeclare model ThermalAir =
          HeatTransfer.Convection.Absorption.Nu_Chen,
      redeclare model MoistureAir =
          MoistureTransfer.Convection.Absorption.Sh_Chen));

  parameter Real simulation_id = 99;
  parameter Modelica.SIunits.NusseltNumber Nu = 5.024;
  parameter Modelica.SIunits.NusseltNumberOfMassTransfer Sh = 3.7;

  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}})),
    experiment(
      StopTime=1800,
      __Dymola_NumberOfIntervals=100,
      __Dymola_Algorithm="Dassl"),
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

end Validation_new_fomular_Chen_2016;
