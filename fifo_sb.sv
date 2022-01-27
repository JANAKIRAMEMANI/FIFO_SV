`include "fifo_trans.sv"
class fifo_sb #(parameter FIFO_WIDTH=8, parameter FIFO_DEPTH=32); 
  
  mailbox in_mon2sb;
  fifo_trans trans;
  //logic [5:0] wrptr, rdptr;  
  //logic [7:0] mem[64:0]; 
  logic [FIFO_WIDTH-1:0] mem [FIFO_DEPTH-1:0];
  int no_trans;
   
 
   function new(mailbox in_mon2sb);
      this.in_mon2sb=in_mon2sb;
    endfunction; // new

  
   
   task run();
     forever begin
       #50;
        in_mon2sb.get(trans); 
       
       if(trans.rd_en) begin
       if(mem[trans.rdptr] != trans.data_out) 
         $error("[SCB-FAIL] \tData :: Expected = %0h Actual = %0h", mem[trans.rdptr],trans.data_out);
        else 
          $display("[SCB-PASS]\t   Data :: Expected = %0h Actual = %0h", mem[trans.rdptr],trans.data_out);
       end
       
       else if ( trans.wr_en ) mem[trans.wrptr] <= trans.data_in; 
       
       no_trans++;
    end
  endtask

endclass // Scoreboard
