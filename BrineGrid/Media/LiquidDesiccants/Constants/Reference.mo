within BrineGrid.Media.LiquidDesiccants.Constants;
record Reference "Reference values of water"
  extends Modelica.Icons.Record;
  constant Types.Temperature criticalTemperature = 647.096;
  constant Types.AbsolutePressure criticalPressure = 220.64e5;
  constant Modelica.SIunits.MolarDensity criticalMolarDensity = 17.874e3;
  constant Modelica.SIunits.MolarEnthalpy criticalMolarEnthalpy = 37.5485e3;
  constant Modelica.SIunits.MolarEntropy criticalMolarEntropy = 79.3933;
  // Triple point of pure water
  constant Types.Temperature triplePointTemperature = 273.16;
  constant Types.AbsolutePressure triplePointPressure = 611.657;
  constant Modelica.SIunits.MolarDensity triplePointMolarDensity = 55.4968e-3;
  constant Modelica.SIunits.MolarHeatCapacity triplePointMolarHeatCapacity = 760.226e-1;
  // Reference values
  constant Types.Temperature referenceTemperature = 221;
  annotation (Documentation(info="<html>
<p>Reference values of water used in the calculation of the thermodynamic properties of liquid desiccants.</p>
</html>", revisions="<html>
<ul>
<li>
January 04, 2017, by Yannick Fuerst:<br/>
First implementation.
</li>
</ul>
</html>"));
end Reference;
