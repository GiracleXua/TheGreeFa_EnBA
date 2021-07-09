within BrineGrid.Fluid.Absorbers.Data;
record Zhang_2010 "Absorber data from Zhang et. al 2010"
  extends BaseClasses.GeneralAdiabaticData(
    final isCircular=false,
    final diameter=1.0,
    final length=0.25,
    final width=0.25,
    final height=0.25,
    final a=550,
    final epsilon=0.8,
    final deq=0.0061);
  annotation (Documentation(revisions="<html>
<ul>
<li>
February 21, 2017, by Yannick Fuerst:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>Absorber data according to Zhang et al. 2010.</p>
<h4>References</h4>
<dl><dt>Zhang, L., Hihara, E., Matsuoka, F., Dang, C.:</dt>
<dd><b>Experimental analysis of mass transfer in adiabatic structured packing dehumidifier/regenerator with liquid desiccant </b></br>
</dd><dd>International Journal of Heat and Mass Transfer 53, p. 2856-2863 (2010)</br>
</dd><dd>DOI: <a href=\"http://dx.doi.org/10.1016/j.ijheatmasstransfer.2010.02.012\">10.1016/j.ijheatmasstransfer.2010.02.012</a> </dd>
</dl></html>"));
end Zhang_2010;
