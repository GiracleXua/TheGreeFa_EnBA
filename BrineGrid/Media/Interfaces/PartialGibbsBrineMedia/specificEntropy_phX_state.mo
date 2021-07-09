within BrineGrid.Media.Interfaces.PartialGibbsBrineMedia;
function specificEntropy_phX_state
  "Returns specific entropy s as a function of pressure p, specific enthalpy h, composition X and the thermodynamic state record"
  extends Modelica.Icons.Function;
  input AbsolutePressure p "Pressure";
  input SpecificEnthalpy h "Specific Enthalpy";
  input MassFraction[nX] X "Composition";
  input ThermodynamicState state "Thermodynamic state";
  output SpecificEntropy s "Specific Entropy";
algorithm
  s := specificEntropy(state=state);
  annotation (
    Inline=false,
    LateInline=true,
    inverse(h=specificEnthalpy_psX_state(p=p, s=s, X=X, state=state)));
end specificEntropy_phX_state;
