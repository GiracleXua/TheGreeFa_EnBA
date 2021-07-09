within BrineGrid.Fluid.Absorbers.Data;
record Koronaki_2013 "Absorber data from Koronaki et. al 2013"
  extends BaseClasses.GeneralAdiabaticData(
    final isCircular=true,
    final diameter=0.1524,
    final length=1.0,
    final width=1.0,
    final height=0.41,
    final a=223,
    final epsilon=0.8,
    final deq=0.0107);
  annotation (Documentation(revisions="<html>
<ul>
<li>
February 21, 2017, by Yannick Fuerst:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>Absorber data according to Koronaki et al. 2013.</p>
<h4>References</h4>
<dl><dt>Koronaki, I. P., Christodoulaki, R. I., Papaefthimiou, V. D., Rogdakis, E. D.:</dt>
<dd><b>Thermodynamic analysis of a counter flow adiabatic dehumidifier with different liquid desiccant materials </b></br>
</dd><dd>Applied Thermal Engineering 50, p. 361-373 (2013)</br>
</dd><dd>DOI: <a href=\"http://dx.doi.org/10.1016/j.applthermaleng.2012.06.043\">10.1016/j.applthermaleng.2012.06.043</a> </dd>
</dl></html>"));
end Koronaki_2013;
