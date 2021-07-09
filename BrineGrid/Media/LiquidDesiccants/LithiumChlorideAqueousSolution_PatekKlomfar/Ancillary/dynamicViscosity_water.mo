within BrineGrid.Media.LiquidDesiccants.LithiumChlorideAqueousSolution_PatekKlomfar.Ancillary;
function dynamicViscosity_water
  "Calculation of dynamic viscosity of liquid water"
  extends Modelica.Icons.Function;
  input Temperature T "Temperature";
  output DynamicViscosity eta "Dynamic viscosity";
protected
  constant Temperature T_crit=reference.criticalTemperature;
  constant Density d_crit=reference.criticalMolarDensity*MMX[Water];
  constant DynamicViscosity eta_crit=55.071e-6;
  constant Real[4] H=Coefficients.dynamicViscosityWaterTerm1;
  constant Real[6, 7] G=Coefficients.dynamicViscosityWaterTerm2;
  Real Theta;
  Real Delta;
  Real eta0;
  Real eta1;
algorithm
  Theta := T/T_crit;
  Delta := density_water(T=T)/d_crit;
  eta0 := Theta^(0.5)*sum(H[i]*Theta^(-i + 1) for i in 1:size(H, 1))^(-1);
  eta1 := exp(Delta*sum(sum(G[i, j]*(Theta^(-1) - 1)^(i - 1)*(Delta - 1)^(j - 1)
    for j in 1:size(G, 2)) for i in 1:size(G, 1)));
  eta := eta_crit*eta0*eta1;
end dynamicViscosity_water;
