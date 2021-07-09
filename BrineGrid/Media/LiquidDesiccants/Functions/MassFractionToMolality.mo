within BrineGrid.Media.LiquidDesiccants.Functions;
function MassFractionToMolality
  "Converts Mass Fraction (kg_solute/kg_overall) to Molality (mol_solute/kg_solvent)"

  extends Modelica.Icons.Function;
  input Modelica.SIunits.MassFraction X[2] "mass fraction vector (solvent,solute)";
  input Modelica.SIunits.MolarMass MMX[2] "molar mass vector of solution";
  output BrineGrid.Media.LiquidDesiccants.Types.Molality b "molality vector of solute(s)";

algorithm
  //for i in 1:size(b,1) loop
  b :=X[2]/((1-X[2])*MMX[2]);
  //end for;
annotation(Inline=true, Documentation(revisions="<html>
<ul>
<li>
January 09, 2019, by Christian Flessner:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>This function converts mass fraction <i>X</i> to molality <i>b</i> (moles of solute per mass of solvent in mol/kg).</p>
<p>Currently only for binary mixtures.</p>
</html>"));
end MassFractionToMolality;
