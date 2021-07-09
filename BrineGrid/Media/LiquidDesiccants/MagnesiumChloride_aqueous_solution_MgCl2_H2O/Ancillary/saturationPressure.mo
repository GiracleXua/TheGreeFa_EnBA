within BrineGrid.Media.LiquidDesiccants.MagnesiumChloride_aqueous_solution_MgCl2_H2O.Ancillary;
function saturationPressure
  "Calculation of the saturation pressure according to the equation of Patek and Klomfar"
  extends Modelica.Icons.Function;
  input Temperature Tsat "Saturation temperature";
    input MassFraction[nX] Xsat "Saturation composition";
  output AbsolutePressure psat "Saturation pressure";

//  constant Real[6] b=Coefficients.b_p;
 // constant Real[6] c=Coefficients.c_p;
 // constant Real[8] a=Coefficients.a_p;
 // constant Real[8] m=Coefficients.m_p;
 // constant Real[8] n=Coefficients.n_p;
  constant Real[8] t=Coefficients.t_p;
protected
  constant Temperature T_crit=reference.criticalTemperature;
  constant AbsolutePressure p_crit=reference.criticalPressure;
  MoleFraction[nX] Ysat;
  Temperature Theta;
  Real polyWater;
  Real polyBrine;

  Real pv_H2O;
  Real x;
  Real gamma;
  Real activity;
  Real ps_H2O;

  MolarMass MM;

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

algorithm

  x := (Xsat[Desiccant]/M_salz*vH)/((Xsat[Desiccant]/M_salz*vH)+((1-Xsat[Desiccant])/M_H2O));
  gamma    := exp(x*((Xsat[Desiccant]-(-1.195+0.002513*(298-Tsat)))+(x*(-19.31-0.01843*(298-Tsat)))));
  activity := gamma * (1-x);

  pv_H2O := a*exp(((b)*(1-Tsat/c)+(d)*(1-Tsat/c)^1.5+(e)*(1-Tsat/c)^3
  +(f)*(1-Tsat/c)^3.5+(g)*(1-Tsat/c)^4+(q)*(1-Tsat/c)^7.5)/(1-(1-Tsat/c)));

  ps_H2O  := pv_H2O * 1000;
  psat := activity * ps_H2O*100;

end saturationPressure;
