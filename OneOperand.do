vsim work.Processor

add wave -position insertpoint  \
sim:/processor/InPort \
sim:/processor/OutPort \
sim:/processor/clk \
sim:/processor/rst \
sim:/processor/pc_reg_out_sig \
sim:/processor/adder_output_sig \
sim:/processor/cout_sig \
sim:/processor/temp_zero \
sim:/processor/fetched_instruction_buffer_input_fetchstage \
sim:/processor/fetched_instruction_buffer_output_fetchstage \
sim:/processor/fetched_instruction_buffer_output_decodestage \
sim:/processor/memRead_s \
sim:/processor/memToReg_s \
sim:/processor/memWrite_s \
sim:/processor/regWrite_s \
sim:/processor/pop_s \
sim:/processor/push_s \
sim:/processor/fnJmp_s \
sim:/processor/flushDecode_s \
sim:/processor/flushExecute_s \
sim:/processor/memEx_s \
sim:/processor/readData1_s \
sim:/processor/readData2_s \
sim:/processor/ALUOut_s \
sim:/processor/ExMemBufferInput \
sim:/processor/ExMemBufferOutput \
sim:/processor/stackOut_s \
sim:/processor/memOut_s \
sim:/processor/MemWBBufferInput \
sim:/processor/MemWBBufferOutput \
sim:/processor/WriteBackData_s  \
sim:/processor/DecExBufferInput \
sim:/processor/DecExBufferOutput

add wave -position insertpoint sim:/processor/fetch_unit/*
add wave -position insertpoint sim:/processor/pcAdder/*
add wave -position insertpoint sim:/processor/control_unit/*
add wave -position insertpoint sim:/processor/register_file/*
add wave -position insertpoint sim:/processor/ALU/*
add wave -position insertpoint sim:/processor/Memory/*
add wave -position insertpoint sim:/processor/WriteBack/*






force -freeze sim:/processor/clk 0 0, 1 {50 ps} -r 100
force -freeze sim:/processor/InPort 16#F76A 0


mem load -i {D:/GitHub/ar-kak-tecture/Memory files/OneOperand.mem} /processor/fetch_unit/instructionmemory/InstructionMemory


force -freeze sim:/processor/rst 1 0
run 25 ps
force -freeze sim:/processor/rst 0 0
run 25 ps

run 5000 ps