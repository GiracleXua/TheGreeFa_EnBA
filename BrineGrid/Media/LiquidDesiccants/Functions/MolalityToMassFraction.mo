within BrineGrid.Media.LiquidDesiccants.Functions;
function MolalityToMassFraction
  "Converts Molality (mol_solute/kg_solvent) to Mass Fraction (kg_solute/kg_overall)"

  extends Modelica.Icons.Function;
  input BrineGrid.Media.LiquidDesiccants.Types.Molality b "molality vector of solute(s)";
  input Modelica.SIunits.MolarMass MMX[2] "molar mass vector of solution";
  output Modelica.SIunits.MassFraction X[2] "mass fraction vector (solvent,solute)";

algorithm
  //for i in 1:size(b,1) loop
  X[2] :=  b*MMX[2]/(1+b*MMX[2]);
  X[1] := 1-X[2];
  //end for;
  //assert(sum(X) == 1, "the element of solution is not complete");
  annotation(Inline=true, Documentation(revisions="<html>
<ul>
<li>
January 09, 2019, by Christian Flessner:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>This function converts molality <i>b</i> (moles of solute per mass of solvent in mol/kg) to mass fraction <i>X</i>.</p>
<p>Currently only for binary mixtures.</p>
</html>"));
end MolalityToMassFraction;
