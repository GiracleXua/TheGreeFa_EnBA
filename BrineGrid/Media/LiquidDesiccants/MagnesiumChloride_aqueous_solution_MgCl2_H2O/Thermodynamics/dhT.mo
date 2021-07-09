within BrineGrid.Media.LiquidDesiccants.MagnesiumChloride_aqueous_solution_MgCl2_H2O.Thermodynamics;
function dhT "Derivative of specific enthalpy h with respect to temperature T"
  extends Modelica.Icons.Function;
  //input AbsolutePressure p "Pressure";
  input Temperature T "Temperature";
  input MassFraction[nX] X "Composition";
  output DerEnthalpyByTemperature dhT;

protected
  constant Temperature T_crit=reference.criticalTemperature;
  constant Temperature T_ref=reference.referenceTemperature;
  constant MolarEnthalpy h_crit=reference.criticalMolarEnthalpy;
  DerEnthalpyByTemperature hM_W "Molar enthalpy of water";

  MolarMass MM;
  MoleFraction[nX] Y;
  Real polyWater;
  Real polyBrine;

 constant Real dHv1 =    2257;
 constant Real Tsp =     373;
 constant Real M_H2O =   18.001;
 constant Real Tk =      647;
 Real nn;

  constant Real g= 1.406;
 constant Real m= -2.388;
 constant Real k= -1.317E-3;
 constant Real p= 0.1792;
 constant Real n= 273.15;

 constant Real a=4.214;
 constant Real b=-2.286*10^(-3);
 constant Real c=4.991*10^(-5);
 constant Real d=-4.519*10^(-7);
 constant Real f=1.857*10^(-9);

algorithm
 // Y := massToMoleFractions(X=X, MMX=MMX);
  MM := molarMass_X(X=X);

 // dhT:=( a* exp(-g*X[Desiccant]) +a*k*T +a*m +a* T^p +b *T*exp(-g*X[Desiccant])+b *T* m + b *T*k * T
 //  + b *T*T^p -(b*n)*exp(-g*X[Desiccant])-(b*n)* m -(b*n)* k * T -(b*n)* T^p+ c*T^2*exp(-g*X[Desiccant])+
 //   c*T^2*m +c*T^2*k * T + c*T^2*T^p - c*2*T*n*exp(-g*X[Desiccant])- c*2*T*n*m -c*2*T*n*k * T -
 //    c*2*T*n*T^p+c*n^2 *exp(-g*X[Desiccant])+ c*n^2 *m +c*n^2 *k * T + c*n^2 *T^p -d*n^3*exp(-g*X[Desiccant])
 //    -d*n^3* m -d*n^3*k * T -d*n^3* T^p+ d*3*n^2*T*exp(-g*X[Desiccant])+ d*3*n^2*T*m +d*3*n^2*T*k * T +
 //     d*3*n^2*T*T^p- d*3*n*T^2*exp(-g*X[Desiccant])- d*3*n*T^2* m - d*3*n*T^2*k * T - d*3*n*T^2* T^p+
  //     d*T^3*exp(-g*X[Desiccant])+ d*T^3*m +d*T^3*k * T + d*T^3*T^p+ f*n^4*exp(-g*X[Desiccant])+ f*n^4*m +f*n^4*k * T
  //      + f*n^4*T^p- f*4*n^3*T*exp(-g*X[Desiccant]) - f*4*n^3*T*m - f*4*n^3*T*k * T  - f*4*n^3*T*T^p+
 //       f*6*n^2*T^2*exp(-g*X[Desiccant])+ f*6*n^2*T^2*m +f*6*n^2*T^2*k * T + f*6*n^2*T^2*T^p- f*4*n*T^3*exp(-g*X[Desiccant])
  //       - f*4*n*T^3*m - f*4*n*T^3*k * T  - f*4*n*T^3*T^p+ f*T^4*exp(-g*X[Desiccant])+ f*T^4*m +f*T^4*k * T + f*T^4*T^p);

   dhT := cp(T=T, X=X);

end dhT;
