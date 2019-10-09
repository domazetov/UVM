`ifndef EQ_AXIS_MONITOR_SV
`define EQ_AXIS_MONITOR_SV

class eq_axis_monitor extends uvm_monitor;

    // control fileds
    bit checks_enable = 1;
    bit coverage_enable = 1;

    uvm_analysis_port #(axis_frame) item_collected_port;

    axis_frame frame_sl;
    axis_frame frame_ma;

    int unsigned num_transactions_sl = 0;
    int unsigned num_transactions_ma = 0;

    `uvm_component_utils_begin(eq_axis_monitor)
        `uvm_field_int(checks_enable, UVM_DEFAULT)
        `uvm_field_int(coverage_enable, UVM_DEFAULT)
    `uvm_component_utils_end

    // The virtual interface used to drive and view HDL signals.
    virtual interface axis_if vif;//use svm interface here !!!

    // current transaction
    axis_frame current_frame;//use svm_frame here

    // coverage can go here
    // ...

    function new(string name = "eq_axis_monitor", uvm_component parent = null);
        super.new(name,parent);
        item_collected_port = new("item_collected_port", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        if (!uvm_config_db#(virtual axis_if)::get(this, "*", "axis_if", vif))
            `uvm_fatal("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"})
    endfunction : connect_phase

    extern virtual task run_phase(uvm_phase phase);
    extern virtual task collect_transactions_sl();
    extern virtual task collect_transactions_ma();
    extern virtual function void report_phase(uvm_phase phase);

endclass : eq_axis_monitor

task eq_axis_monitor::run_phase(uvm_phase phase);
    forever begin
        @(posedge vif.rst);
        `uvm_info(get_type_name(), "Reset dropped", UVM_MEDIUM)

        fork
            collect_transactions_sl(); 
            collect_transactions_ma();
            @(negedge vif.rst);
        join_any
        disable fork;
    end
endtask : run_phase

// monitor axis interface and collect transactions
task eq_axis_monitor::collect_transactions_sl();
    forever begin
        frame_sl = axis_frame::type_id::create("frame_sl");

        // collect transactions only for this slave
        @(posedge vif.clk);

		if(vif.m00_axis_tvalid && vif.m00_axis_tready)
			frame_sl.axis_slave_data = vif.m00_axis_tdata;

        item_collected_port.write(frame_sl); // TLM

        //`uvm_info(get_type_name(), $sformatf("Tr collected :\n%s", tr_collected.sprint()), UVM_MEDIUM)
        num_transactions_sl++;
    end // forever
endtask : collect_transactions_sl


task eq_axis_monitor::collect_transactions_ma();
    forever begin
        frame_ma = axis_frame::type_id::create("frame_ma");

        // collect transactions only for this master
        @(posedge vif.clk);

		if(vif.s01_axis_tvalid && vif.s01_axis_tready)
			frame_ma.axis_master_data = vif.s01_axis_tdata;

        item_collected_port.write(frame_ma); // TLM

        //`uvm_info(get_type_name(), $sformatf("Tr collected :\n%s", tr_collected.sprint()), UVM_MEDIUM)
        num_transactions_ma++;
    end // forever
endtask : collect_transactions_ma

// UVM report_phase
function void eq_axis_monitor::report_phase(uvm_phase phase);
    // final report
    //`uvm_info(get_type_name(), $sformatf("Report: AXIS monitor collected %0d transfers", num_transactions), UVM_LOW);
endfunction : report_phase



`endif

