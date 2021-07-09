within BrineGrid.Media.LiquidDesiccants.PerfectGas;
function saturationPressureLiquid_der
    "Time derivative of saturationPressureLiquid"

  extends Modelica.Icons.Function;
  input Modelica.SIunits.Temperature Tsat "Saturation temperature";
  input Real dTsat(unit="K/s") "Saturation temperature derivative";
  output Real psat_der(unit="Pa/s") "Saturation pressure";

algorithm
  psat_der:=611.657*Modelica.Math.exp(17.2799 - 4102.99/(Tsat - 35.719))*4102.99*dTsat/(Tsat - 35.719)/(Tsat - 35.719);

  annotation (
    smoothOrder=5,
    Inline=true,
Documentation(info="<html>
Derivative function of
<a href=\"modelica://BrineGrid.Media.Specialized.Air.PerfectGas.saturationPressureLiquid\">
BrineGrid.Media.Specialized.Air.PerfectGas.saturationPressureLiquid</a>
</html>"));
end saturationPressureLiquid_der;
