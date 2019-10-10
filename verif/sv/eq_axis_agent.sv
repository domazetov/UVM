`ifndef EQ_AXIS_AGENT_SV
 `define EQ_AXIS_AGENT_SV

class eq_axis_agent extends uvm_agent;

   eq_axis_driver axis_drv;
   eq_axis_monitor axis_mon;
   axis_sequencer axis_slave_seqr;   
   axis_sequencer axis_master_seqr;   

   eq_config cfg;

   `uvm_component_utils_begin (eq_axis_agent)
      `uvm_field_object(cfg, UVM_DEFAULT)
   `uvm_component_utils_end

   function new(string name = "eq_axis_agent", uvm_component parent = null);
      super.new(name,parent);
   endfunction

   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
	   axis_drv = eq_axis_driver::type_id::create("axis_drv", this);
	   axis_slave_seqr = axis_sequencer::type_id::create("axis_slave_seqr", this);
	   axis_master_seqr = axis_sequencer::type_id::create("axis_master_seqr", this);
	   axis_mon = eq_axis_monitor::type_id::create("axis_monitor", this);
   endfunction : build_phase

   function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      axis_drv.seq_item_port.connect(axis_slave_seqr.seq_item_export);
	  axis_drv.seq_item_port.connect(axis_master_seqr.seq_item_export);
	  
   endfunction : connect_phase

endclass : eq_axis_agent

`endif