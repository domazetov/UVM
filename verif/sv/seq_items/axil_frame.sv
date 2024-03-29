`ifndef AXIL_FRAME_SV
 `define AXIL_FRAME_SV

parameter integer C_S00_AXIL_DATA_WIDTH = 32;
parameter integer C_S00_AXIL_ADDR_WIDTH = 7;

class axil_frame extends uvm_sequence_item;

//	logic [C_S00_AXIL_ADDR_WIDTH - 1 : 0]  address;
 //  logic [C_S00_AXIL_DATA_WIDTH - 1 : 0]  data;
   
   logic [C_S00_AXIL_ADDR_WIDTH - 1 : 0]  axil_awaddr;
   logic [C_S00_AXIL_DATA_WIDTH - 1 : 0]  axil_wdata;


   // constraints

	`uvm_object_utils_begin(axil_frame)
		`uvm_field_int(axil_awaddr, UVM_DEFAULT)
      `uvm_field_int(axil_wdata, UVM_DEFAULT)
	`uvm_object_utils_end

   function new(string name = "axil_frame");
      super.new(name);
   endfunction 

endclass : axil_frame

`endif

