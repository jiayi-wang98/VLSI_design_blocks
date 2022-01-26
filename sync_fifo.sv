`timescale 1ns/10ps

module sync_fifo #(parameter DWIDTH=8,
		parameter FIFO_DEPTH=8)
		(input logic clk,rstn,
		input logic push,
		input logic [DWIDTH-1:0] din,
		input logic pop,
		output logic [DWIDTH-1:0] dout,
		output logic fifo_empty,fifo_full,
		output logic overflow,underflow);

	reg [DWIDTH-1:0] mem [0:FIFO_DEPTH-1];
	logic [$clog2(FIFO_DEPTH):0] rd_ptr,wt_ptr;
	logic [DWIDTH-1:0] dout_n;

	//full logic
	assign fifo_full=(rd_ptr[$clog2(FIFO_DEPTH)]!=wt_ptr[$clog2(FIFO_DEPTH)])&&(rd_ptr[$clog2(FIFO_DEPTH)-1:0]==wt_ptr[$clog2(FIFO_DEPTH)-1:0]);
	assign overflow=fifo_full&push;
	//empty logic
	assign fifo_empty=(rd_ptr==wt_ptr)?1'b1:1'b0;
	assign underflow=fifo_empty&pop;
	

	//read logic
	assign dout_n=mem[rd_ptr[$clog2(FIFO_DEPTH)-1:0]];

	always_ff@(posedge clk,negedge rstn)begin
		if(~rstn) begin
			dout<=8'd0;
			wt_ptr<=4'd0;
			rd_ptr<=4'd0;
		end else begin
			if(push & (~fifo_full)) begin
				mem[wt_ptr[$clog2(FIFO_DEPTH)-1:0]]<=din;
				wt_ptr<=wt_ptr+1'd1;
			end
			
			if(pop & (~fifo_empty)) begin
				dout<=dout_n;
				rd_ptr<=rd_ptr+1'd1;
			end
		end
	end
endmodule

module sync_fifo_tb;
logic clk,rstn,push,pop,fifo_empty,fifo_full,overflow,underflow;
logic [7:0] dout,din;

sync_fifo #(.DWIDTH(8),.FIFO_DEPTH(4)) dut (clk,rstn,push,din,pop,dout,fifo_empty,fifo_full,overflow,underflow);

always #5 clk=~clk;

initial begin
	clk<=1'b0;
	rstn<=1'b0;
	din<=8'd0;
	push<=1'b0;
	pop<=1'b0;
	#10 rstn<=1'b1;
	for (int i=0;i<5;i+=1) begin
		#10 push<=1'b1;
		din<=din+8'd1;
		#10 push<=1'b0;
		#10 push<=1'b1;
		din<=din+8'd1;
	end
	for (int i=0;i<8;i+=1) begin
		#10 pop<=1'b1;
	end	
end
endmodule