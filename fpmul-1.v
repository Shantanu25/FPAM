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

module fpmul(clk,rst,pushin, a,b,c,pushout,r);
input pushin; 	     
input clk,rst;// A valid a,b,c
input [63:0] a,b,c;	// the a,b and c inputs
output [63:0] r;	// the results from this multiply
output pushout;		// indicates we have an answer this cycle

reg sA,sB,sC;		// the signs of the a and b inputs
reg [10:0] expA, expB, expC;		// the exponents of each
reg [52:0] fractC_5,fractA, fractB, fractC, fractC_1, fractC_2,fractC_3,fractC_4;
wire [53:0] fractC_6;	// the fraction of A and B  present
reg zeroA,zeroB,zeroC,zeroA_1,zeroB_1,zeroC_1,zeroA_2,zeroB_2,zeroC_2,zeroA_3,zeroB_3,zeroC_3,zeroA_4,zeroB_4,zeroC_4,zeroA_5,zeroB_5,zeroC_5,zeroA_6,zeroB_6,zeroC_6;	// a zero operand (special case for later)
// result of the multiplication, rounded result, rounding constant
reg [159:0] rres,rconstant,rconstant_1;	
reg pushin_1,pushin_2;
reg signres;		// sign of the result
reg [10:0] expres,expres_1,expres_2,expres_3,expres_4,expres_5,expres_6,expres_7;	// the exponent result
reg [63:0] resout;	// the output value from the always block
reg pushin_3,pushin_4,pushin_5,pushin_6,pushin_7,pushin_8,pushin_9,pushin_10;
reg zeroA_7,zeroB_7,zeroC_7,zeroA_8,zeroB_8,zeroC_8,zeroA_9,zeroB_9,zeroC_9,zeroA_10,zeroB_10,zeroC_10;

assign r=resout;
assign pushout=pushin_6 ;

wire [159:0] mres_5;
wire [105:0] mres;
wire [158:0] mres_2;
wire [158:0] mres_3;

//wire [265:0] mres_2; 
// give the fields a name for convience
//reg sA,sB,sC;		// the signs of the a and b inputs
reg [10:0] expA_1, expB_1, expC_1,expA_2, expB_2, expC_2,expA_3, expB_3, expC_3,expA_4, expB_4, expC_4,expA_5, expB_5, expC_5;	//ro operand (special case for later)
// result of the multiplication, rounded result, rounding constant
reg [159:0] mres_1;

reg signres_1;

// second pipelined stage signals


reg [159:0] rres_2,rres_1;
reg signres_2,signres_3,signres_4,signres_5,signres_6,signres_7,signres_8,signres_9,signres_10,signres_11,signres_12;


always @(posedge clk or posedge rst)   // 1st flip flop
begin 
    if(rst)
    begin 
        fractC_1 <= 0;
        expA_1  <= 11'b0;
        expB_1  <= 11'b0;
        expC_1  <= 11'b0;
        signres_1   <= 1'b0;
        zeroA_1     <= 1'b0;
        zeroB_1     <= 1'b0;
        zeroC_1     <= 1'b0;
        pushin_1    <= 1'b0;
    end 
    else 
    begin 
        fractC_1 <= #1 fractC;
        expA_1  <=  #1 expA;
        expB_1  <=  #1 expB;
        expC_1  <=  #1 expC;
        signres_1   <=  #1 signres;
        zeroA_1     <=  #1 zeroA;
        zeroB_1     <=  #1 zeroB;
        zeroC_1     <=  #1 zeroC;
        pushin_1    <=  #1 pushin;    
    
    end 

end 


always @(posedge clk or posedge rst)   // 2st flip flop
begin 
    if(rst)
    begin 
        fractC_2 <= 0;
        expA_2  <= 11'b0;
        expB_2  <= 11'b0;
        expC_2  <= 11'b0;
        signres_2   <= 1'b0;
        zeroA_2     <= 1'b0;
        zeroB_2     <= 1'b0;
        zeroC_2     <= 1'b0;
        pushin_2    <= 1'b0;
    end 
    else 
    begin 
        fractC_2    <=  #1 fractC_1;
        expA_2      <=  #1 expA_1;
        expB_2      <=  #1 expB_1;
        expC_2      <=  #1 expC_1;
        signres_2   <=  #1 signres_1;
        zeroA_2     <=  #1 zeroA_1;
        zeroB_2     <=  #1 zeroB_1;
        zeroC_2     <=  #1 zeroC_1;
        pushin_2    <=  #1 pushin_1;    
    
    end 

end 


always @(posedge clk or posedge rst)   // 3rd flip flop
begin 
    if(rst)
    begin 
        fractC_3    <= 0;
        expA_3      <= 11'b0;
        expB_3      <= 11'b0;
        expC_3      <= 11'b0;
        signres_3   <= 1'b0;
        zeroA_3     <= 1'b0;
        zeroB_3     <= 1'b0;
        zeroC_3     <= 1'b0;
        pushin_3    <= 1'b0;
    end 
    else 
    begin 
        fractC_3    <=  #1 fractC_2;
        expA_3      <=  #1 expA_2;
        expB_3      <=  #1 expB_2;
        expC_3      <=  #1 expC_2;
        signres_3   <=  #1 signres_2;
        zeroA_3     <=  #1 zeroA_2;
        zeroB_3     <=  #1 zeroB_2;
        zeroC_3     <=  #1 zeroC_2;
        pushin_3    <=  #1 pushin_2;    
    
    end 

end 

always @(posedge clk or posedge rst)   // 4th flip flop
begin 
    if(rst)
    begin 
//        fractC_4    <= 0;
//        expA_4      <= 11'b0;
 //       expB_4      <= 11'b0;
//        expC_4      <= 11'b0;
    expres_1 <= 0;
        signres_4   <= 1'b0;
        zeroA_4     <= 1'b0;
        zeroB_4     <= 1'b0;
        zeroC_4     <= 1'b0;
        pushin_4    <= 1'b0;
    end 
    else 
    begin 
//        fractC_4    <=  #1 fractC_3;
//        expA_4      <=  #1 expA_3;
 //       expB_4      <=  #1 expB_3;
 //       expC_4      <=  #1 expC_3;
 
      expres_1 <=  #1 expres;
        signres_4   <=  #1 signres_3;
        zeroA_4     <=  #1 zeroA_3;
        zeroB_4     <=  #1 zeroB_3;
        zeroC_4     <=  #1 zeroC_3;
        pushin_4    <=  #1 pushin_3;    
    
    end 

end 

always @(posedge clk or posedge rst)   // 4th flip flop
begin 
    if(rst)
    begin 
  //      fractC_5    <= 0;
  //      expA_5      <= 11'b0;
   //    expB_5      <= 11'b0;
  //      expC_5      <= 11'b0;
        expres_2 <= 0;
        signres_5   <= 1'b0;
        zeroA_5     <= 1'b0;
        zeroB_5     <= 1'b0;
        zeroC_5     <= 1'b0;
        pushin_5    <= 1'b0;
    end 
    else 
    begin 
//        fractC_5    <=  #1 fractC_4;
//        expA_5      <=  #1 expA_4;
//        expB_5      <=  #1 expB_4;
//        expC_5      <=  #1 expC_4;
        expres_2 <=  #1 expres_1;
        signres_5   <=  #1 signres_4;
        zeroA_5     <=  #1 zeroA_4;
        zeroB_5     <=  #1 zeroB_4;
        zeroC_5     <=  #1 zeroC_4;
        pushin_5    <=  #1 pushin_4;    
    
    end 

end 




always @(posedge clk or posedge rst)
begin 
    if(rst)
    begin 
    expres_3 <= 0;
    zeroA_6  <= 0;
    zeroB_6  <= 0;
    zeroC_6  <= 0;
    signres_6 <= 0;
    pushin_6  <= 0;
  
    end 
    else 
    begin 
     expres_3 <=  #1 expres_2;
    zeroA_6  <=  #1 zeroA_5;
    zeroB_6  <=  #1 zeroB_5;
    zeroC_6  <=  #1 zeroC_5;
    signres_6 <=  #1 signres_5;
    pushin_6 <=  #1 pushin_5;
    
    end 


end 

/*
always @(posedge clk or posedge rst)
begin 
    if(rst)
    begin 

    zeroA_7  <= 0;
    zeroB_7  <= 0;
    zeroC_7  <= 0;
    signres_7 <= 0;
    pushin_7  <= 0;
  
    end 
    else 
    begin 
    
  
    zeroA_7  <=  #1 zeroA_6;
    zeroB_7  <=  #1 zeroB_6;
    zeroC_7  <=  #1 zeroC_6;
    signres_7 <=  #1 signres_6;
    pushin_7  <=  #1 pushin_6;
    
    end 


end 



always @(posedge clk or posedge rst)
begin 
    if(rst)
    begin 
  
    zeroA_8  <= 0;
    zeroB_8  <= 0;
    zeroC_8  <= 0;
    signres_8 <= 0;
    pushin_8  <= 0;
  
    end 
    else 
    begin 
    
    
    zeroA_8  <=  #1 zeroA_7;
    zeroB_8  <=  #1 zeroB_7;
    zeroC_8  <=  #1 zeroC_7;
    signres_8 <=  #1 signres_7;
    pushin_8  <=  #1 pushin_7;
    
    end 


end 

always @(posedge clk or posedge rst)
begin 
    if(rst)
    begin 
   expres_4 <= 0;
    zeroA_9  <= 0;
    zeroB_9  <= 0;
    zeroC_9  <= 0;
    signres_9 <= 0;
    pushin_9  <= 0;
  
    end 
    else 
    begin 
    
 expres_4 <=  #1 expres_3;
    zeroA_9  <=  #1 zeroA_8;
    zeroB_9  <=  #1 zeroB_8;
    zeroC_9  <=  #1 zeroC_8;
    signres_9 <=  #1 signres_8;
    pushin_9  <=  #1 pushin_8;
    
    end 


end 

always @(posedge clk or posedge rst)
begin 
    if(rst)
    begin 
   expres_5 <= 0;
    zeroA_10  <= 0;
    zeroB_10  <= 0;
    zeroC_10  <= 0;
    signres_10 <= 0;
    pushin_10  <= 0;
  
    end 
    else 
    begin 
    
  expres_5 <=  #1 expres_4;
    zeroA_10  <=  #1 zeroA_9;
    zeroB_10  <=  #1 zeroB_9;
    zeroC_10  <=  #1 zeroC_9;
    signres_10 <=  #1 signres_9;
    pushin_10  <=  #1 pushin_9;
    
    end 


end 
*/

// assign fractC_6 = {1'b0,fractC_5};

DW02_mult_4_stage #(53,53) stage_1(.A(fractA),.B(fractB),.TC(1'b0),.CLK(clk),.PRODUCT(mres));

DW02_mult_4_stage #(106,53) stage_2(.A(mres),.B(fractC_3),.TC(1'b0),.CLK(clk),.PRODUCT(mres_2));
assign mres_3 = mres_2[158:0];


always @(*) begin
signres_11 = signres_6;
expres_6  = expres_3;

  sA = a[63];
  sB = b[63];
  sC = c[63];
  signres=sA^sB^sC;
  expA = a[62:52];
  expB = b[62:52];
  expC = c[62:52];
  fractA = { 1'b1, a[51:0]};
  fractB = { 1'b1, b[51:0]};
  fractC = { 1'b1, c[51:0]};
  zeroA = (a[62:0]==0)?1:0;
  zeroB = (b[62:0]==0)?1:0;
  zeroC = (c[62:0]==0)?1:0;
 // mres= fractA*fractB;
  
 // mres_2= mres_1*fractC_1;
  expres = expA_3+expB_3+expC_3-11'd2045;
  
  rconstant_1=0;
 
   if (mres_3[158]==1) rconstant_1[105]=1; else if(mres_3[157]==1'b1) rconstant_1[104]=1; else rconstant_1[103]=1;
  
   rres=mres_3+rconstant_1;
    if((zeroA_6==1) || (zeroB_6==1) || (zeroC_6 == 1)) begin // sets a zero result to a true 0
    rres = 0;
    expres_6 = 0;
    signres_11=0;
    resout=64'b0;
  end else begin
    if(rres[158]==1'b1) begin
      expres_7=expres_6+1;
      resout={signres_11,expres_7,rres[157:106]};
    end else if(rres[157]==1'b0) begin // less than 1/2
      expres_7=expres_6-1;
      resout={signres_11,expres_7,rres[155:104]};
    end else begin 
      resout={signres_11,expres_6,rres[156:105]};
    end
  end
end
endmodule
