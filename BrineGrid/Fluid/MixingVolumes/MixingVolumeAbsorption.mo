within BrineGrid.Fluid.MixingVolumes;
model MixingVolumeAbsorption
  "Mixing volume with heat and moisture port, to be used in absorption processes"
  extends BrineGrid.Fluid.MixingVolumes.BaseClasses.PartialMixingVolume(
    redeclare replaceable package Medium =
        BrineGrid.Media.Interfaces.PartialCondensingFluid,
    dynBal(final use_mWat_flow=true),
    steBal(final use_mWat_flow=true),
    simplify_mWat_flow=false);

  Medium.AbsolutePressure psat "Saturation pressure";
  Medium.MassFraction[Medium.nX] X "Composition";
  Medium.MassFraction X_eq "Equilibrium absolute humidity";
  Medium.MassFraction X_eff "Effective absolute humidity";
  final constant Modelica.SIunits.MolarMass MM_dryair=Modelica.Media.IdealGases.Common.SingleGasesData.Air.MM;
  final constant Modelica.SIunits.MolarMass MM_steam=Modelica.Media.IdealGases.Common.SingleGasesData.H2O.MM;
  final constant Real k_mair=MM_steam/MM_dryair;

  Modelica.Blocks.Sources.RealExpression mWat_flow(y=moisturePort.m_flow)
    "Water flow rate added into the medium"
    annotation (Placement(transformation(extent={{-100,70},{-80,90}})));
  Modelica.Blocks.Interfaces.RealInput TWat(final quantity="ThermodynamicTemperature",
                                            final unit = "K", displayUnit = "degC", min=260)
    "(only used for latent heat)Temperature of liquid that is drained from or injected into volume"
    annotation (Placement(transformation(extent={{-140,28},{-100,68}})));
  Modelica.Blocks.Interfaces.RealOutput X_w "Species composition of medium"
    annotation (Placement(transformation(extent={{100,-60},{140,-20}})));
  Modelica.Blocks.Math.Product QLat_flow
    "Latent heat flow rate added to the fluid stream"
    annotation (Placement(transformation(extent={{20,62},{40,82}})));
  BrineGrid.MoistureTransfer.Interfaces.MoisturePort_a moisturePort
    "Mass port for mass transfer"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
protected
  parameter Integer i_w(fixed=false) "Index for water substance";
  parameter Real s[Medium.nXi] = {
  if Modelica.Utilities.Strings.isEqual(string1=Medium.substanceNames[i],
                                        string2="Water",
                                        caseSensitive=false) then 1 else 0
                                        for i in 1:Medium.nXi}
    "Vector with zero everywhere except where species is";

  Modelica.Blocks.Sources.RealExpression hLiq(y=Medium.enthalpyOfCondensingGas(T=TWat))
    "Enthalpy of water at the given temperature"
    annotation (Placement(transformation(extent={{-40,62},{0,86}})));
  Modelica.Blocks.Math.Add Q_flow(final k1=1, final k2=1)
    "Sensible and latent heat added to the volume"
    annotation (Placement(transformation(extent={{68,68},{88,88}})));
  Modelica.Blocks.Sources.RealExpression XLiq(y=s*Xi)
    "Species composition of the medium"
    annotation (Placement(transformation(extent={{60,-52},{82,-28}})));
initial algorithm
  i_w := 0;
  for i in 1:Medium.nXi loop
    if s[i] > 1e-5 then
      i_w  := i;
    end if;
  end for;
  assert(Medium.nXi == 0 or i_w > 0,
    "Substance 'water' is not present in medium '"
         + Medium.mediumName + "'.\n"
         + "Check medium model.");
equation
  X = cat(1, Xi, {1 - sum(Xi)});
  psat = Medium.saturationPressure(Tsat=T, Xsat=X);
  X_eq = k_mair/(p/min(psat, 0.999*p) - 1); // to calculate humidity ratio x_vapor
  //with given partial pressure x_vapor = M(H20)/M(Air)*P_w / (P_tot-P_w)
  X_eff = min(X_eq, X[1]);
  // Port properties
  moisturePort.X = X_eff;
  connect(QSen_flow.y, Q_flow.u1) annotation (Line(points={{-19,88},{40,88},{40,
          84},{66,84}},         color={0,0,127}));
  connect(QLat_flow.y, Q_flow.u2) annotation (Line(points={{41,72},{44,72},{44,72},
          {66,72}},         color={0,0,127}));
  connect(hLiq.y, QLat_flow.u1) annotation (Line(points={{2,74},{10,74},{10,78},
          {18,78}}, color={0,0,127}));
  connect(Q_flow.y, steBal.Q_flow) annotation (Line(points={{89,78},{92,78},{92,
          40},{0,40},{0,18},{8,18}},               color={0,0,127}));
  connect(Q_flow.y, dynBal.Q_flow) annotation (Line(points={{89,78},{92,78},{92,
          40},{54,40},{54,16},{58,16}},         color={0,0,127}));
  connect(XLiq.y, X_w) annotation (Line(points={{83.1,-40},{94,-40},{120,-40}},
                                                                              color={0,0,127}));
  connect(mWat_flow.y, QLat_flow.u2) annotation (Line(points={{-79,80},{-79,80},
          {-50,80},{-50,66},{18,66}},color={0,0,127}));
  connect(mWat_flow.y, dynBal.mWat_flow) annotation (Line(points={{-79,80},{-60,80},{-60,52},{42,52},
          {42,12},{58,12}},                  color={0,0,127}));
  connect(mWat_flow.y, steBal.mWat_flow) annotation (Line(points={{-79,80},{-50,
          80},{-50,66},{-10,66},{-10,14},{-2,14},{-2,14},{8,14}},
                                                              color={0,0,127}));
  annotation (defaultComponentName="volMasExcCon",Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),
    Documentation(revisions="<html>
<ul>
<li>
January 04, 2017, by Yannick Fuerst:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>This model represents an ideally mixed fluid volume to store mass and energy.
Potential and kinetic energy at the port are neglected, and there is no pressure
drop at the ports. The volume can exchange heat through its heatPort and moisture 
through its moisturePort.</p>
<p>
This model represents the same physics as
<a href=\"modelica://BrineGrid.Fluid.MixingVolumes.MixingVolume\">
BrineGrid.Fluid.MixingVolumes.MixingVolume</a>, but allows
adding or subtracting phase changing water vapor at the additional
<code>moisturePort</code>. Adding or subtracting water causes a change
in enthalpy and composition in the volume.
</p>
<h4>Notes</h4>
<p>
This model can only be used with medium models that include water
as a substance. In particular, the medium model needs to extend from
<a href=BrineGrid.Media.Interfaces.PartialCondensingFluid>
BrineGrid.Media.Interfaces.PartialCondensingFluid</a>, implement the
function <code>enthalpyOfCondensingGas(T)</code> and needs the integer
variable <code>Water</code>, that contains the index to the water
substance. The model is designed to be used in absorption processes.
</p>
</html>"));
end MixingVolumeAbsorption;
