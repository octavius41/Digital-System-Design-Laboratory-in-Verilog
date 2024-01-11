module exp7top(input clk,input sel1,input sel2,input sel3,input sel4,input rnw1,input rnw2,input rnw3,input rnw4 ,inout [7:0]DioExt);

tri [7:0]Dbus;

R8B R1(clk,sel1,rnw1,Dbus);
R8B R2(clk,sel2,rnw2,Dbus);
R8B R3(clk,sel3,rnw3,Dbus);

wire in;
assign in = ( (rnw1|rnw2|rnw3) & ~(sel1&sel2) & ~(sel1&sel3) & ~(sel2&sel3) ) | ( ~(sel1|sel2|sel3) ) ;
wire out;
assign out = ~in;
	
assign Dbus[7:0] = (in) ? DioExt[7:0] : 8'bZ; 
assign DioExt[7:0] = (out) ? Dbus[7:0]  : 8'bZ; 

endmodule


module R8B(input clk, input sel, input rnw, inout [7:0]Dio);

reg [7:0]st;
	
always @(posedge clk)
	if(rnw == 1'b1 && sel == 1'b1)
		st[7:0] <= Dio[7:0];
	else
		st[7:0] <= st[7:0];
			
assign Dio[7:0] = (sel == 1'b1 && rnw == 1'b0) ? st[7:0] : 8'bZ;

endmodule 

module ACC(clk, sel, rnw, Dio);
	input clk;
	input sel;
	input rnw;
	inout [7:0]Dio;
	reg [7:0]st;
	wire reset;
	assign reset = sel & rnw; 
	
	always @(posedge clk) 
		if (rnw ==1'b0 && sel == 1'b1) 
			st[7:0] <= st[7:0] + Dio[7:0]; 
		else if (reset)
			st[7:0] <= 8'b0;
		else
			st[7:0] <= st[7:0];
		
	assign Dio[7:0] = (sel == 1'b1 && rnw == 1'b1) ? st[7:0] : 8'bZ;
endmodule
