within BrineGrid.Media.LiquidDesiccants.LithiumBromideAqueousSolution_PatekKlomfar.Ancillary;
record Coefficients "Coefficients for ancillary equations (psat)"
  extends Modelica.Icons.Record;
  // Saturation pressure
  final constant Real[8] a_p={-2.41303e2,1.91750e7,-1.75521e8,3.25430e7,
      3.92571e2,-2.12626e3,1.85127e8,1.91216e3};
  final constant Real[8] m_p={3,4,4,8,1,1,4,6};
  final constant Real[8] n_p={0,5,6,3,0,2,6,0};
  final constant Real[8] t_p={0,0,0,0,1,1,1,1};
  final constant Real[6] b_p={-7.85951783,1.84408259,-11.7866497,22.6807411,-15.9618719,
      1.80122502};
  final constant Real[6] c_p={1.0,1.5,3.0,3.5,4.0,7.5};
end Coefficients;
