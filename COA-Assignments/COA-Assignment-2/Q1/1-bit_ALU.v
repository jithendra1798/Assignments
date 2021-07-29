/* 1-bit ALU Design */
 
 module ALU(a, b, Ainvert, Binvert, C_In, Operation, Result, CarryOut, Less, Set);
 	
 	input a, b, Ainvert, Binvert, C_In, Less;
 	input [1:0] Operation;
 	output reg CarryOut, Result, Set;
 	
 	
 	reg a1, b1;
 	reg [63:0] temp;
 	reg [1:0] count;
 	
 	always @(*)
 	begin

	 	case(Ainvert)
	 		0: a1=a;
	 		1: a1=~a;
	 	endcase
	 	
	 	case(Binvert)
	 		0: b1=b;
	 		1: b1=~b;
	 	endcase
	 	
	 	case(Operation)
	 		2'b00 : Result=a1&b1;
	 		2'b01 : Result=a1|b1;
	 		2'b10 : begin
	 			Result=(~a1 & ~b1 & C_In) | (~a1 & b1 & ~C_In) | (a1 & ~b1 & ~C_In) | (a1 & b1 & C_In); 
	 			CarryOut = (a1 & b1) | (b1 & C_In) | (C_In & a1);
	 			end
	 		2'b11 : begin
				Set=(~a1 & ~b1 & C_In) | (~a1 & b1 & ~C_In) | (a1 & ~b1 & ~C_In) | (a1 & b1 & C_In);
				CarryOut = (a1 & b1) | (b1 & C_In) | (C_In & a1);
				Result=Less;
	 			end
	 	endcase
 	end
 endmodule
