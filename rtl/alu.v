`timescale 1ns / 1ps

module alu #(parameter WIDTH = 32) (
    input  wire                 clk,
    input  wire                 reset,
    input  wire                 enable,   // Low-power clock gating
    input  wire [WIDTH-1:0]     A,
    input  wire [WIDTH-1:0]     B,
    input  wire [3:0]           opcode,
    
    output reg  [WIDTH-1:0]     result,
    output reg                  Z_flag,   // Zero
    output reg                  C_flag,   // Carry
    output reg                  V_flag,   // Overflow
    output reg                  N_flag    // Negative
);

    // Internal wires for combinational logic
    reg [WIDTH-1:0] next_result;
    reg next_Z, next_C, next_V, next_N;

    // --- OPERAND ISOLATION (Low-Power Concept) ---
    // If the opcode is NOT an arithmetic operation, force adder inputs to 0.
    // This prevents the adder logic gates from toggling unnecessarily.
    wire is_arithmetic = (opcode == 4'b0000 || opcode == 4'b0001 || opcode == 4'b1000 || opcode == 4'b1001);
    wire [WIDTH-1:0] isolated_A = is_arithmetic ? A : {WIDTH{1'b0}};
    wire [WIDTH-1:0] isolated_B = is_arithmetic ? B : {WIDTH{1'b0}};

    always @(*) begin
        // Default flag values
        next_C = 1'b0;
        next_V = 1'b0;
        
        case (opcode)
            4'b0000: begin // ADD
                {next_C, next_result} = isolated_A + isolated_B;
                next_V = (isolated_A[WIDTH-1] == isolated_B[WIDTH-1]) && (next_result[WIDTH-1] != isolated_A[WIDTH-1]);
            end
            4'b0001: begin // SUB
                {next_C, next_result} = isolated_A - isolated_B;
                next_V = (isolated_A[WIDTH-1] != isolated_B[WIDTH-1]) && (next_result[WIDTH-1] != isolated_A[WIDTH-1]);
            end
            4'b0010: next_result = A & B;                // AND
            4'b0011: next_result = A | B;                // OR
            4'b0100: next_result = A ^ B;                // XOR
            4'b0101: next_result = ~A;                   // NOT A
            4'b0110: next_result = A << 1;               // Shift Left
            4'b0111: next_result = A >> 1;               // Shift Right
            4'b1000: {next_C, next_result} = isolated_A + 1; // Increment A
            4'b1001: {next_C, next_result} = isolated_A - 1; // Decrement A
            4'b1010: next_result = (A < B) ? 1 : 0;      // Compare (A < B)
            default: next_result = {WIDTH{1'b0}};
        endcase

        // Common Flags calculation
        next_Z = (next_result == {WIDTH{1'b0}}) ? 1'b1 : 1'b0;
        next_N = next_result[WIDTH-1];
    end

    // --- SEQUENTIAL LOGIC & CLOCK GATING ---
    // Registers only update if 'enable' is high. 
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            result <= {WIDTH{1'b0}};
            Z_flag <= 1'b0;
            C_flag <= 1'b0;
            V_flag <= 1'b0;
            N_flag <= 1'b0;
        end else if (enable) begin
            result <= next_result;
            Z_flag <= next_Z;
            C_flag <= next_C;
            V_flag <= next_V;
            N_flag <= next_N;
        end
        // If enable is 0, registers hold their previous state (saving power)
    end
endmodule