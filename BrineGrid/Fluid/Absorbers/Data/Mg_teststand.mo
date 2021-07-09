within BrineGrid.Fluid.Absorbers.Data;
record Mg_teststand "data of the absorber at teststand"
   extends BaseClasses.GeneralAdiabaticData(
    final isCircular=false,
    final diameter=0.22,
    final length=0.425,
    final width=0.09,
    final height=0.42,
    final a=79.275,
    final epsilon=0.95,
    final deq=0.0399);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(
          preserveAspectRatio=false)),
    Documentation(info="<html>
<p>the geomerty of absorber at test stand of KT</p>
</html>"));
end Mg_teststand;
