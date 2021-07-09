within BrineGrid.Media.LiquidDesiccants.MagnesiumChloride_aqueous_solution_MgCl2_H2O.Ancillary;
function saturationTemperature "Calculation of the saturation temperature"
  extends Modelica.Icons.Function;
  input AbsolutePressure psat "Saturation pressure";
  input MassFraction[nX] Xsat "Saturation composition";
  output Temperature Tsat "Saturation temperature";
protected
  Temperature T_min;
  Temperature T_max;
  Temperature T_iter;
  AbsolutePressure RES_p;
  AbsolutePressure RES_min;
  AbsolutePressure RES_max;
  DerPressureByTemperature dpT "(dp_sat/dT)";
  Integer iter=0;
  constant Real tolerance=1e-9 "Relative tolerance for RES_p";
  constant Integer iter_max=200;
algorithm
  T_min := 0.99*fluidLimits.TMIN;
  T_max := 1.01*fluidLimits.TMAX;
  T_iter := (T_min + T_max)/2;
  // min
  RES_min := Ancillary.saturationPressure(
    Tsat=T_min,
    Xsat=Xsat) - psat;
  // max
  RES_max := Ancillary.saturationPressure(
    Tsat=T_max,
    Xsat=Xsat) - psat;
  // iter
  RES_p := Ancillary.saturationPressure(
    Tsat=T_iter,
    Xsat=Xsat) - psat;
  assert((RES_min*RES_max < 0), "setSat_pX: p_min and p_max did not bracket the root", level=AssertionLevel.warning);
  // thighten the bounds
  if (RES_p*RES_min < 0) then
    T_max := T_iter;
    RES_max := RES_p;
  elseif (RES_p*RES_max < 0) then
    T_min := T_iter;
    RES_min := RES_p;
  end if;
  while ((abs(RES_p/psat) > tolerance) and (iter < iter_max)) loop
    iter := iter + 1;
    dpT := Ancillary.dpT(
      Tsat=T_iter,
      Xsat=Xsat);
    T_iter := T_iter - RES_p/dpT;
    if (T_iter < T_min) or (T_iter > T_max) then
      T_iter := (T_min + T_max)/2;
    end if;
    RES_p := Ancillary.saturationPressure(
      Tsat=T_iter,
      Xsat=Xsat) - psat;
    // thighten the bounds
    if (RES_p*RES_min < 0) then
      T_max := T_iter;
      RES_max := RES_p;
    elseif (RES_p*RES_max < 0) then
      T_min := T_iter;
      RES_min := RES_p;
    end if;
  end while;
  Tsat := T_iter;
end saturationTemperature;
