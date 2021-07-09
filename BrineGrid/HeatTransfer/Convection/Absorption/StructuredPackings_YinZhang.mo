within BrineGrid.HeatTransfer.Convection.Absorption;
model StructuredPackings_YinZhang
  "Structured packings: Convective heat transfer correlation from Yin and Zhang"
  extends BaseClasses.PartialConvectionAbsorption;
  parameter Modelica.SIunits.CoefficientOfHeatTransfer alpha0=10
    "Start value for heat transfer coefficient";

  Medium_a.Density rho_a=Medium_a.density(state=inflow_a)
    "Density of medium a at inlet";
  Medium_a.MassFraction x=
    Media.LiquidDesiccants.Functions.massFractionToTotalHumidity(X=X_a[1])
    "Absolute humidity of medium a at inlet";
  Modelica.SIunits.Velocity v_a=m_flow_in_a/crossArea/rho_a
    "Velocity of medium a at inlet";

  Modelica.SIunits.CoefficientOfHeatTransfer alpha(start=alpha0)
    "Heat transfer coefficient";
equation
  alpha = 6.834e6*v_a^(1.3)*(T_a - 273.15)^(-3.9)*(T_b - 273.15)^(-1.2)*x^(2.2)*exp(6.68*(1 - X_b[1]))*exp(-5.71e-2*(T_a - 273.15))*exp(-1.13e-3*(T_b - 273.15))*exp(-9.28e-2*x);
  Q_flow = alpha*surface*(heatPort_a.T - heatPort_b.T);
  annotation (Documentation(info="<html>
<p>This model calculates the convective heat transfer coeffcient &alpha; between moist air and lithium chloride aqueous solutions.
The correlation is valid for <b>structured packings</b>.</p>

<p><br><span style=\"color: #ff0000;\">This correlation is not yet validated.</span></p>

<h4>References</h4>

<dl><dt>Yin, Y., Zhang, X.:</dt>
<dd><b>A new method for determining coupled heat and mass transfer coefficients between air and liquid desiccant</b><br>
International Journal of Heat and Mass Transfer 51, p. 3287-3297 (2008)<br>
DOI: <a href=\"http://dx.doi.org/10.1016/j.ijheatmasstransfer.2007.11.040\">10.1016/j.ijheatmasstransfer.2007.11.040</a>
</dd></dl>
</html>",      revisions="<html>
<ul>
<li>
January 04, 2017, by Yannick Fuerst:<br/>
First implementation.
</li>
</ul>
</html>"));
end StructuredPackings_YinZhang;
