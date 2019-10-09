`ifndef EQ_AXIS_MASTER_SEQ_SV
`define EQ_AXIS_MASTER_SEQ_SV

class eq_axis_master_seq extends eq_axis_base_seq;

	bit[23:0] a,b; 
	bit[47:0] c;
	int previous;
	int current;
	int total;
	int input_cnt;//
	int first;
	int input_ptr;//

    // UVM factory registration
    `uvm_object_utils(eq_axis_master_seq)

	`include "sequences/input.sv"

    // new - constructor
	function new(string name = "eq_axis_master_seq");
		super.new(name);
	endfunction : new

	task set_data(input integer first_t, previous_t, current_t, total_t);
		first = first_t;
		previous = previous_t;
		current = current_t;
		total = total_t;

		`uvm_info(get_type_name(), $sformatf("***Axi stream write sequence set_data done \n"), UVM_HIGH)
		print_data();
	endtask : set_data

	task reset_data();
		a = 0;
		b = 0;
		c = 0;
		previous = 0;
		current = 0;
		total = 0;
		input_cnt = 0;
		first = 0;
		input_ptr = 0;
	endtask

    // sequence generation logic in body
    virtual task body();
		`uvm_info(get_type_name(), $sformatf("***Starting axi stream write sequence started \n"), UVM_HIGH)
		print_data();
		nn_start_layer(previous,total);
    endtask : body

	extern task nn_start_layer(input integer previous, total);
	extern task load_weights(input integer n);
	extern task load_input(input integer n);
	extern task print_data();

endclass : eq_axis_master_seq

`endif

task eq_axis_master_seq::load_input(input integer n);

	input_cnt=0;
	while(input_cnt!=n) begin//input
		req = axis_frame::type_id::create("req");
		start_item(req);

		a = x_re[input_ptr];
		b = x_im[input_ptr];
		c = {b,a};
		req.axis_master_data = c;
		`uvm_info(get_type_name(), $sformatf("Sent input %d c = {b,a} -> %X \n",input_cnt,c), UVM_HIGH)
		input_cnt += 1;
		input_ptr += 1;
		finish_item(req);
	end
endtask

task eq_axis_master_seq::nn_start_layer(input integer previous, total);
	`uvm_info(get_type_name(), $sformatf("\nnumber of loaded input = %d\n",total), UVM_HIGH)


	repeat(current/total) begin
		load_input(total);
	end
endtask

task eq_axis_master_seq::print_data();
	`uvm_info(get_type_name(), $sformatf("\n a = %X \n b = %X \n c = %X \n previous = %d \n total = %d \n input_cnt = %d \n first = %d \n input_ptr = %d \n",a,b,c,previous,total,input_cnt,first,input_ptr), UVM_HIGH)
endtask
