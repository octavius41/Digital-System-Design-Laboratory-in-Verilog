module L2(input reset, input clock, input fen, output [3:0]d1, output [3:0]d10, output [3:0]d100);
wire [1:0]trans;

ninedbcd digit1(.reset(reset), .clock(clock), .fen(fen), .ct(d1), .xten(trans[0]));
ninedbcd digit10(.reset(reset), .clock(clock), .fen(fen && trans[0]), .ct(d10), .xten(trans[1]));
ninedbcd digit100(.reset(reset), .clock(clock), .fen(fen && trans[0] && trans[1]), .ct(d100), .xten());
endmodule

module ninedbcd(input clock, input reset, input fen, output reg [3:0]ct, output xten);
 
always @(posedge clock or negedge reset)
	begin
		if(reset == 1'b1) 
			if(fen == 1'b1)
				if(ct[3:0] == 4'b1001)
					ct[3:0] <= 4'b0;
				else
					ct[3:0] <= ct[3:0] + 4'b1;
			else 
				ct[3:0] <= ct[3:0];
		else
			ct[3:0] <= 4'b0;
	end

assign xten  = (ct[3:0] == 4'b1001) ? 1'b1 : 1'b0;
endmodule
