class fifo_drv;
	virtual interface fifo_intf fifo_vif;
	`define DRIV_IF fifo_vif.fifo_drv_cb

	// create a mailbox to receive pkt from gen
	mailbox gen2drv;	// Incoming pkt (GEN-->DRV)
      int no_transactions;

	function new (virtual interface fifo_intf fifo_vif, mailbox mbx);// Class constructor
		this.fifo_vif = fifo_vif;
		this.gen2drv = mbx;
	endfunction
      
      task reset;
        begin
    $display("DRV: resetting");
         wait(!fifo_vif.rstN); 
    `DRIV_IF.data_in <= 0;
    `DRIV_IF.wr_en <= 0;
          `DRIV_IF.rd_en <= 0;
	 wait (fifo_vif.rstN);
    $display("DRV: done resetting");
        end
  endtask 

	task run;		// This task puts generated pkts from gen to drv
		forever begin
			fifo_trans trans;
          gen2drv.get(trans);
          `DRIV_IF.wr_en <= 0;
      `DRIV_IF.rd_en <= 0; 
      //gen2driv.get(trans);
          
      $display("--------- [DRIVER-TRANSFER: %0d] ---------",no_transactions);
           @(posedge fifo_vif.fifo_drv_mp.clk);
        //`DRIV_IF.addr <= trans.addr;
      if(trans.wr_en) begin
        `DRIV_IF.wr_en <= trans.wr_en;
        `DRIV_IF.data_in <= trans.data_in;
        $display("\tdata_in = %0h",trans.data_in);
        @(posedge fifo_vif.fifo_drv_mp.clk);
      end
      if(trans.rd_en) begin
        `DRIV_IF.rd_en <= trans.rd_en;
        @(posedge fifo_vif.fifo_drv_mp.clk);
        `DRIV_IF.rd_en <= 0;
        @(posedge fifo_vif.fifo_drv_mp.clk);
        trans.data_out = `DRIV_IF.data_out;
        trans.full = `DRIV_IF.full;
        trans.empty = `DRIV_IF.empty;
        trans.wrptr = `DRIV_IF.wrptr;
        trans.rdptr = `DRIV_IF.rdptr;
        $display("\tdata_out = %0h,\tfull = %0h,\tempty = %0h", `DRIV_IF.data_out,`DRIV_IF.full,`DRIV_IF.empty);
      end
      $display("-----------------------------------------");
      no_transactions++;
        end
	endtask
      
      
              
             

endclass	
