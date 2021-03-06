`timescale 1ns/10ps
module bin2bcd(input logic bin_vld,
	input logic [10:0] bin,
	output logic [16:0] bcd,
	output logic bcd_vld);
	
	
	logic [9:0] bin_comp,data_in;
	assign bin_comp=(~bin[9:0]+10'd1);
	assign data_in=bin[10]?bin_comp:bin[9:0];
	assign bcd[16]=bin[10];
	assign bcd_vld=1'b1;
	logic [5:0] cin_tens,cin_huns;
	//bcd[3:0]
	compute_ones compute_0(.din(data_in),.cin(6'd0),.low_bcd(bcd[3:0]),.high_bcd(cin_tens));
	compute_tens compute_1(.din(data_in[9:4]),.cin(cin_tens),.low_bcd(bcd[7:4]),.high_bcd(cin_huns));
	compute_huns compute_2(.din(data_in[9:7]),.cin(cin_huns),.low_bcd(bcd[11:8]),.high_bcd(bcd[15:12]));
endmodule

module bin2bcd_pipe(input logic bin_vld,clk,rst_n,
	input logic [10:0] bin,
	output logic [16:0] bcd,
	output logic bcd_vld);
	
	logic [9:0] bin_comp,data_n,data_r;
	logic bcd16_n,bcd16_r;
	logic bin_vld_1;
	assign bin_comp=(~bin[9:0]+10'd1);
	assign data_n=bin[10]?bin_comp:bin[9:0];
	assign bcd16_n=bin[10];

	//stage_1
	always_ff @(posedge clk, negedge rst_n)begin
		if(~rst_n) begin
			data_r<=10'd0;
			bcd16_r<=1'b0;
			bin_vld_1<=1'b0;
		end else begin
			data_r<=data_n;
			bcd16_r<=bcd16_n;
			bin_vld_1<=bin_vld;
		end
	end

	//state_2, compute_ones
	logic [3:0] bcd30_1_n,bcd30_1_r;
	logic [5:0] cin_tens_n,cin_tens_r;
	logic [9:0] data_r_2;
	logic bin_vld_2,bcd16_2_r;
	compute_ones compute_0(.din(data_r),.cin(6'd0),.low_bcd(bcd30_1_n),.high_bcd(cin_tens_n));
	always_ff @(posedge clk, negedge rst_n)begin
		if(~rst_n) begin
			bcd16_2_r<=1'b0;
			bcd30_1_r<=4'd0;
			cin_tens_r<=6'd0;
			data_r_2<=10'd0;
			bin_vld_2<=1'b0;
		end else begin
			bcd16_2_r<=bcd16_r;
			bcd30_1_r<=bcd30_1_n;
			cin_tens_r<=cin_tens_n;
			data_r_2<=data_r;
			bin_vld_2<=bin_vld_1;
		end
	end

	//state_3, compute_tens
	logic [3:0] bcd30_2_r;
	logic [3:0] bcd74_2_n,bcd74_2_r;
	logic [5:0] cin_huns_n,cin_huns_r;
	logic [9:0] data_r_3;
	logic bin_vld_3,bcd16_3_r;
	compute_tens compute_1(.din(data_r_2[9:4]),.cin(cin_tens_r),.low_bcd(bcd74_2_n),.high_bcd(cin_huns_n));
	always_ff @(posedge clk, negedge rst_n)begin
		if(~rst_n) begin
			bcd16_3_r<=1'b0;
			bcd30_2_r<=4'd0;
			bcd74_2_r<=4'd0;
			cin_huns_r<=6'd0;
			data_r_3<=10'd0;
			bin_vld_3<=1'b0;
		end else begin
			bcd16_3_r<=bcd16_2_r;
			bcd30_2_r<=bcd30_1_r;
			bcd74_2_r<=bcd74_2_n;
			cin_huns_r<=cin_huns_n;
			data_r_3<=data_r_2;
			bin_vld_3<=bin_vld_2;
		end
	end
	
	//state_4,compute huns and thousands
	logic [3:0] bcd118_3_n;
	logic [3:0] bcd1512_3_n;
	compute_huns compute_2(.din(data_r_3[9:7]),.cin(cin_huns_r),.low_bcd(bcd118_3_n),.high_bcd(bcd1512_3_n));
	always_ff @(posedge clk, negedge rst_n)begin
		if(~rst_n) begin
			bcd_vld<=1'b0;
			bcd<=17'd0;
		end else begin
			bcd_vld<=bin_vld_3;
			bcd<={bcd16_3_r,bcd1512_3_n,bcd118_3_n,bcd74_2_r,bcd30_2_r};
		end
	end
	
endmodule

module bin2bcd_pipeline_tb;
	logic clk,rst_n;
	logic bin_vld,bcd_vld;
	logic [10:0] bin;
	logic [16:0] bcd;

	bin2bcd_pipe dut(bin_vld,clk,rst_n,bin,bcd,bcd_vld);
	
	always #5 clk<=~clk;

	initial begin
		clk<=1'b0;
		rst_n<=1'b0;
		bin<=11'd0;
		bin_vld<=1'b0;
		#10 rst_n<=1'b1;
		#10 bin_vld=1'b1;
		 bin<=-11'd1023;
		#10 bin<=-11'd1000;
		#10 bin<=-11'd999;
		#10 bin<=-11'd888;
		#10 bin<=-11'd777;
		#10 bin<=-11'd666;
		#10 bin<=-11'd555;
		#10 bin<=-11'd444;
		#10 bin<=-11'd333;
		#10 bin<=-11'd222;
		#10 bin<=-11'd111;
		#10 bin<=-11'd0;
		#10 bin<=11'd111;
		#10 bin<=11'd222;
		#10 bin<=11'd333;
		#10 bin<=11'd444;
		#10 bin<=11'd555;
		#10 bin<=11'd666;
		#10 bin<=11'd777;
		#10 bin<=11'd888;
		#10 bin<=11'd999;
		#10 bin<=11'd1000;
		#10 bin<=11'd1023;
		#10 bin<=11'd1010;
	end
endmodule


module bin2bcd_tb;
	logic bin_vld,bcd_vld;
	logic [10:0] bin;
	logic [16:0] bcd;

	bin2bcd dut(bin_vld, bin,bcd,bcd_vld);

	initial begin
		 bin<=-11'd1023;
		#10 bin<=-11'd1000;
		#10 bin<=-11'd999;
		#10 bin<=-11'd888;
		#10 bin<=-11'd777;
		#10 bin<=-11'd666;
		#10 bin<=-11'd555;
		#10 bin<=-11'd444;
		#10 bin<=-11'd333;
		#10 bin<=-11'd222;
		#10 bin<=-11'd111;
		#10 bin<=-11'd0;
		#10 bin<=11'd111;
		#10 bin<=11'd222;
		#10 bin<=11'd333;
		#10 bin<=11'd444;
		#10 bin<=11'd555;
		#10 bin<=11'd666;
		#10 bin<=11'd777;
		#10 bin<=11'd888;
		#10 bin<=11'd999;
		#10 bin<=11'd1000;
		#10 bin<=11'd1023;
		#10 bin<=11'd1010;
	end
endmodule


//a,b all positive
// calculate a-b
// if a>=b, z=1, else z=0
module compare(input logic [5:0] a,b,
		output logic [5:0] sub,
		output logic z);
	logic [6:0] sub_all;
	assign sub_all={1'b0,a}-{1'b0,b};
	assign sub=sub_all[5:0];
	assign z=~sub_all[6];

endmodule

module compute_ones(input logic [9:0]din,
		input logic [5:0] cin,
		output logic [3:0] low_bcd,high_bcd);
	
	localparam [5:0] a [0:9]={6'd1,6'd2,6'd4,6'd8,6'd6,6'd2,6'd4,6'd8,6'd6,6'd2};
	logic [5:0] sum;
	logic [5:0] ele[0:9];
	logic [3:0] z;
	logic [5:0] sub[0:3];
	always_comb begin
		for(int i=0;i<10;i+=1) begin
			ele[i]=din[i]?a[i]:6'd0;
		end
		
		sum=ele[0]+ele[1]+ele[2]+ele[3]+ele[4]+ele[5]+ele[6]+ele[7]+ele[8]+ele[9]+cin;
	end
	
	compare compare_0(.a(sum),.b(6'd40),.sub(sub[3]),.z(z[3]));
	compare compare_1(.a(sum),.b(6'd30),.sub(sub[2]),.z(z[2]));
	compare compare_2(.a(sum),.b(6'd20),.sub(sub[1]),.z(z[1]));
	compare compare_3(.a(sum),.b(6'd10),.sub(sub[0]),.z(z[0]));
	
	always_comb begin 
		if(z[3]) begin
			low_bcd=sub[3];
			high_bcd=4'd4;
		end else if(z[2]) begin
			low_bcd=sub[2];
			high_bcd=4'd3;		
		end else if(z[1]) begin
			low_bcd=sub[1];
			high_bcd=4'd2;	
		end else if(z[0]) begin
			low_bcd=sub[0];
			high_bcd=4'd1;	
		end else begin
			low_bcd=sum;
			high_bcd=4'd0;		
		end
	end	
endmodule

module compute_tens(input logic [9:4]din,
		input logic [5:0] cin,
		output logic [3:0] low_bcd,high_bcd);
	
	localparam [5:0] a [4:9]={6'd1,6'd3,6'd6,6'd2,6'd5,6'd1};
	logic [5:0] sum;
	logic [5:0] ele[4:9];
	logic [3:0] z;
	logic [5:0] sub[0:3];
	always_comb begin
		for(int i=4;i<10;i+=1) begin
			ele[i]=din[i]?a[i]:6'd0;
		end
		
		sum=ele[4]+ele[5]+ele[6]+ele[7]+ele[8]+ele[9]+cin;
	end
	
	compare compare_0(.a(sum),.b(6'd40),.sub(sub[3]),.z(z[3]));
	compare compare_1(.a(sum),.b(6'd30),.sub(sub[2]),.z(z[2]));
	compare compare_2(.a(sum),.b(6'd20),.sub(sub[1]),.z(z[1]));
	compare compare_3(.a(sum),.b(6'd10),.sub(sub[0]),.z(z[0]));
	
	always_comb begin 
		if(z[3]) begin
			low_bcd=sub[3];
			high_bcd=4'd4;
		end else if(z[2]) begin
			low_bcd=sub[2];
			high_bcd=4'd3;		
		end else if(z[1]) begin
			low_bcd=sub[1];
			high_bcd=4'd2;	
		end else if(z[0]) begin
			low_bcd=sub[0];
			high_bcd=4'd1;	
		end else begin
			low_bcd=sum;
			high_bcd=4'd0;		
		end
	end	
endmodule

module compute_huns(input logic [9:7]din,
		input logic [5:0] cin,
		output logic [3:0] low_bcd,high_bcd);
	
	localparam [5:0] a [7:9]={6'd1,6'd2,6'd5};
	logic [5:0] sum;
	logic [5:0] ele[7:9];
	logic [3:0] z;
	logic [5:0] sub[0:3];
	always_comb begin
		for(int i=7;i<10;i+=1) begin
			ele[i]=din[i]?a[i]:6'd0;
		end
		
		sum=ele[7]+ele[8]+ele[9]+cin;
	end
	
	compare compare_0(.a(sum),.b(6'd40),.sub(sub[3]),.z(z[3]));
	compare compare_1(.a(sum),.b(6'd30),.sub(sub[2]),.z(z[2]));
	compare compare_2(.a(sum),.b(6'd20),.sub(sub[1]),.z(z[1]));
	compare compare_3(.a(sum),.b(6'd10),.sub(sub[0]),.z(z[0]));
	
	always_comb begin 
		if(z[3]) begin
			low_bcd=sub[3];
			high_bcd=4'd4;
		end else if(z[2]) begin
			low_bcd=sub[2];
			high_bcd=4'd3;		
		end else if(z[1]) begin
			low_bcd=sub[1];
			high_bcd=4'd2;	
		end else if(z[0]) begin
			low_bcd=sub[0];
			high_bcd=4'd1;	
		end else begin
			low_bcd=sum;
			high_bcd=4'd0;		
		end
	end	
endmodule
