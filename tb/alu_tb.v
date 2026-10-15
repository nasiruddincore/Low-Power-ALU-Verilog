`timescale 1ns / 1ps

module alu_tb;

    // Parameters
    parameter WIDTH = 32;

    // Inputs
    reg clk;
    reg reset;
    reg enable;
    reg [WIDTH-1:0] A;
    reg [WIDTH-1:0] B;
    reg [3:0] opcode;

    // Outputs
    wire [WIDTH-1:0] result;
    wire Z_flag;
    wire C_flag;
    wire V_flag;
    wire N_flag;

    // Instantiate ALU
    alu #(WIDTH) uut (
        .clk(clk), 
        .reset(reset), 
        .enable(enable), 
        .A(A), 
        .B(B), 
        .opcode(opcode), 
        .result(result), 
        .Z_flag(Z_flag), 
        .C_flag(C_flag), 
        .V_flag(V_flag), 
        .N_flag(N_flag)
    );

    // Clock Generation
    always #5 clk = ~clk;

    initial begin
        // Generate VCD file for waveforms (Crucial for EDA Playground / Icarus)
        $dumpfile("dump.vcd");
        $dumpvars(0, alu_tb);

        // Initialize Inputs
        clk = 0;
        reset = 1;
        enable = 0;
        A = 0;
        B = 0;
        opcode = 0;

        // Reset the system
        #10;
        reset = 0;
        enable = 1;

        // Test 1: ADD
        A = 32'd15; B = 32'd10; opcode = 4'b0000;
        #10 $display("ADD: %d + %d = %d", A, B, result);

        // Test 2: SUB
        A = 32'd20; B = 32'd5; opcode = 4'b0001;
        #10 $display("SUB: %d - %d = %d", A, B, result);

        // Test 3: AND
        A = 32'hFFFF0000; B = 32'h00FF00FF; opcode = 4'b0010;
        #10 $display("AND: %h & %h = %h", A, B, result);

        // Test 4: Low Power Enable Test (Hold state)
        enable = 0; 
        A = 32'd999; B = 32'd999; opcode = 4'b0000; 
        #10 $display("DISABLED (Should hold previous AND result): %h", result);

        // Test 5: Re-enable and test COMPARE
        enable = 1;
        A = 32'd5; B = 32'd10; opcode = 4'b1010;
        #10 $display("CMP (5 < 10): %d (Expected 1)", result);

        // End Simulation
        #20 $finish;
    end
endmodule