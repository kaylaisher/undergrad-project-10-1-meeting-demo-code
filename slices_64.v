`timescale 1ns / 1ps

module slices_64 #(
    parameter N = 64,
    parameter IN_W = 256,
    parameter WE_W = 1024,
    parameter Q_W = 20
)(
    input                clk,
    input                reset,
    input [IN_W-1 : 0]   in_array,
    
    input [N*WE_W-1 : 0] weight_arrays_flat,
    
    output [N*Q_W-1 : 0] Q_total_flat
    );
    
    //Internal array
    wire [WE_W-1 : 0] weight_array [0 : N-1];
    wire [Q_W-1 : 0]  Q_total      [0 : N-1];
    
    genvar gi;
    
    //unpack the flat weight bus into 64 weight vector
    generate
        for (gi = 0; gi < N; gi = gi + 1) begin : g_unpack
            assign weight_array[gi] = weight_arrays_flat[WE_W*gi +: WE_W];
        end
    endgenerate
    
    // 64 MAC instances; only Q is used outside
    generate
        for (gi = 0; gi < N; gi = gi + 1) begin : g_mac
            wire        out_vlaid_d;
            wire [11:0] total_sum_d;
        
            mac_with_tree_top u_mac (
                .clk            (clk),
                .reset          (reset),
                .in_array       (in_array),
                .weight_array   (weight_array[gi]),
                .out_valid      (out_valid_d),
                .total_sum      (total_sum_d),
                .Q              (Q_total[gi])
            );
            
            // pack Q back to the flat output
            assign Q_total_flat[Q_W*gi +: Q_W] = Q_total[gi]; 
            
        end
    endgenerate
    
endmodule
