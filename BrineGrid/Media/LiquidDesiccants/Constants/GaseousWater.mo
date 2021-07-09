within BrineGrid.Media.LiquidDesiccants.Constants;
record GaseousWater
  "Constants for calculation of molar gibbs energy of gaseous water"
  extends Modelica.Icons.Record;
  final constant Real[9] n={0, 0, 1, 0, -3, 6, 7, 8, 15};
  final constant Real[9] m={0, 0, 0, 0, 0, 1, 1, 1, 3};
  final constant Real[9] a={1.0, 3.98432, 6.68909, -8.78439, -5.18911e-2, -6.25248e-1, 5.07144e-1, -1.24364e-1, -4.49013e-1};
  annotation (Documentation(info="<html>
<p>Constants used for the calculation of the thermodynamic properties of gaseous water.</p>
</html>",
        revisions="<html>
<ul>
<li>
January 04, 2017, by Yannick Fuerst:<br/>
First implementation.
</li>
</ul>
</html>"));
end GaseousWater;
