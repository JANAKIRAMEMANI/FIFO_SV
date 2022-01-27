module fifo #(parameter FIFO_WIDTH = 8,parameter FIFO_DEPTH = 2**5)
	(clk,rstN,wr_en,rd_en,data_in,data_out,empty,full,wrptr,rdptr);

	input wire clk;
	input logic rstN;
	input logic wr_en;
	input logic rd_en;
	input logic [FIFO_WIDTH-1:0] data_in;
	output logic [FIFO_WIDTH-1:0] data_out;
	output logic empty;
	output logic full;
     output logic [5:0] wrptr,rdptr;
  
	logic tmp_empty;
	logic tmp_full;
  logic [FIFO_WIDTH-1:0] ram [0:FIFO_DEPTH-1]; 


  always@(negedge rstN)  begin // Defining reset conditions
    data_out = 0;
    tmp_empty = 1'b1; 
    tmp_full = 1'b0; 
    wrptr = 0; 
    rdptr = 0; 
  end 

  assign empty = tmp_empty; 
  assign full = tmp_full; 

  always @(posedge clk) begin 
    if((wr_en == 1) && (~tmp_full)&&(rd_en == 0)) begin
      ram[wrptr] <= data_in;
      wrptr = wrptr+1;
      tmp_empty <= 1'b0;
      if(wrptr == rdptr) begin
        tmp_full <= 1'b1;
        tmp_empty <= 1'b0; 
      end
    end
    
    else if((rd_en == 1) && (~tmp_empty)&&(wr_en == 0))begin
      data_out <= ram[rdptr];
      rdptr = rdptr+1;
	if(wrptr == rdptr) begin
        tmp_full <= 1'b0;
        tmp_empty <= 1'b1; 
      end
    end
  end 
	endmodule: fifo
