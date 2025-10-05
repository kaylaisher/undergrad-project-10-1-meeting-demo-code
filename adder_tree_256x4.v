`timescale 1ns/1ps

module adder_tree_256x4 (
    input              clk,
    input              reset,           
    input  [1023:0]    data_in_flat,    // 256 x 4-bit (flattened)
    output reg         out_valid,
    output reg [11:0]  sum_out,

    output reg [128*5-1:0]  L1_r,  // 128 x 5
    output reg [64*6-1:0]   L2_r,  // 64 x 6
    output reg [32*7-1:0]   L3_r,  // 32 x 7
    output reg [16*8-1:0]   L4_r,  // 16 x 8
    output reg [8*9-1:0]    L5_r,  // 8 x 9
    output reg [4*10-1:0]   L6_r,  // 4 x 10
    output reg [2*11-1:0]   L7_r,  // 2 x 11
    output reg [11:0]       L8_r  // 1 x 12 
);

    // -------------------------
    // Level 1: 256x4 -> 128x5
    // -------------------------
    wire [128*5-1:0] L1_w;
    initial  begin
        $display("L1 start");
    end
    
    genvar i1;
    generate
        for (i1 = 0; i1 < 128; i1 = i1 + 1) begin : lvl1
            
            localparam integer GI = i1;        
            wire [3:0] a = data_in_flat[4*(2*GI)   +: 4];
            wire [3:0] b = data_in_flat[4*(2*GI+1) +: 4];
            assign L1_w[5*GI +: 5] = a + b;
            
            always @* begin
                $display("L1[%0d]: a = %0d, b = %0d, sum = %0d, @t = %0t",
                        GI, a, b, L1_w[5*GI +: 5], $time);
            end
        end
    endgenerate

    // -------------------------
    // Level 2: 128x5 -> 64x6
    // -------------------------
    wire [64*6-1:0] L2_w;
    
    initial  begin
        $display("L2 start");
    end
    
    genvar i2;
    generate
        for (i2 = 0; i2 < 64; i2 = i2 + 1) begin : lvl2
        
            localparam integer GI = i2;

        
            wire [4:0] a = L1_r[5*(2*GI)   +: 5];
            wire [4:0] b = L1_r[5*(2*GI+1) +: 5];
            assign L2_w[6*GI +: 6] = a + b;
            
            always @* begin
                $display("L2[%0d]: a = %0d, b = %0d, sum = %0d, @t = %0t",
                        GI, a, b, L2_w[6*GI +: 6], $time);
            
            end

        end
    endgenerate

    // Level 3: 64x6 -> 32x7
    wire [32*7-1:0] L3_w;
    
    initial  begin
        $display("L3 start");
    end

    
    genvar i3;
    generate
        for (i3 = 0; i3 < 32; i3 = i3 + 1) begin : lvl3
        
            localparam integer GI = i3;
        
            wire [5:0] a = L2_r[6*(2*GI)   +: 6];
            wire [5:0] b = L2_r[6*(2*GI+1) +: 6];
            assign L3_w[7*GI +: 7] = a + b;
            
            always @* begin
                $display("L3[%0d]: a = %0d, b = %0d, sum = %0d, @t = %0t",
                        GI, a, b, L3_w[7*GI +: 7], $time);
            
            end

            
        end
    endgenerate

    // Level 4: 32x7 -> 16x8
    wire [16*8-1:0] L4_w;
    
    initial  begin
        $display("L4 start");
    end
    
    genvar i4;
    generate
        for (i4 = 0; i4 < 16; i4 = i4 + 1) begin : lvl4
        
            localparam integer GI = i4; 
        
            wire [6:0] a = L3_r[7*(2*GI)   +: 7];
            wire [6:0] b = L3_r[7*(2*GI+1) +: 7];
            assign L4_w[8*GI +: 8] = a + b;
            
            always @* begin
                $display("L4[%0d]: a = %0d, b = %0d, sum = %0d, @t = %0t",
                        GI, a, b, L4_w[8*GI +: 8], $time);
            
            end

            
        end
    endgenerate

    // Level 5: 16x8 -> 8x9
    wire [8*9-1:0] L5_w;
    
    initial  begin
        $display("L5 start");
    end

    genvar i5;
    generate
        for (i5 = 0; i5 < 8; i5 = i5 + 1) begin : lvl5
            
            localparam integer GI = i5;
            
            wire [7:0] a = L4_r[8*(2*GI)   +: 8];
            wire [7:0] b = L4_r[8*(2*GI+1) +: 8];
            assign L5_w[9*GI +: 9] = a + b;
            
            always @* begin
                $display("L5[%0d]: a = %0d, b = %0d, sum = %0d, @t = %0t",
                        GI, a, b, L5_w[9*GI +: 9], $time);
            
            end

        end
    endgenerate

    // Level 6: 8x9 -> 4x10
    wire [4*10-1:0] L6_w;
    
    initial  begin
        $display("L6 start");
    end
    
    genvar i6;
    generate
        for (i6 = 0; i6 < 4; i6 = i6 + 1) begin : lvl6
            
            localparam integer GI = i6;
            
            wire [8:0] a = L5_r[9*(2*GI)   +: 9];
            wire [8:0] b = L5_r[9*(2*GI+1) +: 9];
            assign L6_w[10*GI +: 10] = a + b;
            
            always @* begin
                $display("L6[%0d]: a = %0d, b = %0d, sum = %0d, @t = %0t",
                        GI, a, b, L6_w[10*GI +: 10], $time);
            
            end

        end
    endgenerate

    // Level 7: 4x10 -> 2x11
    wire [2*11-1:0] L7_w;
    
    initial  begin
        $display("L7 start");
    end

    genvar i7;
    generate
        for (i7 = 0; i7 < 2; i7 = i7 + 1) begin : lvl7
        
            localparam integer GI = i7;
        
            wire [9:0] a = L6_r[10*(2*GI)   +: 10];
            wire [9:0] b = L6_r[10*(2*GI+1) +: 10];
            assign L7_w[11*GI +: 11] = a + b;
            
            always @* begin
                $display("L7[%0d]: a = %0d, b = %0d, sum = %0d, @t = %0t",
                        GI, a, b, L7_w[11*GI +: 11], $time);
            
            end

            
        end
    endgenerate

    initial  begin
        $display("L8 start");
    end

    // Level 8: 2x11 -> 1x12
    wire [11:0] L8_w = L7_r[11*0 +: 11] + L7_r[11*1 +: 11];
    always @(*) begin
        $display("L8[%0d]: a = %0d, b = %0d, sum = %0d, @t = %0t",
                        1'd0, L7_r[11*0 +: 11], L7_r[11*1 +: 11], L8_w, $time);
    end    

    reg [3:0] stage_cnt;
    
    always @(posedge clk) begin
        if (reset) begin
            stage_cnt <= 4'd0;
        end
        else if (stage_cnt != 4'd8) begin
            stage_cnt <= stage_cnt + 4'd1;
        end
    end

    // -------------------------
    // Pipeline registers : set all the container to 0
    // -------------------------
    always @(posedge clk) begin
        if (reset) begin
            L1_r      <= { (128*5){1'b0} };
            L2_r      <= { (64*6){1'b0} };
            L3_r      <= { (32*7){1'b0} };
            L4_r      <= { (16*8){1'b0} };
            L5_r      <= { (8*9){1'b0}  };
            L6_r      <= { (4*10){1'b0} };
            L7_r      <= { (2*11){1'b0} };
            L8_r      <= 12'd0;
            sum_out   <= 12'd0;
            out_valid <= 1'b0;
        end 
        else begin
            // stage regs advance every cycle (streaming)
            L1_r      <= L1_w;
            L2_r      <= L2_w;
            L3_r      <= L3_w;
            L4_r      <= L4_w;
            L5_r      <= L5_w;
            L6_r      <= L6_w;
            L7_r      <= L7_w;
            L8_r      <= L8_w;
            sum_out   <= L8_w;
            out_valid <= (stage_cnt == 4'd8); 
        end
    end

endmodule
