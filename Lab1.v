module Lab1(Clock, Reset, Select, Output);
	input Clock;
	input Reset;
	input Select;
	output Output;
	wire [2:0] Wire;
	
	//module AND_XOR(Input1, Input2, Select, Output);
	//module Counter(Output,Clock,Reset);
	
	Counter Module1(.Clock(Clock), .Reset(Reset), .Output(Wire));
	AND_XOR Module2(.Input1(Wire[0]), .Input2(Wire[2]), .Select(Select), .Output(Output));

endmodule

module Counter(Output,Clock,Reset);
	input Reset;
	input Clock;
	output [2:0] Output;
	reg [2:0] Data;

	always@ ( posedge Clock or negedge Reset)
		begin
			if(Reset == 1'b0) //Reset
				Data[2:0] <= 3'b000; //Non-Blocking Assigment
			else // Increment
				Data[2:0] <= Data[2:0] + 3'b001; //Non-Blocking Assigment
		end

	assign Output[2:0] = Data[2:0]; //Blocking Assigment

endmodule

module AND_XOR(Input1, Input2, Select, Output);
	input Input1;
	input Input2;
	input Select;
	output Output;
	//Select 1 => AND Gate
	//Select 0 0> XOR Gate
	
	assign Output = (Select == 1'b0) ? (Input1 & Input2) : (Input1 ^ Input2);
	
endmodule

