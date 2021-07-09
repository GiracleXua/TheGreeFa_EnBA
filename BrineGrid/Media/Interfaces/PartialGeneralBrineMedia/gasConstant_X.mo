within BrineGrid.Media.Interfaces.PartialGeneralBrineMedia;
function gasConstant_X
  "Return the gas constant of the mixture as a function from composition X"
  extends Modelica.Icons.Function;
  input MassFraction[nX] X "Mass fractions of composition";
  output SpecificHeatCapacity R "Mixture gas constant";
algorithm
  R := sum(RX[i]*X[i] for i in 1:nX);
  annotation(Inline=true);
end gasConstant_X;
