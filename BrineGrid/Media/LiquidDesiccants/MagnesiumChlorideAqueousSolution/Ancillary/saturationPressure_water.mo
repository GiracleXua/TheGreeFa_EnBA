within BrineGrid.Media.LiquidDesiccants.MagnesiumChlorideAqueousSolution.Ancillary;
function saturationPressure_water
  "Calculation of the saturation pressure according to Wagner & Pruss (1993)"
  extends Modelica.Icons.Function;
  input Temperature Tsat "Saturation temperature";
  output AbsolutePressure psatW "Saturation pressure";
protected
  constant Real[6] a=Coefficients.a_p;
  constant Temperature T_crit=reference.criticalTemperature;
  constant AbsolutePressure p_crit=reference.criticalPressure;
  Real Theta=Tsat/T_crit;
  Real tau=1-Theta;
algorithm
  psatW :=p_crit*exp(1/Theta*(a[1]*tau+a[2]*tau^(1.5)+a[3]*tau^3+a[4]*tau^(3.5)+a[5]*tau^4+a[6]*tau^(7.5)));

  annotation (Documentation(info="<html>
<p>Calculation of Saturation pressure according of pure water according to Wagner & Pruss (1993).</p>

<h4>References</h4>

<dl><dt>W. Wagner and A. Pruss:</dt>
<dd><b>International Equations for the Saturation Properties of Ordinary Water Substance. 
Revised According to the International Temperature Scale of 1990. Addendum to J. Phys. Chem. Ref. Data 16, 893 (1987)</b><br>
Journal of Physical and Chemical Reference Data 22, p. 783-787 (1993)<br>
DOI: <a href=\"http://dx.doi.org/10.1063/1.555926\">10.1063/1.555926</a>
</dd></dl>
</html>"));
end saturationPressure_water;
