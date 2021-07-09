within BrineGrid.Media.Interfaces.PartialGibbsBrineMedia;
function specificEntropy_phX
  "Returns specific entropy s as a function of pressure p, specific enthalpy h and composition X"
  extends Modelica.Icons.Function;
  input AbsolutePressure p "Pressure";
  input SpecificEnthalpy h "Specific enthalpy";
  input MassFraction[nX] X "Composition";
  output SpecificEntropy s "Specific entropy";
algorithm
  s := specificEntropy_phX_state(p=p, h=h, X=X, state=setState_phX(p=p, h=h, X=X));
  annotation (
    Inline=true,
    inverse(h=specificEnthalpy_psX(p=p, s=s, X=X)));
end specificEntropy_phX;
