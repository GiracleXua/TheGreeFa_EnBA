within BrineGrid.Fluid.Functions.CharacteristicNumbers;
function beta_from_SherwoodNumber_rho
  "Return mass transfer coefficient from Sh, L, D and rho"
  extends Modelica.Icons.Function;
  input BrineGrid.SIunits.SherwoodNumber Sh "Sherwood number";
  input Modelica.SIunits.Length L "Characteristic dimension";
  input Modelica.SIunits.DiffusionCoefficient D "Diffusion coefficient";
  input Modelica.SIunits.Density rho "Density";
  output BrineGrid.SIunits.CoefficientOfMassTransfer2 beta
    "Coefficient of mass transfer";
algorithm
  beta := Sh*D*rho/L;
  annotation(Inline=true, Documentation(revisions="<html>
<ul>
<li>
January 04, 2017, by Yannick Fuerst:<br/>
First implementation.
</li>
</ul>
</html>",
        info="<html>
<p>Calculate the mass transfer coefficient as a function of the Sherwood number, characteristic dimension, density and diffusion coefficient. </p>
</html>"));
end beta_from_SherwoodNumber_rho;
