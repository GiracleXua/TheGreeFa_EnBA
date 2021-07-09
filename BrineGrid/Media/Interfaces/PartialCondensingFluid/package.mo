within BrineGrid.Media.Interfaces;
partial package PartialCondensingFluid "Base class for mixtures of condensing and non-condensing fluids"
  extends Modelica.Media.Interfaces.PartialCondensingGases(
    ThermoStates=Modelica.Media.Interfaces.Choices.IndependentVariables.pTX);

  redeclare replaceable partial function saturationPressure
  "Return saturation pressure of condensing fluid"
    extends Modelica.Icons.Function;
    input Temperature Tsat "Saturation temperature";
    input MassFraction[nX] Xsat=X_default "Saturation composition";
    output AbsolutePressure psat "Saturation pressure";
  end saturationPressure;

  annotation (Documentation(revisions="<html>
<ul>
<li>
January 04, 2017, by Yannick Fuerst:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>This package and is identical to <a href=\"Modelica.Media.Interfaces.PartialCondensingGases\">Modelica.Media.Interfaces.PartialCondensingGases</a>.
The only difference is the redeclaration of
<a href=BrineGrid.Media.Interfaces.PartialCondensingFluid.saturationPressure>BrineGrid.Media.Interfaces.PartialCondensingFluid.saturationPressure</a>
to have <code>X</code> as an addition input.</p>
</html>"));
end PartialCondensingFluid;
