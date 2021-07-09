within BrineGrid.Media.Interfaces.PartialGibbsBrineMedia;
function temperature_phX_state
  "Returns temperature T as a function of pressure p, specific enthalpy h, composition X and the thermodynamic state record"
  extends Modelica.Icons.Function;
  input AbsolutePressure p "Pressure";
  input SpecificEnthalpy h "Specific enthalpy";
  input MassFraction[nX] X "Composition";
  input ThermodynamicState state "Thermodynamic state";
  output Temperature T "Temperature";
algorithm
  T := temperature(state=state);
  annotation (
    Inline=false,
    LateInline=true,
    inverse(h=specificEnthalpy_pTX_state(p=p, T=T, X=X, state=state)),
    derivative(noDerivative=state)=temperature_phX_der);
end temperature_phX_state;
