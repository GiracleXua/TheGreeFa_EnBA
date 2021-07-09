within BrineGrid.Fluid.Functions.CharacteristicNumbers;
function SherwoodNumber_rho2
  "Return Sherwood number from beta, L, rho and D"
  extends Modelica.Icons.Function;
  input BrineGrid.SIunits.CoefficientOfMassTransfer4 beta
    "Coefficient of mass transfer in kg/(m2.s)";
  input Modelica.SIunits.Length L "Characteristic dimension";
  input Modelica.SIunits.DiffusionCoefficient D "Diffusion coefficient";
  input Modelica.SIunits.Density rho "Density";
  output BrineGrid.SIunits.SherwoodNumber Sh "Sherwood number";
algorithm
  Sh := beta*L/D/rho;
  annotation(Inline=true, Documentation(revisions="<html>
<ul>
<li>
January 04, 2017, by Yannick Fuerst:<br/>
First implementation.
</li>
</ul>
</html>",
        info="<html>
<p>Calculate the Sherwood number as a function of the mass transfer coefficient, characteristic dimension, density and diffusion coefficient. </p>
</html>"));
end SherwoodNumber_rho2;
