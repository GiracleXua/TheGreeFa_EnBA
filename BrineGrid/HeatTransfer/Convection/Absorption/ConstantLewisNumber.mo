within BrineGrid.HeatTransfer.Convection.Absorption;
model ConstantLewisNumber
  "Constant Lewis number (only to be used with coupled mass transfer)"
  extends BaseClasses.PartialConvectionGeneral;
  parameter Modelica.SIunits.CoefficientOfHeatTransfer alpha0=30
    "Start value for heat transfer coefficient";
  parameter Modelica.SIunits.LewisNumber Le0=1 "Lewis number";
  parameter BrineGrid.SIunits.SherwoodNumber Sh=1 "Sherwood number";

  Medium_a.ThermalConductivity lambda_a=Medium_a.thermalConductivity(state=inflow_a)
    "Thermal conductivity of medium a at inlet";
  Medium_a.SpecificHeatCapacity cp_a=Medium_a.specificHeatCapacityCp(state=inflow_a)
    "Specific isobaric heat capacity of medium a at inlet";
  Medium_a.Density rho_a=Medium_a.density(state=inflow_a)
    "Density of medium a at inlet";
  Modelica.SIunits.DiffusionCoefficient D_air=
    Media.LiquidDesiccants.Functions.diffusionCoefficientWaterAir(
      p=p_a,
      T=T_a)
    "Diffusion coefficient of water vapour in air at inlet";

  BrineGrid.SIunits.CoefficientOfMassTransfer1 beta "Mass transfer coefficient";
  Modelica.SIunits.CoefficientOfHeatTransfer alpha(start=alpha0)
    "Coefficient of heat transfer";
equation
  beta = Fluid.Functions.CharacteristicNumbers.beta_from_SherwoodNumber(
    Sh=Sh,
    L=deq,
    D=D_air);
  alpha = Le0*beta*cp_a*rho_a;
  Q_flow = alpha*surface*(heatPort_a.T - heatPort_b.T);
  annotation (Documentation(revisions="<html>
<ul>
<li>
January 04, 2017, by Yannick Fuerst:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>Convective heat transfer model using a constant Lewis number <i>Le</i>.
This model can only be used together with a convective mass transfer model
and the heat transfer coefficient &alpha; is calculated from the mass
transfer coefficient &beta;.</p>
</html>"));
end ConstantLewisNumber;
