within BrineGrid.Media.LiquidDesiccants.MagnesiumChlorideAqueousSolution.Thermodynamics;
function h_der "Derivative of h with respect to time"
  extends Modelica.Icons.Function;
  //input AbsolutePressure p "Pressure";
  input Temperature T "Temperature";
  input MassFraction[nX] X "Mass fractions of composition";
  //input Real p_der(final unit="Pa/s")
  //  "Derivative of pressure with respect to time";
  input Real T_der(final unit="K/s")
    "Derivative of temperature with respect to time";
  input Real[nX] X_der(final unit="1/s")
    "Derivative to composition with respect to time";
  output Real h_der(final unit="J/(kg.s)")
    "Derivative of specific enthalpy with respect to time";
protected
  constant Temperature T_crit=reference.criticalTemperature;
  constant Temperature T_ref=reference.referenceTemperature;
  constant MolarEnthalpy h_crit=reference.criticalMolarEnthalpy;
  MolarMass MM;
  DerEnthalpyByTemperature dhT;
  SpecificEnthalpy dhY;
  Real dY_dX1;
  Real dY_dX2;
algorithm
  MM := molarMass_X(X=X);
  dhT := Thermodynamics.dhT(
    T=T,
    X=X);
  dhY := Thermodynamics.dhY(
    T=T,
    X=X);
  dY_dX1 := -1/MMX[Water]*(X[Water]/MMX[Water]
            + X[Desiccant]/MMX[Desiccant])^(-2)*X[Desiccant]/MMX[Desiccant];
  dY_dX2 := -1/MMX[Desiccant]*(X[Water]/MMX[Water]
            + X[Desiccant]/MMX[Desiccant])^(-2)*X[Desiccant]/MMX[Desiccant] + MM/MMX[Desiccant];
  h_der := T_der*dhT + X_der*{dY_dX1,dY_dX2}*dhY;
    annotation(Inline=true, smoothOrder=2);
end h_der;
