within BrineGrid.Fluid.Functions.CharacteristicNumbers;
function SchmidtNumber "Return Schmidt number from eta, rho and D"
  extends Modelica.Icons.Function;
  input Modelica.SIunits.DynamicViscosity eta "Dynamic viscosity";
  input Modelica.SIunits.Density rho "Density";
  input Modelica.SIunits.DiffusionCoefficient D "Diffusion coefficient";
  output Modelica.SIunits.SchmidtNumber Sc "Schmidt number";
algorithm
  Sc := eta/(rho*D);
  annotation(Inline=true, Documentation(revisions="<html>
<ul>
<li>
January 04, 2017, by Yannick Fuerst:<br/>
First implementation.
</li>
</ul>
</html>",
        info="<html>
<p>Calculate the Schmidt number as a function of the dynamic viscosity, density and diffusion coefficient. </p>
</html>"));
end SchmidtNumber;
