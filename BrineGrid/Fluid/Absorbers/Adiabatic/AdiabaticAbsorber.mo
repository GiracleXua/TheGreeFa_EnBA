within BrineGrid.Fluid.Absorbers.Adiabatic;
model AdiabaticAbsorber
  "Adiabatic absorber with global calculation of heat and mass transfer coefficients"
  extends BaseClasses.PartialAbsorber;
  annotation (defaultComponentName="adiAbs", Documentation(revisions="<html>
<ul>
<li>
January 04, 2017, by Yannick Fuerst:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>This model is able to predict the thermodynamic behaviour of an adiabatic absorber used in air dehumification and regeneration processes. It is not fixed to specific configurations, but can be used for cubic or cylindrical absorber systems with the parameter <code>isCircular</code>. </p>
<p>The parameter <code>flowConf</code> defines the flow configuration between the moist air and the aqueous solution. Possible values are <b>direct, counter</b> or <b>cross current flow</b>. </p>
<p>Media models for aqueous solutions can be found in the package <a href=\"modelica://BrineGrid.Media.LiquidDesiccants\">BrineGrid.Media.LiquidDesiccants</a>. Currently available are media models for lithium chloride and lithium bromide aqueous solution. </p>
<p>Several heat and mass transfer correlations for adiabatic absorbers can be found in the package <a href=\"modelica://BrineGrid.HeatTransfer.Convection.Absorption\">BrineGrid.HeatTransfer.Convection.Absorption</a> and <a href=\"modelica://BrineGrid.MassTransfer.Convection.Absorption\">BrineGrid.MassTransfer.Convection.Absorption</a>, respectively. </p>
<p>A detailed description of the adiabatic absorber can be found in <a href=\"modelica://BrineGrid/Resources/Images/Fluid/MassExchangers/Absorbers/2016_BauSIM_Fuerst.pdf\">Fuerst, Kriegel (2016)</a>. </p>
<h4>References</h4>
<dl><dt>Fuerst, Y., Kriegel, M.:</dt>
<dd><b>Adiabatic Absorber Model For The Liquid Desiccant Distribution Network At The Technology Park Berlin Adlershof Using Modelica</b></dd><dd>Proceedings of the CESBP Central European Symposium on Building Physics and BauSIM 2016, p. 661-668, Dresden (2016). </dd>
</dl></html>"));
end AdiabaticAbsorber;
