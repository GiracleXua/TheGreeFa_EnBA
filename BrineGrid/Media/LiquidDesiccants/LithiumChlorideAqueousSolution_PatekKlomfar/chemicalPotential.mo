within BrineGrid.Media.LiquidDesiccants.LithiumChlorideAqueousSolution_PatekKlomfar;
function chemicalPotential
  "Return the chemical potential of water in the solution as a function of the thermodynamic state record"
  extends Modelica.Icons.Function;
  input ThermodynamicState state "Thermodynamic state record";
  output SpecificEnergy mu "Chemcial potential";
protected
  MolarMass MM=molarMass_X(state.X);
algorithm
  mu := Thermodynamics.mu(p=state.p, T=state.T, X=state.X)/MM;
  annotation (Inline=true);
end chemicalPotential;
