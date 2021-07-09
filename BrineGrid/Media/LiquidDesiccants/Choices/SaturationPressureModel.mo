within BrineGrid.Media.LiquidDesiccants.Choices;
type SaturationPressureModel = enumeration(
    PatekKlomfar "default",
    Conde,
    Patil,
    Kink) annotation (Documentation(revisions="<html>
<ul>
<li>
January 04, 2017, by Yannick Fuerst:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>Enumeration to select the model for the calculation of the saturation pressure.</p>
</html>"));
