within BrineGrid.Fluid.Functions.CharacteristicNumbers;
function alpha_from_NusseltNumber
  "Return mass transfer coefficient from Nu, L and lambda"
  extends Modelica.Icons.Function;
  input Modelica.SIunits.NusseltNumber Nu "Nusselt number";
  input Modelica.SIunits.Length L "Characteristic dimension";
  input Modelica.SIunits.ThermalConductivity lambda "Thermal conductivity";
  output Modelica.SIunits.CoefficientOfHeatTransfer alpha
    "Coefficient of heat transfer";
algorithm
  alpha := Nu*lambda/L;
  annotation(Inline=true, Documentation(revisions="<html>
<ul>
<li>
January 04, 2017, by Yannick Fuerst:<br/>
First implementation.
</li>
</ul>
</html>",
        info="<html>
<p>Calculate the heat transfer coeffcient as a function of the coefficient of the Nusselt number, characteristic dimension and thermal conductivity. </p>
</html>"));
end alpha_from_NusseltNumber;
