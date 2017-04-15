module randist(input clk,rst,pushin,
                  input [63:0] U1,U2,
                  output pushout,
                  output [63:0] z );


wire pushin_1,pushout_1,pushout_2,pushout_3;
wire [63:0] Denorm_u_1,Denorm_u_2;
wire [63:0] delta_a,delta_cube,a_delta_cube,delta_b,a_cube_b_square,c_delta_D;

wire [63:0] b_delta_square;
wire [63:0] c_delta;
wire [63:0] A,B,C,D;

reg [104:0] u1,u2;
reg pushin1,pushin2;
reg [63:0] delta_A,delta_B;
reg [63:0] b_delta_square_1,b_delta_square_2,b_delta_square_3,b_delta_square_4,b_delta_square_5,b_delta_square_6;
reg [63:0] c_delta_1,c_delta_2,c_delta_3,c_delta_4,c_delta_5,c_delta_6;
reg pushout_c_1,pushout_c_2,pushout_c_3,pushout_c_4,pushout_c_5,pushout_c_6;
reg  U2_pushin_3,U2_pushin_4,U2_pushin_5,U2_pushin_6,U2_pushin_7,U2_pushin_8;
wire U2_pushin_9;

reg [63:0] delta_c;
reg [63:0] d_1,d_2,d_3,d_4,d_5,d_6,d_7,d_8,d_9,d_10,d_11,d_12;
reg [63:0] a_1,a_2,a_3,a_4,a_5,a_6;
wire pushout_u1,pushout_u2,system_pushout;
wire [63:0] res_u1, a_b_add,z_res,res_u2;
wire [63:0] u2_a,u2_b,u2_c,U2_a2_delta,U2_b_delta;
reg [63:0] u2_a1,u2_b1,u2_c1;
reg [63:0] U2_a2_delta_1,U2_a2_delta_2,U2_a2_delta_3,U2_a2_delta_4,U2_a2_delta_5,U2_a2_delta_6;
reg [63:0] u2_c_1,u2_c_2,u2_c_3,u2_c_4,u2_c_5,u2_c_6,u2_c_7,u2_c_8,u2_c_9,u2_c_10,u2_c_11,u2_c_12,u2_c_13,u2_c_14,u2_c_15;
reg [63:0] U2_b_delta_1,U2_b_delta_2,U2_b_delta_3,U2_b_delta_4,U2_b_delta_5,U2_b_delta_6;


assign pushout = system_pushout;
assign z   = z_res;  



Denormilization inst_denorm(.a(U1),.b(U2),.Denorm_u1(Denorm_u_1),.Denorm_u2(Denorm_u_2));
normalization renorm(.a({9'b0,u1[54:0]}),.b({10'b0,u2[53:0]}),.delta_1(delta_a),.delta_2(delta_b));
sqrtln loop_up_table(.vin(u1[63:55]),.A(A),.B(B),.C(C),.D(D));
sin_lookup Inst_loop_up(.vin(u2[63:54]),.A(u2_a),.B(u2_b),.C(u2_c));


fpmul delta_3(.clk(clk),.rst(rst),.pushin(pushin1),.a(delta_a),.b(delta_a),.c(delta_a),.pushout(pushout_1),.r(delta_cube));

fpmul a_delta_3(.clk(clk),.rst(rst),.pushin(pushout_1),.a(a_6),.b(delta_cube),.c(64'h3ff0000000000000),.pushout(pushout_2),.r(a_delta_cube));
fpmul b_delta_2(.clk(clk),.rst(rst),.pushin(pushin1),.a(B),.b(delta_a),.c(delta_a),.pushout(),.r(b_delta_square));

fpmul inst_c_delta(.clk(clk),.rst(rst),.pushin(pushin1),.a(C),.b(delta_a),.c(64'h3ff0000000000000),.pushout(pushout_c),.r(c_delta));


fpadd inst_fpadd_1(.clk(clk),.rst(rst),.pushin(pushout_2),.a(a_delta_cube),.b(b_delta_square_6),.pushout(pushout_3),.r(a_cube_b_square));
fpadd inst_fpadd_2(.clk(clk),.rst(rst),.pushin(pushout_2),.a(c_delta_6),.b(d_12),.pushout(),.r(c_delta_D));
		
fpadd inst_fpadd_3(.clk(clk),.rst(rst),.pushin(pushout_3), .a(a_cube_b_square),.b(c_delta_D),.pushout(pushout_u1),.r(res_u1));

//-----------------U2----------------------------------------------------------------------------------------------------------------------------------------------------------	
//

fpmul a_delta_2(.clk(clk),.rst(rst),.pushin(pushin1),.a(u2_a),.b(delta_b),.c(delta_b),.pushout(),.r(U2_a2_delta));
fpmul b_delta(.clk(clk),.rst(rst),.pushin(pushin1),.a(u2_b),.b(delta_b),.c(64'h3ff0000000000000),.pushout(U2_pushin_2),.r(U2_b_delta));

// pipeline it for 6 clocks pushin, resutls 
fpadd a_delta2_b_delta(.clk(clk),.rst(rst),.pushin(U2_pushin_8),.a(U2_a2_delta_6),.b(U2_b_delta_6),.pushout(U2_pushin_9),.r(a_b_add));

fpadd U2_res(.clk(clk),.rst(rst),.pushin(U2_pushin_9),.a(a_b_add),.b(u2_c_15),.pushout(pushout_u2),.r(res_u2));



//-------U1 and U2--------------------------------------------------------------------------------------------------------------------------------------------------------------


fpmul inst_res_system(.clk(clk),.rst(rst),.pushin(pushout_u1),.a(res_u1),.b(res_u2),.c(64'h3ff0000000000000),.pushout(system_pushout),.r(z_res));

always @(posedge clk or posedge rst)
begin 
	if(rst)
	begin 
	u1 <= 0;
	u2 <= 0;
	pushin1 <=0;
	end 
	else 
	begin 
	u1 <= Denorm_u_1;
	u2 <= Denorm_u_2; 
	pushin1 <= pushin;
	end 

end 



always @(posedge clk or posedge rst)
begin 
	if(rst)
	begin 
	U2_a2_delta_1 <= 0;
	U2_a2_delta_2 <= 0;
	U2_a2_delta_3 <= 0;
	U2_a2_delta_4 <= 0;
	U2_a2_delta_5 <= 0;
	U2_a2_delta_6 <= 0;
//	U2_a2_delta_7 <= 0;
//	
	U2_b_delta_1 <= 0;
	U2_b_delta_2 <= 0; 
	U2_b_delta_3 <= 0;
	U2_b_delta_4 <= 0;
	U2_b_delta_5 <= 0;
	U2_b_delta_6 <= 0;
//	U2_b_delta_7 <= 0;

	u2_c_1 <= 0;
	u2_c_2 <= 0;
	u2_c_3 <= 0;
	u2_c_4 <= 0;
	u2_c_5 <= 0;
	u2_c_6 <= 0;
	u2_c_7 <= 0;
	u2_c_8 <= 0;
	u2_c_9 <= 0;
	u2_c_10 <= 0;
	u2_c_11 <= 0;
	u2_c_12 <= 0;
	u2_c_13 <= 0;
	u2_c_14 <= 0;
	u2_c_15 <= 0;
	
	U2_pushin_3 <= 0;
	U2_pushin_4 <= 0;
	U2_pushin_5 <= 0;
	U2_pushin_6 <= 0;
	U2_pushin_7 <= 0;
	U2_pushin_8 <= 0;
//	U2_pushin_3 <= 0;


	end 
	else 
	begin 

	U2_a2_delta_1 <= #1 U2_a2_delta;
	U2_a2_delta_2 <= #1 U2_a2_delta_1;
	U2_a2_delta_3 <= #1 U2_a2_delta_2;
	U2_a2_delta_4 <= #1 U2_a2_delta_3;
	U2_a2_delta_5 <= #1 U2_a2_delta_4;
	U2_a2_delta_6 <= #1 U2_a2_delta_5;
//	U2_a2_delta_7 <= U2_a2_delta_6;

	U2_b_delta_1 <= #1 U2_b_delta ;
	U2_b_delta_2 <= #1 U2_b_delta_1 ; 
	U2_b_delta_3 <= #1 U2_b_delta_2 ;
	U2_b_delta_4 <= #1 U2_b_delta_3 ;
	U2_b_delta_5 <= #1 U2_b_delta_4 ;
	U2_b_delta_6 <= #1 U2_b_delta_5 ;
//	U2_b_delta_7 <= U2_b_delta_6 ;

	u2_c_1 <= #1 u2_c;
	u2_c_2 <= #1 u2_c_1;
	u2_c_3 <= #1 u2_c_2;
	u2_c_4 <= #1 u2_c_3;
	u2_c_5 <= #1 u2_c_4;
	u2_c_6 <= #1 u2_c_5;
	u2_c_7 <= #1 u2_c_6;
	u2_c_8 <= #1 u2_c_7;
	u2_c_9 <= #1 u2_c_8;
	u2_c_10 <= #1 u2_c_9;
	u2_c_11 <= #1 u2_c_10;
	u2_c_12 <= #1 u2_c_11;
	u2_c_13 <= u2_c_12;
	u2_c_14 <= u2_c_13;
	u2_c_15 <= u2_c_14;



	U2_pushin_3 <= U2_pushin_2;
	U2_pushin_4 <= U2_pushin_3;
	U2_pushin_5 <= U2_pushin_4 ;
	U2_pushin_6 <= U2_pushin_5;
	U2_pushin_7 <= U2_pushin_6;
	U2_pushin_8 <= U2_pushin_7;

	end 





end 



always @(posedge clk or posedge rst)
begin 
	if(rst)
	begin 
	a_1 <=0;
	a_2 <=0 ;
	a_3 <=0 ;
	a_4 <=0;
	a_5 <= 0;
	a_6 <= 0;
	d_1 <=0;
	d_2 <=0;
	d_3 <=0;
	d_4 <=0;
	d_5 <=0;
	d_6 <=0;
	d_7 <=0;
	d_8 <=0;
	d_9 <=0;
	d_10 <=0;
	d_11 <=0;
	d_12 <=0; 




	end 
	else 
	begin 
	a_1 <= #1 A;
	a_2 <= #1 a_1;
	a_3 <= #1 a_2;
	a_4 <= #1 a_3;
	a_5 <= #1 a_4;
	a_6 <= #1 a_5;

	d_1 <= #1 D;
	d_2 <= #1 d_1;
	d_3 <= #1 d_2;
	d_4 <= #1 d_3;
	d_5 <= #1 d_4;
	d_6 <= #1 d_5;
	d_7 <= #1 d_6;
	d_8 <= #1 d_7;
	d_9 <= #1 d_8;
	d_10 <= #1 d_9;
	d_11 <= #1d_10;
	d_12 <= #1 d_11; 



	end
end 

always @(posedge clk or posedge rst)
begin 
	if(rst)
	begin 
	 b_delta_square_1 <= 0;
	 b_delta_square_2 <= 0;
	 b_delta_square_3 <= 0;
	 b_delta_square_4 <= 0;
	 b_delta_square_5 <= 0;
	 b_delta_square_6 <= 0;
	c_delta_1 <= 0;
	c_delta_2 <= 0;
	c_delta_3 <= 0;
	c_delta_4 <= 0;
	c_delta_5 <= 0;
	c_delta_6 <= 0;

	pushout_c_1 <= 0; 
	pushout_c_2 <= 0; 	
	pushout_c_3 <= 0; 	
	pushout_c_4 <= 0; 	
	pushout_c_5 <= 0; 
	pushout_c_6 <= 0;

	end
	else 
	begin 
	
	 b_delta_square_1 <= #1 b_delta_square;
	 b_delta_square_2 <=#1  b_delta_square_1;
	 b_delta_square_3 <= #1 b_delta_square_2;
	 b_delta_square_4 <= #1 b_delta_square_3;
	 b_delta_square_5 <= #1 b_delta_square_4;
	 b_delta_square_6 <= #1 b_delta_square_5;
		 		
	c_delta_1 <=#1 c_delta;
	c_delta_2 <=#1 c_delta_1;
	c_delta_3 <=#1 c_delta_2;
	c_delta_4 <=#1 c_delta_3;
	c_delta_5 <=#1 c_delta_4;
	c_delta_6 <=#1 c_delta_5;

	pushout_c_1 <=#1 pushout_c; 
	pushout_c_2 <= #1 pushout_c_1; 	
	pushout_c_3 <= #1pushout_c_2; 	
	pushout_c_4 <=#1 pushout_c_3; 	
	pushout_c_5 <= #1pushout_c_4; 
	pushout_c_6 <= #1pushout_c_5;

	end
end 



endmodule 

 
