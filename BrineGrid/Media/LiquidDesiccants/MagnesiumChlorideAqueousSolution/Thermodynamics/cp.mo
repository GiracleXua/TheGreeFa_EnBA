within BrineGrid.Media.LiquidDesiccants.MagnesiumChlorideAqueousSolution.Thermodynamics;
function cp
  "Calculate specific heat capacity cp from temperature T and composition X"
  extends Modelica.Icons.Function;
  //input AbsolutePressure p "Pressure";
  input Temperature T "Temperature";
  input MassFraction[nX] X "Composition";
  output SpecificHeatCapacity cp "Specific heat capacity";
protected
  Modelica.SIunits.SpecificHeatCapacity cp_W "Specific heat capacity of water";
  Modelica.SIunits.AbsolutePressure psat_W=
      Modelica.Media.Water.IF97_Utilities.BaseIF97.Basic.psat(T);
  Real theta;
  Real factor_cp;
algorithm
  theta :=T/228 - 1;
  cp_W := 88.79 -120.196*theta^0.02 -16.926*theta^0.04 + 52.4654 * theta^0.06 + 0.10826 * theta^1.8 + 0.46988 * theta^8;
  factor_cp := exp(1.148*X[Desiccant])+(-7.316-0.005528*T+T^0.3264)*X[Desiccant];
  cp := cp_W*factor_cp;
  annotation (Documentation(info="<html>
<p>Specific heat capacity mostly according to Koller (2018). The heat capacity of pure water is calculated by IAPWS IF 97 data and not in accordance with Conde (2004) as in the original concept.</p>

<h4>References</h4>

<dl><dt>C. Koller:</dt>
<dd><b>Property Model for MgCl2</b><br>
MATLAB-Code developed at ZHAW not published yet (2018)<br>
</dd></dl>
<dl><dt>Conde, M. R.:</dt>
<dd><b>Properties of aqueous solutions of lithium and calcium chlorides: formulations for use in air conditioning equipment design</b><br>
International Journal of Thermal Sciences 43, p. 367-382 (2004)<br>
DOI: <a href=\"https://doi.org/10.1016/j.ijthermalsci.2003.09.003\">10.1016/j.ijthermalsci.2003.09.003</a>
</dd></dl>
</html>"));
end cp;
