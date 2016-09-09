module adder(input_if.port inter, output_if.port out_inter, output state);
    enum logic [1:0] {INITIAL,WAIT,SEND} state;
    
    always_ff @(posedge inter.clk)
        if(inter.rst) begin
            inter.ready <= 0;
            out_inter.data <= 'x;
            out_inter.valid <= 0;
            state <= INITIAL;
        end
        else case(state)
                INITIAL: begin
                    inter.ready <= 1;
                    state <= WAIT;
                end
                
                WAIT: begin
                    if(inter.valid) begin
                        inter.ready <= 0;
                        out_inter.data <= inter.A + inter.B;
                        out_inter.valid <= 1;
                        state <= SEND;
                    end
                end
                
                SEND: begin
                    if(out_inter.ready) begin
                        out_inter.valid <= 0;
                        inter.ready <= 1;
                        state <= WAIT;
                    end
                end
        endcase
endmodule: adder
