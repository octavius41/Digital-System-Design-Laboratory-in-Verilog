module mlab4(input clk, input sen, input [7:0]Din, output [7:0]Do, output Ro, output trDo, output clko2);

	wire clk2;
	wire pass;
	
	assign trDo = pass;
	assign clko2 = clk2;
		
	transmt trn(.clk(clk),.Din(Din[7:0]),.sen(sen),.clko(clk2),.Do(pass) );
	receiv rcv(.clk(clk2),.trDin(pass),.rDo(Do[7:0]),.Ro(Ro));

endmodule

module transmt(input clk, input sen, input [7:0] Din, output clko, output Do);

	reg [8:0]temp;
	
	assign clko = clk;
	assign Do = temp[8];
	
	always @(posedge clk)
		begin
			if(sen)
				begin 
					temp[7:0] <= Din[7:0];
					temp[8] <= 1'b1;
				end
			else
				begin	
					temp[8:1] <= temp[7:0];
					temp[0] <= 1'b0;
				end
		end
		
endmodule

module receiv(input clk, input trDin, output [7:0]rDo, output Ro);

	reg [8:0]temp;
	
	assign rDo[7:0] = (temp[8]) ? temp[7:0] : 8'b0;
	assign Ro = temp[8];
	
	always @(posedge clk)
		begin
			if (temp[8])
				temp[8:0] <= 9'b0;
			else if (~temp[8])
				begin
					temp[8:1] <= temp[7:0];
					temp[0]   <= trDin;
				end
			else
				temp[8:0] <= temp[8:0];
		end
		
endmodule

