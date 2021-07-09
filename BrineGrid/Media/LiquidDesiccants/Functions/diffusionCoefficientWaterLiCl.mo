within BrineGrid.Media.LiquidDesiccants.Functions;
function diffusionCoefficientWaterLiCl
  "Calculate the diffusion coefficient of water in LiCl solution"
  extends Modelica.Icons.Function;
  input Modelica.SIunits.Temperature T "Temperature";
  input Modelica.SIunits.MassFraction X "Mass fraction of solvate";
  output Modelica.SIunits.DiffusionCoefficient D
    "Diffusion coefficient of water vapour in LiCl solution";
protected
  constant Real[3] delta={0.52, -4.92, -0.56};
  Modelica.SIunits.DiffusionCoefficient DH20
    "Self-diffusion coefficient of water";
algorithm
  DH20 := selfDiffusionCoefficientWater(T=T);
  D := DH20*(1 - (1 + (sqrt(X)/delta[1])^delta[2])^delta[3]);
  annotation (Documentation(info="<html>
<p>This function returns the diffusion coefficient of water in aqueous lithium chloride solution <i>D</i> as a function of temperature <i>T</i> and composition <i>X</i>.</p>

<h4>References</h4>

<dl><dt> Holz, M., Heil, S. R., Sacco, A.:</dt>
<dd> <b>Temperature-dependent self-diffusion coefficients of water and six selected molecular liquids for calibration in accurate H NMR PFG measurements</b><br />
Physical Chemistry Chemical Physics 20, p. 4740-4742 (2000)<br />
DOI: <a href=\"http://dx.doi.org/10.1039/b005319h\">10.1039/b005319h</a>
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
end diffusionCoefficientWaterLiCl;
