within BrineGrid.Media.LiquidDesiccants.Functions;
function diffusionCoefficientWaterAir
  "Calculate the diffusion coefficient of water vapour in air"
  extends Modelica.Icons.Function;
  input Modelica.SIunits.Temperature T "Temperature";
  input Modelica.SIunits.AbsolutePressure p "Pressure";
  output Modelica.SIunits.DiffusionCoefficient D
    "Diffusion coefficient of water vapour in air";
algorithm
  D := 805/p/9.80665/3600*T^1.8/273.15 "in m^2/h; p in kp/m^2";
  annotation (Documentation(revisions="<html>
<ul>
<li>
January 04, 2017, by Yannick Fuerst:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>This function returns the diffusion coefficient of water vapor in air <i>D</i> as a function of temperature <i>T</i> and pressure <i>p</i>.

<h4>References</h4>

<dl><dt>Groeber, H., Erk, S., Grigull, U.:</dt>
<dd><b>Grundgesetze der Waermeuebertragung</b><br>
Springer Verlag, Ed. 3, Berlin (1988)
</dd></dl>
</html>"));
end diffusionCoefficientWaterAir;
