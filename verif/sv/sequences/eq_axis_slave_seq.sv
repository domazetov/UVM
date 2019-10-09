`ifndef EQ_AXIS_SLAVE_SEQ_SV
`define EQ_AXIS_SLAVE_SEQ_SV

class eq_axis_slave_seq extends eq_axis_base_seq;

    `uvm_object_utils(eq_axis_slave_seq)
	bit[23:0]  x_re[24]; 
	bit[23:0]  x_im[24];
	int 		cnt_output_reg;		
	int 		num_curr_layer;
	int i = 0;

	function new(string name = "eq_axis_slave_seq");
		super.new(name);
	endfunction : new

	function void set_data(int num_curr_layer_t);
		num_curr_layer = num_curr_layer_t;
		`uvm_info(get_type_name(), $sformatf("\n***Axi stream read sequence set_data done\nnum_curr_layer = %d\n",num_curr_layer), UVM_HIGH)
	endfunction : set_data

	function void get_data(output bit[23:0] x_re_t[24], output bit[23:0] x_im_t[24]);
		x_re_t	=	x_re;
		x_im_t	=	x_im;
	endfunction : get_data

	task reset_data();
		cnt_output_reg = 0;
		num_curr_layer = 0;
		for(i=0;i<24;i++)
			x_re[i] = 0;
			x_im[i] = 0;
	endtask

    virtual task body(); 

		for(i=0;i<24;i++)
			x_re[i] = 0;
			x_im[i] = 0;

		cnt_output_reg = 0;

		`uvm_info(get_type_name(), $sformatf("\nAxi stream read sequence data to be read out = %d\n",num_curr_layer), UVM_HIGH)

		while(cnt_output_reg!=num_curr_layer) begin
			req = axis_frame::type_id::create("req");
			start_item(req);

			finish_item(req);
			get_response(req);
			if(cnt_output_reg<24)
			begin
				x_re[cnt_output_reg] = req.axis_slave_data;
			end
			else if(cnt_output_reg>=24)
			begin
				x_im[cnt_output_reg] = req.axis_slave_data;
			end
			`uvm_info(get_type_name(), $sformatf("\nreq.axis_slave_data = %X\nAxi stream data which is read next_layer_inputs[%d] = %X\n",req.axis_slave_data,cnt_output_reg,x_re[cnt_output_reg],x_im[cnt_output_reg]), UVM_HIGH)

			cnt_output_reg++;
		end

    endtask : body

endclass : eq_axis_slave_seq

`endif
