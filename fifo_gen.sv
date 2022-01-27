class fifo_gen #(parameter FIFO_WIDTH=8, parameter FIFO_DEPTH=2**5);

	rand fifo_trans trans;			// Create an instance of trans class
	int num_data ;// Random number of data packets to be generated
	mailbox gen2drv;			// Outward bound (GEN-->DRV) packet 

  	int mode_val = 1;// Control randomization of trans rand variables
  	string test = "rand";// Default value - can be over written in test

    function new(mailbox gen2drv);// fifo_gen class constructor    
      this.gen2drv = gen2drv;
	 endfunction 

     task run;
       int count ;
       $display($time,":","No. of input data : %0d",num_data);
       repeat(num_data) begin
         trans = new();
         trans.rand_mode(mode_val);// Added to control rand mode from env
         if(mode_val&&(test=="rand"))		// Enable randomization
           begin
             trans.trans_id++;
             $display("\tGEN::run() : %0tns New data_generated \t Data item no. %0d out of %0d\n",$time,count+1,num_data);
             if(!trans.randomize())
               $fatal("\tGEN:: Transaction class randomization failed! Exiting...\n");

	      $display("\tGEN::run() Transaction info: %0tns wr_en = %0d, rd_en = %0d, data_in = %0d\n",$time,trans.wr_en,trans.rd_en,trans.data_in);
               
		       end
		       else 	begin

			       if(test=="write_only")		// WRITE_ONLY_TEST
			       begin
				       trans.wr_en=1'b1;
				       trans.rd_en=1'b0;
				       trans.data_in = $urandom();
				       $display("\tGEN::run() : %0tns New data_generated \t Data item no. %0d out of %0d\n",$time,count+1,num_data);
				      $display("\tGEN::run() Transaction info: %0tns wr_en = %0d, rd_en = %0d, data_in = %0d\n",$time,trans.wr_en,trans.rd_en,trans.data_in);
                                           
			       end				// END: WRITE_ONLY_TEST

			       if(test=="write_read")		// WRITE_READ_TEST
			       begin
				       if(count%2==0)
				       begin
					       trans.wr_en = 1'b1;
					       trans.rd_en = 1'b0;
          				       end
				       else
				       begin
					       trans.wr_en = 1'b0;
					       trans.rd_en = 1'b1;
                         end
				       trans.data_in = $urandom();
				       $display("\tGEN::run() : %0tns New data_generated \t Data item no. %0d out of %0d\n",$time,count+1,num_data);
				       $display("\tGEN::run() Transaction info: %0tns wr_en = %0d, rd_en = %0d, data_in = %0d\n",$time,trans.wr_en,trans.rd_en,trans.data_in);
                     
                     			       end				// END: WRITE_READ_TEST
		       end
			       gen2drv.put(trans);
			       count++;
	       end
       endtask	
endclass
