/* Testbench for ALL MODULES */

module cpu_tb;
	//clock
	reg clock_tb;
	//cpu
	wire [31:0] output_cpu;
	//pc_counter
	wire [31:0] output_pc_counter;
	//memoria
	wire [31:0] output_memoria;
	wire [31:0] counter_memoria;
	//registradores
	wire [31:0] output_registradores;
	wire [31:0] valor_regd;
	wire [31:0] valor_reg1;
	wire [31:0] valor_reg2;
	//ula
	wire [31:0] output_ula;

	// all modules variables:
	pc_counter dut2(clock_tb, output_pc_counter);
	cpu dut1(clock_tb, output_cpu);
	memoria_instrucoes dut3(output_pc_counter, clock_tb, output_memoria);
	banco_registradores dut4(clock_tb, output_memoria[26:22], output_memoria[21:17], output_memoria[16:12], output_ula, valor_regd, valor_reg1, valor_reg2);
	ula dut5(output_memoria[31:27], valor_reg1, valor_reg2, output_ula);

	initial
	begin
		// specify test points to be captured
		$dumpfile("latch.vcd");
		$dumpvars(1);
		$display("endereco saida");
      $monitor("clock: %b\npc counter: %b\n memoria: %b\ncpu: %b\nregistradores: %b %b %b\nula: %b\n", clock_tb, output_pc_counter, output_memoria, output_cpu, valor_regd, valor_reg1, valor_reg2, output_ula);

		// excercise the lines to test:

		clock_tb=1'b0;
		#5 clock_tb=1'b1;
		#5 clock_tb=1'b0;
		#5 clock_tb=1'b1;
		#5 clock_tb=1'b0;
		#5 clock_tb=1'b1;
		#5 clock_tb=1'b0;
		#5 clock_tb=1'b1;
		#5 clock_tb=1'b0;
		#5 clock_tb=1'b1;

		#5  $finish;
	end
endmodule
