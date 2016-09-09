interface input_if(input clk, rst);
    logic [31:0] A, B;
    logic valid, ready;
    
    modport port(input clk, rst, A, B, valid, output ready);
endinterface

