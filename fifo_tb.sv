`include "interface.sv"
`include "test.sv"
`define DEF_FIFO_WIDTH 8
`define DEF_FIFO_DEPTH 2**5

module fifo_top;		// Testbench top file
	// Clock gen logic
	bit clk;
	
	always #5 clk = ~clk;
	
	
	
	logic rstN;
	
	initial begin
		rstN = 0; #100 rstN = 1;
	end 
	
	
	// instantiate interface 
	fifo_intf 	#(.FIFO_WIDTH(`DEF_FIFO_WIDTH),
			.FIFO_DEPTH(`DEF_FIFO_DEPTH))
			intf 	
				(.clk(clk),
				.rstN(rstN)
			);
	
	
	// Connect DUT and interface signals
	fifo 	 	#(.FIFO_WIDTH(`DEF_FIFO_WIDTH),
			.FIFO_DEPTH(`DEF_FIFO_DEPTH))
			DUT	(
			.clk(intf.clk),
			.rstN(intf.rstN),
			.wr_en(intf.wr_en),
			.rd_en(intf.rd_en),
			.data_in(intf.data_in),
			.data_out(intf.data_out),
    			.empty(intf.empty),
              .full(intf.full),
              .wrptr(intf.wrptr),
              .rdptr(intf.rdptr)
            );	

 test t1(intf);

	initial begin			// for dumping signals
      $dumpfile("dump.vcd");
		$dumpvars;
	end
endmodule
