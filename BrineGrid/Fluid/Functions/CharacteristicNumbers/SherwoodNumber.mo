within BrineGrid.Fluid.Functions.CharacteristicNumbers;
function SherwoodNumber "Return Sherwood number from beta, L and D"
  extends Modelica.Icons.Function;
  input BrineGrid.SIunits.CoefficientOfMassTransfer1 beta
    "Coefficient of mass transfer in m/s";
  input Modelica.SIunits.Length L "Characteristic dimension";
  input Modelica.SIunits.DiffusionCoefficient D "Diffusion coefficient";
  output BrineGrid.SIunits.SherwoodNumber Sh "Sherwood number";
algorithm
  Sh := beta*L/D;
  annotation(Inline=true, Documentation(revisions="<html>
<ul>
<li>
January 04, 2017, by Yannick Fuerst:<br/>
First implementation.
</li>
</ul>
</html>",
        info="<html>
<p>Calculate the Sherwood number as a function of the mass transfer coefficient, characteristic dimension and diffusion coefficient.</p>
</html>"));
end SherwoodNumber;
