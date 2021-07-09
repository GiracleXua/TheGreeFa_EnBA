within BrineGrid.Media.LiquidDesiccants.MagnesiumChloride_aqueous_solution_MgCl2_H2O.Thermodynamics;
record Coefficients
  "Coefficients for the calculation of state variables of lithium chloride aqueous solution"
  extends Modelica.Icons.Record;

  //Solubility of MgCl2
   // final constant Real[5] a_k={0.4222,0.0499,-1.4109,0.0000,0.0000}; //C = 0.209%
   // final constant Real[5] b_k={0.9768,-8.4015,37.3257,-52.5927,0.0000}; //C = 0.209-0.297%
   // final constant Real[5] c_k={-1.0287,8.4567,-12.3217,0.0000,0.0000}; //C = 0.297-0.345%
   //   final constant Real[5] d_k={-7.4482,52.4158,-115.6476,86.4544,0.0000};//C = 0.345-0.474%
   //final constant Real[5] e_k={-16.5854,93.7050,-170.2631,103.7241,0.0000};//C = 0.474-0.563%
   //final constant Real[5] f_k={-15.0170,74.9304,-121.0804,66.8022,0.0000};//C = 0.563 -%

   final constant Real[6] a_k={0.4222,0.9768,1.0287,-7.4482,-16.5854,-15.0170};
   final constant Real[6] b_k={0.0499,-8.4015,8.4567,52.4158,93.7050,74.9304};
   final constant Real[6] c_k={-1.4109,37.3257,-12.3217,-115.6476,-170.2631,-121.0804};
   final constant Real[6] d_k={0.0000,-52.5927,0.0000,86.4544,103.7241,66.8022};
   final constant Real[6] e_k={0.0000,0.0000,0.0000,0.0000,0.0000};

  // Lithium bromide aqueous solution

  // Specific entropy
  final constant Real[29] a_s={1.53091,-4.52564,6.98302e2,-2.16664e4,-1.47533e3,
      8.47012e-2,-6.59523,-2.95331e4,9.56314e-3,-1.88679e-1,9.31752,5.78104,
      1.38931e4,-1.71762e4,4.15108e2,-5.55647e4,-4.23409e-3,3.05242e1,-1.67620,
      1.48283e1,3.03055e-3,-4.01810e-2,1.49252e-1,2.59240,-1.77421e-1,-6.99650e-5,
      6.05007e-4,-1.65228e-3,1.22966e-3};
  final constant Real[29] m_s={1,1,2,3,6,1,3,5,1,2,2,4,5,5,6,6,1,3,5,7,1,1,1,2,
      3,1,1,1,1};
  final constant Real[29] n_s={0,1,6,6,2,0,0,4,0,0,4,0,4,5,2,5,0,4,0,1,0,2,4,7,
      1,0,1,2,3};
  final constant Real[29] t_s={0,0,0,0,0,1,1,1,2,2,2,2,2,2,2,2,3,3,3,3,4,4,4,4,
      4,5,5,5,5};

  // Liquid water IF95
  // Density
  final constant Real[6] b_d={1.99274064,1.09965342,-0.510839303,-1.75493479,-45.5170352,
      -6.7469445e5};
  final constant Real[6] c_d={1/3,2/3,5/3,16/3,43/3,110/3};
  // Specific enthalpy
  final constant Real[4] b_h={-4.37196e-1,3.03440e-1,-1.29582,-1.76410e-1};
  final constant Real[4] c_h={1/3,2/3,5/6,21/6};
  // Specific entropy
  final constant Real[4] b_s={-3.34112e-1,-8.47987e-1,-9.11980e-1,-1.64046};
  final constant Real[4] c_s={1/3,1,8/3,8};
  // Specific heat capacity
  final constant Real[5] b_cp={1.38801,-2.95318,3.18721,-0.645473,9.18946e5};
  final constant Real[5] c_cp={0,2,3,6,34};
  final constant Real[5] d_cp={0,2,3,5,0};
  // Saturation pressure
  final constant Real[6] b_p={-7.85951783,1.84408259,-11.7866497,22.6807411,-15.9618719,
      1.80122502};
  final constant Real[6] c_p={1.0,1.5,3.0,3.5,4.0,7.5};
end Coefficients;
