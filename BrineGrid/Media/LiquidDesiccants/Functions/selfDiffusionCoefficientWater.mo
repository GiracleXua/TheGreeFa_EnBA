within BrineGrid.Media.LiquidDesiccants.Functions;
function selfDiffusionCoefficientWater
  "Calculate the self diffusion coefficient of water"
  extends Modelica.Icons.Function;
  input Modelica.SIunits.Temperature T "Temperature";
  output Modelica.SIunits.DiffusionCoefficient D
    "Self diffusion coefficient of water";
protected
  constant Modelica.SIunits.DiffusionCoefficient D0=1.635e-8;
  constant Modelica.SIunits.Temperature Ts=215;
  constant Real gamma=2.063;
algorithm
  D := D0*((T/Ts) - 1)^gamma;
  annotation (Documentation(info="<html>
<p>This function returns the self diffusion coefficient of water <i>D</i> as a function of temperature <i>T</i>.</p>

<h4>References</h4>
<dl><dt>Conde, M.:</dt>
<dd><b>Aqueous solutions of lithium and calcium chlorides: Property formulations for use in air conditioning equipment design</b><br />
M. Conde Engineering, Zurich (2003)<br />
</dd>
</dl>
</html>", revisions="<html>
<ul>
<li>
January 04, 2017, by Yannick Fuerst:<br/>
First implementation.
</li>
</ul>
</html>"));
end selfDiffusionCoefficientWater;
