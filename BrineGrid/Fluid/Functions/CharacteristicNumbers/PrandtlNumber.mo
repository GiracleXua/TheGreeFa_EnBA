within BrineGrid.Fluid.Functions.CharacteristicNumbers;
function PrandtlNumber "Return Prandtl number from eta, cp and lambda"
  extends Modelica.Icons.Function;
  input Modelica.SIunits.DynamicViscosity eta "Dynamic viscosity";
  input Modelica.SIunits.SpecificHeatCapacity cp
    "Specific isobaric heat capacity";
  input Modelica.SIunits.ThermalConductivity lambda "Thermal conductivity";
  output Modelica.SIunits.PrandtlNumber Pr "Prandtl number";
algorithm
  Pr := eta*cp/lambda;
  annotation(Inline=true, Documentation(revisions="<html>
<ul>
<li>
January 04, 2017, by Yannick Fuerst:<br/>
First implementation.
</li>
</ul>
</html>",
        info="<html>
<p>Calculate the Prandtl number as a function of the dynamic viscosity, spezific isobaric heat capacity and thermal conductivity. </p>
</html>"));
end PrandtlNumber;
