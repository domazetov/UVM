`ifndef EQ_AXIS_BASE_SEQ_SV
`define EQ_AXIS_BASE_SEQ_SV

class eq_axis_base_seq extends uvm_sequence#(axis_frame);

    `uvm_object_utils(eq_axis_base_seq)
    `uvm_declare_p_sequencer(axis_sequencer)

    function new(string name = "eq_axis_base_seq");
        super.new(name);
    endfunction

    // objections are raised in pre_body
    virtual task pre_body();
        uvm_phase phase = get_starting_phase();
        if (phase != null)
            phase.raise_objection(this, {"Running sequence '", get_full_name(), "'"});
    endtask : pre_body 

    // objections are dropped in post_body
    virtual task post_body();
        uvm_phase phase = get_starting_phase();
        if (phase != null)
            phase.drop_objection(this, {"Completed sequence '", get_full_name(), "'"});
    endtask : post_body

endclass : eq_axis_base_seq

`endif
