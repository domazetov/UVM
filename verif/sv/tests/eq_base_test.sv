`ifndef EQ_BASE_TEST_SV
`define EQ_BASE_TEST_SV

class eq_base_test extends uvm_test;

    eq_env env;
    eq_config cfg;

    `uvm_component_utils(eq_base_test)

    function new(string name = "eq_base_test", uvm_component parent = null);
        super.new(name,parent);
    endfunction : new
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = eq_env::type_id::create("env", this);
        cfg = eq_config::type_id::create("cfg");
        uvm_config_db#(eq_config)::set(this, "*", "eq_config", cfg);
    endfunction : build_phase

    function void end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);
        uvm_top.print_topology();
    endfunction : end_of_elaboration_phase

endclass : eq_base_test

`endif

