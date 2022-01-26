`timescale 1ns/10ps

module sync_handshake(input logic clk_i,rstn_i,clk_o,rstn_o,
			input logic [7:0] din,
			output logic [7:0] dout,
			input logic in_vld,out_ack,
			output logic out_vld,in_ack);

	logic in_vld_t;
	logic out_ack_t;
	logic in_vld_o,out_ack_o,out_vld_o;
	logic [7:0] din_t;

	//send in_vld
	always_ff@(posedge clk_i,negedge rstn_i)begin
		if(~rstn_i) in_vld_t<=1'b0;
		else in_vld_t<=in_vld;
	end

	always_ff@(posedge clk_o,negedge rstn_o)begin
		if(~rstn_o) begin
			in_vld_o<=1'b0;
			out_vld_o<=1'b0;
			out_vld<=1'b0;
		end else begin
			in_vld_o<=in_vld_t;
			out_vld_o<=in_vld_o;
			out_vld<=out_vld_o;
		end
	end

	//send data
	always_ff@(posedge clk_i,negedge rstn_i)begin
		if(~rstn_i) din_t<=1'b0;
		else din_t<=din;
	end


	
	always_ff@(posedge clk_o,negedge rstn_o)begin
		if(~rstn_o) begin
			dout<=8'd0;
		end else if (out_vld_o)begin
			dout<=din_t;
		end
	end

	//send out_ack
	always_ff@(posedge clk_o,negedge rstn_o)begin
		if(~rstn_o) out_ack_t<=1'b0;
		else out_ack_t<=out_ack;
	end

	always_ff@(posedge clk_i,negedge rstn_i)begin
		if(~rstn_i) begin 
			out_ack_o<=1'b0;
			in_ack<=1'b0;
		end else begin
			out_ack_o<=out_ack_t;
			in_ack<=out_ack_o;
		end
	end

endmodule


module sync_hs_tb;

logic clk_i,clk_o,rstn_i,rstn_o;
logic [7:0] din,dout;
logic in_vld,out_vld,in_ack,out_ack;

sync_handshake dut(clk_i,rstn_i,clk_o,rstn_o,din,dout,in_vld,out_ack,out_vld,in_ack);

always #3 clk_i<=~clk_i;
always #5 clk_o<=~clk_o;

initial begin
	clk_i<=1'b0;
	clk_o<=1'b0;
	rstn_i<=1'b0;
	rstn_o<=1'b0;
	din<=8'hff;
	in_vld<=1'b0;
	out_ack<=1'b0;
	#10 rstn_i<=1'b1;
	#10 rstn_o<=1'b1;
	#10 in_vld<=1'b1;
	#30 out_ack<=1'b1;
	@(posedge in_ack) #1 in_vld<=1'b0;
	
end

endmodule

