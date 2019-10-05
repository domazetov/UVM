`ifndef EQ_CONFIG_SV
`define EQ_CONFIG_SV

class eq_config extends uvm_object;

   uvm_active_passive_enum is_active = UVM_ACTIVE;
   
   `uvm_object_utils_begin (eq_config)
      `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
   `uvm_object_utils_end

   function new(string name = "eq_config");
      super.new(name);
   endfunction

endclass : eq_config

`endif


