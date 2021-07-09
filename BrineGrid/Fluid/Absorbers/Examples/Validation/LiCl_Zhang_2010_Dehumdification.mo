within BrineGrid.Fluid.Absorbers.Examples.Validation;
model LiCl_Zhang_2010_Dehumdification
  extends BaseClasses.BaseValidation(
    T_air=273.15 + 34.7,
    T_abs=273.15 + 16.2,
    x=0.01486,
    X_w=Media.LiquidDesiccants.Functions.totalHumidityToMassFraction(x=x),
    X_s=0.32,
    m_flow_air=0.0328,
    m_flow_abs=0.0143,
    abs(
      redeclare Data.Zhang_2010                                          data,
      flowConf=Choices.FlowConfiguration.CrossCurrent,
      redeclare model ThermalAir =
        HeatTransfer.Convection.Absorption.IdealHeatTransfer,
      redeclare model MoistureAir =
        MoistureTransfer.Convection.Absorption.StructuredPackingDehumidification_ZhangHiharaMatsuokaDang));
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
<p>This model is validating the adiabatic absorber model in cross current flow configuration using lithium chloride with measured outlet data from Zhang et al. 2010. </p>

<p>The correlations for the heat and mass transfer are from Zhang et al. 2010.</p>

<h4>References</h4>

<dl><dt>Zhang, L., Hihara, E., Matsuoka, F., Dang, C.:</dt>
<dd><b>Experimental analysis of mass transfer in adiabatic structured packing dehumidifier/regenerator with liquid desiccant </b></br>
</dd><dd>International Journal of Heat and Mass Transfer 53, p. 2856-2863 (2010)</br>
</dd><dd>DOI: <a href=\"http://dx.doi.org/10.1016/j.ijheatmasstransfer.2010.02.012\">10.1016/j.ijheatmasstransfer.2010.02.012</a>
</dd></dl>
</html>"));
end LiCl_Zhang_2010_Dehumdification;
