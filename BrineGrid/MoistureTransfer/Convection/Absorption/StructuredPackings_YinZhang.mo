within BrineGrid.MoistureTransfer.Convection.Absorption;
model StructuredPackings_YinZhang
  "Structured packings: Convective mass transfer correlation from Yin and Zhang"
  extends BaseClasses.PartialConvectionAbsorption;
  parameter BrineGrid.SIunits.CoefficientOfMassTransfer2 beta0=0.03
    "Start value for mass transfer coefficient in kg/(m2.s)";

  Medium_a.Density rho_a=Medium_a.density(state=inflow_a)
    "Density of medium a at inlet";
  Medium_a.MassFraction x=
    Media.LiquidDesiccants.Functions.massFractionToTotalHumidity(X=X_a[1])
    "Absolute humidity of medium a at inlet";
  Modelica.SIunits.Velocity v_a=m_flow_in_a/crossArea/rho_a
    "Velocity of medium a at inlet";

  BrineGrid.SIunits.CoefficientOfMassTransfer2 beta(start=beta0)
    "Mass transfer coefficient in kg/(m2.s)";
equation
  beta = 3.0223e-4*v_a^(0.7407)*x^(2.1505)*exp(-0.0011294*(T_b - 273.15))*exp(-0.057101*(T_a - 273.15))*exp(19.377*(1 - X_b[1]));
  m_flow = beta*surface*(moisturePort_a.X - moisturePort_b.X);
  annotation (Documentation(info="<html>
<p>This model calculates the convective mass transfer coeffcient &beta; between moist air and aqueous solutions.
The correlation is valid for <b>structured packings</b>.</p>

<p><br><span style=\"color: #ff0000;\">This correlation is not yet validated.</span></p>

<h4>References</h4>

<dl><dt>Yin, Y., Zhang, X.:</dt>
<dd><b>A new method for determining coupled heat and mass transfer coefficients between air and liquid desiccant</b><br>
International Journal of Heat and Mass Transfer 51, p. 3287-3297 (2008)<br>
DOI: <a href=\"http://dx.doi.org/10.1016/j.ijheatmasstransfer.2007.11.040\">10.1016/j.ijheatmasstransfer.2007.11.040</a>
</dd></dl>
</html>", revisions="<html>
<ul>
<li>
January 04, 2017, by Yannick Fuerst:<br/>
First implementation.
</li>
</ul>
</html>"));
end StructuredPackings_YinZhang;
