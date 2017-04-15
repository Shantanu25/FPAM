 

module normalization(input [63:0]a,
			input [63:0]b,

			output [63:0] delta_1,
			output [63:0] delta_2);
parameter fbw=63;
reg [10:0] U1_expR,U2_expR;	
integer U1_renorm,U2_renorm;
reg [63:0] U1_resout,U2_resout;
reg [fbw:0] fractR;
reg [fbw:0] U1_fractR,U2_fractR;
integer constant = 1023;
assign delta_1 = U1_resout;

assign delta_2 = U2_resout;


always @(*)
begin 
	U1_fractR = a;
	U2_fractR = b;
  // U1_expR = 9;
  // U2_expR = 9;
    U1_renorm=0; 
    if(U1_fractR[fbw]) begin
      U1_fractR={U1_fractR[fbw]};
      U1_expR=U1_expR+1;
    end
    if(U1_fractR[63:32]==0) begin 
	U1_renorm[5]=1; U1_fractR={U1_fractR[31:0],32'b0 }; 
    end
    if(U1_fractR[63:48]==0) begin 
	U1_renorm[4]=1; U1_fractR={U1_fractR[47:0],16'b0 }; 
    end
    if(U1_fractR[63:56]==0) begin 
	U1_renorm[3]=1; U1_fractR={U1_fractR[55:0], 8'b0 }; 
    end
    if(U1_fractR[63:60]==0) begin 
	U1_renorm[2]=1; U1_fractR={ U1_fractR[59:0], 4'b0 }; 
    end
    if(U1_fractR[63:62]==0) begin 
	U1_renorm[1]=1; U1_fractR={U1_fractR[61:0], 2'b0 }; 
    end
    if(U1_fractR[63]==0) begin 
	U1_renorm[0]=1; U1_fractR={ U1_fractR[62:0], 1'b0 }; 
    end
       if(U1_fractR != 0) begin
       	U1_expR =  1023 - U1_renorm + 1 -2 ;
     	 if(U1_fractR[fbw]==0) begin
           U1_expR=U1_expR+1;
       	   U1_fractR={U1_fractR[fbw:0]};
      	  end
        end 
       else 
       begin
     	 U1_expR=0;
       end
 
    	U1_resout={1'b0,U1_expR,U1_fractR[fbw-1:fbw-52]};


	U2_renorm=0;   
    if(U2_fractR[fbw]) begin
      U2_fractR={U2_fractR[fbw]};
      U2_expR=U2_expR+1;
    end

    if(U2_fractR[fbw:fbw-31]==0) begin 
	U2_renorm[5]=1; U2_fractR={U2_fractR[fbw-32:0],32'b0 }; 
    end
    if(U2_fractR[fbw:fbw-15]==0) begin 
	U2_renorm[4]=1; U2_fractR={ U2_fractR[fbw-16:0],16'b0 }; 
    end
    if(U2_fractR[fbw:fbw-7]==0) begin 
	U2_renorm[3]=1; U2_fractR={ U2_fractR[fbw-8:0], 8'b0 }; 
    end
    if(U2_fractR[fbw:fbw-3]==0) begin 
	U2_renorm[2]=1; U2_fractR={ U2_fractR[fbw-4:0], 4'b0 }; 
    end
    if(U2_fractR[fbw:fbw-1]==0) begin 
	U2_renorm[1]=1; U2_fractR={ U2_fractR[fbw-2:0], 2'b0 }; 
    end
    if(U2_fractR[fbw]==0) begin 
	U2_renorm[0]=1; U2_fractR={ U2_fractR[fbw-1:0], 1'b0 }; 
    end
   if(U2_fractR != 0) begin
       	U2_expR =  1023 - U2_renorm + 1 - 2;
   	 if(U2_fractR[fbw]==0) begin
           U2_expR=U2_expR+1;
       	   U2_fractR={U2_fractR[fbw:0]};
      	  end
        end 
       else 
       begin
     	 U2_expR=0;
       end


	U2_resout={1'b0,U2_expR,U2_fractR[fbw-1:fbw-52]};
	

end 

















endmodule 



