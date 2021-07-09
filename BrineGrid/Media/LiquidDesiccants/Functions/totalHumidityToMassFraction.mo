within BrineGrid.Media.LiquidDesiccants.Functions;
function totalHumidityToMassFraction
  extends Modelica.Icons.Function;
  input Modelica.SIunits.MassFraction x;
  output Modelica.SIunits.MassFraction X;
algorithm
  X := x/(1 + x);
  annotation(Inline=true, Documentation(revisions="<html>
<ul>
<li>
January 04, 2017, by Yannick Fuerst:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>This function converts the total humidity <i>x</i> to the mass fraction <i>X</i>.</p>
</html>"));
end totalHumidityToMassFraction;
