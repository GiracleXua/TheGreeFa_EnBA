within BrineGrid.Media.Examples;
partial package PartialGeneralBrineMedia "Base class for general brine media"
  extends BrineGrid.Media.LiquidDesiccants.Choices;

  extends BrineGrid.Media.LiquidDesiccants.Types(
    Density(
      min=fluidLimits.DMIN,
      max=fluidLimits.DMAX,
      start=d_init,
      nominal=d_init),
    Temperature(
      min=fluidLimits.TMIN,
      max=fluidLimits.TMAX,
      start=T_init,
      nominal=T_init),
    AbsolutePressure(
      min=fluidLimits.PMIN,
      max=fluidLimits.PMAX,
      start=p_init,
      nominal=p_init),
    SpecificEnthalpy(
      min=fluidLimits.HMIN,
      max=fluidLimits.HMAX,
      start=h_init,
      nominal=h_init),
    SpecificEntropy(
      min=fluidLimits.SMIN,
      max=fluidLimits.SMAX,
      start=s_init,
      nominal=s_init));

  extends BrineGrid.Media.Interfaces.PartialCondensingFluid(
  mediumName="aqueous solution",
  substanceNames={"water","desiccant"},
  final singleState=false,
  final reducedX=true,
  final fixedX=false);

  function gasConstant_X
    "Return the gas constant of the mixture as a function from composition X"
    extends Modelica.Icons.Function;
    input MassFraction[nX] X "Mass fractions of composition";
    output SpecificHeatCapacity R "Mixture gas constant";
  algorithm
    R := sum(RX[i]*X[i] for i in 1:nX);
    annotation(Inline=true);
  end gasConstant_X;

  function molarMass_X
    "Return molar mass of mixture as a function from mass composition X"
    extends Modelica.Icons.Function;
    input Modelica.SIunits.MassFraction[nX] X "Mass fractions of mixture";
    output Modelica.SIunits.MolarMass MM "Molar mass of mixture";
  algorithm
    MM := 1/sum(X[i]/MMX[i] for i in 1:nX);
    annotation (Inline=true);
  end molarMass_X;

  function specificHeatCapacity = specificHeatCapacityCp
    "Alias for the specific heat capacity, as cp=cv" annotation(Inline=true);
  constant Integer Desiccant=2 "Index of desiccant";
  constant Temperature T_init=reference_T
    "Default value for temperature of medium (for initialization)";
  constant Integer Water=1 "Index of water";
  constant MassFraction XMAX=1.0 "Maximum desiccant concentration";
  constant MassFraction XMIN=0.0 "Minimum dessicant concentration";
  constant Density d_init=0.0
    "Default value for density of medium (for initialization)";
  constant SpecificEnthalpy h_init=0.0
    "Default value for specific enthalpy of medium (for initialization)";
  constant IndependentVariables independentVariables=IndependentVariables.pTX
    "Default choice of input variables for property computations";
  constant AbsolutePressure p_init=reference_p
    "Default value for pressure of medium (for initialization)";
  constant SpecificEntropy s_init=0.0
    "Default value for specific entropy of medium (for initialization)";
  constant MassFraction[nX] X_init=reference_X
    "Default value for mass fractions of medium (for initialization)";
  constant BrineGrid.Media.LiquidDesiccants.Constants.Reference reference;
  constant FluidConstants[nS] fluidConstants;
  constant FluidLimits fluidLimits "Fluid limits";
  constant MolarMass[nX] MMX "Molar masses of components";
  constant SpecificHeatCapacity[nX] RX "Gas constants of components";

  redeclare replaceable partial model extends BaseProperties(
    final standardOrderComponents=true)
    "Base properties of lithium bromide aqueous solution"
    SpecificEntropy s;
    //SpecificVolume v;
    SaturationProperties sat "Saturation properties at the medium temperature";
  equation
    assert(T >= fluidLimits.TMIN and T <= fluidLimits.TMAX, "Temperature T is not in the allowed range " + String(fluidLimits.TMIN) + " K <= (T ="+ String(T) + " K) <= " + String(fluidLimits.TMAX) + " K required from medium model \"" + mediumName + "\".");
    assert(X[Desiccant] >= XMIN and X[Desiccant] <= XMAX, "Mass Fraction X of Desiccant is not in the allowed range " + String(XMIN) + " <= X[Desiccant] <= " + String(XMAX) + " required from medium model \"" + mediumName + "\".");

    MM = molarMass_X(X);
    R = gasConstant_X(X);
    sat = setSat_TX(Tsat=T, Xsat=X);

    state.p = p;
    state.T = T;
    state.X = X;
    state.h = h;
    state.u = u;
    state.s = s;
    state.d = d;
  end BaseProperties;

  redeclare replaceable record extends ThermodynamicState
    "ThermodynamicState record for aqueous solutions"
    Density d "Density of medium";
    SpecificEnergy u "Specific inner energy of medium";
    SpecificEnthalpy h "Specific enthalpy of medium";
    SpecificEntropy s "Specific entropy of medium";

  end ThermodynamicState;

  redeclare replaceable record extends SaturationProperties
    "Saturation properties of two phase medium"
    MassFraction[nX] Xsat "Saturation composition";
  end SaturationProperties;

  redeclare function extends molarMass
    "Return molar mass of mixture as a function from thermodynamic state"
  algorithm
    MM := 1/sum(state.X[i]/MMX[i] for i in 1:nX);
    annotation (Inline=true);
  end molarMass;

  redeclare function extends gasConstant
    "Return the gas constant of the mixture as a function from thermodynamic state"
  algorithm
    R := sum(RX[i]*state.X[i] for i in 1:nX);
    annotation(Inline=true);
  end gasConstant;

  replaceable partial function setSat_TX
    "Return saturation property record from temperature and composition"
    extends Modelica.Icons.Function;
    input Temperature Tsat "Saturation temperature";
    input MassFraction[:] Xsat "Saturation composition";
    output SaturationProperties sat "Saturation property record";
  protected
    MassFraction[nX] Xfull = if size(Xsat, 1) == nX then Xsat else cat(1, Xsat, {1 - sum(Xsat)});
  end setSat_TX;

  replaceable partial function setSat_pX
    "Return saturation property record from pressure and composition"
    extends Modelica.Icons.Function;
    input AbsolutePressure psat "Saturation pressure";
    input MassFraction[:] Xsat "Saturation composition";
    output SaturationProperties sat "Saturation property record";
  protected
    MassFraction[nX] Xfull = if size(Xsat, 1) == nX then Xsat else cat(1, Xsat, {1 - sum(Xsat)});
  end setSat_pX;

  redeclare function extends pressure
    "Returns pressure of an aqueous solution as a function of the thermodynamic state record"
  algorithm
    p := state.p;
    annotation(Inline=true);
  end pressure;

  redeclare function extends temperature
    "Return temperature of an aqueous solution as a function of the thermodynamic state record"
  algorithm
    T := state.T;
    annotation(Inline=true);
  end temperature;

  redeclare function extends density
    "Returns density of an aqueous solution as a function of the thermodynamic state record"
  algorithm
    d := state.d;
    annotation(Inline=true);
  end density;

  redeclare function extends specificEnthalpy
    "Return specific enthalpy of aqueous solution as a function of the thermodynamic state record"
  algorithm
    h := state.h;
    annotation(Inline=true);
  end specificEnthalpy;

  redeclare function extends specificInternalEnergy
    "Return specific internal energy of aqueous solution as a function of the thermodynamic state record"
  algorithm
    u := state.u;
    annotation(Inline=true);
  end specificInternalEnergy;

  redeclare function extends specificEntropy
    "Return specific entropy of aqueous solution as a function of the thermodynamic state record"
  algorithm
    s := state.s;
    annotation(Inline=true);
  end specificEntropy;

  redeclare function extends specificHeatCapacityCv
    "Return specific heat capacity at constant volume of an aqueous solution as a function of the thermodynamic state record"
  algorithm
    // The aqueous solution is incompressible, so cp=cv
    cv := specificHeatCapacityCp(state);
    annotation(Inline=true);
  end specificHeatCapacityCv;

  redeclare function enthalpyOfCondensingGas
    "Enthalpy of steam per unit mass of steam"
    extends Modelica.Icons.Function;
    input Temperature T "temperature";
    output SpecificEnthalpy h "steam enthalpy";
  algorithm
    h := (T - reference_T)*BrineGrid.Utilities.Psychrometrics.Constants.cpSte
       + BrineGrid.Utilities.Psychrometrics.Constants.h_fg;
    annotation(smoothOrder=5,
    Inline=true);
  end enthalpyOfCondensingGas;

  redeclare function enthalpyOfVaporization =
    Modelica.Media.Air.MoistAir.enthalpyOfVaporization
    "Return vaporization enthalpy of water";

  redeclare function enthalpyOfLiquid =
    Modelica.Media.Air.MoistAir.enthalpyOfWater
    "Return enthalpy of liquid water as a function of temperature T";

  replaceable partial function saturationTemperature
  "Return saturation temperature of condensing fluid"
    extends Modelica.Icons.Function;
    input AbsolutePressure psat "Saturation pressure";
    input MassFraction[nX] Xsat=X_default "Saturation composition";
    output Temperature Tsat "Saturation temperature";
  end saturationTemperature;

  replaceable partial function diffusionCoefficient
  "Returns the diffusion coeffcient of water in mixture"
    extends Modelica.Icons.Function;
    input ThermodynamicState state "Thermodynamic state";
    output Modelica.SIunits.DiffusionCoefficient D
    "Diffusion coefficient of water in medium";
  end diffusionCoefficient;

  annotation (Documentation(info="<html>
<p>This package contains all declarations for aqueous solution models based on equations
of state or a fundamental equation, like the Gibbs free energy equation. </p>
</html>",     revisions="<html>
<ul>
<li>
January 04, 2017, by Yannick Fuerst:<br/>
First implementation.
</li>
</ul>
</html>"));
end PartialGeneralBrineMedia;
