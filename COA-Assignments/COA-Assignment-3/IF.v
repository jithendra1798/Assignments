/* iF   */
module IF(clk, reset, Instruction, PC_next);
    input clk;
    input reset;
    output [31:0] Instruction;
    output [31:0] PC_next;
    reg [31:0] pc;
    wire [31:0] pc_next;
    always @(posedge clk or posedge reset)
    begin
        if(reset)
            pc <= 32'b0;
        else
            pc <= pc_next;
    end
    assign pc_next = pc + 32'b0100;
    InstructionMemory im(Instruction, pc);
    assign PC_next = pc;
endmodule