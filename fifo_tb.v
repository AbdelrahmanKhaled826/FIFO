`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   03:30:00 08/30/2023
// Design Name:   FIFO
// Module Name:   C:/example_verilog/d_ff/fifo_tb.v
// Project Name:  d_ff
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: FIFO
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module fifo_tb;

parameter FIFO_DEPTH=8;
 parameter DATA_WIDTH=32;
	// Inputs
	reg clk;
	reg reset;
	reg cs;
	reg wr_en;
	reg rd_en;
	reg [31:0] data_in;

	// Outputs
	wire full;
	wire empty;
	wire [31:0] data_out;


	integer i;
	// Instantiate the Unit Under Test (UUT)
	FIFO  #(.FIFO_DEPTH(8),
	     .DATA_WIDTH(32))
		FIFO(
		.clk(clk), 
		.reset(reset), 
		.cs(cs), 
		.wr_en(wr_en), 
		.rd_en(rd_en), 
		.data_in(data_in), 
		.full(full), 
		.empty(empty), 
		.data_out(data_out)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 0;
		cs = 0;
		wr_en = 0;
		rd_en = 0;
		data_in = 0;

	end
       task write_data(input [DATA_WIDTH-1:0] d_in);
	    begin
		    @(posedge clk); // sync to positive edge of clock
			cs = 1; wr_en = 1;
			data_in = d_in;
			$display($time, " write_data data_in = %0d", data_in);
			@(posedge clk);
		    cs = 1; wr_en = 0;
		end
	endtask
	
	task read_data();
	    begin
		    @(posedge clk);  // sync to positive edge of clock
			cs = 1; rd_en = 1;
			@(posedge clk);
			#0.1;
		    $display($time, " read_data data_out = %0d", data_out);
		    cs = 1; rd_en = 0;
		end
	endtask
	
	// Create the clock signal
	always begin #0.5 clk = ~clk; end
	
    // Create stimulus	  
    initial begin
	    #1; 
		reset = 0; rd_en = 0; wr_en = 0;
		
		#1.3; 
		reset = 1;
		$display($time, "\n SCENARIO 1");
		write_data(1);
		write_data(10);
		write_data(100);
		read_data();
		read_data();
		read_data();
		read_data();
		
        $display($time, "\n SCENARIO 2");
		for (i=0; i<FIFO_DEPTH; i=i+1) begin
		    write_data(2**i);
			read_data();        
		end

        $display($time, "\n SCENARIO 3");		
		for (i=0; i<=FIFO_DEPTH; i=i+1) begin
		    write_data(2**i);
		end
		
		for (i=0; i<FIFO_DEPTH; i=i+1) begin
			read_data();
		end
		
	    #40 $stop;
	end
      
endmodule

