within BrineGrid.Media.Interfaces.PartialGeneralBrineMedia;
function molarMass_X
  "Return molar mass of mixture as a function from mass composition X"
  extends Modelica.Icons.Function;
  input Modelica.SIunits.MassFraction[nX] X "Mass fractions of mixture";
  output Modelica.SIunits.MolarMass MM "Molar mass of mixture";
algorithm
  MM := 1/sum(X[i]/MMX[i] for i in 1:nX);
  annotation (Inline=true);
end molarMass_X;
