typedef virtual output_if output_vif;

class driver_out extends uvm_driver #(packet_out);
    `uvm_component_utils(driver_out)
    output_vif vif;

    function new(string name = "driver_out", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        assert(uvm_config_db#(output_vif)::get(this, "", "vif", vif));
    endfunction

    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        fork
            reset_signals();
            drive(phase);
        join
    endtask

    virtual protected task reset_signals();
        wait (vif.rst === 1);
        forever begin
            vif.ready <= '0;
            @(posedge vif.rst);
        end
    endtask

    virtual protected task drive(uvm_phase phase);
        wait(vif.rst === 1);
        @(negedge vif.rst);
        forever begin
          @(posedge vif.clk);
          vif.ready <= 1;
        end
    endtask
endclass
