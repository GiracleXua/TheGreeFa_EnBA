within BrineGrid.Media.LiquidDesiccants.MagnesiumChlorideAqueousSolution.Thermodynamics;
function h "Calculate specific enthalpy h from temperature T and composition X"
  extends Modelica.Icons.Function;
  //input AbsolutePressure p "Pressure";
  input Temperature T "Temperature";
  input MassFraction[nX] X "Composition";
  output SpecificEnthalpy h "Specific enthalpy";

protected
  constant Real[6] k = Coefficients.h_coeff;

algorithm
  // equation by multi-variant-regression
  h := 1000*(k[1] + k[2]*T + k[3]*X[2] + k[4]*T^2 + T*X[2]*k[5] + k[6]*X[2]^2);
  annotation (
  smoothOrder=2,
    Inline=true,
    Documentation(info="<html>
<p>Specific enthalpy of aqueous magnesium chloride solution</p>
</html>"));
end h;
