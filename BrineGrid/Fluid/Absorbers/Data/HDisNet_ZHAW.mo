within BrineGrid.Fluid.Absorbers.Data;
record HDisNet_ZHAW
  "data of the absorber in ZHAW demonstator"
  extends BaseClasses.GeneralAdiabaticData(
    final isCircular=true,
    final diameter=0.5,
    final length=0.75,
    final width=0.75,
    final height=1.5,
    final a=350,
    final epsilon=0.91,
    final deq=0.015);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(
          preserveAspectRatio=false)),
    Documentation(info="<html>
    <p>the geomerty of absorber of ZHAW demonstator</p>
</html>"));

end HDisNet_ZHAW;
