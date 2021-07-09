within BrineGrid.Media.LiquidDesiccants.Functions;
function MolarEnthalpyToSpecificEnthalpy "Converts molar enthalpy to specific enthalpy"
  extends Modelica.Icons.Function;
  input Modelica.SIunits.MolarEnthalpy h_molar;
  input Modelica.SIunits.MolarMass MMX[2];
  input Modelica.SIunits.MoleFraction Y[2];
  output Modelica.SIunits.SpecificEnthalpy h;
algorithm
  h := h_molar*MMX[2]/(Y*MMX);

end MolarEnthalpyToSpecificEnthalpy;
