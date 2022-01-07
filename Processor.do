vsim work.Processor_test
add wave -r  *
mem load -i {D:/GitHub/ar-kak-tecture/Memory files/OneOperandMemeory.mem} /processor_test/uut/fetch_unit/instructionmemory/InstructionMemory
run 1500 ps