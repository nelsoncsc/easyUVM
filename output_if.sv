interface output_if(input clk, rst);
    logic [31:0] data;
    logic valid, ready;
    
    modport port(input clk, rst, output valid, data, ready);
endinterface

