`ifndef _MEM_COMMAND_SV_
`define _MEM_COMMAND_SV_

// Class:RN |  memory_type  |  base_addr    |  size |  pattern  |  N.A
// MEM_INIT_FILE    |  memory_type  |  base_addr    |  N.A  |  pattern  |  file_path
//--------------------------------------------------
//mem_load ( sec_mem, 0x8000, "python/over/perl.dat");
//mem_init ( sec_mem, 0x5000, 0x2000, ALL_ZERO);
//mem_init ( pri_mem, 0x2000, "python/over/perl.dat", RANDOM);
class memory_model_command extends uvm_sequence_item;
   kind_e          kind;
   memory_type_e   memory_type;
   uint64_t        base_address;
   uint64_t        size;
   string          pattern;
   string          file_path;
       `uvm_object_utils_begin(memory_model_command)
	          `uvm_field_enum(kind_e,        kind,        UVM_ALL_ON)
	          `uvm_field_enum(memory_type_e, memory_type, UVM_ALL_ON)
	          `uvm_field_int(base_address,                UVM_ALL_ON)
	          `uvm_field_int(size,                        UVM_ALL_ON)
	          `uvm_field_string(pattern,                  UVM_ALL_ON)
	          `uvm_field_string(file_path,                UVM_ALL_ON)
	      `uvm_object_utils_end
   function new(string name="mem_model_cmd");

      super.new(name);

   endfunction // new
endclass: memory_model_command

// Class: result checker command
//  usage: trace parser to result checker
//  usage: result checker to memory model
//--------------------------------------------------
// kind             | sync_id   | memory_type   | base_addr     | size  | crc   | file_path
// CHECK_NOTHING    |  sync_id  |  N.A          |  N.A          |  N.A  |  N.A  |  N.A
// CHECK_CRC        |  sync_id  |  memory_type  |  base_addr    |  size | crc   |  N.A
// CHECK_FILE       |  sync_id  |  memory_type  |  base_addr    |  size |  N.A   | file_path
//--------------------------------------------------
class result_checker_command extends uvm_sequence_item;
   kind_e          kind;
   string          sync_id;
   memory_type_e   memory_type;
   uint64_t        base_address;
   uint64_t        size;
   uint64_t        golden_crc;
   string          golden_file_path;
       `uvm_object_utils_begin(result_checker_command)
	          `uvm_field_enum(kind_e,  kind,      UVM_ALL_ON)
	          `uvm_field_string(sync_id,          UVM_ALL_ON)
	          `uvm_field_enum(memory_type_e, memory_type, UVM_ALL_ON)
	          `uvm_field_int(base_address,        UVM_ALL_ON)
	          `uvm_field_int(size,                UVM_ALL_ON)
	          `uvm_field_int(golden_crc,          UVM_ALL_ON)
	          `uvm_field_string(golden_file_path, UVM_ALL_ON)
	      `uvm_object_utils_end
   function new(string name="result_checker_cmd");

      super.new(name);

   endfunction // new
endclass: result_checker_command

`endif
