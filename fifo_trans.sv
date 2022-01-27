class fifo_trans #(parameter FIFO_WIDTH=8);
 
  bit 				rstN,clk;
  rand bit [FIFO_WIDTH-1:0] 	data_in;
  rand bit 			wr_en,rd_en;	
  bit[FIFO_WIDTH-1:0]			data_out;
  bit 				full,empty;
  bit [5:0] wrptr,rdptr;
  
  static int trans_id;
  static int no_of_read_trans;
  static int no_of_write_trans;
  static int no_of_rw_trans;
  
  constraint v1 {wr_en != rd_en;};
  constraint v2 {{wr_en,rd_en} != 2'd0;};
  constraint v3 {data_in inside {[1:4294]};};
  
  virtual function void display(input string message);
	  $display("------------------");
	  $display("%s",message);
	  $display("\t transaction number : %d",trans_id);
	  $display("\t read transaction number : %d",no_of_read_trans);
	  $display("\t write transaction number : %d",no_of_write_trans);
	  $display("\t rd_wr transaction number : %d",no_of_rw_trans);
	  $display("\t write=%d read=%d",wr_en,rd_en);
	  $display("\t data_in = %d",data_in);
	  $display("\t data_out = %d",data_out);
      $display("\t wrptr = %d",wrptr);
      $display("\t rdptr = %d",rdptr);
	  $display("------------------");
  endfunction:display
  
  function void post_randomize();
	  if(this.rd_en == 1 && this.wr_en == 0) no_of_read_trans++;
	  if(this.rd_en == 0 && this.wr_en == 1) no_of_write_trans++;
	  if(this.rd_en == 1 && this.wr_en == 1) no_of_rw_trans++;
	  this.display("\t randomized data");
  endfunction
  
endclass
