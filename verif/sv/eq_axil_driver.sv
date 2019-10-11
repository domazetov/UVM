`ifndef EQ_AXIL_DRIVER_SV
 `define EQ_AXIL_DRIVER_SV

class eq_axil_driver extends uvm_driver#(axil_frame);

   `uvm_component_utils(eq_axil_driver)

   // The virtual interface used to drive and view HDL signals.
   virtual interface axil_if vif;

   function new(string name = "eq_axil_driver", uvm_component parent = null);
      super.new(name,parent);
   endfunction

   function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      if (!uvm_config_db#(virtual axil_if)::get(this, "*", "axil_if", vif))
        `uvm_fatal("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"})
   endfunction : connect_phase

   task run_phase(uvm_phase phase);
      @(negedge vif.rst);       
      forever begin
         seq_item_port.get_next_item(req);
         `uvm_info(get_type_name(),
                   $sformatf("Driver sending...\n%s", req.sprint()),
                   UVM_FULL)
         // do actual driving here
	      
	      @(posedge vif.clk)begin//writing using AXIL
            vif.s00_axil_awaddr = req.axil_awaddr;
	         vif.s00_axil_awvalid = 1;
	         vif.s00_axil_wdata = req.axil_wdata;
	         vif.s00_axil_wvalid = 1;
	         vif.s00_axil_bready = 1'b1;	       
	         wait(vif.s00_axil_awready && vif.s00_axil_wready);	       
	         wait(vif.s00_axil_bvalid);
	         vif.s00_axil_wdata = 0;
	         vif.s00_axil_awvalid = 0; 
	         vif.s00_axil_wvalid = 0;
            wait(!vif.s_axil_bvalid);	   
	         vif.s_axil_bready = 0;        
	      end // @ (posedge vif.s_axi_aclk)
	      
	      //end of driving
         seq_item_port.item_done();
      end
   endtask : run_phase

endclass : eq_axil_driver
`endif

