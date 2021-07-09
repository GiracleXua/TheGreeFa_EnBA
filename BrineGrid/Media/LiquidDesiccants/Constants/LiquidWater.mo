within BrineGrid.Media.LiquidDesiccants.Constants;
record LiquidWater
  "Constants for calculation of molar gibbs energy of liquid water"
  extends Modelica.Icons.Record;
  final constant Real[13] n={0, 0, 1, 0, -1, -2, -3, -4, 1, 0, -1, -2, -3};
  final constant Real[13] m={0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1};
  final constant Real[13] a={0, 5.88137e1, -9.18938, -8.33307e1, 1.84228e2, -1.70534e2, 1.05457e2, -2.94856e1, 1.96926e-1, -8.68008e-1, 2.25497, -2.60177, 1.17349};
  annotation (Documentation(info="<html>
<p>Constants used for the calculation of the thermodynamic properties of liquid water.</p>
</html>",
        revisions="<html>
<ul>
<li>
January 04, 2017, by Yannick Fuerst:<br/>
First implementation.
</li>
</ul>
</html>"));
end LiquidWater;
