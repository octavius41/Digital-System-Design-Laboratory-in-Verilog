module mlab5(input clk, input ten, input [7:0]tDi, output [7:0]tDo, output tRo, output trDo, output tclko, output tPER);

	wire clk2;
	wire temp;
	
	assign trDo = temp;
	assign tclko = clk2;
	
	uptr	trn(.clk(clk),.Di(tDi[7:0]),.en(ten),.clko(clk2),.Do(trDo));
	uprecv	rcv(.clk(clk2),.tDi(temp),.rDo(tDo[7:0]),.Ro(tRo),.PER(tPER));

endmodule


module uptr(input clk, input [7:0]Di, input en, output clko, output Do);

	reg [9:0]temp;
	assign clko = clk;
	assign Do = temp[9];
	reg remb;	
	reg tout;

	always @(posedge clk) 
	begin 
		if(tout)
			begin
				temp[9]   <= 1'b1;
				temp[8:1] <= Di[7:0];
				temp[0]   <= Di[7]+Di[6]+Di[5]+Di[4]+Di[3]+Di[2]+Di[1]+Di[0];
			end
		else
			begin
				temp[9:1] <= temp[8:0];
				temp[0] <= 1'b0;
			end	
		remb <= tout;
	end
	
	always @(posedge en or posedge remb)
		begin
			if (remb)
				tout <= 1'b0;
			else
				tout <= 1'b1;
		end
		
endmodule

module uprecv(input clk, input tDi, output [7:0]rDo, output Ro, output reg PER);

	reg hold;
	reg [9:0]temp;
	reg tPar;
	
	
always @(posedge clk)
	hold <= tDi;
	
assign rDo[7:0] = (temp[9]) ? temp[8:1] : 8'b0;
assign Ro = temp[9];

always @(posedge clk)
	begin
		if (temp[9])
			begin
				tPar <= 1'b1;
				temp[9:0] <= 10'b0;
			end
		else
			begin
				temp[0]   <= hold;
				temp[9:1] <= temp[8:0];
			end
	end

always @(posedge Ro)
	begin
		PER <= rDo[0]+rDo[1]+rDo[2]+rDo[3]+rDo[4]+rDo[5]+rDo[6]+rDo[7]+tPar;
	end

	
endmodule
