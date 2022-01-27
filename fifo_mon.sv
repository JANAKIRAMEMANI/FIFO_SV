`define MON_IF fifo_vif.fifo_mon_mp.fifo_mon_cb
class fifo_input_mon;
	
	virtual fifo_intf fifo_vif;

	mailbox in_mon2sb;		// Mailbox from input monitor to SB

	// constructor
	function new(virtual fifo_intf vif, mailbox in_mon2sb);
		this.fifo_vif = vif;
		this.in_mon2sb = in_mon2sb;
	endfunction

	task sample;
		forever begin
			fifo_trans trans;
			trans = new();
		
          @(posedge fifo_vif.fifo_mon_mp.clk);
      wait(`MON_IF.rd_en || `MON_IF.wr_en);
          
        trans.wr_en = `MON_IF.wr_en;
        trans.rd_en = `MON_IF.rd_en;
          trans.data_in = `MON_IF.data_in;
          trans.wrptr = `MON_IF.wrptr;
          trans.rdptr = `MON_IF.rdptr;
          
         
          @(negedge fifo_vif.fifo_mon_mp.clk); 
          fork
            fifo_trans trans_temp;
            begin
              trans_temp = trans;
              @(posedge fifo_vif.fifo_mon_mp.clk);
          trans_temp.full = `MON_IF.full;
          trans_temp.empty = `MON_IF.empty;
          trans_temp.data_out = `MON_IF.data_out;
              
              $display($time,":","MON: wr_en=%0d ,rd_en=%0d, wrptr=%0d,rdptr=%0d,data_in=%0d,data_out=%0d,full=%0d,empty=%0d",trans.wr_en,trans.rd_en,trans.wrptr,trans.rdptr,trans.data_in,trans_temp.data_out, trans_temp.full,trans_temp.empty);

              in_mon2sb.put(trans_temp);
            end
          join_none
					
			end
		//end
	endtask
endclass
