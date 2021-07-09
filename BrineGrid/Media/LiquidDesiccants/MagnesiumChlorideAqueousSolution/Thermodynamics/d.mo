within BrineGrid.Media.LiquidDesiccants.MagnesiumChlorideAqueousSolution.Thermodynamics;
function d "Calculate density d from temperature T and composition X"
  extends Modelica.Icons.Function;
  //input AbsolutePressure p "Pressure";
  input Temperature T "Temperature";
  input MassFraction[nX] X "Composition";
  output Density d "Density";

  //final Density d_c = 322 "density of water at critial point";

protected
  constant Real[6] c_dw=Coefficients.dw_coeff;
  constant Real[6] c=Coefficients.c_d;
  constant Temperature T_crit=reference.criticalTemperature; //not 647 exactly
  constant Temperature T_ref=reference.referenceTemperature;
  constant Density d_c = 322 "density of water at critial point";

  Density d_W "Density of saturated liquid water";
  Real Theta=T/T_crit;
  Real tau=1 - Theta;
  Real polyBrine;

algorithm
  d_W := d_c * (1+c_dw[1]*tau^(1/3)+c_dw[2]*tau^(2/3)+c_dw[3]*tau^(5/3)+c_dw[4]*tau^(16/3)+
                c_dw[5]*tau^(43/3)+c_dw[6]*tau^(110/3));
  polyBrine := (0.108 + 8.68e-4*T)*X[Desiccant]^2 + (0.6802 + 4.928e-4*T)*X[Desiccant] + 1;
  d := d_W*polyBrine;
  annotation (
  smoothOrder=3,
      Inline=true,
    Documentation(info="<html>
<p>Density of aqueous magnesium chloride solution according to Koller (2018). Density of saturated liquid water originally according to Saul and Wagner (1987) or Wagner and Pruss (1993). In this iteration IAPWS IF97 data is used.</p>
<p><b>References</b> </p>
<dl><dt>C. Koller:</dt>
<dd><h4>Property Model for MgCl2</h4></dd>
<dd>MATLAB-Code developed at ZHAW not published yet (2018)<br></dd>
<dl><dt>Saul, A. and W. Wagner:</dt>
<dd><h4>International Equations for the Saturation Properties of Ordinary Water Substance.</h4></dd>
<dd>Journal of Physical and Chemical Reference Data, 16(4), pp.893-901 (1987) <\\dd>
<dd>DOI: <a href=\"https://doi.org/10.1063/1.555787\">10.1063/1.555787</a> </dd>
<dl><dt>W. Wagner and A. Pruss:</dt>
<dd><h4>International Equations for the Saturation Properties of Ordinary Water Substance. Revised According to the International Temperature Scale of 1990. Addendum to J. Phys. Chem. Ref. Data 16, 893 (1987)</h4></dd>
<dd>Journal of Physical and Chemical Reference Data 22, p. 783-787 (1993)</dd>
<dd>DOI: <a href=\"http://dx.doi.org/10.1063/1.555926\">10.1063/1.555926</a> </dd>
</dl></html>",
      revisions="<html>
First version 20.02.2019 Christian Fleßner
</html>"));
end d;
