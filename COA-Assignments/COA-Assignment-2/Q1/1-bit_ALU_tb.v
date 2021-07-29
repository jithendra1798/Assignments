/* 1-bit ALU testbench */

module ALU_1BIT_TESTBENCH;

	reg a, b, Ainvert, Binvert, C_In, Less;
	reg [1:0] Operation;
 	wire C_Out, Result, Set;
	
	ALU uut(a, b, Ainvert, Binvert, C_In, Operation, Result, C_Out, Less, Set);
	
	initial
	begin
		$monitor($time, ". a:%b, b:%b, Ainvert:%b, Binvert:%b, C_In:%b, Operation:%b, Result:%b, C_Out:%b, Less:%b ",a, b, Ainvert, Binvert, C_In, Operation, Result, C_Out, Less);
	#5 Ainvert = 0; Binvert = 0; C_In = 0; Operation = 00;
	a = 0; b = 0;
   	#5 a = 1; b = 0;
   	#5 a = 0; b = 1;
   	#5 a = 1; b = 1;
   	
	#5 Ainvert = 0; Binvert = 0; C_In = 0; Operation = 01;
	a = 0; b = 0;
   	#5 a = 1; b = 0;
   	#5 a = 0; b = 1;
   	#5 a = 1; b = 1;
   	
	#5 Ainvert = 0; Binvert = 0; C_In = 0; Operation = 10;
	a = 0; b = 0;
   	#5 a = 1; b = 0;
   	#5 a = 0; b = 1;
   	#5 a = 1; b = 1;
   	
	#5 Ainvert = 0; Binvert = 1; C_In = 1; Operation = 10;
	a = 0; b = 0;
   	#5 a = 1; b = 0;
   	#5 a = 0; b = 1;
   	#5 a = 1; b = 1;
   	
	#5 Ainvert = 1; Binvert = 1; C_In = 0; Operation = 01;
	a = 0; b = 0;
   	#5 a = 1; b = 0;
   	#5 a = 0; b = 1;
   	#5 a = 1; b = 1;
   	
	#5 Ainvert = 1; Binvert = 1; C_In = 0; Operation = 00;
	a = 0; b = 0;
   	#5 a = 1; b = 0;
   	#5 a = 0; b = 1;
   	#5 a = 1; b = 1;
   	
	#5 Ainvert = 0; Binvert = 1; C_In = 1; Operation = 11;
	a = 0; b = 0;
   	#5 a = 1; b = 0;
   	#5 a = 0; b = 1;
   	#5 a = 1; b = 1;

	end
endmodule
