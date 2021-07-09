within BrineGrid.Media.Interfaces.PartialGibbsBrineMedia;
function temperature_psX_state
  "Returns temperature T as a function of pressure p, specific entropy s, composition X and the thermodynamic state record"
  extends Modelica.Icons.Function;
  input AbsolutePressure p "Pressure";
  input SpecificEntropy s "Entropy";
  input MassFraction[nX] X "Composition";
  input ThermodynamicState state "Thermodynamic state";
  output Temperature T "Temperature";
algorithm
  T := temperature(state=state);
  annotation (
    Inline=false,
    LateInline=true,
    inverse(s=specificEntropy_pTX_state(p=p, T=T, X=X, state=state)));
end temperature_psX_state;
