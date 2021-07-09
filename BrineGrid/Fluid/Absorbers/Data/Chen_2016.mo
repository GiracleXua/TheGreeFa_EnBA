within BrineGrid.Fluid.Absorbers.Data;
record Chen_2016 "Absorber data from Chen et. al 2016"
  extends BaseClasses.GeneralAdiabaticData(
    final isCircular=false,
    final diameter=1.0,
    final length=0.75,
    final width=0.75,
    final height=1.5,
    final a=450,
    final epsilon=0.9,
    final deq=0.01);
  annotation (Documentation(revisions="<html>
<ul>
<li>
February 21, 2017, by Yannick Fuerst:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>Absorber data according to Chen et al. 2016.</p>
<h4>References</h4>
<dl><dt>Chen, Y., Zhang, X., Yin, Y.:</dt>
<dd><b>Experimental and theoretical analysis of liquid desiccant dehumidification process based on an advanced hybrid air-conditioning system </b></br>
</dd><dd>Applied Thermal Engineering 98, p. 387-399 (2016)</br>
</dd><dd>DOI: <a href=\"http://dx.doi.org/10.1016/j.applthermaleng.2015.12.066\">10.1016/j.applthermaleng.2015.12.066</a> </dd>
</dl></html>"));
end Chen_2016;
