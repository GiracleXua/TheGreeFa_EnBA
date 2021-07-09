within BrineGrid.Media.LiquidDesiccants.LithiumChlorideAqueousSolution_PatekKlomfar.Ancillary;
function saturationPressure_ChaudhariPatil
  "Calculation of the saturation pressure according to the equation of Chaudhari and Patil"
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
  A := 8.202988 - 0.1353801*m + 0.017922*m^2 - 0.0005392*m^3;
  B := -1727.8 + 58.3845*m - 10.208*m^2 + 0.3125*m^3;
  C := -95014.0 - 4701.526*m + 929.081*m^2 - 31.766*m^3;
  psat := 1000*10^(-2.12 + A + B/Tsat + C/Tsat^2);
end saturationPressure_ChaudhariPatil;
