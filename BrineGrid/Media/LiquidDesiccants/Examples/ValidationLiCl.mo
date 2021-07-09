within BrineGrid.Media.LiquidDesiccants.Examples;
model ValidationLiCl "Validation of the lithium chloride medium model"
  extends BaseClasses.PartialValidation(
    redeclare package Medium =
        LiquidDesiccants.LithiumChlorideAqueousSolution_PatekKlomfar,
    T=350,
    p=101325,
    Y={0.88,0.12});
  Medium.BaseProperties base_nonlin;
  Medium.ThermodynamicState state_nonlin;
equation
  base_nonlin.h = base.h;
  base_nonlin.p = p;
  base_nonlin.X[1] = X[1];

  state_nonlin = Medium.setState_phX(p=p, h=base.h, X=X);
  annotation (Documentation(revisions="<html>
<ul>
<li>
January 04, 2017, by Yannick Fuerst:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>This model helps validating the media model of lithium chloride (LiCl) aqueous solution with reference values.</p>
</html>"));
end ValidationLiCl;
