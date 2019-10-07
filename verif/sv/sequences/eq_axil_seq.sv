`ifndef EQ_AXIL_SEQ_SV
`define EQ_AXIL_SEQ_SV

class eq_axil_seq extends eq_axil_base_seq;
   int num_of_images = 0;
   int image = 0;   
    `uvm_object_utils (eq_axil_seq)

    function new(string name = "eq_axil_seq");
        super.new(name);
    endfunction

    virtual task body();
      int n = 0;
		int p [10] = '{2097152, 1048576, 524288, 262144, 131072, 65536, 32768, 16384, 8192, 4096};
		
		`uvm_info(get_type_name(), $sformatf("AXI LITE SLAVE Sequence started \n"), UVM_HIGH)

		repeat(19) begin
			req = axil_transaction::type_id::create("req");

			start_item(req);

			req.dir = AXIL_WRITE;

			case(n)
				0: begin
						req.axil_awaddr	<= n;
						req.axil_wdata 	<= 32'd2097152; 		//p1
				end
				1: begin
						req.axil_awaddr	<= n;
						req.axil_wdata 	<= 32'd1048576; 		//p2
				end
				2: begin
						req.axil_awaddr	<= n;
						req.axil_wdata 	<= 32'd524288;			//p3
				end
				3: begin
						req.axil_awaddr	<= n;
						req.axil_wdata 	<= 32'd262144;			//p4
				end
				4: begin
						req.axil_awaddr	<= n;
						req.axil_wdata 	<= 32'd131072;			//p5
				5: begin
						req.axil_awaddr	<= n;
						req.axil_wdata 	<= 32'd65536;			//p6
				end
				6: begin
						req.axil_awaddr	<= n;
						req.axil_wdata 	<= 32'd32768;			//p7
				end
				7: begin
						req.axil_awaddr	<= n;
						req.axil_wdata 	<= 32'd16384;			//p8
				end	
				8: begin
						req.axil_awaddr	<= n;
						req.axil_wdata 	<= 32'd8192;			//p9
				end
				9: begin
						req.axil_awaddr	<= n;
						req.axil_wdata 	<= 32'd4096;			//p10
				end
				10: begin
						req.axil_awaddr	<= n;
						req.axil_wdata 	<= 32'd5;			//pr1
				end
				11: begin
						req.axil_awaddr	<= n;
						req.axil_wdata 	<= 32'd10;			//pr2
				end
				12: begin
						req.axil_awaddr	<= n;
						req.axil_wdata 	<= 32'd19;			//pr3
				end
				13: begin
						req.axil_awaddr	<= n;
						req.axil_wdata 	<= 32'd35;			//pr4
				end
				14: begin
						req.axil_awaddr	<= n;
						req.axil_wdata 	<= 32'd70;			//pr5
				end
				15: begin
						req.axil_awaddr	<= n;
						req.axil_wdata 	<= 32'd117;			//pr6
				end
				16: begin
						req.axil_awaddr	<= n;
						req.axil_wdata 	<= 32'd163;			//pr7
				end
				17: begin
						req.axil_awaddr	<= n;
						req.axil_wdata 	<= 32'd232;			//pr8
				18: begin
						req.axil_awaddr	<= n;
						req.axil_wdata 	<= 32'd348;			//pr9
				end
			endcase

			finish_item(req);
			n++;
		end
    endtask : body 

endclass : eq_axil_seq

`endif

