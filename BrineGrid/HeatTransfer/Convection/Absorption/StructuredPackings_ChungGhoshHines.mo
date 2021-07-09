within BrineGrid.HeatTransfer.Convection.Absorption;
model StructuredPackings_ChungGhoshHines
  "Structured packings: Convective heat transfer correlation from Chung, Ghosh and Hines"
  extends BaseClasses.PartialConvectionAbsorption;
  parameter Modelica.SIunits.CoefficientOfHeatTransfer alpha0=10
    "Start value for heat transfer coefficient";

  Medium_a.Density rho_a=Medium_a.density(state=inflow_a)
    "Density of medium a at inlet";
  Medium_a.DynamicViscosity eta_a=Medium_a.dynamicViscosity(state=inflow_a)
    "Dynamic viscosity of medium a at inlet";
  Medium_a.ThermalConductivity lambda_a=Medium_a.thermalConductivity(state=inflow_a)
    "Thermal conductivity of medium a at inlet";
  Medium_a.SpecificHeatCapacity cp_a=Medium_a.specificHeatCapacityCp(state=inflow_a)
    "Specific isobaric heat capacity of medium a at inlet";

  Modelica.SIunits.CoefficientOfHeatTransfer alpha(start=alpha0)
    "Heat transfer coefficient";
  Modelica.SIunits.NusseltNumber Nu "Nusselt number";
  Modelica.SIunits.PrandtlNumber Pr "Prandtl number";
  Modelica.SIunits.ReynoldsNumber Re "Reynolds number";
equation
  Re = BrineGrid.Fluid.Functions.CharacteristicNumbers.ReynoldsNumber_m_flow(
    m_flow=m_flow_in_a/epsilon,
    eta=eta_a,
    L=deq,
    A=crossArea);
  Pr = Fluid.Functions.CharacteristicNumbers.PrandtlNumber(
    eta=eta_a,
    cp=cp_a,
    lambda=lambda_a);
  Nu = 2.78e-6*X_b[1]^(1.8)*(m_flow_in_b/m_flow_in_a)^(0.40)*Pr^(0.333)*Re^(1.6);
  alpha = Nu*lambda_a/deq;
  Q_flow = alpha*surface*(heatPort_a.T - heatPort_b.T);
  annotation (Documentation(info="<html>
<p>This model calculates the convective heat transfer coeffcient &alpha; between moist air and lithium chloride aqueous solutions.
The correlation is valid for <b>structured packings</b>.</p>

<p><br><span style=\"color: #ff0000;\">This correlation is not yet validated.</span></p>

<h4>References</h4>

<dl><dt>Chung, T.-W., Ghosh, T. K., Hines, A. L.:</dt>
<dd><b>Comparison between Random and Structured Packings for Dehumidification of Air by Lithium Chloride Solutions in a Packed Column and Their Heat and Mass Transfer Correlations</b><br>
Industrial and Engineering Chemistry Research 35, p. 192-198 (1996)<br>
DOI: <a href=\"http://dx.doi.org/10.1021/ie940652u\">10.1021/ie940652u</a>
</dd></dl>
</html>",      revisions="<html>
<ul>
<li>
January 04, 2017, by Yannick Fuerst:<br/>
First implementation.
</li>
</ul>
</html>"));
end StructuredPackings_ChungGhoshHines;
