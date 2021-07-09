within BrineGrid.Media.LiquidDesiccants;
package LithiumChlorideAqueousSolution_PatekKlomfar "H2O-LiCl: Lithium chloride aqueous solution (273 K ... 400 K, 0 wt-% ... 50 wt-%)"
   extends Interfaces.PartialGibbsBrineMedia(
    final ThermoStates=Modelica.Media.Interfaces.Choices.IndependentVariables.pTX,
    final mediumName="aqueous lithium chloride solution",
    final substanceNames={"water", "lithium chloride"},
    final MMX={Modelica.Media.IdealGases.Common.SingleGasesData.H2O.MM,Modelica.Media.IdealGases.Common.SingleGasesData.LiCL.MM},
    final RX={Modelica.Media.IdealGases.Common.SingleGasesData.H2O.R,Modelica.Media.IdealGases.Common.SingleGasesData.LiCL.R},
    final reference_X=X_init,
    final reference_T=T_init,
    final reference_p=p_init,
    final fluidLimits(
      TMIN=273.16,
      TMAX=400,
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
    h_init=74194.6,
    d_init=1118.06,
    s_init=346.46);







  constant SaturationPressureModel saturationPressureModel=
    SaturationPressureModel.PatekKlomfar
    "Default choice of source for saturation pressure computations";

  redeclare model extends BaseProperties
    "Base properties of lithium chloride aqueous solution"
  equation
    if (independentVariables == IndependentVariables.phX) then
      d = density_phX(p=p, h=h, X=X);
      T = temperature_phX(p=p, h=h, X=X);
      s = specificEntropy_phX(p=p, h=h, X=X);
      //v = specificVolume_phX(p=p, h=h, X=X);
    elseif (independentVariables == IndependentVariables.psX) then
      d = density_psX(p=p, s=s, X=X);
      //v = specificVolume_psX(p=p, s=s, X=X);
      T = temperature_psX(p=p, s=s, X=X);
      h = specificEnthalpy_psX(p=p, s=s, X=X);
    elseif (independentVariables == IndependentVariables.pTX) then
      d = density_pTX(p=p, T=T, X=X);
      h = specificEnthalpy_pTX(p=p, T=T, X=X);
      s = specificEntropy_pTX(p=p, T=T, X=X);
      //v = specificVolume_pTX(p=p, T=T, X=X);
    else
      assert(false, "Invalid choice of independent variables.");
    end if;
    u = h - p/d;
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
    Thermodynamics.GibbsDerivs g;
  algorithm
    state.p := p;
    state.T := T;
    state.X := Xfull;
    g := Thermodynamics.setGibbsDerivsFirst(
      p=p,
      T=T,
      X=Xfull);
    state.h := Thermodynamics.h(g);
    state.u := Thermodynamics.u(g);
    state.s := Thermodynamics.s(g);
    state.d := Thermodynamics.d(g);
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
    Thermodynamics.GibbsDerivs g;
    Temperature T_min;
    Temperature T_max;
    Temperature T_iter;
    SpecificEnthalpy RES_h;
    SpecificEnthalpy RES_min;
    SpecificEnthalpy RES_max;
    DerEnthalpyByTemperature dhTp "(dh/dT)@p=const";
    Integer iter=0;
    constant Temperature T_crit=reference.criticalTemperature;
    constant AbsolutePressure p_crit=reference.criticalPressure;
    constant Real tolerance=1e-9 "Relative tolerance for RES_h";
    constant Integer iter_max=200;
  algorithm
    //Modelica.Utilities.Files.remove("debug.txt");
    //Modelica.Utilities.Streams.print(" ", "debug.txt");
    //Modelica.Utilities.Streams.print("LiCl: setState_phX input was p=" + String(p) + ", h=" + String(h) + " and X={" + String(Xfull[Water]) + ", " + String(Xfull[Desiccant]) + "}", "debug.txt");
    T_min := 0.99*fluidLimits.TMIN;
    T_max := 1.01*fluidLimits.TMAX;
    T_iter := (T_min + T_max)/2;
    // min
    g := Thermodynamics.setGibbsDerivsFirst(
      p=p,
      T=T_min,
      X=Xfull);
    RES_min := Thermodynamics.h(g) - h;
    // max
    g := Thermodynamics.setGibbsDerivsFirst(
      p=p,
      T=T_max,
      X=Xfull);
    RES_max := Thermodynamics.h(g) - h;
    // iter
    g := Thermodynamics.setGibbsDerivsFirst(
      p=p,
      T=T_iter,
      X=Xfull);
    RES_h := Thermodynamics.h(g) - h;
    assert((RES_min*RES_max < 0), "setState_phX: h_min and h_max did not bracket the root", level=AssertionLevel.warning);
    // thighten the bounds
    if (RES_h*RES_min < 0) then
      T_max := T_iter;
      RES_max := RES_h;
    elseif (RES_h*RES_max < 0) then
      T_min := T_iter;
      RES_min := RES_h;
    end if;
    while ((abs(RES_h/h) > tolerance) and (iter < iter_max)) loop
      iter := iter + 1;
      g := Thermodynamics.setGibbsDerivsSecond(
        p=p,
        T=T_iter,
        X=Xfull);
      dhTp := Thermodynamics.dhTp(g);
      T_iter := T_iter - RES_h/dhTp;
      if (T_iter < T_min) or (T_iter > T_max) then
        //Modelica.Utilities.Streams.print("T_iter out of bounds, fallback to bisection method, step=" + String(iter) + ", T_iter=" + String(T_iter) + ", input was p=" + String(p) + ", h=" + String(h) + " and X={" + String(Xfull[Water]) + ", " + String(Xfull[Desiccant]) + "}", "printlog.txt");
        T_iter := (T_min + T_max)/2;
      end if;
      g := Thermodynamics.setGibbsDerivsFirst(
        p=p,
        T=T_iter,
        X=Xfull);
      RES_h := Thermodynamics.h(g) - h;
      // thighten the bounds
      if (RES_h*RES_min < 0) then
        T_max := T_iter;
        RES_max := RES_h;
      elseif (RES_h*RES_max < 0) then
        T_min := T_iter;
        RES_min := RES_h;
      end if;
      //Modelica.Utilities.Streams.print("T_min=" + String(T_min) + ", T_max=" + String(T_max) + " and T_iter=" + String(T_iter), "printlog.txt");
    end while;
    //Modelica.Utilities.Streams.print("setState_phX required " + String(iter) + " iterations to find T=" + String(T_iter) + " for input p=" + String(p) + ", h=" + String(h) + " and X={" + String(Xfull[Water]) + ", " + String(Xfull[Desiccant]) + "}", "printlog.txt");
    assert(iter < iter_max, "setState_phX did not converge, input was p="
      + String(p) + ", h=" + String(h) + " and X={" + String(Xfull[Water])
      + ", " + String(Xfull[Desiccant]) + "}");
    state.p := p;
    state.h := h;
    state.X := Xfull;
    state.T := T_iter;
    state.s := Thermodynamics.s(g);
    state.u := Thermodynamics.u(g);
    state.d := Thermodynamics.d(g);
  end setState_phX;

  redeclare function setState_psX
    "Return thermodynamic state as a function of pressure p, specific entropy s and composition X"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input SpecificEntropy s "Specific entropy";
    input MassFraction X[:] "Composition";
    output ThermodynamicState state "Thermodynamic state record";
protected
    MassFraction[nX] Xfull=if size(X, 1) == nX then X else cat(
        1,
        X,
        {1 - sum(X)});
    Thermodynamics.GibbsDerivs g;
    Temperature T_min;
    Temperature T_max;
    Temperature T_iter;
    SpecificEntropy RES_s;
    SpecificEntropy RES_min;
    SpecificEntropy RES_max;
    DerEntropyByTemperature dsTp "(ds/dT)@p=const";
    Integer iter=0;
    constant Temperature T_crit=reference.criticalTemperature;
    constant AbsolutePressure p_crit=reference.criticalPressure;
    constant Real tolerance=1e-9 "Relative tolerance for RES_s";
    constant Integer iter_max=200;
  algorithm
    //Modelica.Utilities.Files.remove("debug.txt");
    //Modelica.Utilities.Streams.print(" ", "debug.txt");
    //Modelica.Utilities.Streams.print("LiCl: setState_psX input was p=" + String(p) + ", s=" + String(s) + " and X={" + String(Xfull[Water]) + ", " + String(Xfull[Desiccant]) + "}", "debug.txt");
    T_min := 0.99*fluidLimits.TMIN;
    T_max := 1.01*fluidLimits.TMAX;
    T_iter := (T_min + T_max)/2;
    // min
    g := Thermodynamics.setGibbsDerivsFirst(
      p=p,
      T=T_min,
      X=Xfull);
    RES_min := Thermodynamics.s(g) - s;
    // max
    g := Thermodynamics.setGibbsDerivsFirst(
      p=p,
      T=T_max,
      X=Xfull);
    RES_max := Thermodynamics.s(g) - s;
    // iter
    g := Thermodynamics.setGibbsDerivsFirst(
      p=p,
      T=T_iter,
      X=Xfull);
    RES_s := Thermodynamics.s(g) - s;
    assert((RES_min*RES_max < 0), "setState_psX: s_min and s_max did not bracket the root", level=AssertionLevel.warning);
    // thighten the bounds
    if (RES_s*RES_min < 0) then
      T_max := T_iter;
      RES_max := RES_s;
    elseif (RES_s*RES_max < 0) then
      T_min := T_iter;
      RES_min := RES_s;
    end if;
    while ((abs(RES_s/s) > tolerance) and (iter < iter_max)) loop
      iter := iter + 1;
      g := Thermodynamics.setGibbsDerivsSecond(
        p=p,
        T=T_iter,
        X=Xfull);
      dsTp := Thermodynamics.dsTp(g);
      T_iter := T_iter - RES_s/dsTp;
      if (T_iter < T_min) or (T_iter > T_max) then
        //Modelica.Utilities.Streams.print("T_iter out of bounds, fallback to bisection method, step=" + String(iter) + ", T_iter=" + String(T_iter) + ", input was p=" + String(p) + ", s=" + String(s) + " and X={" + String(Xfull[Water]) + ", " + String(Xfull[Desiccant]) + "}", "debug.txt");
        T_iter := (T_min + T_max)/2;
      end if;
      g := Thermodynamics.setGibbsDerivsFirst(
        p=p,
        T=T_iter,
        X=Xfull);
      RES_s := Thermodynamics.s(g) - s;
      // thighten the bounds
      if (RES_s*RES_min < 0) then
        T_max := T_iter;
        RES_max := RES_s;
      elseif (RES_s*RES_max < 0) then
        T_min := T_iter;
        RES_min := RES_s;
      end if;
      //Modelica.Utilities.Streams.print("T_min=" + String(T_min) + ", T_max=" + String(T_max) + " and T_iter=" + String(T_iter), "debug.txt");
    end while;
    //Modelica.Utilities.Streams.print("setState_psX required " + String(iter) + " iterations to find T=" + String(T_iter) + " for input p=" + String(p) + ", s=" + String(s) + " and X={" + String(Xfull[Water]) + ", " + String(Xfull[Desiccant]) + "}", "printlog.txt");
    assert(iter < iter_max, "setState_psX did not converge, input was p="
      + String(p) + ", s=" + String(s) + " and X={" + String(Xfull[Water])
      + ", " + String(Xfull[Desiccant]) + "}");
    state.p := p;
    state.s := s;
    state.X := Xfull;
    state.T := T_iter;
    state.h := Thermodynamics.h(g);
    state.u := Thermodynamics.u(g);
    state.d := Thermodynamics.d(g);
  end setState_psX;

  redeclare function extends setSat_TX
    "Return saturation property record from temperature"
protected
    AbsolutePressure psat;
  algorithm
    if (saturationPressureModel == SaturationPressureModel.PatekKlomfar) then
      psat := Ancillary.saturationPressure_PatekKlomfar(Tsat=Tsat, Xsat=Xfull);
    elseif (saturationPressureModel == SaturationPressureModel.Conde) then
      psat := Ancillary.saturationPressure_Conde(Tsat=Tsat, Xsat=Xfull);
    elseif (saturationPressureModel == SaturationPressureModel.Patil) then
      psat := Ancillary.saturationPressure_Patil(Tsat=Tsat, Xsat=Xfull);
    elseif (saturationPressureModel == SaturationPressureModel.Kink) then
      psat := Ancillary.saturationPressure_Kink(Tsat=Tsat, Xsat=Xfull);
    else
      assert(false, "Invalid choice for saturationPressureModel");
    end if;
    sat.Tsat := Tsat;
    sat.psat := psat;
    sat.Xsat := Xfull;
  end setSat_TX;

  redeclare function extends dynamicViscosity
    "Return dynamic viscosity as a function of the thermodynamic state record"
  algorithm
    eta := Ancillary.dynamicViscosity_Conde(T=state.T, X=state.X);
    annotation (Inline=true);
  end dynamicViscosity;

  redeclare function extends thermalConductivity
    "Return thermal conductivity as a function of the thermodynamic state record (NOT IMPLEMENTED YET)"
  algorithm
    lambda := 0.5592;
    annotation (Inline=true);
  end thermalConductivity;

  redeclare function extends specificHeatCapacityCp
    "Return specific heat capacity at constant pressure as a function of the thermodynamic state record"
protected
    Thermodynamics.GibbsDerivs g;
  algorithm
    g := Thermodynamics.setGibbsDerivsSecond(
      p=state.p,
      T=state.T,
      X=state.X);
    cp := Thermodynamics.cp(g=g);
    annotation (Inline=true);
  end specificHeatCapacityCp;

  redeclare function extends saturationPressure_der
    "Derivative of saturationPressure with respect to time (NOT IMPLEMENTED)"
  algorithm
    psat_der := 1;
    annotation (Inline=true);
  end saturationPressure_der;

  redeclare function extends saturationTemperature_der
  "Derivative of saturationTemperature with respect to time (NOT IMPLEMENTED)"
  algorithm
    Tsat_der := 1;
    annotation (Inline=true);
  end saturationTemperature_der;

  redeclare function extends density_pTX_der
    "Derivative of density_pTX with respect to time"
protected
    SpecificVolume v;
  algorithm
    v := 1/density(state=setState_pTX(p=p, T=T, X=X));
    //specificVolume(state=state);
    d_der := -specificVolume_pTX_der(
      p=p,
      T=T,
      X=X,
      p_der=p_der,
      T_der=T_der,
      X_der=X_der)/v^2;
      //state=state,
    annotation (Inline=true);
  end density_pTX_der;

  redeclare function extends density_phX_der
    "Derivative of density_phX with respect to time"
protected
    SpecificVolume v;
  algorithm
    v := 1/density(state=setState_phX(p=p, h=h, X=X));
    //specificVolume(state=state);
    d_der := -specificVolume_phX_der(
      p=p,
      h=h,
      X=X,
      p_der=p_der,
      h_der=h_der,
      X_der=X_der)/v^2;
      //state=state,
    annotation (Inline=true);
  end density_phX_der;

  redeclare function extends specificVolume_pTX_der
    "Derivative of specificVolume_pTX with respect to time"
protected
    Thermodynamics.GibbsDerivs g;
    DerVolumeByPressure dvpT;
    DerVolumeByTemperature dvTp;
    SpecificVolume dvY;
    Real dY_dX1;
    Real dY_dX2;
  algorithm
    g := Thermodynamics.setGibbsDerivsSecond(
      p=p,
      T=T,
      X=X);
    dY_dX1 := -1/MMX[Water]*(X[Water]/MMX[Water]
      + X[Desiccant]/MMX[Desiccant])^(-2)*X[Desiccant]/MMX[Desiccant];
    dY_dX2 := -1/MMX[Desiccant]*(X[Water]/MMX[Water]
      + X[Desiccant]/MMX[Desiccant])^(-2)*X[Desiccant]/MMX[Desiccant]
      + g.MM/MMX[Desiccant];
    dvpT := Thermodynamics.dvpT(g=g);
    dvTp := Thermodynamics.dvTp(g=g);
    dvY := Thermodynamics.dvY(g=g);
    v_der := p_der*dvpT + T_der*dvTp + X_der*dvY*{dY_dX1,dY_dX2};
    annotation (Inline=true);
  end specificVolume_pTX_der;

  redeclare function extends specificVolume_phX_der
    "Derivative of specificVolume_phX with respect to time"
protected
    Thermodynamics.GibbsDerivs g;
    DerVolumeByPressure dvpT;
    DerVolumeByEnthalpy dvhp;
    SpecificVolume dvY;
    Real dY_dX1;
    Real dY_dX2;
  algorithm
    g := Thermodynamics.setGibbsDerivsSecond(
      p=p,
      T=temperature_phX(
        p=p,
        h=h,
        X=X),
      X=X);
    dY_dX1 := -1/MMX[Water]*(X[Water]/MMX[Water]
      + X[Desiccant]/MMX[Desiccant])^(-2)*X[Desiccant]/MMX[Desiccant];
    dY_dX2 := -1/MMX[Desiccant]*(X[Water]/MMX[Water]
      + X[Desiccant]/MMX[Desiccant])^(-2)*X[Desiccant]/MMX[Desiccant]
      + g.MM/MMX[Desiccant];
    dvpT := Thermodynamics.dvpT(g=g);
    dvhp := Thermodynamics.dvTp(g=g)/Thermodynamics.dhTp(g=g);
    dvY := Thermodynamics.dvY(g=g);
    v_der := p_der*dvpT + h_der*dvhp + X_der*{dY_dX1,dY_dX2}*dvY;
    annotation (Inline=true);
  end specificVolume_phX_der;

  redeclare function extends temperature_phX_der
    "Derivative of temperature_phX with respect to time"
protected
    Real dY_dX1;
    Real dY_dX2;
    Thermodynamics.GibbsDerivs g;
    SpecificEnthalpy dhY;
    Temperature dTY;
  algorithm
    g := Thermodynamics.setGibbsDerivsSecond(
      p=state.p,
      T=state.T,
      X=state.X);
    dY_dX1 := -1/MMX[Water]*(X[Water]/MMX[Water]
      + X[Desiccant]/MMX[Desiccant])^(-2)*X[Desiccant]/MMX[Desiccant];
    dY_dX2 := -1/MMX[Desiccant]*(X[Water]/MMX[Water]
      + X[Desiccant]/MMX[Desiccant])^(-2)*X[Desiccant]/MMX[Desiccant]
      + g.MM/MMX[Desiccant];
    dhY := Thermodynamics.dhY(g=g);
    dTY := dhY/specificHeatCapacityCp(state=setState_phX(
      p=p,
      h=h,
      X=X));
    T_der := p_der*isenthalpicThrottlingCoefficient(state=setState_phX(
      p=p,
      h=h,
      X=X)) + h_der/specificHeatCapacityCp(state=setState_phX(
      p=p,
      h=h,
      X=X)) + X_der*{dY_dX1,dY_dX2}*dTY;
    annotation (Inline=true);
  end temperature_phX_der;

  redeclare function extends specificEnthalpy_pTX_der
    "Derivative of specificEnthalpy_pTX with respect to time"
protected
    Real dY_dX1;
    Real dY_dX2;
    Thermodynamics.GibbsDerivs g;
    SpecificEnthalpy dhY;
  algorithm
    g := Thermodynamics.setGibbsDerivsFirst(
      p=state.p,
      T=state.T,
      X=state.X);
    dhY := Thermodynamics.dhY(g=g);
    dY_dX1 := -1/MMX[Water]*(X[Water]/MMX[Water]
      + X[Desiccant]/MMX[Desiccant])^(-2)*X[Desiccant]/MMX[Desiccant];
    dY_dX2 := -1/MMX[Desiccant]*(X[Water]/MMX[Water]
      + X[Desiccant]/MMX[Desiccant])^(-2)*X[Desiccant]/MMX[Desiccant]
      + g.MM/MMX[Desiccant];
    h_der := p_der*isothermalThrottlingCoefficient(state=setState_pTX(
      p=p,
      T=T,
      X=X)) + T_der*specificHeatCapacityCp(state=setState_pTX(
      p=p,
      T=T,
      X=X)) + X_der*{dY_dX1,dY_dX2}*dhY;
    annotation (Inline=true);
  end specificEnthalpy_pTX_der;

  redeclare function extends diffusionCoefficient
    "Returns the diffusion coeffcient of water in medium"
    extends Modelica.Icons.Function;
  algorithm
    D := Functions.diffusionCoefficientWaterLiCl(T=state.T, X=state.X[Desiccant]);
  end diffusionCoefficient;

  redeclare function extends isothermalThrottlingCoefficient
    "Returns the isothermal throttling coeffcient (dh/dp)@T=const"
protected
    Thermodynamics.GibbsDerivs g;
  algorithm
    g := Thermodynamics.setGibbsDerivsSecond(
      p=state.p,
      T=state.T,
      X=state.X);
    dhpT := Thermodynamics.dhpT(g=g);
  end isothermalThrottlingCoefficient;

  redeclare function extends isenthalpicThrottlingCoefficient
    "Returns the isenthalpic throttling coeffcient (dT/dp)@h=const (Joule-Thomson coefficient)"
protected
    Thermodynamics.GibbsDerivs g;
  algorithm
    g := Thermodynamics.setGibbsDerivsSecond(
      p=state.p,
      T=state.T,
      X=state.X);
    dTph := Thermodynamics.dTph(g=g);
  end isenthalpicThrottlingCoefficient;

  annotation (Documentation(info="<html>
<p>This model allows the calculation of fluid properties of lithium chloride
aqueous solution (LiCl-H2O) in the fluid region of 273 K to 400 K and from
0 wt-% to 50 wt-% LiCl. </p>

<p>The thermodynamic properties do not only depend on the pressure and temperature,
but mostly on the composition. As the compositions changes significantly during absorption,
very accurate media models are needed. This medium model is based on the Gibbs energy
equation, that allows the calculation of all thermodynamic properties, including the
saturation properties.</p>

<h4>Notes</h4>
<p>The derivatives of some thermodynamic functions are not yet implemented, e.g. <code>saturationPressure_TX</code>
or <code>saturationTemperature_pX</code>.</p>

<h4>References</h4>

<dl><dt>P&aacute;tek, J., Klomfar, J.:</dt>
<dd><b>Thermodynamic properties of the LiCl–H2O system at vapor–liquid equilibrium from 273 K to 400 K</b><br>
International Journal of Refrigeration 31, p. 287-303 (2008)<br>
DOI: <a href=\"http://dx.doi.org/10.1016/j.ijrefrig.2007.05.003\">10.1016/j.ijrefrig.2007.05.003</a>
</dd></dl>
</html>",     revisions="<html>
<ul>
<li>
January 04, 2017, by Yannick Fuerst:<br/>
First implementation.
</li>
</ul>
</html>"));
end LithiumChlorideAqueousSolution_PatekKlomfar;
