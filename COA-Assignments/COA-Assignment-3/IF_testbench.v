/* IF test_bench*/
module IF_testbench();
    reg clk;
    reg reset;
    wire [31:0] Instruction;
    wire [31:0] PC_next;
    IF instr_fetch(clk, reset, Instruction, PC_next);

    initial
    begin
        clk = 1'b0;
        repeat(100)
        #5 clk = ~clk;
    end
    initial
    begin
        $monitor($time, ": Program counter=%h   Instruction = %b",PC_next,Instruction);
        reset = 1'b1;
        #1;
        reset = 1'b0;
    end
endmodule