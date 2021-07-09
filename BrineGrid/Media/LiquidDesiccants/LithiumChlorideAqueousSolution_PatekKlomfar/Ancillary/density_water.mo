within BrineGrid.Media.LiquidDesiccants.LithiumChlorideAqueousSolution_PatekKlomfar.Ancillary;
function density_water "Calculation of density of liquid water"
  extends Modelica.Icons.Function;
  input Temperature T "Temperature";
  output Density rho "Density";
protected
  constant Temperature T_crit=reference.criticalTemperature;
  constant Density d_crit=reference.criticalMolarDensity*MMX[Water];
  constant Real[6] a=Coefficients.densityWater;
  Real Theta;
algorithm
  Theta := T/T_crit;
  rho := d_crit*(1 + a[1]*(1 - Theta)^(1/3) + a[2]*(1 - Theta)^(2/3) + a[3]*(1
         - Theta)^(5/3) + a[4]*(1 - Theta)^(16/3) + a[5]*(1 - Theta)^(43/3)
         + a[6]*(1 - Theta)^(110/3));
end density_water;
