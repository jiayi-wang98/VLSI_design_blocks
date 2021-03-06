`timescale 1ns/10ps
module z_scan(input logic clk,rstn,sob,
		output logic [5:0] zid,
		output logic zid_vld);

	logic state,next_state;
	logic [5:0]cnt;

	assign zid_vld=state;

	always_ff@(posedge clk, negedge rstn)begin
		if(!rstn) begin 
			state<=1'b0;
			cnt<=6'd0;
		end else begin 
			state<=next_state;
			if (state)
				if(cnt!=6'd63) cnt<=cnt+6'd1;
				else cnt<=6'd0;
			else cnt<=6'd0;
		end
	end
	assign zid={cnt[5],cnt[3],cnt[1],cnt[4],cnt[2],cnt[0]};
	assign next_state=(!state & sob ) | (state & (!(&cnt) | sob));
endmodule 

module z_scan_tb;
logic clk,rstn,sob,zid_vld;
logic [5:0] zid;
z_scan dut(clk,rstn,sob,zid,zid_vld);

always begin
	#5 clk<=~clk;
end

initial begin
	clk<=1'b0;
	rstn<=1'b0;
	sob<=1'b0;
	#10 rstn<=1'b1;
	#10 sob<=1'b1;
	#10 sob<=1'b0;
	#630 sob<=1'b1;
	#10 sob<=1'b0;
	#660 sob<=1'b1;
	#10 sob<=1'b0;
	#640;
end
endmodule
		
