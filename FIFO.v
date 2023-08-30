`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:05:17 08/26/2023 
// Design Name: 
// Module Name:    FIFO 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module FIFO
#(
parameter FIFO_DEPTH=8,
 parameter DATA_WIDTH=32
)
( 
input clk,reset,cs,
input  wr_en,rd_en,
input [DATA_WIDTH-1:0] data_in,
output full,empty,
output  reg [DATA_WIDTH-1:0] data_out
);
localparam DEPTH=clog2(FIFO_DEPTH);

reg [DATA_WIDTH -1:0] fifo [0 : FIFO_DEPTH -1 ];
 
 // Wr/Rd pointer have 1 extra bits at MSB
 reg [DEPTH:0] write_pointer;
 reg [DEPTH:0] read_pointer;
 


always @(posedge clk or negedge reset) begin
	if(! reset) 
		begin
		write_pointer<=0;
		end
	else if(cs && wr_en  && !full)
		begin
		write_pointer<=write_pointer+1'b1;
		fifo[write_pointer[DEPTH-1:0]] <= data_in;
		end
end

always @(posedge clk or negedge reset) begin
	if(! reset) 
		begin
		read_pointer<=0;
		data_out <= 0;
		end
	else if(cs && rd_en  && !empty)
		begin
		read_pointer<=read_pointer+1'b1;
		data_out <= fifo[read_pointer[DEPTH-1:0]];
		end
end

		
assign empty =(read_pointer == write_pointer)? 1'b1:1'b0;

assign full  = (read_pointer == {~write_pointer[DEPTH], write_pointer[DEPTH-1:0]});
		

//****************************************************
// function for log 
function integer clog2;
  input integer value;
  begin
    value = value-1;
    for (clog2=0; value>0; clog2=clog2+1)
      value = value>>1;
  end
endfunction

endmodule
