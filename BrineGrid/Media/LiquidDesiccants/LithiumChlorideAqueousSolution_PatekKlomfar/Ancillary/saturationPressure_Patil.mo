within BrineGrid.Media.LiquidDesiccants.LithiumChlorideAqueousSolution_PatekKlomfar.Ancillary;
function saturationPressure_Patil
  "Calculation of the saturation pressure according to the equation of Patil"
  extends Modelica.Icons.Function;
  input Temperature Tsat "Saturation temperature";
  input MassFraction[nX] Xsat "Saturation composition";
  output AbsolutePressure psat "Saturation pressure";
protected
  Real A;
  Real B;
  Real C;
  Real m(unit="mol/kg");
  constant Modelica.SIunits.MolarMass MM=0.042394;
algorithm
  m := Xsat[Desiccant]/(Xsat[Water]*MM);
  A := 7.3233550 - 0.0623661*m + 0.0061613*m^2 - 0.0001042*m^3;
  B := -1718.1570 + 8.2255*m - 2.2131*m^2 + 0.0246*m^3;
  C := -97575.680 + 3839.979*m - 421.429*m^2 + 16.731*m^3;
  psat := 1000*10^(A + B/Tsat + C/Tsat^2);
end saturationPressure_Patil;
