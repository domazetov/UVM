`ifndef EQ_VERIF_PKG_SV
 `define EQ_VERIF_PKG_SV

package eq_verif_pkg;

 import uvm_pkg::*;            
 `include "uvm_macros.svh"     
   
 `include "eq_config.sv"
 `include "seq_items/axil_frame.sv"
 `include "seq_items/axis_frame.sv"

 `include "eq_axis_driver.sv"
 `include "eq_axil_driver.sv"
 `include "sequencers/axis_sequencer.sv"
 `include "sequencers/axil_sequencer.sv"
 `include "eq_axis_monitor.sv"
 `include "eq_axil_monitor.sv"
 `include "eq_axil_agent.sv"
 `include "eq_axis_agent.sv"
 `include "eq_scoreboard.sv"
 `include "eq_env.sv"

 `include "sequences/eq_seq_lib.sv"
 `include "tests/eq_test_lib.sv"

endpackage : eq_verif_pkg

 `include "eq_if.sv"

`endif

