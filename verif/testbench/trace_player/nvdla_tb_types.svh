`ifndef __NVDLA_TB_TYPES_SVH__
`define __NVDLA_TB_TYPES_SVH__

import uvm_pkg::*;

`include "uvm_macros.svh"

typedef byte unsigned       uint8_t;
typedef byte                int8_t;
typedef shortint unsigned   uint16_t;
typedef shortint            int16_t;
typedef int unsigned        uint32_t;
typedef int                 int32_t;
typedef longint unsigned    uint64_t;
typedef longint             int64_t;
// define trace parser instruction command enum type
typedef enum { WRITE
               , NOTIFY
               , WAIT
               , READ
               , READ_CHECK
               , POLL_REG_EQUAL
               , POLL_FIELD
               , SINGLE_SHOT
               , MULTI_SHOT
               , CHECK_CRC
               , CHECK_FILE
               , CHECK_NOTHING
               , MEM_LOAD
               , MEM_INIT_PATTERN
               , MEM_INIT_FILE
             } kind_e;

typedef enum { PRIMARY_MEM      = 0,
               SECONDARY_MEM    = 1
             } memory_type_e;

typedef uvm_enum_wrapper#(kind_e)           kind_wrapper;
typedef uvm_enum_wrapper#(memory_type_e)    memory_type_wrapper;

`endif //  `ifndef __NVDLA_TB_TYPES_SVH__

