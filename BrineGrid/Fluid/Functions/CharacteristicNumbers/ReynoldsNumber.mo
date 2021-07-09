within BrineGrid.Fluid.Functions.CharacteristicNumbers;
function ReynoldsNumber "Return Reynolds number from v, rho, eta, L"
  extends Modelica.Icons.Function;
  input Modelica.SIunits.Velocity v "Mean velocity of fluid flow";
  input Modelica.SIunits.Density rho "Fluid density";
  input Modelica.SIunits.DynamicViscosity eta "Dynamic (absolute) viscosity";
  input Modelica.SIunits.Length L
    "Characteristic dimension (hydraulic diameter of pipes)";
  output Modelica.SIunits.ReynoldsNumber Re "Reynolds number";
algorithm
  Re := abs(v)*rho*L/eta;
  annotation(Inline=true, Documentation(revisions="<html>
<ul>
<li>
January 04, 2017, by Yannick Fuerst:<br/>
First implementation.
</li>
</ul>
</html>",
        info="<html>
<p>Calculate the Reynolds number as a function of the mean fluid velocity, density, dynamic viscosity and characteristic dimension. </p>
</html>"));
end ReynoldsNumber;
