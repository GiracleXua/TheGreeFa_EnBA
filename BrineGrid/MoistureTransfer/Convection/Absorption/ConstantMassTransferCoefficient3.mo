within BrineGrid.MoistureTransfer.Convection.Absorption;
model ConstantMassTransferCoefficient3
  "Constant mass transfer coefficient in mol/(m2.s.mole fraction)"
  extends BaseClasses.PartialConvectionAbsorption;
  parameter BrineGrid.SIunits.CoefficientOfMassTransfer4 beta0=0.03
    "Mass transfer coefficient in mol/(m2.s.mole fraction)";

  Medium_a.MolarMass MM_a=Medium_a.molarMass(state=inflow_a)
    "Molar mass of medium a at inflow";
equation
  m_flow = beta0*MM_a*surface*(moisturePort_a.X - moisturePort_b.X);
  annotation (Documentation(info="<html>
<p>Convective mass transfer model using a constant heat transfer coefficient &beta; in mol/(m2.s.mole fraction).</p>
</html>", revisions="<html>
<ul>
<li>
January 04, 2017, by Yannick Fuerst:<br/>
First implementation.
</li>
</ul>
</html>"));
end ConstantMassTransferCoefficient3;
