within BrineGrid.Media.LiquidDesiccants.LithiumChlorideAqueousSolution_PatekKlomfar.Ancillary;
function saturationPressure_PatekKlomfar
  "Calculation of the saturation pressure according to the equation of Patek and Klomfar"
  extends Modelica.Icons.Function;
  input Temperature Tsat "Saturation temperature";
  input MassFraction[:] Xsat "Saturation composition";
  output AbsolutePressure psat "Saturation pressure";
protected
  MassFraction[nX] Xfull=if size(Xsat, 1) == nX then Xsat else cat(
        1,
        Xsat,
        {1 - sum(Xsat)});
  MoleFraction[nX] Ysat=massToMoleFractions(Xfull, MMX);
  MolarEnergy omega;
  MolarEnergy mu;
  AbsolutePressure psat_iter;
  Integer iter=0;
  Boolean stop=false;
  constant Integer nSumW=size(Thermodynamics.GibbsCoeff.aWG, 1);
  constant Real[nSumW] aW=Thermodynamics.GibbsCoeff.aWG;
  constant Real[nSumW] nW=Thermodynamics.GibbsCoeff.nWG;
  constant Real[nSumW] mW=Thermodynamics.GibbsCoeff.mWG;
  constant SpecificHeatCapacity R=Modelica.Constants.R "Specific gas constant";
  constant Temperature T_crit=reference.criticalTemperature;
  constant AbsolutePressure p_crit=reference.criticalPressure;
  constant Real tolerance=1e-10;
  constant Integer iter_max=200;
  Real pi(unit="1") "Reduced pressure";
  Real tau(unit="1")=T_crit/Tsat "Inverse reduced temperature";
  Real delta(unit="1")=Ysat[Desiccant]/(1 - Ysat[Desiccant]);
algorithm
  //Modelica.Utilities.Files.remove("debug.txt");
  psat := 101325 "Start value";
  pi := psat/p_crit;
  mu := Thermodynamics.mu(
    p=psat,
    T=Tsat,
    X=Xsat);
  omega :=  R*Tsat*(aW[2]*log(tau) + sum(aW[i]*tau^nW[i]*pi^mW[i] for i in 3:nSumW));
  while ((stop == false) and (iter < iter_max)) loop
    iter := iter + 1;
    psat_iter := p_crit*exp((mu - omega)/(R*Tsat));
    //Modelica.Utilities.Streams.print(" ", "debug.txt");
    //Modelica.Utilities.Streams.print("psat_iter: " + String(psat_iter), "debug.txt");
    pi := psat_iter/p_crit;
    mu := Thermodynamics.mu(
      p=psat,
      T=Tsat,
      X=Xsat);
    omega := R*Tsat*(aW[2]*log(tau) + sum(aW[i]*tau^nW[i]*pi^mW[i] for i in 3:nSumW));
    if (abs(psat - psat_iter) < tolerance) then
      stop := true;
    end if;
    psat := psat_iter;
  end while;
  //annotation (Inline=true, derivative=saturationPressure_der_PatekKlomfar);
end saturationPressure_PatekKlomfar;
