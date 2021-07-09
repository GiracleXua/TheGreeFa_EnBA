within BrineGrid.Fluid.Absorbers.Examples.Validation;
package test_EnBA
  extends Modelica.Icons.ExamplesPackage;
  model LiCl_Chen_2016_Dehumdification_var_input

    extends BaseClasses.BaseValidation(
      T_abs=273.15 + 14.9,
      x_a=0.0162,
      X_s=0.23,
      m_flow_air=1.85,
      m_flow_abs=2.61,
      nNodes=10,
      mNodes=10,
      abs(
        redeclare Data.Chen_2016                                          data,
        flowConf=BrineGrid.Fluid.Absorbers.Choices.FlowConfiguration.CrossCurrent,
        redeclare model ThermalAir =
          HeatTransfer.Convection.Absorption.RandomPackings_ChenZhangYin,
        redeclare model MoistureAir =
          MoistureTransfer.Convection.Absorption.RandomPackings_ChenZhangYin),
      sou_air(use_T_in=true));
      //redeclare final package Medium_b =
         // Media.LiquidDesiccants.LithiumChlorideAqueousSolution_PatekKlomfar,
      //    T_air=273.15 + 25.6,
    parameter Real simulation_id = 4;
    Modelica.Blocks.Sources.Step step(
      height=20,
      offset=293.15,
      startTime=2000) annotation (Placement(transformation(extent={{-92,44},{-72,64}})));
  equation
    connect(step.y, sou_air.T_in) annotation (Line(points={{-71,54},{-62,54}}, color={0,0,127}));
    annotation (
      Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
              100,100}})),
      experiment(
        StopTime=3600,
        Interval=1,
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
</html>",   info="<html>
<p>This model is validating the adiabatic absorber model in cross current flow configuration using lithium chloride with measured outlet data from Chen et al. 2016. </p>

<p>The correlations for the heat and mass transfer are from Chen et al. 2016.</p>

<h4>References</h4>

<dl><dt>Chen, Y., Zhang, X., Yin, Y.:</dt>
<dd><b>Experimental and theoretical analysis of liquid desiccant dehumidification process based on an advanced hybrid air-conditioning system </b></br>
</dd><dd>Applied Thermal Engineering 98, p. 387-399 (2016)</br>
</dd><dd>DOI: <a href=\"http://dx.doi.org/10.1016/j.applthermaleng.2015.12.066\">10.1016/j.applthermaleng.2015.12.066</a>
</dd></dl>
</html>"));
  end LiCl_Chen_2016_Dehumdification_var_input;
end test_EnBA;
