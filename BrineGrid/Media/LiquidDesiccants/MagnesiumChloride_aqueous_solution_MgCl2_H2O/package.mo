within BrineGrid.Media.LiquidDesiccants;
package MagnesiumChloride_aqueous_solution_MgCl2_H2O "H2O-LiBr: Lithium bromide aqueous solution (273 K ... 500 K, 0 wt-% ... 75 wt-%)"

  extends BrineGrid.Media.Examples.PartialGeneralBrineMedia(
    final ThermoStates=Modelica.Media.Interfaces.Choices.IndependentVariables.pTX,
    final mediumName="aqueous lithium bromide solution",
    final substanceNames={"water", "lithium bromide"},
    final MMX={Modelica.Media.IdealGases.Common.SingleGasesData.H2O.MM,Modelica.Media.IdealGases.Common.SingleGasesData.MgCL2.MM},
    final RX={Modelica.Media.IdealGases.Common.SingleGasesData.H2O.R,Modelica.Media.IdealGases.Common.SingleGasesData.MgCL2.R},
    final reference_X=X_init,
    final reference_T=T_init,
    final reference_p=p_init,
    final fluidLimits(
     TMIN=238.15,
     TMAX= 450,
      DMIN=Modelica.Constants.small,
      DMAX=1e5,
      PMIN=Modelica.Constants.small,
      PMAX=10e5,
      HMIN=-1e10,
      HMAX=1e10,
      SMIN=-1e7,
      SMAX=1e7),
    final XMIN=0,
    final XMAX=0.6,
    p_init=101325.0,
    T_init=300.0,
    X_init={0.792726, 0.207274},
    h_init=70654.0,
    d_init=1083.78,
     s_init=374.718);        //475,

  redeclare model extends BaseProperties(
    p(stateSelect=if preferredMediumStates then StateSelect.prefer else StateSelect.default),
    T(stateSelect=if preferredMediumStates then StateSelect.prefer else StateSelect.default),
    Xi(each stateSelect=if preferredMediumStates then StateSelect.prefer else StateSelect.default))
    "Base properties of lithium bromide aqueous solution"
  equation
    d = Thermodynamics.d(T=T, X=X);
    h = Thermodynamics.h(T=T, X=X);
    s =Thermodynamics.s(T=T, X=X);
    u = Thermodynamics.u(p=p, T=T, X=X);
  end BaseProperties;

  redeclare function setState_pTX
    "Return thermodynamic state as a function of pressure p, temperature T and composition X"
     extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input Temperature T "Temperature";
    input MassFraction X[:] "Composition";
    output ThermodynamicState state "Thermodynamic state record";
protected
    MassFraction[nX] Xfull=if size(X, 1) == nX then X else cat(
        1,
        X,
        {1 - sum(X)});
  algorithm
    state.p := p;
    state.T := T;
    state.X := Xfull;
    state.h := Thermodynamics.h(T=T, X=Xfull);
  //  state.cp := Thermodynamics.cp(T=T, X=Xfull);
    state.u := Thermodynamics.u(p=p, T=T, X=Xfull);
    state.s :=Thermodynamics.s(T=T, X=Xfull);
    state.d := Thermodynamics.d(T=T, X=Xfull);
  end setState_pTX;

  redeclare function setState_dTX
    "Return thermodynamic state as a function of density d, temperature T and composition X"
    extends Modelica.Icons.Function;
    input Density d "Density";
    input Temperature T "Temperature";
    input MassFraction X[:] "Composition";
    output ThermodynamicState state "Thermodynamic state record";
  algorithm
    assert(false, "setState_dTX: Pressure can not be computed from temperature and density for an incompressible fluid!");
  end setState_dTX;

  redeclare function setState_phX
    "Return thermodynamic state as a function of pressure p, specific enthalpy h and composition X"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input SpecificEnthalpy h "Specific enthalpy";
    input MassFraction X[:] "Composition";
    output ThermodynamicState state "Thermodynamic state record";
protected
    MassFraction[nX] Xfull=if size(X, 1) == nX then X else cat(
        1,
        X,
        {1 - sum(X)});
    Temperature T;
  algorithm
    T := Thermodynamics.T(h=h, X=Xfull);
    state.p := p;
    state.X := Xfull;
    state.T := T;
    state.h := Thermodynamics.h(T=T, X=Xfull);
    state.u := Thermodynamics.u(p=p, T=T, X=Xfull);
    state.s :=Thermodynamics.s(T=T, X=Xfull);
    state.d := Thermodynamics.d(T=T, X=Xfull);
  end setState_phX;

  redeclare function setState_psX
    "Return thermodynamic state as a function of pressure p, specific entropy s and composition X"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input SpecificEntropy s "Specific entropy";
    input MassFraction X[:] "Composition";
    output ThermodynamicState state "Thermodynamic state record";
  algorithm
    assert(false, "setState_psX is not used in this medium model");
  end setState_psX;

  redeclare function extends setSat_TX
    "Return saturation property record from temperature and composition"
  extends Modelica.Icons.Function;
  algorithm
    sat.Tsat := Tsat;
    sat.psat := Ancillary.saturationPressure(Tsat=Tsat, Xsat=Xfull);
    sat.Xsat := Xfull;
  end setSat_TX;

  redeclare function extends setSat_pX
  "Return saturation property record from pressure and composition"
  algorithm
    sat.Tsat := Ancillary.saturationTemperature(psat=psat, Xsat=Xfull);
    sat.psat := psat;
    sat.Xsat := Xfull;
  end setSat_pX;

  redeclare function extends specificHeatCapacityCp
    "Return specific heat capacity at constant pressure of an aqueous solution as a function of the thermodynamic state record"
  algorithm
    cp := Thermodynamics.cp(T=state.T, X=state.X);
    annotation (Inline=true);
  end specificHeatCapacityCp;

  redeclare function extends dynamicViscosity
    "Return dynamic viscosity as a function of the thermodynamic state record"
  algorithm
    eta := Ancillary.dynamicViscosity(T=state.T, X=state.X);
  end dynamicViscosity;

  redeclare function extends thermalConductivity
    "Return thermal conductivity as a function of the thermodynamic state record"
protected
    constant Real[3] a={-1.46741e-2,11.0513,-1407.53};
    constant Real[3] b={3.48073e-4,-0.240475,38.9855};
    constant Real[3] c={-2.32262e-6,1.51915e-3,-0.265025};
    Real poly1;
    Real poly2;
    Real poly3;
  algorithm
    poly1 := a[1];
    poly2 := b[1];
    poly3 := c[1];
    for i in 2:size(a, 1) loop
      poly1 := poly1*state.T + a[i];
      poly2 := poly2*state.T + b[i];
      poly3 := poly3*state.T + c[i];
    end for;
    lambda := (poly1 + poly2*(state.X[Desiccant]*100) + poly3*(state.X[Desiccant]*100)^2)/1000;
    annotation (smoothOrder=2);
  end thermalConductivity;

  redeclare function extends saturationPressure
    "Returns saturation pressure as a function of temperature T and composition X"
  algorithm
    psat := Ancillary.saturationPressure(Tsat=Tsat, Xsat=Xsat);
    annotation (
      Inline=true,
      inverse=saturationTemperature(psat=psat, Xsat=Xsat));
  end saturationPressure;

  redeclare function extends saturationTemperature
    "Returns saturation temperature as a function of pressure p and composition X"
  algorithm
    Tsat := Ancillary.saturationTemperature(psat=psat, Xsat=Xsat);
    annotation (
      Inline=true,
      inverse=saturationPressure(Tsat=Tsat, Xsat=Xsat));
  end saturationTemperature;

  annotation (Documentation(info="<html>
  <p>This model allows the calculation of fluid properties of Magnesium chloride 
aqueous solution (MgCl2-H2O). </p>

<p>The thermodynamic properties do not only depend on the pressure and temperature,
but mostly on the composition. This medium model is based on the thermal, caloric
and entropy equations of state.</p>

<h4>Notes</h4>
<p>The derivatives of some thermodynamic functions are not yet implemented, e.g. <code>saturationPressure_TX</code>
or <code>saturationTemperature_pX</code>.</p>

<h4>References</h4>

<dl><dt>Delivrable D23 of H_DisNet poject, funded by the European Commission in the Horizon 2020 program under grant no. 695780:</dt>
</dd></dl>
</html>",     revisions="<html>
<ul>
<li>
January 15, 2018, by Muhannad Delwati:<br/>
First implementation.
</li>
</ul>
</html>"));
end MagnesiumChloride_aqueous_solution_MgCl2_H2O;
