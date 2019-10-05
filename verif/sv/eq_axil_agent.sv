`ifndef EQ_AXIL_AGENT_SV
 `define EQ_AXIL_AGENT_SV

class eq_axil_agent extends uvm_agent;

   eq_axil_driver axil_drv;
   eq_axil_monitor axil_mon;
   axil_sequencer axil_seqr;

   eq_config cfg;

   `uvm_component_utils_begin (eq_axil_agent)
      `uvm_field_object(cfg, UVM_DEFAULT)
   `uvm_component_utils_end

   function new(string name = "eq_axil_agent", uvm_component parent = null);
      super.new(name,parent);
   endfunction

   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      axil_drv = eq_axil_driver::type_id::create("axil_drv", this);
      axil_seqr = axil_sequencer::type_id::create("axil_seqr", this);
      axil_mon = eq_axil_monitor::type_id::create("axil_monitor", this);
   endfunction : build_phase

   function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      axil_drv.seq_item_port.connect(axil_seqr.seq_item_export);      
   endfunction : connect_phase

endclass : eq_axil_agent

`endif