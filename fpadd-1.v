//
// This is a simple version of a 64 bit floating point multiplier 
// used in EE287 as a homework problem.
// This is a reduced complexity floating point.  There is no NaN
// overflow, underflow, or infinity values processed.
//
// Inspired by IEEE 754-2008 (Available from the SJSU library to students)
//
// 63  62:52 51:0
// S   Exp   Fract (assumed high order 1)
// 
// Note: all zero exp and fract is a zero 
// 
//

module fpadd(clk,rst,pushin,a,b,pushout,r);
input pushin;
input clk,rst;
input [63:0] a,b;	// the a and b inputs
output [63:0] r;	// the results from this multiply
output pushout;		// indicates we have an answer this cycle

parameter fbw=104;

reg sA,sB;		// the signs of the a and b inputs
reg [10:0] expA, expB,expR;		// the exponents of each
reg [fbw:0] fractA, fractB,fractR,fractAdd,fractPreRound,denormB,
	f2,d2;	
	// the fraction of A and B  present
reg zeroA,zeroB;	// a zero operand (special case for later)
	

reg signres;		// sign of the result
reg [10:0] expres;	// the exponent result
reg [63:0] resout;	// the output value from the always block
integer iea,ieb,ied;	// exponent stuff for difference...
integer renorm;		// How much to renormalize...
parameter [fbw:0] zero=0;
reg stopinside;
reg pushin_1;
reg [5:0] variable_a;
reg pushin_2,pushin_3;
assign r=resout;
assign pushout=pushin_3;
//
// give the fields a name for convience
//
// pipeline register 

reg sA_1,sB_1,sA_2,sB_2;		// the signs of the a and b inputs
reg [10:0] expA_1, expB_1,expR_1;		// the exponents of each
reg [fbw:0] fractA_1, fractB_1,fractAdd_1,fractPreRound_1,denormB_1,fractB_2,fractB_3,fractR_2,fractB_4,fractA_3,fractA_2,fractB_5,
	f2_1,d2_1;	
	// the fraction of A and B  present
reg signres_1;
integer renorm_1,renorm_3;

//---- second stage 

reg signres_2,signres_3,signres_4;

integer renorm_2,ied_1,ied_2;
reg [fbw:0] fractR_1,fractR_3,fractR_4;
reg [10:0] expA_2, expB_2,expR_2,expR_3,expR_4;

always @(posedge (clk) or posedge (rst))
begin 
    if(rst)
    begin 
    expA_1      <= 11'b0;
    expB_1      <= 11'b0;
    sA_1        <= 1'b0;
    sB_1        <= 1'b0;
    fractA_1    <= 105'b0;
    fractB_2    <= 105'b0;
    signres_1   <= 1'b0;
    pushin_1    <= 1'b0;
   // ied_1       <= 32'b0;
//    renorm_1    <= 32'b0;
    end 
    
    else if(pushin)
    begin 
    
    expA_1  <= #1 expA;
    expB_1  <= #1 expB;
    sA_1    <= #1 sA;
    sB_1    <=  #1 sB;
    fractA_1    <= #1 fractA;
    fractB_2    <= #1 fractB;
    signres_1  <=  #1 signres;
    pushin_1    <= #1 pushin;
  //  ied_1       <= #1 ied;
 //   renorm_1    <= #1 renorm;
    end 
   
    else
    begin 
    
    expA_1      <= #1 expA_1;
    expB_1      <= #1 expB_1;
    sA_1        <= #1 sA_1;
    sB_1        <= #1 sB_1;
    fractA_1    <= #1 fractA_1;
    fractB_2    <= #1 fractB_2;
    signres_1   <= #1 signres_1;
    pushin_1    <= #1 pushin;

    end 


end 

always @(posedge clk or posedge rst)
begin 
    if(rst)
    begin 
        expR_2      <= 11'b0;
        fractR_2    <= 105'b0;
          signres_2   <= 1'b0;
        pushin_2    <= 1'b0;
        ied_1       <= 32'b0;
        sA_2        <=0;
        sB_2        <= 0;
        fractA_3    <= 0;
        fractB_5    <= 0;
    end 
    else if(pushin_1)
    begin 
        expR_2  <= #1 expR_1;
        fractR_2    <=#1  fractR_1;
         signres_2   <=#1  signres_1;
        pushin_2    <=#1  pushin_1;
        ied_1       <=#1  ied;
        sA_2        <=sA_1;
        sB_2        <=sB_1;
        fractA_3    <= fractA_1;
        fractB_5    <= fractB_1;
 
 end 
    else 
    begin 
        expR_2  <=#1  expR_2;
        fractR_2    <=#1  fractR_2;
         signres_2   <=#1  signres_2;
        pushin_2    <=#1  pushin_1;
        ied_1       <=#1  ied_1;
        sA_2        <=#1 sA_2;
        sB_2        <=#1 sB_2;
        fractA_3    <=#1 fractA_3;
        fractB_5    <=#1 fractB_5;
    end 

end 


always @(posedge clk or posedge rst)
begin 
    if(rst)
    begin 
        expR_3      <= 11'b0;
        fractR_4    <= 105'b0;
          signres_3   <= 1'b0;
        pushin_3    <= 1'b0;
        ied_2       <= 32'b0;
        renorm_3    <= 0;
        
    end 
    else if(pushin_2)
    begin 
        expR_3  <= #1 expR;
        fractR_4    <=#1  fractR;
         signres_3   <=#1  signres_2;
        pushin_3    <=#1  pushin_2;
        ied_2       <=#1  ied_1;
        renorm_3   <= #1 renorm_1;
    end 
    else 
    begin 
        expR_3  <=#1  expR_3;
        fractR_4    <=#1  fractR_4;
         signres_3   <=#1  signres_3;
        pushin_3    <=#1  pushin_2;
        ied_2       <=#1  ied_2;
         renorm_3   <= #1 renorm_3;
    end 

end 

always @(*) begin
//$display("%d value of a is ", a);
//$display("%d value of b is ", b);
  zeroA = (a[62:0]==0)?1:0;
  zeroB = (b[62:0]==0)?1:0;
  renorm=0;
//$display("%d value of renorm is ", renorm);
//$display("%d value of renorm_1 is ", renorm_1);
  if( b[62:0] > a[62:0] ) begin
    expA = b[62:52];
    expB = a[62:52];
    sA = b[63];
    sB = a[63];
        fractA = (zeroB)?0:{ 2'b1, b[51:0],zero[fbw:54]};
        fractB = (zeroA)?0:{ 2'b1, a[51:0],zero[fbw:54]};
   // $display("%b value of fractA", fractA);
   // $display("%b calue of fractB", fractB);
    signres=sA;
  end else begin
    sA = a[63];
    sB = b[63];
    expA = a[62:52];
    expB = b[62:52];
    fractA = (zeroA)?0:{ 2'b1, a[51:0],zero[fbw:54]};
    fractB = (zeroB)?0:{ 2'b1, b[51:0],zero[fbw:54]};
   // $display("%b value of fractA", fractA);
   // $display("%b calue of fractB", fractB);
  signres=sA;
  end
 
  iea=expA_1;
  ieb=expB_1;
  ied=expA_1-expB_1;
 // $display("1 is executing ");
  
  if(ied > 60) begin
    expR_1=expA_1;
    fractR_1=fractA_1;
    fractB_1 = 0;
//$display("1 is executing if");
  end else begin
  fractB_3 = fractB_2;
  fractB_1 = fractB_3;	    
    
    expR_1=expA_1;
    denormB=0;
    fractB_1=(ied[5])?{32'b0,fractB_1[fbw:32]}: {fractB_1};
    fractB_1=(ied[4])?{16'b0,fractB_1[fbw:16]}: {fractB_1};
    fractB_1=(ied[3])?{ 8'b0,fractB_1[fbw:8 ]}: {fractB_1};
     fractB_1=(ied[2])?{ 4'b0,fractB_1[fbw:4 ]}: {fractB_1};
    fractB_1=(ied[1])?{ 2'b0,fractB_1[fbw:2 ]}: {fractB_1};
    fractB_1=(ied[0])?{ 1'b0,fractB_1[fbw:1 ]}: {fractB_1};
   fractR_1 = 0;
    
  end 
end 


always @(*)
begin 


 //  fractR = fractR_2;
// fractB_4 = fractB_5;
 fractA_2 = fractA_3;
  //  signres_3 = signres_2;
   renorm_1=0;
   expR = expR_2 ;
    
  if(ied_1 >60)
  begin 
    expR = expR_2;
    fractR = fractR_2;
 
  end 
  else 
  begin 
  
       if(sA_2 == sB_2) fractR=fractA_2+fractB_5;else fractR=fractA_2-fractB_5;
    

    fractAdd=fractR;
  
  if(fractR[fbw]) begin
      fractR={1'b0,fractR[fbw:1]};
      expR=expR+1;
      variable_a = 5'd1;
    end
    if(fractR[fbw-1:fbw-32]==0) begin 
	renorm_1[5]=1; fractR={ 1'b0,fractR[fbw-33:0],32'b0 }; 
	variable_a = 5'd2;
    end

  
    end
    
  end 

    
  always @(*)
  begin 
   fractR_3 = fractR_4;
   signres_4 = signres_3;
   renorm_2  = renorm_3;
   expR_4  = expR_3;
  if(ied_2 >60)
   begin 
        expR_4 = expR_3;
        fractR_3 = fractR_4;
   end 
   else 
   begin 
    
    if(fractR_3[fbw-1:fbw-16]==0) begin 
	renorm_2[4]=1; fractR_3={ 1'b0,fractR_3[fbw-17:0],16'b0 }; 
	variable_a = 5'd3;
    end
      
  if(fractR_3[fbw-1:fbw-8]==0) begin 
	renorm_2[3]=1; fractR_3={ 1'b0,fractR_3[fbw-9:0], 8'b0 }; 
	//variable_a = 5'd4;
    end
  if(fractR_3[fbw-1:fbw-4]==0) begin 
	renorm_2[2]=1; fractR_3={ 1'b0,fractR_3[fbw-5:0], 4'b0 }; 
//	variable_a = 5'd5;
    end
    
  
    if(fractR_3[fbw-1:fbw-2]==0) begin 
	renorm_2[1]=1; fractR_3={ 1'b0,fractR_3[fbw-3:0], 2'b0 };
	//variable_a = 5'd6;
    end
    if(fractR_3[fbw-1   ]==0) begin 
	renorm_2[0]=1; fractR_3={ 1'b0,fractR_3[fbw-2:0], 1'b0 }; 
	//variable_a = 5'd7;
    end
   
    fractPreRound=fractR_3;
    if(fractR_3 != 0) begin
      if(fractR_3[fbw-55:0]==0 && fractR_3[fbw-54]==1) begin
	if(fractR_3[fbw-53]==1) begin
            fractR_3=fractR_3+{1'b1,zero[fbw-54:0]};
          //  variable_a = 5'd8;
            end 
      end 
      else 
      begin
        if(fractR_3[fbw-54]==1) begin 
            fractR_3=fractR_3+{1'b1,zero[fbw-54:0]};
           // variable_a = 5'd9;
            end
      end
      expR_4=expR_4-renorm_2;
      if(fractR_3[fbw-1]==0) begin
       expR_4=expR_4+1;
       variable_a = 5'd10;
       fractR_3={1'b0,fractR_3[fbw-1:1]};
      end
    end else begin
      expR_4=0;
      variable_a = 5'd11;
      signres_4=0;
    end
  end

//$display("%d calue of result out", resout);
  resout={signres_4,expR_4,fractR_3[fbw-2:fbw-53]};

end






endmodule
