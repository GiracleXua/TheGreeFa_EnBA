within BrineGrid.Media.LiquidDesiccants.LithiumBromideAqueousSolution_PatekKlomfar.Thermodynamics;
function d_der "Derivative of d with respect to time"
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
  output Real d_der(final unit="kg/(m3.s)")
    "Derivative of specific enthalpy with respect to time";
protected
  constant Real[6] b=Coefficients.b_d;
  constant Real[6] c=Coefficients.c_d;
  constant Real[2] a=Coefficients.a_d;
  constant Real[2] m=Coefficients.m_d;
  constant Real[2] t=Coefficients.t_d;
  constant Temperature T_crit=reference.criticalTemperature;
  constant Temperature T_ref=reference.referenceTemperature;
  constant MolarDensity d_crit=reference.criticalMolarDensity;
  MolarMass MM;
  DerDensityByTemperature ddT;
  Density ddY;
  Real dY_dX1;
  Real dY_dX2;
algorithm
  MM := molarMass_X(X=X);
  ddT := Thermodynamics.ddT(
    T=T,
    X=X);
  ddY := Thermodynamics.ddY(
    T=T,
    X=X);
  dY_dX1 := -1/MMX[Water]*(X[Water]/MMX[Water]
            + X[Desiccant]/MMX[Desiccant])^(-2)*X[Desiccant]/MMX[Desiccant];
  dY_dX2 := -1/MMX[Desiccant]*(X[Water]/MMX[Water]
            + X[Desiccant]/MMX[Desiccant])^(-2)*X[Desiccant]/MMX[Desiccant] + MM/MMX[Desiccant];
  d_der := T_der*ddT + X_der*{dY_dX1,dY_dX2}*ddY;
  annotation(smoothOrder=2);
end d_der;
