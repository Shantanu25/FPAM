`timescale 1 ns/1 ps


module Denormilization(input [63:0]a, // U1
			input [63:0]b,  //
			output [63:0] Denorm_u1,
			output [63:0] Denorm_u2 );

parameter fbw = 104;
parameter [fbw:0] zero= 0;


reg [63:0] fractA,fractB;
reg [10:0] expA,expB;
integer expA_temp,expB_temp,expA_eff,expB_eff;

 assign Denorm_u1 = fractA;
 assign Denorm_u2 = fractB;

always @(*)
begin 

  expA   = a[62:52];
  expB   = b[62:52];
  fractA = {1'b1,a[51:0],11'b0};
  fractB = {1'b1,b[51:0],11'b0};
  expA_temp = expA;
  expB_temp = expB;
  expA_eff = 1023 - expA_temp-1;
  expB_eff = 1023 - expB_temp-1;

  if(expA_eff > 60)
  begin 
    fractA = fractA;

  end	

  else 
  begin 
    fractA=(expA_eff[5])?{32'b0,fractA[63:32]}: {fractA};
    fractA=(expA_eff[4])?{16'b0,fractA[63:16]}: {fractA};
    fractA=(expA_eff[3])?{ 8'b0,fractA[63:8 ]}: {fractA};
    fractA=(expA_eff[2])?{ 4'b0,fractA[63:4 ]}: {fractA};
    fractA=(expA_eff[1])?{ 2'b0,fractA[63:2 ]}: {fractA};
    fractA=(expA_eff[0])?{ 1'b0,fractA[63:1 ]}: {fractA};
   end 
 if(expB_eff > 60)
  begin 
  fractB = fractB;
   end	
  else 
   begin 
    fractB=(expB_eff[5])?{32'b0,fractB[63:32]}: {fractB};
    fractB=(expB_eff[4])?{16'b0,fractB[63:16]}: {fractB};
    fractB=(expB_eff[3])?{ 8'b0,fractB[63:8 ]}: {fractB};
    fractB=(expB_eff[2])?{ 4'b0,fractB[63:4 ]}: {fractB};
    fractB=(expB_eff[1])?{ 2'b0,fractB[63:2 ]}: {fractB};
    fractB=(expB_eff[0])?{ 1'b0,fractB[63:1 ]}: {fractB};
   
  
   end 
end 

 
endmodule


