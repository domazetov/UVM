`ifndef AXIS_FRAME_SV
 `define AXIS_FRAME_SV

class axis_frame extends uvm_sequence_item;

	bit [31:0]			axis_master_data;
	bit [31:0]			axis_slave_data;

    // constraints

	`uvm_object_utils_begin(axis_transaction)
		`uvm_field_int(axis_master_data , UVM_DEFAULT)
		`uvm_field_int(axis_slave_data , UVM_DEFAULT)
	`uvm_object_utils_end

   function new(string name = "axis_frame");
      super.new(name);
   endfunction 

endclass : axis_frame

`endif

