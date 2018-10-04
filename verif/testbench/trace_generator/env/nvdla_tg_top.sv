//
// Component: XXX
//
// Description:
/// @file 
/// XXX
//
`include "nvdla_tg_common.svh"
`include "nvdla_tg_base_test.sv"
`include "nvdla_test_suite.sv"

module nvdla_tg_top;
    
    initial begin
      	run_test("nvdla_tg_base_test");
    end

endmodule
