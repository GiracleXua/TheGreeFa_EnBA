within BrineGrid.Media.Interfaces.PartialGibbsBrineMedia;
function specificEntropy_pTX_state
  "Returns specific entropy s as a function of pressure p, temperature T, composition X and the thermodynamic state record"
  extends Modelica.Icons.Function;
  input AbsolutePressure p "Pressure";
  input Temperature T "Temperature";
  input MassFraction[nX] X "Composition";
  input ThermodynamicState state "Thermodynamic state";
  output SpecificEntropy s "Specific entropy";
algorithm
  s := specificEntropy(state=state);
  annotation (
    Inline=false,
    LateInline=true,
    inverse(T=temperature_psX_state(p=p, s=s, X=X, state=state)));
end specificEntropy_pTX_state;
