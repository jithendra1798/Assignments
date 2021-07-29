module SingleCycleMain(initialPCval, run);
  input [31:0]initialPCval;  
  input run;
  
  reg [31:0]PC;
    
  
  //instances of all the smaller modules of the processor.
  
  reg [31:0]instrReg;
  
  reg [31:0]instrAddress;
  wire [31:0]instrWire;  
  InstructionMemory instrMem(instrAddress, instrWire);
  
  reg [31:0]inputToShiftLeft;
  wire [31:0]outputFromShiftLeft;
  LeftShifter_2bit instLftShft(inputToShiftLeft, outputFromShiftLeft);


  reg [31:0]constantFour;
  wire [31:0]nextPCval;
  wire overflow1;
  Adder32Bit nextPCvalue(PC, constantFour, nextPCval, overflow1);


  wire [31:0]nextPCvalPlusOffset; 
  wire overflow2;
  Adder32Bit PCafterBranch(nextPCval, outputFromShiftLeft, nextPCvalPlusOffset, overflow2);
  
  reg [31:0]dataAddress;
  reg [31:0]inputData;
  wire[31:0]outputData;
  reg MemRead, MemWrite;
  DataMemory dataMem(dataAddress, inputData, outputData, MemRead, MemWrite);
  
  
  reg [4:0]inputReg1;
  reg [4:0]inputReg2;
  reg RegDst;
  wire [4:0]writeRegWire;
  MUX_2to1_5bit regDstMUX(inputReg1, inputReg2, RegDst, writeRegWire);
  
  
  reg [4:0]readReg1, readReg2, writeReg;
  reg [31:0]writeData;
  wire [31:0]readData1, readData2;
  reg RegWrite;
  RegisterFile regFile(readReg1, readReg2, writeReg, writeData, readData1, readData2, RegWrite);
  
  
  reg [15:0]inputDataSEXT;
  wire [31:0]outputDataSEXT;
  SignExtender_16to32 signExt(inputDataSEXT, outputDataSEXT);
  

  
  reg aluSrc;
  wire [31:0] ALUSrc2;
  MUX_2to1 aluSrc2MUX(readData2, outputDataSEXT, aluSrc, ALUSrc2);
  
  
  reg [5:0]FunctField;
  reg [1:0]ALUOp;
  wire [2:0]ALUCtrl1;
  ALU_Control aluCtrlInstance(FunctField, ALUOp, ALUCtrl1);
  
  
  reg [31:0]ALUSrc1;
  //wire [31:0] ALUSrc2;
  reg [2:0]ALUCtrl;  
  wire[31:0]ALUout;
  wire ZeroOUT;
  ALU_Core aluCoreInstance(ALUSrc1, ALUSrc2, ALUCtrl, ALUout, ZeroOUT);
  
  reg Branch;
  reg ZeroIN;
  wire BranchEnabled;  
  and branchAND(BranchEnabled, Branch, ZeroIN);
  
  

  wire [31:0]nextPCactual;
  MUX_2to1 pcSrcMUX(nextPCval, nextPCvalPlusOffset, BranchEnabled, nextPCactual);
  

  //wire[31:0]ALUout; //already declared
  //wire[31:0]outputData; //already declared
  reg MemtoReg;
  wire [31:0]writeDataToReg;
  MUX_2to1 mem2regSrcMUX(ALUout, outputData, MemtoReg, writeDataToReg);
  
  
  
  reg [5:0]OpCode;
  reg [4:0]rs, rt, rd, shamt;
  reg [25:0]target;   
  reg [31:0]jumpTarget;
  integer counter, prevInstrWasJ;
  
  initial
  begin
    PC = initialPCval;
    //instrReg = 32'b001001_10010_10011_00000_00000_000100;    //addi $s1, $s2 ,4;    
    constantFour = 32'h0000_0004;   //updated it was 'constantFout'
    counter = 0;
  end
  
  always@(run)  
  begin
        if(counter != 0)      
          PC = nextPCactual;
        
        if(prevInstrWasJ == 1) 
          PC = jumpTarget;
          
        instrAddress = PC;
        #10
        instrReg = instrWire;   
        OpCode = instrReg[31:26];
        
        writeReg = 5'b00000;
        writeData = 32'h1111_1111;
        
        RegDst = 0;
        $display("value after init, %d, %d", writeReg, writeRegWire);
        
        counter = 1;   
        
        /*  Beginning of ##CRITICAL INTERCONNECTIONS##. DO NOT MODIFY*/  
              rs = instrReg[25:21];
              rt = instrReg[20:16];
              rd = instrReg[15:11];
              inputDataSEXT = instrReg[15:0];
              shamt =  instrReg[10:6];
              FunctField = instrReg[5:0];
               

              //the inputs to the register 
              readReg1 = rs;
              readReg2 = rt;
              
              //the two inputs to the RegDst mux.
              inputReg1 = rt;              
              inputReg2 = rd;
              #10
             
              ALUCtrl = ALUCtrl1;
              
                    
                            $display("value after first mod, %5d, %5s", writeReg, writeRegWire);
              //connecting ALUout with memory input and memory mux.
              //ALUout already connected to mem2regMUX.
              dataAddress = ALUout;   
              ZeroIN = ZeroOUT;         //ALU connections complete
              
              
              //connecting the readData2 register output to the memory data input.
              inputData = readData2;
              //the outputData is already connected to the mem2regMUX.
              
              //output from Sign extender being given to the shiftleft module.
              inputToShiftLeft = outputDataSEXT;
                   #20        
            
                     
        /*  End of ##CRITICAL INTERCONNECTIONS##. DO NOT MODIFY*/
        

        
        if(OpCode == 6'b000010 || OpCode == 6'b000011)    //If the instruction is 'J' type.
          begin
              target = instrReg[25:0];
              jumpTarget[27:2] = target;
              jumpTarget[1:0] = 2'b00;
              jumpTarget[31:28] = PC[31:28];
              prevInstrWasJ = 1;                  
          end
          
        else if(OpCode == 6'b000000)     // If the instruction is  'R' type.
        begin
              
              ALUOp = 2'b10;   
              RegDst = 1'b1;
              Branch = 0;
              MemRead = 0;
              MemWrite = 0;
              aluSrc = 0;
              MemtoReg = 0;
              RegWrite = 1;
              
     
        end   //'R' Type.
        
        
        else                            // If the instruction is 'I' type.
        begin
              
            
              if(OpCode == 6'b100011)   // lw instruction.
              begin
                  //Control Signals
                  ALUOp = 2'b00;   
                  RegDst = 1'b0;
                  Branch = 0;
                  MemRead = 1;
                  MemWrite = 0;
                  aluSrc = 1;
                  MemtoReg = 1;
                  RegWrite = 1;
                  
              end
              
              if(OpCode == 6'b101011)   //sw instruction
              begin
                  //Control Signals
                  ALUOp = 2'b00;   
                  RegDst = 1'b0;  //irrelevant as data not being written into regfile.
                  Branch = 0;
                  MemRead = 0;
                  MemWrite = 1;
                  aluSrc = 1;
                  MemtoReg = 1; //irrelevant
                  RegWrite = 0;
                  
              end
              
              if(OpCode == 6'b000100)   //beq instruction
              begin
                  //Control Signals
                  ALUOp = 2'b01;   
                  RegDst = 1'b0;  //irrelevant
                  Branch = 1;
                  MemRead = 0;
                  MemWrite = 0;
                  aluSrc = 0; 
                  MemtoReg = 1; //irrelevant
                  RegWrite = 0; //irrelevant

              end
              
              if(OpCode == 6'b000101)  //bne instruction
              begin
                  //Control Signals
                  ALUOp = 2'b01;    //for branch instruction.
                  RegWrite = 0;
                  RegDst = 0;
                  Branch = 1;
                  aluSrc = 0;
                  ZeroIN = ~ZeroOUT;    //passing the negated value of ZeroOUT from the ALU to the PCSrc MUX.
                  MemRead = 0;
                  MemWrite = 0;
                  
                  MemtoReg = 1;
                  
                  
                  
                  
                  
              end
              
              if(OpCode == 6'b001101)   //ori instruction
              begin
                  
                  //Control Signals
                  prevInstrWasJ = 0;
                  ALUOp = 2'b01;  //presently irrelevant
                  RegDst = 0;
                  
                  Branch = 0;
                  MemRead = 0;
                  MemWrite = 0;
                  $display("value after first mod before second\t %d  %5d", writeReg, writeRegWire);
                  writeReg = writeRegWire;
                  $display("value after second mod\t %d,  %5d", writeReg, writeRegWire);
                  RegWrite=1;
                  
                                  
                  #50 
                  $display("value of readData1  %d", readData1);
                  
                  #50
                  $display("value of readData1  %d", readData1);
                  ALUSrc1 = readData1;  
                  aluSrc = 1;
                  
                  ALUCtrl = 3'b001;   
                  #20
                
                  $display("1 writeData = %d, writeDataToReg = %d", writeData, writeDataToReg);

                  MemtoReg = 0;   //the aluout is to be redirected to the regwrite.
                  #20
                  $display("2 writeData = %d, writeDataToReg = %d", writeData, writeDataToReg);
                                    
                  writeData = writeDataToReg;
                  RegWrite = ~RegWrite;   //this will write the initialized value 32'b1111_1111
                  RegWrite = ~RegWrite;   //this will run the next cycle of the reg file, writing the updated value.
                  
                  $display("3 writeData = %d, writeDataToReg = %d", writeData, writeDataToReg);
                  
                  

                  
              end
              
              if(OpCode == 6'b001000)   //addi instruction
              begin
                  //Control Signals
                  prevInstrWasJ = 0; 
                  ALUOp = 2'b01;  //presently irrelevant
                  RegDst = 0;
                  
                  Branch = 0;
                  MemRead = 0;
                  MemWrite = 0;
                  $display("value after first mod before second %5d, %5d", writeReg, writeRegWire);
                  writeReg = writeRegWire;
                  $display("value after second mod,%5d, %5d", writeReg, writeRegWire);
                  RegWrite = 1;
                
                  #20 
                  $display("value of readData1, %d", readData1);
                  ALUSrc1 = readData1;  
                  aluSrc = 1;
                  
                  ALUCtrl = 3'b010;   //for add
                  #20
                
                  $display("1 writeData = %d, writeDataToReg = %d", writeData, writeDataToReg);

                  MemtoReg = 0;   //the aluout is to be redirected to the regwrite.
                  #20
                  $display("2 writeData = %d, writeDataToReg = %d", writeData, writeDataToReg);
                                    
                  writeData = writeDataToReg;
                  RegWrite = ~RegWrite;
                  RegWrite = ~RegWrite;
                  
                  $display("3 writeData = %d,writeDataToReg = %d", writeData, writeDataToReg); 
              end
        end   //'I' Type.
  end     //always block
endmodule

