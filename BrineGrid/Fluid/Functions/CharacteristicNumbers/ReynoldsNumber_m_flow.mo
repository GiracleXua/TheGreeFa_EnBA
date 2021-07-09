within BrineGrid.Fluid.Functions.CharacteristicNumbers;
function ReynoldsNumber_m_flow "Return Reynolds number from m_flow, eta, L, A"
  extends Modelica.Icons.Function;
  input Modelica.SIunits.MassFlowRate m_flow "Mass flow rate";
  input Modelica.SIunits.DynamicViscosity eta "Dynamic viscosity";
  input Modelica.SIunits.Length L
    "Characteristic dimension (hydraulic diameter of pipes or orifices)";
  input Modelica.SIunits.Area A
    "Cross sectional area of fluid flow"; //=Modelica.Constants.pi/4*L*L
  output Modelica.SIunits.ReynoldsNumber Re "Reynolds number";
algorithm
  Re := abs(m_flow)*L/A/eta;
  annotation(Inline=true, Documentation(revisions="<html>
<ul>
<li>
January 04, 2017, by Yannick Fuerst:<br/>
First implementation.
</li>
</ul>
</html>",
        info="<html>
<p>Calculate the Reynolds number as a function of the mass flow rate, dynamic viscosity, characteristic dimension and cross sectional area. </p>
</html>"));
end ReynoldsNumber_m_flow;
