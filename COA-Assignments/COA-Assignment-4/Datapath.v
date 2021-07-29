module InstructionMemory(readAddress, instruction);
  input [31:0]readAddress;
  output [0:31]instruction;
  reg [0:31]instruction;
  
  reg [0:7]InstructionMemory[0:31];
  
  reg [4:0]internalAddress;
  
  integer internalAddressINT, placeVal, i, j;
  
  always@(readAddress)
  begin
      //use this template to hardwire instructions. 
      //Only 5 bit addresses supported.
//      InstructionMemory[0] = 32'b00000_00000_00000_00000_00000_000000;
      
      {InstructionMemory[0], InstructionMemory[1], InstructionMemory[2], InstructionMemory[3]} = 32'b001101_10010_10011_0000000000000001;    //ori $s2, $s1 , 1539;
      {InstructionMemory[4], InstructionMemory[5], InstructionMemory[6], InstructionMemory[7]} = 32'b000101_10011_00000_0000000000000100;     // bne $s2, reg1, 4h;               
          
       
      {InstructionMemory[24], InstructionMemory[24+1], InstructionMemory[24+2], InstructionMemory[24+3]} = 32'b001000_10011_10010_0000000000000100;    //addi $s1, $s2 ,4;
      {InstructionMemory[28], InstructionMemory[28+1], InstructionMemory[28+2], InstructionMemory[28+3]} = 32'b000010_00000_00000_0000000000000000;    // j 0;                               
//      InstructionMemory[1] = 32'b001001_10010_10011_00000_00000_000010;   //addi $s2, $s3, 2;
//      InstructionMemory[3] = 32'b000000_00010_00001_00000_00000_100000;   

      //truncating the address.
      internalAddress = readAddress[4:0];
      
      //internalAddressINT = 0;
      //
      placeVal = 1;
      internalAddressINT = 0;
      for(i=0 ; i<5 ; i=i+1)
      begin
            if(internalAddress[i] == 1)
                internalAddressINT = internalAddressINT + placeVal;
                
            placeVal = placeVal * 2;
      end
      
      
      for(i=0 ; i<32 ; i=i+1)
      begin
             instruction[i] = InstructionMemory[internalAddressINT + i/8][i%8];        
      end
      
      
  end  
  
endmodule

module RegisterFile(readReg1, readReg2, writeReg, writeData, readData1, readData2, RegWrite);
     input [4:0]readReg1, readReg2, writeReg;
     input [31:0]writeData;     //address of the register to be written on to.
     input RegWrite;    //RegWrite - register write signal; writeReg-the destination register.
     
     output [31:0]readData1, readData2;
     reg [31:0]readData1, readData2;
     
     reg [31:0]RegMemory[0:31];
     
     integer placeVal, i, j, writeRegINT=0, readReg1INT=0, readReg2INT=0;
     
     initial
     begin
       for(i=0 ; i<32 ; i=i+1)
       begin
              for(j=0 ; j<32 ; j= j+1)
                RegMemory[i][j] = 1'b0;
       end
     end
     
     always@ (RegWrite or readReg1 or readReg2 or writeReg or writeData)
     begin
       
        if(RegWrite == 1)
        begin
          
          placeVal = 1;
          readReg1INT=0;
          readReg2INT=0;
          for(i=0 ; i<5 ; i=i+1)
          begin
               if(readReg1[i] == 1)
                  readReg1INT = readReg1INT + placeVal;
                  
               if(readReg2[i] == 1)
                  readReg2INT = readReg2INT + placeVal; 
                    
               placeVal = placeVal * 2;
          end
          
          
          for(i=0 ; i<32 ; i=i+1)
          begin
              readData1[i] = RegMemory[readReg1INT][i];
              readData2[i] = RegMemory[readReg2INT][i];
          end
          
          
          
          //binary to decimal address translation.
          placeVal = 1;
          writeRegINT=0;
          for(i=0 ; i<5 ; i=i+1)
          begin
               if(writeReg[i] == 1)
                  writeRegINT = writeRegINT + placeVal;
                  
               placeVal = placeVal * 2;
          end
          
          $display("before writing %d at %d", writeData, writeRegINT);
          for(i=0 ; i<32 ; i=i+1)
          begin
                RegMemory[writeRegINT][i] = writeData[i];
          end
          $display("after writing %d at %d", writeData, writeRegINT);
            
        end  // Register Write
        
        if(RegWrite == 0)
        begin
            //binary to decimal address translation.
          placeVal = 1;
          readReg1INT=0;
          readReg2INT=0;
          for(i=0 ; i<5 ; i=i+1)
          begin
               if(readReg1[i] == 1)
                  readReg1INT = readReg1INT + placeVal;
                  
               if(readReg2[i] == 1)
                  readReg2INT = readReg2INT + placeVal; 
                    
               placeVal = placeVal * 2;
          end
          
          
          for(i=0 ; i<32 ; i=i+1)
          begin
              readData1[i] = RegMemory[readReg1INT][i];
              readData2[i] = RegMemory[readReg2INT][i];
          end
          
          
        end// Register Read
          
     end  //always@
     
endmodule  

module MUX_2to1( input1 , input2, select, out );
  input [31:0] input1, input2;
  input select;
  output [31:0]out;
  reg [31:0]out;
  
  always @(input1 or input2 or select )
    begin 
      case(select)
       
          1'b0:   out=input1;
          1'b1:  out=input2;
          
      endcase
    end
 endmodule  

 module MUX_2to1_5bit( input1 , input2, select, out );
  input [4:0] input1, input2;
  input select;
  output [4:0]out;
  reg [4:0]out;
  
  always @(input1 or input2 or select )
    begin 
      case(select)
       
          1'b0:   out=input1;
          1'b1:  out=input2;
          
      endcase
    end
 endmodule

 module ALU_Core(ALUSrc1 , ALUSrc2 , ALUCtrl , ALUResult , Zero);
  input[31:0] ALUSrc1;
  input[31:0] ALUSrc2;
  input[2:0] ALUCtrl;
  
  output Zero;
  reg Zero;
    
  output [31:0]ALUResult;
  reg [31:0]ALUResult;
  
  
  always @(ALUSrc1 or ALUSrc2 or ALUCtrl)
    begin
          
          if(ALUCtrl == 3'b010) //'add'
          begin
               ALUResult = ALUSrc1 + ALUSrc2; 
               if(ALUResult == 32'h0000)
               begin
                      Zero = 1'b1;
               end 
               else
                 begin
                      Zero = 1'b0;
                 end
          end
          
          if(ALUCtrl == 3'b110) // 'sub'
          begin
               ALUResult = ALUSrc1 - ALUSrc2; 
               if(ALUResult == 32'h0000)
               begin
                      Zero = 1'b1;
               end 
               else
                 begin
                      Zero = 1'b0;
                 end
          end
          
          if(ALUCtrl == 3'b000) // 'and'
          begin
               ALUResult = ALUSrc1 & ALUSrc2; 
               if(ALUResult == 32'h0000)
               begin
                      Zero = 1'b1;
               end 
               else
                 begin
                      Zero = 1'b0;
                 end
          end
               
          if(ALUCtrl == 3'b001) // 'or'
          begin
               ALUResult = ALUSrc1 | ALUSrc2; 
               if(ALUResult == 32'h0000)
               begin
                      Zero = 1'b1;
               end 
               else
                 begin
                      Zero = 1'b0;
                 end
          end     
          
          if(ALUCtrl == 3'b111) // 'slt'
          begin
               ALUResult = ALUSrc1 - ALUSrc2; 
               if(ALUResult == 32'h0000)
               begin
                      Zero = 1'b1;
               end 
               else
                 begin
                      Zero = 1'b0;
                 end
          end
        
    end
  
endmodule



module ALU_Control(FunctField, ALUOp, ALUCtrl);
input [5:0]FunctField;
input [1:0]ALUOp;
output [2:0]ALUCtrl;
reg [2:0]ALUCtrl;

always@(FunctField or ALUOp)
begin
    if(ALUOp == 2'b10)      //'Arithmetic' Type Instructions
    begin
      case(FunctField)        
        6'b100000: ALUCtrl = 3'b010;    //ADDITION in 'R' Type
        6'b100010: ALUCtrl = 3'b110;    //SUBTRACTION in 'R' Type
        6'b100100: ALUCtrl = 3'b000;    //AND in 'R' Type
        6'b100101: ALUCtrl = 3'b001;    //OR in 'R' Type
        6'b101010: ALUCtrl = 3'b111;    //SLT in 'R' Type
    endcase
    end
    
    if(ALUOp == 2'b00)    
    begin
        ALUCtrl = 3'b010;               //ADDITION irrespective of the FunctField.
    end
    
    if(ALUOp == 2'b01)    //   'BEQ', 'BNE' Type Instructions
    begin
        ALUCtrl = 3'b110;               //SUBTRACTION irrespective of the FunctField.
    end        
    

    
end   //always block 

endmodule  //ALUOp module

module DataMemory(inputAddress, inputData32bit, outputData32bit, MemRead, MemWrite);

input [31:0]inputAddress;
//input READ_Bar;
input [31:0]inputData32bit;
input MemRead, MemWrite;
output [31:0]outputData32bit;

// THE MAIN MEMORY REGISTERS WHICH HOLD EMULATE THE ACTUAL RAM. 
        reg [7:0]MM[255:0];


reg [7:0]address;
reg [7:0]dataBuff;
reg [31:0]outputData32bit;

integer addressInt, i, j, placeVal,var, baseAddress;
genvar k;

always @( inputData32bit or inputAddress or MemRead or MemWrite)
begin

  address=inputAddress[7:0];
    

  addressInt = 0;  // the integer equivalent of the 8 bit address we have got in the address[]
  placeVal = 1;   // the placevalue for the unit place is 1.
  
  for( i=0 ; i<8 ; i=i+1 )
  begin
      
      if(address[i] == 1'b1)
        addressInt = addressInt + placeVal;
        
      placeVal = placeVal * 2;
  end
  
  //calculated address as an integer, stored in addressInt
  


  if(MemRead == 1)  // the memory is being read from.
  begin
    
    baseAddress = addressInt;  // i is the variable pointing to the address location pointed by the input address
        
    // now copying the 8 bits of the pointed address one by one.   
    
    ///BIG ENDIAN
    for(i=0 ; i<4 ; i=i+1)
    begin 
       for(j = 0 ; j < 8 ; j = j+1 )
        begin
           outputData32bit[j] = MM[baseAddress + i][j];           
        end 
    end    
        
    
       
  end               
   
  
  if(MemWrite == 1) // the memory is being written into
  begin
    baseAddress = addressInt;
    
    // the given data is being written into the place pointed by the address            
    
    ///BIG ENDIAN
    for(i=0 ; i<4 ; i = i + 1)
    begin
      
      for(j = 0 ; j < 8 ; j = j+1 )
         begin
             MM[baseAddress + i][j] = inputData32bit[j] ;
         end     
      
    end   
    
      
  end               
end  // end of the always block

endmodule

module LeftShifter_2bit(inData,outData);
  
  input [31:0]inData;
  output [31:0]outData;
  reg [31:0]outData;
  
  always@(inData)
    begin
      
      outData=inData<<2;
  
    end
    
endmodule

module Adder32Bit(input1, input2, out, overflowBit);
  
  input [31:0] input1, input2;
  output [31:0] out;
  reg [31:0]out;
  output overflowBit;
  reg overflowBit;
  
      always@(input1 or input2)
        begin
          
          {overflowBit , out } = input1 + input2;
          
        end
    
endmodule

module SignExtender_16to32(inputData, outputData);
  
  input[15:0] inputData;
  output[31:0] outputData;
  reg [31:0] outputData;
  
  always@(inputData)
    begin
      
      outputData[15:0]  = inputData[15:0];
      outputData[31:16] = {16{inputData[15]}};
      
    end
endmodule

