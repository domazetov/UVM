`ifndef EQ_IF_SV
`define EQ_IF_SV
parameter integer DATA_WIDTH = 24;
parameter integer AMPLIFICATION_WIDTH = 24;
parameter integer BOUNDARIES_WIDTH = 11;
parameter integer PACKAGE_LENGTH = 1024;
parameter integer C_S00_AXIL_DATA_WIDTH = 32;
parameter integer C_S00_AXIL_ADDR_WIDTH = 7;

interface axil_if (input clk, logic rst);
   //Axi Lite
   logic [C_S00_AXIL_ADDR_WIDTH - 1 : 0]  s00_axil_awaddr;
   logic                                  s00_axil_awvalid;
   logic                                  s00_axil_awready;
   logic [C_S00_AXIL_DATA_WIDTH - 1 : 0]  s00_axil_wdata;
   logic                                  s00_axil_wvalid;
   logic                                  s00_axil_wready;
   logic                                  s00_axil_bvalid;
   logic                                  s00_axil_bready;

endinterface : axil_if

interface axis_if (input clk, logic rst);
	//Axi Stream Slave
   logic                                 s01_axis_tready;
   logic [2*DATA_WIDTH - 1 : 0]          s01_axis_tdata;
   logic                                 s01_axis_tvalid;

   //Axi Stream Master
   logic                                 m00_axis_tvalid;
   logic [2*DATA_WIDTH - 1 : 0]          m00_axis_tdata;
   logic                                 m00_axis_tready;   

   
endinterface : axis_if

`endif

