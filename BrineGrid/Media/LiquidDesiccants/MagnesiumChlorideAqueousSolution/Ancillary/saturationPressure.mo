within BrineGrid.Media.LiquidDesiccants.MagnesiumChlorideAqueousSolution.Ancillary;
function saturationPressure
  "Calculation of the saturation pressure according to the equation of Claudio Koller"
  extends Modelica.Icons.Function;
  input Temperature Tsat "Saturation temperature";
  input MassFraction[nX] Xsat "Saturation composition";
  output AbsolutePressure psat "Saturation pressure";
protected
  MoleFraction[nX] Ysat;
  AbsolutePressure psatW;
  Real gamma;
  Real activity;
  constant Integer vH=3;
algorithm

  psatW := Modelica.Media.Water.IF97_Utilities.BaseIF97.Basic.psat(Tsat);
  Ysat[2] := (Xsat[2]/MMX[2]*vH)/((Xsat[2]/MMX[2]*vH)+(Xsat[1]/MMX[1]));
  Ysat[1] := 1-Ysat[2];
  gamma := exp(Ysat[2]*((Ysat[2]-(-1.195 + 0.002513*(298-Tsat)))+(Ysat[2]*(-19.31-0.01843*(298-Tsat)))));
  activity :=gamma*Ysat[1];
  psat :=activity*psatW;

  annotation (Documentation(info="<html>
<p>Calculation of Saturation pressure according to the set of equations used by Claudio Koller (2018).</p>
<p>The model is based on the saturation pressure of pure water according to Wagner & Pruss (1993) 
corrected with an activity coefficient of unknown provenance</p>

<h4>References</h4>

<dl><dt>C. Koller:</dt>
<dd><b>Property Model for MgCl2</b><br>
MATLAB-Code developed at ZHAW not published yet (2018)<br>
</dd></dl>
<dl><dt>W. Wagner and A. Pruss:</dt>
<dd><b>International Equations for the Saturation Properties of Ordinary Water Substance. 
Revised According to the International Temperature Scale of 1990. Addendum to J. Phys. Chem. Ref. Data 16, 893 (1987)</b><br>
Journal of Physical and Chemical Reference Data 22, p. 783-787 (1993)<br>
DOI: <a href=\"http://dx.doi.org/10.1063/1.555926\">10.1063/1.555926</a>
</dd></dl>
</html>", revisions="<html>
<p>first implementation Wang, 2019</p>
</html>"));
end saturationPressure;
