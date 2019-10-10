`ifndef eq_simple_test
 `define eq_simple_test

class eq_simple_test extends eq_base_test;

   `uvm_component_utils(eq_simple_test)

   eq_axil_seq axil_seq;
   eq_axis_slave_seq axis_slave_seq;
   eq_axis_master_seq axis_master_seq;

   function new(string name = "eq_simple_test", uvm_component parent = null);
      super.new(name,parent);
   endfunction : new
   
   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      axil_seq = eq_axil_seq::type_id::create("axil_seq");
      axis_slave_seq = eq_axis_slave_seq::type_id::create("axis_slave_seq");
      axis_master_seq = eq_axis_master_seq::type_id::create("axis_master_seq");
   endfunction : build_phase

   task run_phase(uvm_phase phase);
      phase.raise_objection(this);
      phase.phase_done.set_drain_time(this, 1000);
      fork
	      axil_seq.start(env.axil_agent.axil_seqr);	         	            
	      axis_slave_seq.start(env.axis_agent.axis_slave_seqr);     
         axis_master_seq.start(env.axis_agent.axis_master_seqr);    
	   join_any    
      phase.drop_objection(this);
   endtask : run_phase

endclass : eq_simple_test

`endif

