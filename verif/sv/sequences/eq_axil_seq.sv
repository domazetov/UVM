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
		`uvm_info(get_type_name(), $sformatf("AXI LITE SLAVE Sequence started \n"), UVM_HIGH)

		repeat(19) begin
			req = axil_frame::type_id::create("req");

			start_item(req);

			case(n)
				0: begin
						req.axil_awaddr	<= n;
						req.axil_wdata 	<= 32'b100011111111010110011; 		//p1
				end
				1: begin
						req.axil_awaddr	<= n;
						req.axil_wdata 	<= 32'b100011111111010110011; 		//p2
				end
				2: begin
						req.axil_awaddr	<= n;
						req.axil_wdata 	<= 32'b100011111111010110011;			//p3
				end
				3: begin
						req.axil_awaddr	<= n;
						req.axil_wdata 	<= 32'b101111111111100100010;			//p4
				end
				4: begin
						req.axil_awaddr	<= n;
						req.axil_wdata 	<= 32'b1000000000000000000000;			//p5
				end
				5: begin
						req.axil_awaddr	<= n;
						req.axil_wdata 	<= 32'b1010101010110000110101;			//p6
				end
				6: begin
						req.axil_awaddr	<= n;
						req.axil_wdata 	<= 32'b1110001110011110101010;			//p7
				end
				7: begin
						req.axil_awaddr	<= n;
						req.axil_wdata 	<= 32'b1110001110011110101010;			//p8
				end	
				8: begin
						req.axil_awaddr	<= n;
						req.axil_wdata 	<= 32'b1110001110011110101010;			//p9
				end
				9: begin
						req.axil_awaddr	<= n;
						req.axil_wdata 	<= 32'b1110001110011110101010;			//p10
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
				end
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

