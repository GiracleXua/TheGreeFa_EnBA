within BrineGrid.Media.LiquidDesiccants.MagnesiumChloride_aqueous_solution_MgCl2_H2O.Thermodynamics;
function h "Calculate specific enthalpy h from temperature T and composition X"
  extends Modelica.Icons.Function;
  //input AbsolutePressure p "Pressure";
  input Temperature T "Temperature";
  input MassFraction[nX] X "Composition";
  output SpecificEnthalpy h "Specific enthalpy";

protected
  constant Temperature T_crit=reference.criticalTemperature;
  constant Temperature T_ref=reference.referenceTemperature;
  constant MolarEnthalpy h_crit=reference.criticalMolarEnthalpy;
  MolarEnthalpy hM_W "Molar enthalpy of water";
  MolarMass MM;
  MoleFraction[nX] Y;
  Real polyWater;
  Real polyBrine;

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

 constant Real dHv1 =    2257;// J/kg
 constant Real Tsp =     373;
 constant Real M_H2O =   18.001;//kg/mol
 constant Real Tk =      647;
 constant Real T0= 273.15;

  Real h0;
  Real h1;
  Real h2;
  Real h3;
  Real h4;
  Real h5;
  Real h_t;
  Real h_0;
algorithm

 // Y := massToMoleFractions(X=X, MMX=MMX);
  MM := molarMass_X(X=X);

  h_t:= (a*m*T+ a*T*exp(-g*X[Desiccant]) +(a*T^(p+1))/(p+1) -b*m*n*T -b*n*T*exp(-g*X[Desiccant]) - (b*n*T^(p+1))/(p+1)
  + (b*T^(p+2))/(p+2)+c*m*n^2*T +c*n^2*T*exp(-g*X[Desiccant])+ (c*n^2*T^(p+1))/(p+1)- (2*c*n*T^(p+2))/(p+2)+
   (c*T^(p+3))/(p+3)-d*m*n^3*T-d*n^3*T*exp(-g*X[Desiccant])- (d*n^3*T^(p+1))/(p+1)+ (3*d*n^2*T^(p+2))/(p+2)-
    (3*d*n*T^(p+3))/(p+3)+ (d*T^(p+4))/(p+4)+(f*k*T^6)/6+f*m*n^4*T+f*n^4*T* exp(-g*X[Desiccant])+ (f*n^4*T^(p+1))/(p+1)-
    (4*f*n^3*T^(p+2))/(p+2)+ (6*f*n^2*T^(p+3))/(p+3)- (4*f*n*T^(p+4))/(p+4)+ (f*T^(p+5))/(p+5)+T^5*((d*k)/5 -
    (4/5)*f*k*n + (f*m)/5 + (f/5) *exp(-g*X[Desiccant]))+T^4*((c*k)/4 - (3/4)*d*k*n + (d*m)/4 + (d/4) *exp(-g*X[Desiccant]) + (3/2)*f*k*n^2
    - f*m*n - f*n*exp(-g*X[Desiccant]))+T^3*((b*k)/3 - (2/3)*c*k*n + (c*m)/3+(c/3) *exp(-g*X[Desiccant]) + d*k*n^2 - d*m*n - d*n*exp(-g*X[Desiccant])
    -(4/3)*f*k*n^3 + 2*f*m*n^2 + 2*f*n^2*exp(-g*X[Desiccant]))+T^2*((a*k)/2 - ((b*k)/2)*n + (b*m)/2 +  (b/2) *exp(-g*X[Desiccant]) + ((c*k)/2)*n^2
     - c*m*n - c*n* exp(-g*X[Desiccant]) - (d*k/2)*n^3 +(3/2)*d*m*n^2+
     (3/2)*d*n^2*exp(-g*X[Desiccant])+((f*k)/2)*n^4-(2*f*m*n^3) -2*f*n^3*exp(-g*X[Desiccant])))*1000;

      h_0:= (a*m*T0+ a*T0*exp(-g*X[Desiccant]) +(a*T0^(p+1))/(p+1) -b*m*n*T0 -b*n*T0*exp(-g*X[Desiccant]) - (b*n*T0^(p+1))/(p+1)
  + (b*T0^(p+2))/(p+2)+c*m*n^2*T0 +c*n^2*T0*exp(-g*X[Desiccant])+ (c*n^2*T0^(p+1))/(p+1)- (2*c*n*T0^(p+2))/(p+2)+
   (c*T0^(p+3))/(p+3)-d*m*n^3*T0-d*n^3*T0*exp(-g*X[Desiccant])- (d*n^3*T0^(p+1))/(p+1)+ (3*d*n^2*T0^(p+2))/(p+2)-
    (3*d*n*T0^(p+3))/(p+3)+ (d*T0^(p+4))/(p+4)+(f*k*T0^6)/6+f*m*n^4*T0+f*n^4*T0* exp(-g*X[Desiccant])+ (f*n^4*T0^(p+1))/(p+1)-
    (4*f*n^3*T0^(p+2))/(p+2)+ (6*f*n^2*T0^(p+3))/(p+3)- (4*f*n*T0^(p+4))/(p+4)+ (f*T0^(p+5))/(p+5)+T0^5*((d*k)/5 -
    (4/5)*f*k*n + (f*m)/5 + (f/5) *exp(-g*X[Desiccant]))+T0^4*((c*k)/4 - (3/4)*d*k*n + (d*m)/4 + (d/4) *exp(-g*X[Desiccant]) + (3/2)*f*k*n^2
    - f*m*n - f*n*exp(-g*X[Desiccant]))+T0^3*((b*k)/3 - (2/3)*c*k*n + (c*m)/3+(c/3) *exp(-g*X[Desiccant]) + d*k*n^2 - d*m*n - d*n*exp(-g*X[Desiccant])
    -(4/3)*f*k*n^3 + 2*f*m*n^2 + 2*f*n^2*exp(-g*X[Desiccant]))+T0^2*((a*k)/2 - ((b*k)/2)*n + (b*m)/2 +  (b/2) *exp(-g*X[Desiccant]) + ((c*k)/2)*n^2
     - c*m*n - c*n* exp(-g*X[Desiccant]) - (d*k/2)*n^3 +(3/2)*d*m*n^2+
     (3/2)*d*n^2*exp(-g*X[Desiccant])+((f*k)/2)*n^4-(2*f*m*n^3) -2*f*n^3*exp(-g*X[Desiccant])))*1000;

     h := h_t - h_0;

  annotation (
    Inline=true,
    smoothOrder=2,
    inverse=T0_test(h, X));
end h;
