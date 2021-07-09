within BrineGrid.Media.LiquidDesiccants.MagnesiumChloride_aqueous_solution_MgCl2_H2O.Thermodynamics;
function cp
  "Calculate specific heat capacity cp from temperature T and composition X"
  extends Modelica.Icons.Function;
  //input AbsolutePressure p "Pressure";
  input Temperature T "Temperature";
  input MassFraction[nX] X "Composition";
  output SpecificHeatCapacity cp "Specific heat capacity";

protected
  constant Temperature T_crit=reference.criticalTemperature;
  constant Temperature T_ref=reference.referenceTemperature;
  constant Temperature T_triple=reference.triplePointTemperature;
  constant MolarEntropy s_crit=reference.criticalMolarEntropy;
  constant MolarHeatCapacity cp_triple=reference.triplePointMolarHeatCapacity;

 constant Real cp1= 1.406;
 constant Real cp2= -2.388;
 constant Real cp3= -1.317E-3;
 constant Real cp4= 0.1792;

// constant Real a =       88.79;
// constant Real b =       -120.196;
// constant Real c =       -16.926;
// constant Real d =       52.4654;
 //constant Real e =       0.10826;
// constant Real f =       0.46988;

 // Real O;
  Real cp_water;
  Real f1;
  Real f2;

constant Real p0=4.214;
constant Real p1=-2.286*10^(-3);
constant Real p2=4.991*10^(-5);
constant Real p3=-4.519*10^(-7);
constant Real p4=1.857*10^(-9);

algorithm

// O       :=((T/ 228) - 1);
// cp_water:=a + b*O^0.02 + c*O^0.04 + d*O^0.06 + e*O^1.8 + f*O^8;

 cp_water:= p0+p1*(T-273.15)+p2*(T-273.15)^2+p3*(T-273.15)^3+p4*(T-273.15)^4;

 f1 := exp(-cp1*X[Desiccant]);
 f2 := cp2 + cp3 * T + T^cp4;
 cp := (cp_water *( f1+f2))*1000;

end cp;
