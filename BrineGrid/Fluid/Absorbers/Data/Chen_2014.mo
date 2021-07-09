within BrineGrid.Fluid.Absorbers.Data;
record Chen_2014 "Absorber data from Chen et. al 2014"
  extends BaseClasses.GeneralAdiabaticData(
    final isCircular=false,
    final diameter=1.0,
    final length=0.5,
    final width=0.5,
    final height=0.5,
    final a=450,
    final epsilon=0.9,
    final deq=7.85e-3);
  annotation (Documentation(revisions="<html>
<ul>
<li>
February 21, 2017, by Yannick Fuerst:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>Absorber data according to Chen et al. 2014.</p>
<h4>References</h4>
<dl><dt>Chen, Y., Yin, Y., Zhang, X.:</dt>
<dd><b>Performance analysis of a hybrid air-conditioning system dehumidified by liquid desiccant with low temperature and low concentration </b></br>
</dd><dd>Energy and Buildings 77, p. 91-102 (2014)</br>
</dd><dd>DOI: <a href=\"http://dx.doi.org/10.1016/j.enbuild.2014.03.050\">10.1016/j.enbuild.2014.03.050</a> </dd>
</dl></html>
"));
end Chen_2014;
