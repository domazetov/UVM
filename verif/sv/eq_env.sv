`ifndef EQ_ENV_SV
 `define EQ_ENV_SV

class eq_env extends uvm_env;

   eq_axis_agent axis_agent;
   eq_axil_agent axil_agent;
   eq_scoreboard scbd;
   eq_config cfg;
   
   `uvm_component_utils (eq_env)

   function new(string name = "eq_env", uvm_component parent = null);
      super.new(name,parent);
   endfunction

   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      axis_agent = eq_axis_agent::type_id::create("axis_agent", this);
      axil_agent = eq_axil_agent::type_id::create("axil_agent", this);
      scbd = eq_scoreboard::type_id::create("scbd", this);
      if(!uvm_config_db#(eq_config)::get(this, "", "eq_config", cfg))
        `uvm_fatal("NOCONFIG",{"Config object must be set for: ",get_full_name(),".cfg"})
   endfunction : build_phase

   function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      axis_agent.axis_mon.item_collected_port.connect(scbd.port_axis);
      axil_agent.axil_mon.item_collected_port.connect(scbd.port_axil);      
   endfunction : connect_phase

endclass : eq_env

`endif


