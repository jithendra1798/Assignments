/* instruction memory*/
module InstructionMemory(Instruction, Address);
    input [31:0] Address;
    output reg [31:0] Instruction;
    reg [31:0] MEMO[1023:0];

    initial
    begin
        $readmemb("InstructionMemory.txt", MEMO);
    end

    always @(Address)
    begin
        Instruction = MEMO[Address];
    end
endmodule