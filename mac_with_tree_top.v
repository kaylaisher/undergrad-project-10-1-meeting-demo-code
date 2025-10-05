`timescale 1ns/1ps

module mac_with_tree_top (
    input              clk,
    input              reset,           // sync, active-high
    input  [255:0]     in_array,
    input  [1023:0]    weight_array,
    output             out_valid,
    output [11:0]      total_sum,
    output [19:0]      Q,

    output [128*5-1:0] L1_r,
    output [64*6-1:0]  L2_r,
    output [32*7-1:0]  L3_r,
    output [16*8-1:0]  L4_r,
    output [8*9-1:0]   L5_r,
    output [4*10-1:0]  L6_r,
    output [2*11-1:0]  L7_r,
    output [11:0]      L8_r
);
    wire [1023:0] product_array;

    mac_slice u_mac (
        .in_array(in_array),
        .weight_array(weight_array),
        .product_array(product_array)
    );

    adder_tree_256x4 u_tree (
        .clk        (clk),
        .reset      (reset),
        .data_in_flat(product_array),
        .out_valid  (out_valid),
        .sum_out    (total_sum),
        .L1_r       (L1_r),
        .L2_r       (L2_r),
        .L3_r       (L3_r),
        .L4_r       (L4_r),
        .L5_r       (L5_r),
        .L6_r       (L6_r),
        .L7_r       (L7_r),
        .L8_r       (L8_r)
    );
    assign Q = {8'b0, total_sum};
    
endmodule
