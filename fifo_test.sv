`include "fifo_env.sv"
`define DEF_FIFO_WIDTH 8
`define DEF_FIFO_DEPTH 2**5

program test(fifo_intf intf);

	// Declare env object
fifo_env #(.FIFO_WIDTH(`DEF_FIFO_WIDTH),.FIFO_DEPTH(`DEF_FIFO_DEPTH)) env;

	//int num_data = $urandom_range(15,`DEF_FIFO_DEPTH);
  int num_data = `DEF_FIFO_DEPTH; // FORCES full signal after reaching FIFO_DEPTH

	// Instantiate the environment object
	initial begin
      if($test$plusargs("T1"))
begin
  env = new(intf);
  env.gen.num_data = num_data;// Overrides default value generated in gen
  env.run();
end

if($test$plusargs("T2"))
begin
	env = new(intf);
	env.gen.num_data = num_data;// Overrides default value generated in gen
	env.gen.mode_val = 0;			// Disable randomization
	env.gen.test = "write_only";// Overrides default value generated in gen
	env.run();
end

if($test$plusargs("T3"))
begin
	env = new(intf);
	env.gen.num_data = num_data;// Overrides default value generated in gen
	env.gen.mode_val = 0;			// Disable randomization
	env.gen.test = "write_read";// Overrides default value generated in gen
		env.run();
end
    end
  
endprogram
