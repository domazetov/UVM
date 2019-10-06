`ifndef eq_simple_test
 `define eq_simple_test

class eq_simple_test extends eq_base_test;

   `uvm_component_utils(test_svm_dskw_simple_2)

   eq_axil_seq axil_seq;
   eq_axis_seq axis_seq;
   

   function new(string name = "eq_simple_test", uvm_component parent = null);
      super.new(name,parent);
   endfunction : new
   
   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      axil_seq = svm_axil_seq::type_id::create("axil_seq");
      axis_seq = svm_dskw_axis_seq::type_id::create("axis_seq");
   endfunction : build_phase

   task run_phase(uvm_phase phase);
      phase.raise_objection(this);
      phase.phase_done.set_drain_time(this, 1000);
      fork
	      axil_seq.start(env.axil_agent.axil_seqr);	         	            
	      axis_seq.start(env.axis_agent.axis_seqr);         
	   join_any    
      phase.drop_objection(this);
   endtask : run_phase

endclass : eq_simple_test

`endif

