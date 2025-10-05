`timescale 1ns / 1ps

module tb_slices_64();

reg clk = 0;
always #5 clk = ~clk; 

reg reset;
initial begin
    reset = 1'b1;
    repeat (2) @ (posedge clk);
    reset = 1'b0;
end

reg  [255:0]             in_array;
reg  [1024*64-1:0]       weight_arrays_flat;
wire [64*20-1:0]         Q_total_flat;

genvar i;
generate
    for (i = 0; i < 64; i = i + 1) begin : Q_slice
        wire [19:0] Q = Q_total_flat[20*i +: 20];
    end
endgenerate


initial begin
    in_array                 = {256{1'b1}};
    //{1024*32{1'b1}, 1024*32{1'b0}}
    weight_arrays_flat            = 65535'b0;
    weight_arrays_flat[1023:0]    = {256{4'b0001}};
    weight_arrays_flat[2047:1024] = {256{4'b0010}};
    weight_arrays_flat[3071:2048] = {256{4'b0011}};


end


slices_64 #(
    .N(64), .IN_W(256), .WE_W(1024), .Q_W(20)
) dut (
    .clk(clk),
    .reset(reset),
    .in_array(in_array),
    .weight_arrays_flat(weight_arrays_flat),
    .Q_total_flat(Q_total_flat)
);

initial begin
    #200;
    $finish;
end


endmodule
