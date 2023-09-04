// pc_counter -----
module pc_counter (clock, endereco);
	input clock;
	reg [31:0] counter;
	output [31:0] endereco;
	initial begin
		counter = 32'b00000000000000000000000000000000;
	end

	always @(posedge clock) begin
		counter = counter + 32'b00000000000000000000000000000001;
	end
	assign endereco = counter;
endmodule


// cpu -----
module cpu (clock, valor_saida);
	input clock;
	output [31:0] valor_saida;
	wire [31:0] counter;
	wire [31:0] instrucao;
	wire [31:0] data_ula;
	wire [31:0] valor_regd;
	wire [31:0] valor_reg1;
	wire [31:0] valor_reg2;
	pc_counter pc_counter
	( 
		clock, 
		counter
	);
	memoria_instrucoes memoria_instrucoes
	(
		counter, 
		clock,
		instrucao
	);
	banco_registradores banco_registradores
	(
		clock,
		instrucao[26:22],
		instrucao[21:17],
		instrucao[16:12],
		data_ula,
		valor_regd,
		valor_reg1, 
		valor_reg2
	);
	ula ula
	(
		instrucao[31:27],
		valor_reg1,
		valor_reg2,
		data_ula
	);
	assign valor_saida = valor_regd;
endmodule


// memoria -----
module memoria_instrucoes (counter, clock, instrucao_saida);
	input clock;
	input [31:0] counter;
	output [31:0] instrucao_saida;
	reg [31:0] memoria_instrucoes [99:0];
	always @(posedge clock)
	begin
		//                          |opc  regd reg1 reg2 |
		//                          |/////\\\\\/////\\\\\|
		memoria_instrucoes[0] <= 32'b00001001100011000100000000000000; 
		memoria_instrucoes[1] <= 32'b00001001100011000100000000000000; 
		memoria_instrucoes[2] <= 32'b00001001100011000100000000000000;
		memoria_instrucoes[3] <= 32'b00001001100011000100000000000000;
		memoria_instrucoes[4] <= 32'b00011001100011000101000000000000;
		//teste
		memoria_instrucoes[5] <= 32'b00001000100000100011000000000001;
		memoria_instrucoes[6] <= 32'b00001000100001100000000000000010;
		memoria_instrucoes[7] <= 32'b00001000100000000001000000000000; 
		memoria_instrucoes[8] <= 32'b00001000100000100011000000000001;
		memoria_instrucoes[9] <= 32'b00001000100001100000000000000010;
		memoria_instrucoes[10] <= 32'b00001000100000000001000000000000; 
		memoria_instrucoes[11] <= 32'b00001000100000100011000000000001;
		memoria_instrucoes[12] <= 32'b00001000100001100000000000000010;
		memoria_instrucoes[13] <= 32'b00001000100000000001000000000000; 
		memoria_instrucoes[13] <= 32'b00001000100000100011000000000001;
		memoria_instrucoes[15] <= 32'b00001000100001100000000000000010;
	end
	assign instrucao_saida = memoria_instrucoes[counter];
endmodule

// registradores -----
module banco_registradores (clock, endereco_regd, endereco_reg1, endereco_reg2, data_in, valor_regd, valor_reg1, valor_reg2);
	input clock;
	input [4:0] endereco_regd;
	input [4:0] endereco_reg1;
	input [4:0] endereco_reg2;
	input [31:0] data_in;
	output [31:0] valor_regd;
	output [31:0] valor_reg1;
	output [31:0] valor_reg2;
	reg [31:0] registradores[31:0];
	initial begin
      	registradores[5'b00000] = 32'b00000000000000000000000000000011;
		registradores[5'b00001] = 32'b00000000000000000000000000000101;
		registradores[5'b00010] = 32'b00000000000000000000000000001011;
		registradores[5'b00011] = 32'b00000000000000000000000000000110;
		registradores[5'b00100] = 32'b00000000000000000000000000001010; // 10
		registradores[5'b00101] = 32'b00000000000000000000000000000011; // 3
		registradores[5'b00110] = 32'b00000000000000000000000000000000; // 0 destino
	end
	always @(posedge clock)
	begin
		registradores[endereco_regd] <= data_in; 
	end
	assign valor_regd = registradores[endereco_regd];
	assign valor_reg1 = registradores[endereco_reg1];
	assign valor_reg2 = registradores[endereco_reg2];
endmodule

// ula -----
module ula
	(opcode, data1_in, data2_in, data_out);
	input [31:0] data1_in;   
	input [31:0] data2_in;
	input [4:0] opcode;
	output [31:0] data_out;
	reg [31:0] result;
	always @(data1_in or data2_in or opcode)
	begin
		case(opcode)
			5'b00001:
			result = data1_in + data2_in;
            5'b00011:
			result = data1_in - data2_in;
			default:
				result = 32'b00000000000000000000000000000000;
		endcase
	end
	assign data_out = result;
endmodule
