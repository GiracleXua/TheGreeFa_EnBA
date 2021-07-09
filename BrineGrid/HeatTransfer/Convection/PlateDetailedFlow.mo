within BrineGrid.HeatTransfer.Convection;
model PlateDetailedFlow
  "Plate: Laminar and turbulent flow, local coefficients"
  extends BaseClasses.PartialConvectionGeneral;
  parameter Modelica.SIunits.CoefficientOfHeatTransfer alpha0=100
    "Start value for heat transfer coefficients";

  Medium_a.SpecificHeatCapacity cp_a=Medium_a.specificHeatCapacityCp(state=inflow_a)
    "Specific heat capacity of medium a at inlet";
  Medium_a.DynamicViscosity eta_a=Medium_a.dynamicViscosity(state=inflow_a)
    "Dynamic viscosity of medium a at inlet";
  Medium_a.ThermalConductivity lambda_a=Medium_a.thermalConductivity(state=inflow_a)
    "Thermal conductivity of medium a at inlet";

  Modelica.SIunits.CoefficientOfHeatTransfer alpha(start=alpha0)
    "Coefficient of heat transfer";
  Modelica.SIunits.ReynoldsNumber Re "Reynolds number";
  Modelica.SIunits.PrandtlNumber Pr "Prandtl number";
  Modelica.SIunits.NusseltNumber Nu "Nusselt number";
protected
  Modelica.SIunits.NusseltNumber Nu_tur "Nusselt number for turbulent flow";
  Modelica.SIunits.NusseltNumber Nu_lam "Nusselt number for laminar flow";
equation
  Pr = BrineGrid.Fluid.Functions.CharacteristicNumbers.PrandtlNumber(
    eta=eta_a,
    cp=cp_a,
    lambda=lambda_a);
  Re = BrineGrid.Fluid.Functions.CharacteristicNumbers.ReynoldsNumber_m_flow(
    m_flow=m_flow_in_a,
    eta=eta_a,
    L=deq,
    A=crossArea);
  Nu = BrineGrid.Fluid.Functions.CharacteristicNumbers.NusseltNumber(
    alpha=alpha,
    lambda=lambda_a,
    L=deq);
  Nu_lam = 0.332*max(Re, Modelica.Constants.small)^(1/2)*Pr^(1/3);
  Nu_tur = 0.0296*max(Re, Modelica.Constants.small)^0.8*Pr/(1 + 2.185*max(Re,
           Modelica.Constants.small)^(-0.1)*(Pr - 1));
  Nu = BrineGrid.Utilities.Math.Functions.spliceFunction(
    pos=Nu_tur,
    neg=Nu_lam,
    x=Re,
    deltax=4e5);
  Q_flow = alpha*surface*(heatPort_a.T - heatPort_b.T);
  annotation (Documentation(info="<html>
<p>
Convective heat transfer model for plane plates in a longitudinal flow. The correlation considers the local position along the plate and is valid for
</p>
<ul>
<li>uniform plate temperature,</li>
<li>fully developed flow,</li>
<li>forced convection and</li>
<li>0 &le; Re &le; 1e7, 0.5 &le; Pr &le; 2000.</li>
</ul>
<p><br><span style=\"color: #ff0000;\">Transition function not implemented yet.</span></p>
<h4>References</h4>
<dl><dt>Verein Deutscher Ingenieure:</dt>
<dd><b>VDI W&auml;rmeatlas</b><br>
Springer Verlag, Ed. 11 (2013).<br>
DOI: <a href=\"http://dx.doi.org/10.1007/978-3-642-19981-3\">10.1007/978-3-642-19981-3</a>
</dd></dl>
</html>",      revisions="<html>
<ul>
<li>
January 04, 2017, by Yannick Fuerst:<br/>
First implementation.
</li>
</ul>
</html>"));
end PlateDetailedFlow;
