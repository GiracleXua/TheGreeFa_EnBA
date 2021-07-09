within BrineGrid.Media.Interfaces;
partial package PartialGibbsBrineMedia "Base class for brine media on the basis of a gibbs equation"
  extends BrineGrid.Media.Examples.PartialGeneralBrineMedia;
















  function density_pTX_state
    "Returns density d as a function of pressure p, temperature T, composition X and the thermodynamic state record"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input Temperature T "Temperature";
    input MassFraction[nX] X "Composition";
    input ThermodynamicState state "Thermodynamic state";
    output Density d "Density";
  algorithm
    d := density(state=state);
    annotation (
      Inline=false,
      LateInline=true,
      derivative(noDerivative=state)=density_pTX_der);
  end density_pTX_state;

  function density_phX_state
    "Returns density d as a function of pressure p, specific enthalpy h, composition X and the thermodynamic state record"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input SpecificEnthalpy h "Specific enthalpy";
    input MassFraction[nX] X "Composition";
    input ThermodynamicState state "Thermodynamic state";
    output Density d "Density";
  algorithm
    d := density(state=state);
    annotation (
      Inline=false,
      LateInline=true,
      derivative(noDerivative=state)=density_phX_der);
  end density_phX_state;








  redeclare replaceable partial model extends BaseProperties(
    p(stateSelect=if preferredMediumStates and (independentVariables ==
        IndependentVariables.phX or independentVariables ==
        IndependentVariables.pTX or independentVariables ==
        IndependentVariables.psX) then StateSelect.prefer else StateSelect.default),
    T(stateSelect=if preferredMediumStates and (independentVariables ==
        IndependentVariables.pTX) then StateSelect.prefer else StateSelect.default),
    h(stateSelect=if preferredMediumStates and (independentVariables ==
        IndependentVariables.phX) then StateSelect.prefer else StateSelect.default),
    Xi(each stateSelect=if preferredMediumStates then StateSelect.prefer else StateSelect.default),
    s(stateSelect=if preferredMediumStates and (independentVariables ==
        IndependentVariables.psX) then StateSelect.prefer else StateSelect.default))
    "Base properties of aqueous solution"
  end BaseProperties;

  redeclare function extends saturationPressure
    "Returns saturation pressure as a function of temperature T and composition X"
protected
    SaturationProperties sat;
  algorithm
    sat := setSat_TX(Tsat=Tsat, Xsat=Xsat);
    psat := sat.psat;
    annotation (
      Inline=true,
      inverse=saturationTemperature(psat=psat, Xsat=Xsat));
  end saturationPressure;

  replaceable partial function saturationPressure_der
    "Derivative of saturationPressure with respect to time"
    extends Modelica.Icons.Function;
    input Temperature Tsat "Saturation temperature";
    input MassFraction[nX] Xsat "Saturation composition";
    input SaturationProperties sat "Saturation property record";
    input Real Tsat_der(final unit="K/s")
    "Derivative of saturation temperature with respect to time";
    input Real[nX] Xsat_der(final unit="1/s")
    "Derivative to saturation composition with respect to time";
    output Real psat_der(unit="Pa/s")
    "Derivative of saturation pressure with respect to time";
  end saturationPressure_der;

  redeclare function extends saturationTemperature
    "Returns saturation temperature as a function of pressure p and composition X"
protected
    SaturationProperties sat;
  algorithm
    sat := setSat_pX(psat=psat, Xsat=Xsat);
    Tsat := sat.Tsat;
    annotation (
      Inline=true,
      inverse=saturationPressure(Tsat=Tsat, Xsat=Xsat));
  end saturationTemperature;

  replaceable partial function saturationTemperature_der
    "Derivative of saturationTemperature with respect to time"
    extends Modelica.Icons.Function;
    input AbsolutePressure psat "Saturation pressure";
    input MassFraction[nX] Xsat "Saturation composition";
    input SaturationProperties sat "Saturation property record";
    input Real psat_der(final unit="Pa/s")
    "Derivative of saturation pressure with respect to time";
    input Real[nX] Xsat_der(final unit="1/s")
    "Derivative to saturation composition with respect to time";
    output Real Tsat_der(unit="K/s")
    "Derivative of saturation temperature with respect to time";
  end saturationTemperature_der;

  redeclare function density_pTX
    "Returns density d as a function of pressure p, temperature T and composition X"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input Temperature T "Temperature";
    input MassFraction[nX] X "Composition";
    output Density d "Density";
  algorithm
    d := density_pTX_state(p=p, T=T, X=X, state=setState_pTX(p=p, T=T, X=X));
    annotation (Inline=true);
  end density_pTX;

  replaceable partial function density_pTX_der
    "Derivative of density_pTX with respect to time"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input Temperature T "Temperature";
    input MassFraction[nX] X "Composition";
    input ThermodynamicState state "Thermodynamic state";
    input Real p_der(final unit="Pa/s")
    "Derivative of pressure with respect to time";
    input Real T_der(final unit="K/s")
    "Derivative of temperature with respect to time";
    input Real[nX] X_der(final unit="1/s")
    "Derivative to composition with respect to time";
    output Real d_der(final unit="kg/(m3.s)")
    "Derivative of density with respect to time";
  end density_pTX_der;

  redeclare function density_phX
    "Returns density d as a function of pressure p, specific enthalpy h and composition X"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input SpecificEnthalpy h "Specific enthalpy";
    input MassFraction[nX] X "Composition";
    output Density d "Density";
  algorithm
    d := density_phX_state(p=p, h=h, X=X, state=setState_phX(p=p, h=h, X=X));
    annotation (Inline=true);
  end density_phX;

  replaceable partial function density_phX_der
    "Derivative of density_phX with respect to time"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input SpecificEnthalpy h "Specific enthalpy";
    input MassFraction[nX] X "Composition";
    input ThermodynamicState state "Thermodynamic state";
    input Real p_der(final unit="Pa/s")
    "Derivative of pressure with respect to time";
    input Real h_der(final unit="J/(kg.s)")
    "Derivative of temperature with respect to time";
    input Real[nX] X_der(final unit="1/s")
    "Derivative to composition with respect to time";
    output Real d_der(final unit="kg/(m3.s)")
    "Derivative of density with respect to time";
  end density_phX_der;

  replaceable partial function specificVolume_pTX_der
    "Derivative of specificVolume_pTX with respect to time"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input Temperature T "Temperature";
    input MassFraction[nX] X "Composition";
    //input ThermodynamicState state "Thermodynamic state";
    input Real p_der(final unit="Pa/s")
    "Derivative of pressure with respect to time";
    input Real T_der(final unit="K/s")
    "Derivative of temperature with respect to time";
    input Real[nX] X_der(final unit="1/s")
    "Derivative to composition with respect to time";
    output Real v_der(final unit="m3/(kg.s)")
    "Derivative of specific volume with respect to time";
  end specificVolume_pTX_der;

  replaceable partial function specificVolume_phX_der
    "Derivative of specificVolume_phX with respect to time"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input SpecificEnthalpy h "Specific enthalpy";
    input MassFraction[nX] X "Composition";
    //input ThermodynamicState state "Thermodynamic state";
    input Real p_der(final unit="Pa/s")
    "Derivative of pressure with respect to time";
    input Real h_der(final unit="J/(kg.s)")
    "Derivative of specific enthalpy with respect to time";
    input Real[nX] X_der(final unit="1/s")
    "Derivative to composition with respect to time";
    output Real v_der(final unit="m3/(kg.s)")
    "Derivative of specific volume with respect to time";
  end specificVolume_phX_der;

  redeclare function temperature_phX
    "Returns temperature T as a function of pressure p, specific enthalpy h and composition X"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input SpecificEnthalpy h "Specific enthalpy";
    input MassFraction[nX] X "Composition";
    output Temperature T "Temperature";
  algorithm
    T := temperature_phX_state(p=p, h=h, X=X, state=setState_phX(p=p, h=h, X=X));
    annotation (
      Inline=true,
      inverse(h=specificEnthalpy_pTX(p=p, T=T, X=X)));
  end temperature_phX;

  replaceable partial function temperature_phX_der
    "Derivative of temperature_phX with respect to time"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input SpecificEnthalpy h "Specific enthalpy";
    input MassFraction[nX] X "Composition";
    input ThermodynamicState state "Thermodynamic state";
    input Real p_der(final unit="Pa/s")
    "Derivative of pressure with respect to time";
    input Real h_der(final unit="J/(kg.s)")
    "Derivative of temperature with respect to time";
    input Real[nX] X_der(final unit="1/s")
    "Derivative to composition with respect to time";
    output Real T_der(final unit="K/s")
    "Derivative of temperature with respect to time";
  end temperature_phX_der;

  redeclare function temperature_psX
    "Returns temperature T as a function of pressure p, specific entropy s and composition X"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input SpecificEntropy s "Entropy";
    input MassFraction[nX] X "Composition";
    output Temperature T "Temperature";
  algorithm
    T := temperature_psX_state(p=p, s=s, X=X, state=setState_psX(p=p, s=s, X=X));
    annotation (
      Inline=true,
      inverse(s=specificEntropy_pTX(p=p, T=T, X=X)));
  end temperature_psX;

  redeclare function specificEnthalpy_pTX
    "Returns specific enthalpy h as a function of pressure p, temperature T and composition X"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input Temperature T "Temperature";
    input MassFraction[nX] X "Composition";
    output SpecificEnthalpy h "Specific enthalpy";
  algorithm
    h := specificEnthalpy_pTX_state(p=p, T=T, X=X, state=setState_pTX(p=p, T=T, X=X));
    annotation (
      Inline=true,
      inverse(T=temperature_phX(p=p, h=h, X=X)));
  end specificEnthalpy_pTX;

  replaceable partial function specificEnthalpy_pTX_der
    "Derivative of specificEnthalpy_pTX with respect to time"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input Temperature T "Temperature";
    input MassFraction[nX] X "Mass fractions of composition";
    input ThermodynamicState state "Thermodynamic state";
    input Real p_der(final unit="Pa/s")
    "Derivative of pressure with respect to time";
    input Real T_der(final unit="K/s")
    "Derivative of temperature with respect to time";
    input Real[nX] X_der(final unit="1/s")
    "Derivative to composition with respect to time";
    output Real h_der(final unit="J/(kg.s)")
    "Derivative of specific enthalpy with respect to time";
  end specificEnthalpy_pTX_der;

  redeclare function specificEnthalpy_psX
    "Returns specific enthalpy h as a function of pressure p, specific entropy s and composition X"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input SpecificEntropy s "Specific entropy";
    input MassFraction[nX] X "Composition";
    output SpecificEnthalpy h "specific enthalpy";
  algorithm
    h := specificEnthalpy_psX_state(p=p, s=s, X=X, state=setState_psX(p=p, s=s, X=X));
    annotation (
      Inline=true,
      inverse(s=specificEntropy_phX(p=p, h=h, X=X)));
  end specificEnthalpy_psX;

  redeclare function specificEntropy_pTX
    "Returns specific entropy s as a function of pressure p, temperature T and composition X"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input Temperature T "Temperature";
    input MassFraction[nX] X "Composition";
    output SpecificEntropy s "Specific entropy";
  algorithm
    s := specificEntropy_pTX_state(p=p, T=T, X=X, state=setState_pTX(p=p, T=T, X=X));
    annotation (
      Inline=true,
      inverse(T=temperature_psX(p=p, s=s, X=X)));
  end specificEntropy_pTX;

  replaceable partial function isothermalThrottlingCoefficient
    "Returns the isothermal throttling coeffcient (dh/dp)@T=const"
    extends Modelica.Icons.Function;
    input ThermodynamicState state "Thermodynamic state";
    output DerEnthalpyByPressure dhpT "Isothermal throttling coeffcient";
  end isothermalThrottlingCoefficient;

  replaceable partial function isenthalpicThrottlingCoefficient
    "Returns the isenthalpic throttling coeffcient (dT/dp)@h=const (Joule-Thomson coefficient)"
    extends Modelica.Icons.Function;
    input ThermodynamicState state "Thermodynamic state";
    output DerTemperatureByPressure dTph "Isenthalpic throttling coeffcient";
  end isenthalpicThrottlingCoefficient;

  annotation (Documentation(info="<html>
<p>This package contains all declarations for aqueous solutions based on the Gibbs energy equation. </p>
</html>",     revisions="<html>
<ul>
<li>
January 04, 2017, by Yannick Fuerst:<br/>
First implementation.
</li>
</ul>
</html>"));
end PartialGibbsBrineMedia;
