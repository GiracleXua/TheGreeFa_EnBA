within BrineGrid.Media.LiquidDesiccants.MagnesiumChlorideAqueousSolution.Thermodynamics;
function T
  "Return temperature as a function of pressure p, specific enthalpy h and composition X"
  extends Modelica.Icons.Function;
  input Modelica.SIunits.SpecificEnthalpy h "specific enthalpy";
  input Modelica.SIunits.MassFraction[:] X "mass fractions of composition";
  output Modelica.SIunits.Temperature T "temperature";
protected
  MassFraction[nX] Xfull=if size(X, 1) == nX then X else cat(
      1,
      X,
      {1 - sum(X)});
  Temperature T_min;
  Temperature T_max;
  Temperature T_iter;
  SpecificEnthalpy RES_h;
  SpecificEnthalpy RES_min;
  SpecificEnthalpy RES_max;
  DerEnthalpyByTemperature dhT "(dh/dT)";
  Integer iter=0;
  constant Real tolerance=1e-9 "Relative tolerance for RES_h";
  constant Integer iter_max=200;
algorithm
  //Modelica.Utilities.Files.remove("debug.txt");
  //Modelica.Utilities.Streams.print(" ", "debug.txt");
  //Modelica.Utilities.Streams.print("LiBr: setState_phX input was p=" + String(p) + ", h=" + String(h) + " and X={" + String(Xfull[Water]) + ", " + String(Xfull[Desiccant]) + "}", "debug.txt");
  T_min := 1.01*fluidLimits.TMIN;
  T_max := 0.99*fluidLimits.TMAX;
  T_iter := (T_min + T_max)/2;
  // min
  RES_min := Thermodynamics.h(
    T=T_min,
    X=Xfull) - h;
  // max
  RES_max := Thermodynamics.h(
    T=T_max,
    X=Xfull) - h;
  // iter
  RES_h := Thermodynamics.h(
    T=T_iter,
    X=Xfull) - h;
  assert((RES_min*RES_max < 0), "setState_phX: h_min and h_max did not bracket the root", level=AssertionLevel.warning);
  // thighten the bounds
  if (RES_h*RES_min < 0) then
    T_max := T_iter;
    RES_max := RES_h;
  elseif (RES_h*RES_max < 0) then
    T_min := T_iter;
    RES_min := RES_h;
  end if;
  while ((abs(RES_h/h) > tolerance) and (iter < iter_max)) loop
    iter := iter + 1;
    dhT := Thermodynamics.dhT(
      T=T_iter,
      X=Xfull);
    T_iter := T_iter - RES_h/dhT;
    if (T_iter < T_min) or (T_iter > T_max) then
      Modelica.Utilities.Streams.print("T_iter out of bounds, fallback to bisection method, step=" + String(iter) + ", T_iter=" + String(T_iter) + ", input was h=" + String(h) + " and X={" + String(Xfull[Water]) + ", " + String(Xfull[Desiccant]) + "}", "printlog.txt");
      T_iter := (T_min + T_max)/2;
    end if;
    RES_h := Thermodynamics.h(
      T=T_iter,
      X=Xfull) - h;
    // thighten the bounds
    if (RES_h*RES_min < 0) then
      T_max := T_iter;
      RES_max := RES_h;
    elseif (RES_h*RES_max < 0) then
      T_min := T_iter;
      RES_min := RES_h;
    end if;
    Modelica.Utilities.Streams.print("T_min=" + String(T_min) + ", T_max=" + String(T_max) + " and T_iter=" + String(T_iter), "printlog.txt");
  end while;
  Modelica.Utilities.Streams.print("setState_phX required " + String(iter) + " iterations to find T=" + String(T_iter) + " for input h=" + String(h) + " and X={" + String(Xfull[Water]) + ", " + String(Xfull[Desiccant]) + "}", "printlog.txt");
  assert(iter < iter_max, "setState_phX did not converge, input was h=" + String(h) + " and X={" + String(Xfull[Water]) + ", " + String(Xfull[Desiccant]) + "}");
  T := T_iter;
  annotation (
    smoothOrder=2,
    inverse(h = Thermodynamics.h(T=T, X=X)));
end T;
