`timescale 1ns/10ps
module arbiter_circle(input logic clk,rst_n,
		input logic [3:0] req,
		output logic [3:0] gnt);

	logic [1:0]state,next_state;
	logic [3:0]gnt_out;
	logic [15:0]priority_seq;
	logic en;
	assign en=(state==2'b01)?1'b1:1'b0;
	always_ff@(posedge clk,negedge rst_n) begin
		if(~rst_n) state<=2'b00;
		else state<=next_state;
	end

	always_ff@(posedge clk,negedge rst_n) begin
		if(~rst_n) gnt<=4'b0000;
		else gnt<=(next_state==2'b01)?gnt_out:4'b0000;
	end

	always_comb begin
		if(state==2'b00) 
			if(|req) next_state=2'b01;
			else next_state=2'b00;
		else next_state=state+1'b1;
	end
	
	priority_register r0(.clk(clk),.rst_n(rst_n),.enabled(en),.gnt(gnt_out),.priority_seq(priority_seq));
	priority_decoder d0(.req(req),.seq(priority_seq),.gnt(gnt_out));
	

endmodule

module arbiter_circle_tb;
logic clk,rst_n;
logic [3:0] req,gnt;

always #5 clk=~clk;

arbiter_circle dut(clk,rst_n,req,gnt);

initial begin
	clk<=1'b0;
	rst_n<=1'b0;
	req<=4'b0000;
	#10 rst_n<=1'b1;
	#10 req<=4'b0001;
	#15 req<=4'b0000;
	#25 req<=4'b1000;
	#15 req<=4'b0010;
	#20 req<=4'b0000;
	#20 req<=4'b1111;
	#30;
end
endmodule
	

module priority_register(input logic clk,rst_n,enabled,
			input logic [3:0] gnt,
			output logic [15:0] priority_seq);
	
	logic [2:0] en;
	always_comb begin
		if (gnt==priority_seq[3:0]) en=3'b111;
		else if (gnt==priority_seq[7:4]) en=3'b110;
		else if (gnt==priority_seq[11:8]) en=3'b100;
		else en=3'b000;
	end

	always_ff@(posedge clk, negedge rst_n)begin
		if(~rst_n) begin
			priority_seq<=16'b1000_0100_0010_0001; // 3 2 1 0
		end else if (enabled) begin
			priority_seq[3:0]<=en[0]?priority_seq[7:4]:priority_seq[3:0];
			priority_seq[7:4]<=en[1]?priority_seq[11:8]:priority_seq[7:4];
			priority_seq[11:8]<=en[2]?priority_seq[15:12]:priority_seq[11:8];
			priority_seq[15:12]<=gnt;		
		end
	end
			
endmodule


module priority_decoder(input logic [3:0] req,
			input logic [15:0] seq,
			output logic [3:0] gnt);

	always_comb begin
		if ((seq[3:0]&req)!=4'd0) gnt=seq[3:0];
		else if ((seq[7:4]&req)!=4'd0) gnt=seq[7:4];
		else if ((seq[11:8]&req)!=4'd0) gnt=seq[11:8];
		else if ((seq[15:12]&req)!=4'd0) gnt=seq[15:12];
		else gnt=4'b0000;
	end
endmodule


		

		