`include "fifo_sb.sv"
`include "fifo_gen.sv"
`include "fifo_drv.sv"
`include "fifo_mon.sv"

`ifndef FIFO_ENV
`define FIFO_ENV

class fifo_env #(parameter FIFO_WIDTH = 8,parameter FIFO_DEPTH=32);
	// Instantiate Driver and Generator classes
	fifo_gen # (.FIFO_WIDTH(FIFO_WIDTH),.FIFO_DEPTH(FIFO_DEPTH)) gen;	// Fifo Generator
	fifo_drv drv;								// Fifo Master Driver
	fifo_input_mon in_mon;							// Input monitor
	fifo_sb sb;								// Fifo Scoreboard

	// Create a mailbox to send/receive data packets

	mailbox gen2drv;
	mailbox in_mon2sb;

	// Instantiate a virtual interface
	virtual fifo_intf fifo_vif;

	// User-defined class constructor

	function new(virtual fifo_intf fifo_vif);
		this.fifo_vif = fifo_vif;
		
		/* TODO:Check if necessary to use new() on mailbox*/
		gen2drv = new();	
		in_mon2sb = new();	

		// instantiate al TB classes

		drv = new(fifo_vif,gen2drv);
		gen = new(gen2drv);
      in_mon = new(fifo_vif,in_mon2sb);
      sb = new(in_mon2sb);

	endfunction

	task pre_test;			// Run the reset task
		drv.reset();
	endtask
	
	task test;
		fork
			gen.run();
			drv.run();
			in_mon.sample();
			sb.run();
		join_any
	endtask

	task post_test;
		wait(gen.num_data == drv.no_transactions);
      wait(gen.num_data == sb.no_trans);
	endtask

	task run;
      begin
		pre_test;
		test;
		post_test;
		$finish;
      end
	endtask

endclass
`endif
