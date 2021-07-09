within BrineGrid.Media.LiquidDesiccants.Functions;
function massFractionToTotalHumidity
  extends Modelica.Icons.Function;
  input Modelica.SIunits.MassFraction X;
  output Modelica.SIunits.MassFraction x;
algorithm
  x := X/(1 - X);
  annotation(Inline=true, Documentation(revisions="<html>
<ul>
<li>
January 04, 2017, by Yannick Fuerst:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>This function converts the mass fraction <i>X</i> to the total humidity <i>x</i>.</p>
</html>"));
end massFractionToTotalHumidity;
