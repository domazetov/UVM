`ifndef EQ_VERIF_TOP_SV
`define EQ_VERIF_TOP_SV

module eq_verif_top#
  ( parameter integer DATA_WIDTH = 24,
    parameter integer AMPLIFICATION_WIDTH = 24,
    parameter integer BOUNDARIES_WIDTH = 11,
    parameter integer PACKAGE_LENGTH = 1024,
    parameter integer C_S00_AXIL_DATA_WIDTH = 32,
    parameter integer C_S00_AXIL_ADDR_WIDTH = 7
   )
   ();
   
   import uvm_pkg::*;            // import the UVM library
   `include "uvm_macros.svh"     // Include the UVM macros

   import eq_verif_pkg::*;
   
   logic             axi_aclk = 0;
   logic             axi_aresetn;

   // interface
   axil_if axil_vif(axi_aclk, axi_aresetn);//if svm interface is needed this is the place you should instantiate it
   axis_if axis_vif(axi_aclk, axi_aresetn);
   
   // DUT
   top_module #
      (
         .DATA_WIDTH(DATA_WIDTH),
         .AMPLIFICATION_WIDTH(AMPLIFICATION_WIDTH),
         .BOUNDARIES_WIDTH(BOUNDARIES_WIDTH),
         .PACKAGE_LENGTH(PACKAGE_LENGTH),
         .C_S00_AXIL_DATA_WIDTH(C_S00_AXIL_DATA_WIDTH),
         .C_S00_AXIL_ADDR_WIDTH(C_S00_AXIL_ADDR_WIDTH)
      )
      dut
      (
         .s00_axil_awaddr    	      ( axil_vif.s00_axil_awaddr ),
         .s00_axil_awvalid 			( axil_vif.s00_axil_awvalid ),
         .s00_axil_awready       	( axil_vif.s00_axil_awready ),
         .s00_axil_wdata    	      ( axil_vif.s00_axil_wdata ),
         .s00_axil_wvalid    	      ( axil_vif.s00_axil_wvalid ),
         .s00_axil_wready  	      ( axil_vif.s00_axil_wready ),
         .s00_axil_bvalid     	   ( axil_vif.s00_axil_bvalid ),
         .s00_axil_bready        	( axil_vif.s00_axil_bready ),

         .s01_axis_tready 	         ( axis_vif.s01_axis_tready ),
         .s01_axis_tdata            ( axis_vif.s01_axis_tdata ),
         .s01_axis_tvalid        	( axis_vif.s01_axis_tvalid ),

         .m00_axis_tvalid    		   ( axis_vif.m00_axis_tvalid ),
         .m00_axis_tdata   	      ( axis_vif.m00_axis_tdata ),
         .m00_axis_tready           ( axis_vif.m00_axis_tready ),
         
         .axi_aclk                  ( axi_aclk ),
         .axi_aresetn               ( axi_aresetn )
      ); 

   initial begin
      uvm_config_db#(virtual axil_if)::set(null,"uvm_test_top.*","axil_if", axil_vif);
      uvm_config_db#(virtual axis_if)::set(null,"uvm_test_top.*","axis_if", axis_vif);
      run_test();
   end

   // clock and reset init.
   initial begin

      axi_aclk <= 0;
      axi_aresetn <= 0;
      #50 axi_aresetn <= 1;
   end

   // clock generation
   always #50 axi_aclk = ~axi_aclk;

endmodule : eq_verif_top

