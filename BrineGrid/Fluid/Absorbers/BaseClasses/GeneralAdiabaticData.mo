within BrineGrid.Fluid.Absorbers.BaseClasses;
record GeneralAdiabaticData "General data for adiabatic absorber"
  extends Modelica.Icons.Record;

  parameter Boolean isCircular=false "= true for cylindrical absorber" annotation(Evaluate=true);
  parameter Modelica.SIunits.Length length=1.0 "Length of absorber" annotation(Dialog(enable=not isCircular));
  parameter Modelica.SIunits.Length width=1.0 "Width of absorber" annotation(Dialog(enable=not isCircular));
  parameter Modelica.SIunits.Height height=1.0 "Height of absorber";
  parameter Modelica.SIunits.Diameter diameter=1.0 "Diameter of column" annotation(Dialog(enable=isCircular));
  final parameter Modelica.SIunits.Volume volume=crossArea*height "Volume";
  final parameter Modelica.SIunits.Area crossArea=if isCircular then
    Modelica.Constants.pi*diameter^2/4.0 else length*width
    "Cross sectional area of desiccant flow";
  parameter Modelica.SIunits.Diameter deq=1.0 "Equivalent diameter";
  parameter Real a(unit="m2/m3")=1.0 "Specific area";
  parameter Real epsilon(min=0, max=1)=1.0 "Void fraction";
  final parameter Modelica.SIunits.Area surface=volume*a "Surface area";
  annotation (Documentation(revisions="<html>
<ul>
<li>
February 21, 2017, by Yannick Fuerst:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>Record that holds geometric data of adabatic absorber units.</p>
</html>"));
end GeneralAdiabaticData;
