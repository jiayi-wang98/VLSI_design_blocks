module async_fifo #(parameter DWIDTH=8,
		parameter FIFO_DEPTH=8) //should be 2^N
		(input logic wclk,rclk,rstn,
		input logic push,
		input logic [DWIDTH-1:0] din,
		input logic pop,
		output logic [DWIDTH-1:0] dout,
		output logic fifo_empty,fifo_full,
		output logic overflow,underflow);

	reg [DWIDTH-1:0] mem [0:FIFO_DEPTH-1];
	logic [$clog2(FIFO_DEPTH):0] rd_ptr,rd_ptr_w,rd_ptr_gray,rd_ptr_gray_t,rd_ptr_gray_tt;
	logic [$clog2(FIFO_DEPTH):0] wt_ptr,wt_ptr_r,wt_ptr_gray,wt_ptr_gray_t,wt_ptr_gray_tt;
	logic [DWIDTH-1:0] dout_n;
	
	//full logic
	assign fifo_full=(rd_ptr_w[$clog2(FIFO_DEPTH)]!=wt_ptr[$clog2(FIFO_DEPTH)])&&(rd_ptr_w[$clog2(FIFO_DEPTH)-1:0]==wt_ptr[$clog2(FIFO_DEPTH)-1:0]);
	assign overflow=fifo_full&push;
	//empty logic
	assign fifo_empty=(rd_ptr==wt_ptr_r)?1'b1:1'b0;
	assign underflow=fifo_empty&pop;
	
	//write pointer block and memory
	bin2gray #(.WIDTH($clog2(FIFO_DEPTH)+1)) rp_gray(wt_ptr,wt_ptr_gray);
	always_ff@(posedge wclk,negedge rstn)begin
		if(~rstn) begin
			wt_ptr<='d0;
		end else if(push & (~fifo_full)) begin
			mem[wt_ptr[$clog2(FIFO_DEPTH)-1:0]]<=din;
			wt_ptr<=wt_ptr+1'd1;
		end
	end

	always_ff@(posedge wclk,negedge rstn)begin
		if(~rstn) begin
			rd_ptr_gray_t<='d0;
			rd_ptr_gray_tt<='d0;
		end else begin
			rd_ptr_gray_t<=rd_ptr_gray;
			rd_ptr_gray_tt<=rd_ptr_gray_t;
		end
	end
	
	gray2bin #(.WIDTH($clog2(FIFO_DEPTH)+1)) gray2bin_rd(rd_ptr_gray_tt,rd_ptr_w);


	//read logic
	assign dout=mem[rd_ptr[$clog2(FIFO_DEPTH)-1:0]];

	//read pointer block
	bin2gray #(.WIDTH($clog2(FIFO_DEPTH)+1)) wp_gray(rd_ptr,rd_ptr_gray);
	always_ff@(posedge rclk,negedge rstn)begin
		if(~rstn) begin
			rd_ptr<='d0;
		end else if(pop & (~fifo_empty)) begin
			rd_ptr<=rd_ptr+1'd1;
		end
	end

	always_ff@(posedge rclk,negedge rstn)begin
		if(~rstn) begin
			wt_ptr_gray_t<='d0;
			wt_ptr_gray_tt<='d0;
		end else begin
			wt_ptr_gray_t<=wt_ptr_gray;
			wt_ptr_gray_tt<=wt_ptr_gray_t;
		end
	end
	
	gray2bin #(.WIDTH($clog2(FIFO_DEPTH)+1)) gray2bin_wt(wt_ptr_gray_tt,wt_ptr_r);
endmodule


module bin2gray #(parameter WIDTH=8)
		(input logic [WIDTH-1:0] bin,
		output logic [WIDTH-1:0] gray);

	assign gray=bin^{1'b0,bin[WIDTH-1:1]};

endmodule

module gray2bin #(parameter WIDTH=8)
		(input logic [WIDTH-1:0] gray,
		output logic [WIDTH-1:0] bin);
	
	assign bin[WIDTH-1]=gray[WIDTH-1];
	always_comb begin
		for(int i=1;i<WIDTH;i+=1) begin
			bin[WIDTH-1-i]=gray[WIDTH-1-i]^bin[WIDTH-i];
		end
	end
endmodule

module async_fifo_tb();
reg wclk,rclk;
reg[7:0] din;
wire[7:0] dout;
wire fifo_empty,fifo_full,overflow,underflow;
reg rstn;
reg push,pop;
async_fifo #(.DWIDTH(8),.FIFO_DEPTH(8))
	dut(wclk,rclk,rstn,push,din, pop,dout,fifo_empty,fifo_full,overflow,underflow);
initial begin
	#0 din=8'h0;
	#50 din=8'b00000001;
	#80 din=8'h2;
	#70 din=8'h3;
	#79 din=8'h4;
	#80 din=8'h5;
	#40 din=8'h6;
	#60 din=8'h7;
	#50 din=8'h8;
	#50 din=8'h9;
	#20 din=8'h10;
	#70 din=8'h11;
	#80 din=8'h12;
	#19 din=8'h13;
	#10 din=8'h14;
	#80 din=8'h15;
	end

initial begin
	wclk=1'b0;
	push=1'b0;
	rclk=1'b0;
	pop=1'b0;
end

always #50 wclk=~wclk; 
always #10 rclk=~rclk;

initial rstn=1'b0;
initial #50 rstn=1'b1;

initial #50 push=1'b1;
initial #50 pop=1'b1;
initial
$monitor( "$time data_out,empty ,full= %d %d %d",dout,fifo_empty,fifo_full);
endmodule