within BrineGrid.Media.LiquidDesiccants.Examples;
model ValidationLiBr "Validation of the lithium bromide medium model"
  extends BaseClasses.PartialValidation(
    redeclare package Medium =
        LiquidDesiccants.LithiumBromideAqueousSolution_PatekKlomfar,
    T=300,
    p=101325,
    Y={0.9,0.1});
  Medium.BaseProperties base_nonlin;
  Medium.ThermodynamicState state_nonlin;

  Medium.SaturationProperties sat_pX;
  Medium.Temperature Tsat;
  Medium.ThermodynamicState state_test;
equation
  Tsat = Medium.saturationTemperature(psat=psat, Xsat=sat_TX.Xsat);
  sat_pX = Medium.setSat_pX(psat=psat, Xsat=X);

  base_nonlin.h = base.h;
  base_nonlin.p = p;
  base_nonlin.X[1] = X[1];

  state_nonlin = Medium.setState_phX(p=p, h=base.h, X=X);
  state_test = Medium.setState_pTX(p=p, T=T, X={0.651, 0.349});
  annotation (Documentation(revisions="<html>
<ul>
<li>
January 04, 2017, by Yannick Fuerst:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>This model helps validating the media model of lithium bromide (LiBr) aqueous solution with reference values.</p>
</html>"));
end ValidationLiBr;
