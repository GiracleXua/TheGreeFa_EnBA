within BrineGrid.Media.LiquidDesiccants.Examples;
package ValidationMgCl2

  model Test_MgCL2_Cp "test model only for cp of MgCl2 solution"
    extends Modelica.Icons.Example;
    import SI = Modelica.SIunits;
    //import conv = Modelica.SIunits.Conversions;

    //constant SI.Temperature T_ref = Modelica.Media.Water.IF97_Utilities.BaseIF97.triple.Ttriple;
    //constant Modelica.SIunits.Conversions.NonSIunits.Temperature_degC theta_ref=conv.to_degC(T_ref);

    //parameter Modelica.SIunits.Conversions.NonSIunits.Temperature_degC theta[8]=
        //theta_ref:10:(70+theta_ref) "Temperature vector in C";
    //parameter Modelica.SIunits.MassFraction Xsalt[11]=0.0:0.04:0.4
    //"Mass Fraction vector of salt";

    SI.Temp_K T=333.15;
    SI.MassFraction X = 0.4;

    SI.SpecificHeatCapacity cp;
    SI.SpecificHeatCapacity cp_w_0;
    SI.SpecificHeatCapacity cp_w_1;
    SI.SpecificHeatCapacity cp_w_x;
            // intermediate vairable
  protected
    Modelica.SIunits.AbsolutePressure psat_W=
        Modelica.Media.Water.IF97_Utilities.BaseIF97.Basic.psat(T);

  equation
    cp_w_0 = Modelica.Media.Water.IF97_Utilities.cp_pT(101325, T, 0);
    cp_w_1 = Modelica.Media.Water.IF97_Utilities.cp_pT(101325, T, 1);
    cp_w_x = Modelica.Media.Water.IF97_Utilities.cp_pT(psat_W, T, 1);
    cp = BrineGrid.Media.LiquidDesiccants.MagnesiumChlorideAqueousSolution.Thermodynamics.cp(
          T, {1-X, X});

    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(
            preserveAspectRatio=false)));
  end Test_MgCL2_Cp;

  model Validation_MgCl2 "validate MgCl2 function against literature data"
    extends BaseClasses.PartialValidation(
      redeclare package Medium =
        LiquidDesiccants.MagnesiumChlorideAqueousSolution,
        T = 303.15, p = 101325, b=2.006);

    //import Modelica.SIunits.Conversions.*;
    import stoff = BrineGrid.Media.LiquidDesiccants;

    //stoff.Types.Molality b;
    Modelica.SIunits.AbsolutePressure P_vapor;

    //Medium.MassFraction X1[Medium.nX] = Medium.moleToMassFractions(moleFractions=Y, MMX=Medium.MMX);
  protected
    Medium.MassFraction X1[Medium.nX] = stoff.Functions.MolalityToMassFraction(b=b, MMX=Medium.MMX);

  equation
    P_vapor = Medium.saturationPressure(Tsat = T, Xsat = X1);

    //b = stoff.Functions.MassFractionToMolality(X = X1, MMX = Medium.MMX);

    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(
            preserveAspectRatio=false)));
  end Validation_MgCl2;

  model TestFunctions_MgCL_fluid_property_Chris
    "Model to test media functions and generate comparative plot data"
    extends Modelica.Icons.Example;
    import SI = Modelica.SIunits;
    import Modelica.SIunits.Conversions.*;

    constant SI.Temperature T_ref=Modelica.Media.Water.IF97_Utilities.BaseIF97.triple.Ttriple;
    constant Modelica.SIunits.Conversions.NonSIunits.Temperature_degC theta_ref=to_degC(T_ref);

    parameter Modelica.SIunits.Conversions.NonSIunits.Temperature_degC theta[8]=
        theta_ref:10:(70+theta_ref) "Temperature vector in °C";
    parameter Modelica.SIunits.MassFraction Xsalt[5]=0.0:0.1:0.4
      "Mass fraction vector of salt";

    SI.Temperature T[8] "Temperature in K";
    SI.MassFraction X[2,5] "Mass fraction";
    SI.AbsolutePressure psatW[8];
    SI.AbsolutePressure psat[8,5];
    SI.SpecificHeatCapacity cp_W[8];
    SI.SpecificHeatCapacity cp[8,5];
    SI.SpecificEnthalpy h_W[8];
    SI.SpecificEnthalpy h[8,5];
    SI.Density rho[8,5];
    //Modelica.SIunits.AbsolutePressure psatDiff[8,5];
    //Real psatDiffRel[8,5];

  equation

    for i in 1:size(theta, 1) loop
    T[i] = from_degC(theta[i]);
    end for;
    for j in 1:size(Xsalt, 1) loop
      X[1, j] = 1 - Xsalt[j];
      X[2, j] = Xsalt[j];
    end for;
    for i in 1:size(theta, 1) loop
      psatW[i] =
        BrineGrid.Media.LiquidDesiccants.MagnesiumChlorideAqueousSolution.Ancillary.saturationPressure_water(
        T[i]);
      cp_W[i] = Modelica.Media.Water.IF97_Utilities.cp_pT(
        psatW[i],
        T[i],
        1);
       h_W[i] = Modelica.Media.Water.IF97_Utilities.h_pT(
        psatW[i],
        T[i],
        1);
      for j in 1:size(Xsalt, 1) loop
        psat[i, j] =
          BrineGrid.Media.LiquidDesiccants.MagnesiumChlorideAqueousSolution.Ancillary.saturationPressure(
          T[i], X[:, j]);
        rho[i, j] =
          BrineGrid.Media.LiquidDesiccants.MagnesiumChlorideAqueousSolution.Thermodynamics.d(
          T[i], X[:, j]);
        cp[i, j] =
          BrineGrid.Media.LiquidDesiccants.MagnesiumChlorideAqueousSolution.Thermodynamics.cp(
          T[i], X[:, j]);
        h[i, j] =
          BrineGrid.Media.LiquidDesiccants.MagnesiumChlorideAqueousSolution.Thermodynamics.h(
          T[i], X[:, j]);
      end for;
    end for;

    //   psatDiff[:, :] = psat2[:, :] - psat[:, :];
    //   psatDiffRel[:, :] = psatDiff[:, :] ./ psat[:, :];

    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end TestFunctions_MgCL_fluid_property_Chris;

  model Test_validate_MgCl2
    extends BaseClasses.PartialValidation(
      redeclare package Medium =
        LiquidDesiccants.LithiumBromideAqueousSolution_PatekKlomfar,
      T = 300, p=101325, Y = {0.8, 0.2});
        //LiquidDesiccants.MagnesiumChlorideAqueousSolution,

    // property
    //Medium.BaseProperties base_nonlin;

    //state
    Medium.ThermodynamicState state_nonlin;

    Medium.ThermodynamicState state_test;

    //saturation
    Medium.SaturationProperties sat_pX;
    Medium.Temperature Tsat;

  equation
    Tsat = Medium.saturationTemperature(psat=psat, Xsat=sat_TX.Xsat);
    sat_pX = Medium.setSat_pX(psat=psat, Xsat=X);

    //base_nonlin.h = base.h;
    //base_nonlin.p = p;
    //base_nonlin.X[1] = X[1];

    state_nonlin = Medium.setState_phX(p=p, h=base.h, X=X);
    state_test = Medium.setState_pTX(p=p, T=T, X={0.6512, 0.3488});

    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(
            preserveAspectRatio=false)));
  end Test_validate_MgCl2;
end ValidationMgCl2;
