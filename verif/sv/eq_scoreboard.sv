`ifndef EQ_SCOREBOARD_SV
 `define EQ_SCOREBOARD_SV
`uvm_analysis_imp_decl(_axis)
`uvm_analysis_imp_decl(_axil)
class eq_scoreboard extends uvm_scoreboard;

	//control fields
	bit 		 checks_enable 	= 1;
	bit 		 coverage_enable	= 1;
	int 		 num_of_tr;
	int 		 num_of_tr_moduo_42;
	int 		 status_re; 
	int 		 status_im; 
	logic [47:0] temp_result; 
	logic [23:0] temp1; 
	logic [23:0] temp2; 
	real 		 dut_result_re;
	real 		 dut_result_im;
	real 		 expected_result_re; 
	real 		 expected_result_im; 
	real 		 p = 0.5;

	//*****ERROR TOLERANCE
	logic[23:0]  error_tolerance = 24'b000000000010000011000101;
	real 		 error_tolerance_f = bin2real(error_tolerance);

	int 		 y_re_expected = $fopen("../sv/IP_output_re.txt", "r");
	int          y_im_expected = $fopen("../sv/IP_output_im.txt", "r");

	// This TLM port is used to connect the scoreboard to the monitor
	uvm_analysis_imp#(axis_frame, eq_scoreboard) item_collected_imp;

	`uvm_component_utils_begin(eq_scoreboard)
		`uvm_field_int(checks_enable, UVM_DEFAULT)
		`uvm_field_int(coverage_enable, UVM_DEFAULT)
	`uvm_component_utils_end
    	
	function new(string name = "eq_scoreboard", uvm_component parent = null);
		super.new(name,parent);
		item_collected_imp = new("item_collected_imp", this);
	endfunction : new

	function write (input axis_frame fr);
		axis_frame fr_clone;
		assert($cast(tr_clone, fr.clone()));

		if(checks_enable) begin
			status_re = $fscanf(y_re_expected,"%f",expected_result_re); //izmena
			if(status_re != 1) $error("*E:	Error while opening file IP_output_re \n"); //izmena

			status_im = $fscanf(y_im_expected,"%f",expected_result_im); //izmena
			if(status_im != 1) $error("*E:	Error while opening file IP_output_im \n"); //izmena


			temp_result	= tr_clone.axis_slave_data;
			temp1 = temp_result & 48'b000000000000000000000000111111111111111111111111; //izmena
			temp2 = temp_result >> 24; //izmena
			dut_result_re	= bin2real(temp1); //izmena
			dut_result_im	= bin2real(temp2); //izmena

			num_of_tr_moduo_42 = 1; // OVDE CEMO MENJATI KADA UBACIMO DA IMA VISE PAKETA JER SADA RADI SA 1024 VREDNOSTI ODNOSNO 1 PAKETOM

			asrt_check_result_re: assert((dut_result_re >= (expected_result_re-error_tolerance_f))&&(dut_result_re <= (expected_result_re+error_tolerance_f))) //izmena
				$display("**************TEST PASS - PACKAGE_NUMBER: %0d - FRAME: %0d - Expected: %0d -  Result: %0d **************\n \n ", num_of_tr_moduo_42, num_of_tr, expected_result_re, dut_result_re); //izmena
			else
			begin
				$warning("*W:	********TEST FAIL - PACKAGE_NUMBER: %0d - FRAME: %0d - Expected: %0d -  Result: %0d \n \n ", num_of_tr_moduo_42, num_of_tr, expected_result_re, dut_result_re); //izmena
				//$finish;
			end
			
			asrt_check_result_im: assert((dut_result_im >= (expected_result_im-error_tolerance_f))&&(dut_result_im <= (expected_result_im+error_tolerance_f))) //izmena 
				$display("**************TEST PASS - PACKAGE_NUMBER: %0d - FRAME: %0d - Expected: %0d -  Result: %0d **************\n \n ", num_of_tr_moduo_42, num_of_tr, expected_result_im, dut_result_im);//izmena
			else
			begin
				$warning("*W:	********TEST FAIL - Picture: %0d - Neuron: %0d - Expected: %0d -  Result: %0d \n \n ", num_of_tr_moduo_42, num_of_tr, expected_result_im, dut_result_im);//izmena
				//$finish;
			end

			num_of_tr++;
		end
	endfunction : write

	function real bin2real(input logic[23:0] x); //IZMENJENA CELA FUNKCIJA
		logic sign;

		if (x[23]==1'b0)
			sign = 1'b0;
		else
			sign = 1'b1;

		bin2real = 0; // mislim i da ovo ne pise da bi bio 0
		if(!sign)
		begin
			for(int i =22; i >=0; i++)
				bin2real += x[i]*p;
				p = p/2;
		end
		else
		begin
			x = x - 'b000000000000000000000001;
			for(int i =22; i >-1; i++)
				bin2real -= ~x[i]*p;
				p = p/2;
		end	
		endfunction

	function void report_phase(uvm_phase phase);
		`uvm_info(get_type_name(), $sformatf("Calc scoreboard examined: %0d	transactions", num_of_tr), UVM_LOW);
	endfunction : report_phase

endclass : eq_scoreboard


`endif

