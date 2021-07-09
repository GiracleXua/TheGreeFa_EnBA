within BrineGrid.Media.LiquidDesiccants.MagnesiumChloride_aqueous_solution_MgCl2_H2O.Ancillary;
function dpT
  "Derivative of saturation pressure p with respect to temperature T"
  extends Modelica.Icons.Function;
  input Temperature Tsat "Saturation temperature";
  input MassFraction[nX] Xsat "Saturation composition";
  output DerPressureByTemperature dpT;
   constant Real[8] t=Coefficients.t_p;
protected
  constant Temperature T_crit=reference.criticalTemperature;
  constant AbsolutePressure p_crit=reference.criticalPressure;
  Temperature Theta;
  Real dThetaT;
  MoleFraction[nX] Ysat;

  Real tem;
  Real x;

  constant Real M_H2O =   18.015/1000;//kg/mol
  constant Real M_salz =  95.211/1000;//kg/mol
  constant Real vH =      3;

  constant Real w = -1.195;
  constant Real r = 0.002513;
  constant Real u = -19.31;
  constant Real p = 0.01843;

  constant Real a = 220.64;
  constant Real b = -7.858230;
  constant Real c = 647.226;
  constant Real d = 1.839910;
  constant Real e = -11.7811;
  constant Real f = 22.6705;
  constant Real g = -15.9393;
  constant Real q = 1.775160;
  Real f1;
  Real f2;
  Real f3;
  Real f4;

algorithm

   x := (Xsat[Desiccant]/M_salz*vH)/((Xsat[Desiccant]/M_salz*vH)+((1-Xsat[Desiccant])/M_H2O));
   tem := 1 - (Tsat/c);

   f1 := (-b/c - (3/(2*c))*d* (sqrt(tem))-(7/(2*c))*f*(tem)^(5/2)-4/c * g *(tem)^(3) - 15/(2*c) * q * (tem)^(13/2)-3/c * e * (1-(Tsat/c))^2);
   f2 := ((c/Tsat)^2*(b*tem+d*tem^(3/2)+f*tem^(7/2)+g*tem^4+q*tem^(15/2)+e*tem^3));
   f3 := ((c/Tsat)*((b*tem+d*tem^(3/2)+f*tem^(7/2)+g*tem^4+q*tem^(15/2)+e*tem^3))+x*(Xsat[Desiccant]+x*(-p*(-Tsat+298)+u)-r*(-Tsat+298)-w));

  dpT := a * (-x + 1) * (((c/Tsat)* f1 - f2 * x*( x * p + r))* exp(f3));

end dpT;
