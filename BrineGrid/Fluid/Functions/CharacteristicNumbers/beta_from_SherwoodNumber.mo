within BrineGrid.Fluid.Functions.CharacteristicNumbers;
function beta_from_SherwoodNumber
  "Return mass transfer coefficient from Sh, L and D"
  extends Modelica.Icons.Function;
  input BrineGrid.SIunits.SherwoodNumber Sh "Sherwood number";
  input Modelica.SIunits.Length L "Characteristic dimension";
  input Modelica.SIunits.DiffusionCoefficient D "Diffusion coefficient";
  output BrineGrid.SIunits.CoefficientOfMassTransfer1 beta
    "Coefficient of mass transfer";
algorithm
  beta := Sh*D/L;
  annotation(Inline=true, Documentation(revisions="<html>
<ul>
<li>
January 04, 2017, by Yannick Fuerst:<br/>
First implementation.
</li>
</ul>
</html>",
        info="<html>
<p>Calculate the mass transfer coefficient as a function of the Sherwood number, characteristic dimension and diffusion coefficient. </p>
</html>"));
end beta_from_SherwoodNumber;
