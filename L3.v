module L3(clock,SwO,db1o,db2o);

	input clock, SwO;
	output db1o, db2o;

	debouncer1 db1(.clock(clock), .SwO(SwO), .out(db1o)); 
	debouncer2 db2(.clock(clock), .SwO(SwO), .out(db2o)); 
	
endmodule

module debouncer1(clock,SwO,out);

	input SwO,clock;
	output reg out;
	reg [3:0] sw_reg;

	always @(posedge clock)
		begin
			sw_reg[0] <= SwO;
			sw_reg[3:1] <= sw_reg[2:0];
		
			if ((sw_reg[0] == sw_reg[1]) && (sw_reg[0] == sw_reg[2]) && (sw_reg[0] == sw_reg[3]))
				out <= sw_reg[0];
			else
				out <= out;
		end

endmodule

module debouncer2(clock,SwO,out);

	input clock;
	input SwO;
	output reg out;
	reg [1:0] ct;
	
	always @(posedge clock)
	begin
		if (ct == 2'b11)
			begin
			if (SwO != out)
				begin
					out <= ~out;
					ct <= 2'b00;
				end
			else
				begin
					out <= out;
					ct <= ct;
				end
			
			end
		else
			begin
				if (ct != 2'b11)
					ct <= ct + 2'b01;
				else
					ct <= ct;
			end
	end
	
endmodule
