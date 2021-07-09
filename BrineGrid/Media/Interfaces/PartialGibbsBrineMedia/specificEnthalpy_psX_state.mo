within BrineGrid.Media.Interfaces.PartialGibbsBrineMedia;
function specificEnthalpy_psX_state
  "Returns specific enthalpy h as a function of pressure p, specific entropy s and composition X"
  extends Modelica.Icons.Function;
  input AbsolutePressure p "Pressure";
  input SpecificEntropy s "Specific entropy";
  input MassFraction[nX] X "Composition";
  input ThermodynamicState state "Thermodynamic state";
  output SpecificEnthalpy h "specific enthalpy";
algorithm
  h := specificEnthalpy(state=state);
  annotation (
    Inline=false,
    LateInline=true,
    inverse(s=specificEntropy_phX_state(p=p, h=h, X=X, state=state)));
end specificEnthalpy_psX_state;
