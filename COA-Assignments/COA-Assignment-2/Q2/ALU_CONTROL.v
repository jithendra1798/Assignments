//191CS261 VAMSHIKRISHNA M 
/* ALU Control */
module ALU_CONTROL(ALUOperation, F, Operation);

	input [1:0] ALUOperation;
	input [5:0] F;
	output reg [3:0] Operation;
	
	always @(ALUOperation, Operation)
	begin
		Operation[0] = (F[0] | F[3]) & ALUOperation[1];
		Operation[1] = (~F[2] | ~ALUOperation[1]);
		Operation[2] = (ALUOperation[1] & F[1]) |ALUOperation[0];
		Operation[3] = (ALUOperation & ~ALUOperation);
	end
endmodule