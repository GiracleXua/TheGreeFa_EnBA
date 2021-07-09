within BrineGrid.Fluid.Absorbers.Data;
record Nelson_2002
  extends BaseClasses.GeneralAdiabaticData(
    final isCircular=true,
    final diameter=0.24,
    final length=0.1,
    final width=0.1,
    final height=0.6,
    final a=210,
    final epsilon=0.9,
    final deq=0.01);

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(
          preserveAspectRatio=false)),
    Documentation(info="<html>
    <p>the geomerty of absorber in Nelson Fumo et al. (2002).</p>
</html>"));

end Nelson_2002;
