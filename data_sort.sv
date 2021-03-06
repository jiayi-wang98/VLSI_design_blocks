`timescale 1ns/10ps

module ctrl(input logic clk,rstn,sob,in_vld,
	input [3:0] addr_o,
	output logic we,out_vld,
	output logic [3:0] addr);

	logic [3:0] cnt;
	logic [1:0]state,next_state;
	
	always_ff @(posedge clk,negedge rstn)begin
		if(~rstn) begin
			cnt<=4'h0;
			state<=2'b00;
		end else begin
			cnt<=4'h0;
			state<=next_state;
			if(|state) begin
				if(&cnt) cnt<=4'h0;
				else cnt<=cnt+4'h1;
			end
		end
	end

	assign we=(|state);
	assign addr=state[0]?cnt:addr_o;
	assign out_vld=state[1];
	always_comb begin
		case (state)
			2'b00:next_state=sob? 2'b01:2'b00;
			2'b01:next_state=(&cnt)?2'b10:2'b01;
			2'b10:next_state=(&cnt)?(sob?2'b01:2'b00):2'b10;
			default:next_state=2'b00;
		endcase
	end
endmodule

module data_buff(input logic clk,rstn,we,
		input logic [15:0] data_in,
		input logic [3:0] addr,
		output logic [255:0] data_out);

	logic [15:0] data_buff[0:15];
	always_ff@(posedge clk, negedge rstn)begin
		if(~rstn) begin
			for (int i=0;i<16;i+=1)begin
				data_buff[i]<=16'h0000;
			end
		end else begin
			if(we) data_buff[addr]<=data_in;
		end
	end

	always_comb begin
		for (int i=0;i<16;i+=1) begin
			data_out[i*16+:16]=data_buff[i];
		end
	end
endmodule

module compare_two(input logic [15:0] a,b,
		output logic [15:0] max,
		output logic z);

	logic [16:0] sub;
	logic [15:0] notb;
	assign notb=~b;
	assign sub={a[15],a}+{notb[15],notb}+{{16{1'b0}},1'b1};
	assign z=sub[16];
	assign max=z?b:a;
endmodule

module data_sort(input logic clk,rstn,sob,in_vld,
		input logic [15:0] din,
		output logic [15:0] dout,
		output logic out_vld);
	
	logic [3:0]com_addr_o,ram_addr_i;
	logic we;
	logic [255:0] com_data_i;
	logic [15:0] data_in;

	assign data_in=out_vld?16'h8000:din;

	ctrl ctrl_0(.clk(clk),.rstn(rstn),.sob(sob),.in_vld(in_vld),
	.addr_o(com_addr_o),
	.we(we),.out_vld(out_vld),
	.addr(ram_addr_i));

	data_buff data_buff_0(.clk(clk),.rstn(rstn),.we(we),
		.data_in(data_in),
		.addr(ram_addr_i),
		.data_out(com_data_i));
	
	logic [7:0]A_z;
	logic [15:0] A_d [0:7];

	logic [3:0]B_z;
	logic [15:0] B_d[0:3];
	
	logic [1:0]C_z;
	logic [31:0] C_d;
	
	logic D_z;	

	genvar i;

	generate
		for(i=0;i<8;i+=1) begin: compare_block_A
			compare_two compare_two_A1(.a(com_data_i[i*32+:16]),.b(com_data_i[(i*32+16)+:16]),.max(A_d[i]),.z(A_z[i]));
		end

		for(i=0;i<4;i+=1) begin: compare_block_B
			compare_two compare_two_B1(.a(A_d[i*2]),.b(A_d[i*2+1]),.max(B_d[i]),.z(B_z[i]));
		end
	endgenerate

	compare_two compare_two_C1(.a(B_d[0]),.b(B_d[1]),.max(C_d[15:0]),.z(C_z[0]));
	compare_two compare_two_C2(.a(B_d[2]),.b(B_d[3]),.max(C_d[31:16]),.z(C_z[1]));

	compare_two compare_two_D1(.a(C_d[15:0]),.b(C_d[31:16]),.max(dout),.z(D_z));

	always_comb begin
		com_addr_o[3]=D_z;
		com_addr_o[2]=D_z?C_z[1]:C_z[0];
		case({D_z,com_addr_o[2]})
			2'b00:com_addr_o[1]=B_z[0];
			2'b01:com_addr_o[1]=B_z[1];
			2'b10:com_addr_o[1]=B_z[2];
			2'b11:com_addr_o[1]=B_z[3];
		endcase

		case({D_z,com_addr_o[2],com_addr_o[1]})
			3'b000:com_addr_o[0]=A_z[0];
			3'b001:com_addr_o[0]=A_z[1];
			3'b010:com_addr_o[0]=A_z[2];
			3'b011:com_addr_o[0]=A_z[3];
			3'b100:com_addr_o[0]=A_z[4];
			3'b101:com_addr_o[0]=A_z[5];
			3'b110:com_addr_o[0]=A_z[6];
			3'b111:com_addr_o[0]=A_z[7];
		endcase
	end
endmodule

		
module data_sort_tb;

logic clk,rstn,sob,in_vld,out_vld;
logic [15:0] din,dout;

always #5 clk<=~clk;

data_sort dut(clk,rstn,sob,in_vld,din,dout,out_vld);
initial begin
	clk<=1'b0;
	rstn<=1'b0;
	sob<=1'b0;
	in_vld<=1'b0;
	din<=16'h0000;
	#10 rstn<=1'b1;
	#10 sob<=1'b1;
	#10 in_vld<=1'b1;din<=16'hffff;sob<=1'b0;
	#10 din<=16'hfff0;
	#10 din<=16'h0000;
	#10 din<=16'h1234;
	#10 din<=16'h6264;
	#10 din<=16'hf264;
	#10 din<=16'h5261;
	#10 din<=16'h5000;
	#10 din<=16'h2001;
	#10 din<=16'haaaa;
	#10 din<=16'h5555;
	#10 din<=16'h1111;
	#10 din<=16'h2222;
	#10 din<=16'h8888;
	#10 din<=16'h9999;
	#10 din<=16'h1101;
	#10 in_vld=1'b0;
	#200;
end
endmodule
	
		
		
