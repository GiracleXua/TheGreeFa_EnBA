within BrineGrid.Fluid.Absorbers.Examples.Validation;
model LiCl_Chen_2014_Dehumdification
  extends BaseClasses.BaseValidation(
    T_air=273.15 + 35.2,
    T_abs=273.15 + 26.6,
    x=0.0173,
    X_w=Media.LiquidDesiccants.Functions.totalHumidityToMassFraction(x=x),
    X_s=0.35,
    m_flow_air=0.247,
    m_flow_abs=0.186,
    abs(
      redeclare Data.Chen_2014                                          data,
      flowConf=Choices.FlowConfiguration.CrossCurrent,
      redeclare model MoistureAir =
        MoistureTransfer.Convection.Absorption.StructuredPackings_YinZhang,
      redeclare model ThermalAir =
        HeatTransfer.Convection.Absorption.StructuredPackings_YinZhang));
    //redeclare package Medium_b =
    //BrineGrid.Media.LiquidDesiccants.LithiumBromideAqueousSolution_PatekKlomfar,
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})),
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
<p>This model is validating the adiabatic absorber model in cross current flow configuration using lithium chloride with measured outlet data from Chen et al. 2014. </p>

<p>The correlations for the heat and mass transfer are from Yin et al. 2008.</p>

<h4>References</h4>

<dl><dt>Chen, Y., Yin, Y., Zhang, X.:</dt>
<dd><b>Performance analysis of a hybrid air-conditioning system dehumidified by liquid desiccant with low temperature and low concentration </b></dd>
<dd>Energy and Buildings 77, p. 91-102 (2014) </dd>
<dd>DOI: <a href=\"http://dx.doi.org/10.1016/j.enbuild.2014.03.050\">10.1016/j.enbuild.2014.03.050</a>
</dd></dl>

<dl><dt>Yin, Y., Zhang, X.:</dt>
<dd><b>A new method for determining coupled heat and mass transfer coefficients between air and liquid desiccant</b><br>
International Journal of Heat and Mass Transfer 51, p. 3287-3297 (2008)<br>
DOI: <a href=\"http://dx.doi.org/10.1016/j.ijheatmasstransfer.2007.11.040\">10.1016/j.ijheatmasstransfer.2007.11.040</a>
</dd></dl>
</html>"));
end LiCl_Chen_2014_Dehumdification;
