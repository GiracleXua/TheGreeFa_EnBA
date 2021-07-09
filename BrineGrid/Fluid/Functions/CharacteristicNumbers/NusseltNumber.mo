within BrineGrid.Fluid.Functions.CharacteristicNumbers;
function NusseltNumber "Return Nusselt number from alpha, L and lambda"
  extends Modelica.Icons.Function;
  input Modelica.SIunits.CoefficientOfHeatTransfer alpha
    "Coefficient of heat transfer";
  input Modelica.SIunits.Length L "Characteristic dimension";
  input Modelica.SIunits.ThermalConductivity lambda "Thermal conductivity";
  output Modelica.SIunits.NusseltNumber Nu "Nusselt number";
algorithm
  Nu := alpha*L/lambda;
  annotation(Inline=true, Documentation(info="<html>
<p>Calculate the Nusselt number as a function of the heat transfer coefficient, characteristic dimension and thermal conductivity. </p>
</html>",
        revisions="<html>
<ul>
<li>
January 04, 2017, by Yannick Fuerst:<br/>
First implementation.
</li>
</ul>
</html>"));
end NusseltNumber;
