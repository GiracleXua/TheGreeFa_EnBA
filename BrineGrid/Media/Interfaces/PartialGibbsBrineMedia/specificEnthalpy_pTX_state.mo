within BrineGrid.Media.Interfaces.PartialGibbsBrineMedia;
function specificEnthalpy_pTX_state
  "Returns specific enthalpy h as a function of pressure p, temperature T, composition X and the thermodynamic state record"
  extends Modelica.Icons.Function;
  input AbsolutePressure p "Pressure";
  input Temperature T "Temperature";
  input MassFraction[nX] X "Composition";
  input ThermodynamicState state "Thermodynamic state";
  output SpecificEnthalpy h "Specific enthalpy";
algorithm
  h := specificEnthalpy(state=state);
  annotation (
    Inline=false,
    LateInline=true,
    inverse(T=temperature_phX_state(p=p, h=h, X=X, state=state)),
    derivative(noDerivative=state)=specificEnthalpy_pTX_der);
end specificEnthalpy_pTX_state;
