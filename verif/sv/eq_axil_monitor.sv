`ifndef EQ_AXIL_MONITOR_SV
`define EQ_AXIL_MONITOR_SV
class eq_axil_monitor extends uvm_monitor;

   // control fileds
   bit checks_enable = 1;
   bit coverage_enable = 1;
   bit [31:0] address;
   
   uvm_analysis_port #(axil_frame) item_collected_port;

   `uvm_component_utils_begin(eq_axil_monitor)
      `uvm_field_int(checks_enable, UVM_DEFAULT)
      `uvm_field_int(coverage_enable, UVM_DEFAULT)
   `uvm_component_utils_end

   // The virtual interface used to drive and view HDL signals.
   virtual interface axil_if vif;

   // current transaction
   axil_frame current_frame;

   // coverage can go here
   
   covergroup write_address;
      option.per_instance = 1;
      write_address: coverpoint address{
         bins write_address_bin = {0};
      }
      data_write_cpt: coverpoint vif.s00_axil_wdata {
         bins start_0 = {0};
         bins start_1 = {1};         
      }
   endgroup // write_read_address
     
   // ----------------------------------------------
   function new(string name = "eq_axil_monitor", uvm_component parent = null);
      super.new(name,parent);
      item_collected_port = new("item_collected_port", this);
      write_address = new();  
   endfunction

   function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      if (!uvm_config_db#(virtual axil_if)::get(this, "*", "axil_if", vif))
        `uvm_fatal("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"})
      
   endfunction : connect_phase

   task run_phase(uvm_phase phase);     
      forever begin

         current_frame = axil_frame::type_id::create("current_frame", this);
         @(posedge vif.clk)begin
            if(vif.s_axi_awready )begin
//               `uvm_info(get_name(), $sformatf("write address: %d", vif.s_axi_awaddr), UVM_LOW)
               address = vif.s00_axi_awaddr;               
               write_address.sample();
            end
      end
      end
   endtask : run_phase

endclass : eq_axil_monitor

`endif

