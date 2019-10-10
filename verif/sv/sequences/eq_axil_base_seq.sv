`ifndef EQ_AXIL_BASE_SEQ_SV
`define EQ_AXIL_BASE_SEQ_SV

class eq_axil_base_seq extends uvm_sequence#(axil_frame);

    `uvm_object_utils(eq_axil_base_seq)
    `uvm_declare_p_sequencer(axil_sequencer)

    function new(string name = "eq_axil_base_seq");
        super.new(name);
    endfunction

    // Use a base sequence to raise/drop objections if this is a default sequence
	virtual task pre_body();
	if (starting_phase != null)
	starting_phase.raise_objection(this, {"Running sequence '",
	get_full_name(), "'"});
	endtask

	virtual task post_body();
	if (starting_phase != null)
	starting_phase.drop_objection(this, {"Completed sequence '",
	get_full_name(), "'"});
	endtask

endclass : eq_axil_base_seq

`endif

