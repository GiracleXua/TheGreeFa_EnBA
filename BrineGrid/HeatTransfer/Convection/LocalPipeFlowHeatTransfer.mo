within BrineGrid.HeatTransfer.Convection;
model LocalPipeFlowHeatTransfer
  "Pipe: Laminar and turbulent forced convection, local coefficients"
  extends BaseClasses.PartialConvectionGeneral;
  parameter Modelica.SIunits.CoefficientOfHeatTransfer alpha0=100
    "Start value for heat transfer coefficients";
  parameter Modelica.SIunits.Length length=1.0 "Length of pipe";

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
  Real Nu_turb "Nusselt number for turbulent flow";
  Real Nu_lam "Nusselt number for laminar flow";
  Real Nu_1;
  Real Nu_2;
  Real Xi;
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
  Nu_1 = 3.66;
  Nu_turb = smooth(0, (Xi/8)*abs(Re)*Pr/(1 + 12.7*(Xi/8)^0.5*(Pr^(2/3) - 1))
            *(1 + 1/3*(deq/length)^(2/3)));
  Xi = (1.8*log10(max(Modelica.Constants.small, Re)) - 1.5)^(-2);
  Nu_2 = smooth(0, 1.077*(abs(Re)*Pr*deq/length)^(1/3));
  Nu_lam = (Nu_1^3 + 0.7^3 + (Nu_2 - 0.7)^3)^(1/3);
  Nu = BrineGrid.Utilities.Math.Functions.spliceFunction(
    pos=Nu_turb,
    neg=Nu_lam,
    x=Re - 6150,
    deltax=3850);
  Q_flow = alpha*surface*(heatPort_a.T - heatPort_b.T);
  annotation (Documentation(info="<html>
<p>
Convective heat transfer model for laminar and turbulent flow in pipes. The correlation considers the local position along the pipe and is valid for
</p>
<ul>
<li>constant wall temperature,</li>
<li>fully developed flow,</li>
<li>forced convection and</li>
<li>0 &le; Re &le; 1e6, 0.1 &le; Pr &le; 100, d/L &le; 1. </li>
</ul>
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
end LocalPipeFlowHeatTransfer;
