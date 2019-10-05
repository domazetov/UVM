`ifndef EQ_AXIS_DRIVER_SV
`define EQ_AXIS_DRIVER_SV

class eq_axis_driver extends uvm_driver#(axis_frame);

   `uvm_component_utils(eq_axis_driver)

   // The virtual interface used to drive and view HDL signals.
   virtual interface axis_if vif;

   function new(string name = "eq_axis_driver", uvm_component parent = null);
      super.new(name,parent);
   endfunction

   function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      if (!uvm_config_db#(virtual axis_if)::get(this, "*", "axis_if", vif))
        `uvm_fatal("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"})
   endfunction : connect_phase

   extern virtual task run_phase(uvm_phase phase);
   extern virtual task get_and_drive_sl();
   extern virtual task get_and_drive_ma();
   extern virtual task reset();
   extern virtual task drive_slave (axis_frame sl);
   extern virtual task drive_master (axis_frame ma);
   extern virtual task force_reset ();
   
endclass : eq_axis_driver

task eq_axis_driver::run_phase(uvm_phase phase);
    reset(); 
    forever begin
        fork
            get_and_drive_sl();
            get_and_drive_ma();
            @(negedge vif.rst); 
        join_any
        disable fork;

        reset();
    end
endtask : run_phase   

task eq_axis_driver::reset();
    vif.s01_axis_tdata      <= 0;
    vif.s01_axis_tvalid     <= 0;
    vif.m00_axis_tready     <= 0;
    @(posedge vif.rst); 
endtask : reset

task eq_axis_driver::get_and_drive_sl();
   forever begin
      seq_item_port.get_next_item(req);

      drive_slave(req);

      seq_item_port.item_done();
   end
endtask : get_and_drive

task axis_slave_driver::get_and_drive_ma();
   forever begin
      seq_item_port.get_next_item(req);

      drive_master(req);

      seq_item_port.item_done();
		seq_item_port.put_response(req);
   end
endtask : get_and_drive

task eq_axis_driver::drive_slave (axis_frame sl);

	int n;

	//n = $urandom_range(1,100);
	n = 1;

	@(posedge vif.clk)

	repeat(n) begin //Used for random moments of sending data
		@(posedge vif.clk)
		vif.s01_axis_tvalid <= 1'b0;
	end

	vif.s01_axis_tvalid <= 1'b1;

	wait(vif.s01_axis_tvalid);
	vif.s01_axis_tdata  <=  tr.axis_master_data;

	wait(vif.s01_axis_tready == 1'b1);

	@(posedge vif.clk);
	vif.s01_axis_tvalid <= 0;
endtask : drive_tr

task eq_axis_driver::drive_master (axis_frame ma);

	@(posedge vif.clk);
	vif.m00_axis_tready = 1'b1;

	@(posedge vif.clk);
	wait(vif.m00_axis_tvalid)
	tr.axis_slave_data = vif.m00_axis_tdata;

	`uvm_info(get_type_name(), $sformatf("\n***Axi stream slave driver read data -> %d\n",vif.m00_axis_tdata), UVM_HIGH)

	@(posedge vif.clk);
	@(posedge vif.clk);
	vif.m00_axis_tready = 0;
endtask : drive_tr

task eq_axis_driver::force_reset();
	@(posedge vif.clk)
    	vif.rst <= 0;

	@(posedge vif.clk)
	@(posedge vif.clk)
	@(posedge vif.clk)
		vif.rst <= 1;
endtask : reset

`endif

