within BrineGrid.Fluid.Absorbers.Data;
record Mg_dempav "data of the absorber in demstration pavillion"
  extends BaseClasses.GeneralAdiabaticData(
    final isCircular=true,
    final diameter=0.288,
    final length=0.75,
    final width=0.75,
    final height=1.1,
    final a=90.644,
    final epsilon=0.95,
    final deq=0.0399);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(
          preserveAspectRatio=false)),
    Documentation(info="<html>
<p>the geomerty of absorber in demonstation pavillion</p>
</html>"));
end Mg_dempav;
