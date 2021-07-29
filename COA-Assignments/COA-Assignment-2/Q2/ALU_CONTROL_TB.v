//191cs261 VAMSHIKRISHNA
/* Testbench for ALUControl */


module ALU_CONTROL_TB();

	reg [1:0] ALUOperation;
	reg [5:0] func;
	wire [3:0] Operation;

	ALU_CONTROL alu(ALUOperation, func, Operation);

	initial
	begin
		$monitor($time, ". ALUOperation:%b, func:%b, Operation :%b.", ALUOperation, func, Operation);

		   ALUOperation = 2'b00; func=6'bxxxxxx;
		#5 ALUOperation = 2'bx1; func=6'bxxxxxx;
		#5 ALUOperation = 2'b1x; func=6'bxx0000;
		#5 ALUOperation = 2'b1x; func=6'bxx0010;
		#5 ALUOperation = 2'b1x; func=6'bxx0100;
		#5 ALUOperation = 2'b1x; func=6'bxx0101;
		#5 ALUOperation = 2'b1x; func=6'bxx1010;

		#10 $finish;
	end
endmodule


