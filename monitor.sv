class monitor extends uvm_monitor;
    input_vif  vif;
    event begin_record, end_record;
    packet_in tr;
    uvm_analysis_port #(packet_in) item_collected_port;
    `uvm_component_utils(monitor)
   
    function new(string name, uvm_component parent);
        super.new(name, parent);
        item_collected_port = new ("item_collected_port", this);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        assert(uvm_config_db#(input_vif)::get(this, "", "vif", vif));
        tr = packet_in::type_id::create("tr", this);
    endfunction

    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        fork
            collect_transactions(phase);
            record_tr();
        join
    endtask

    virtual task collect_transactions(uvm_phase phase);
        wait(vif.rst === 1);
        @(negedge vif.rst);
        
        forever begin
            do begin
                @(posedge vif.clk);
            end while (vif.valid === 0 || vif.ready === 0);
            -> begin_record;
            
            tr.A = vif.A;
            tr.B = vif.B;
            item_collected_port.write(tr);

            @(posedge vif.clk);
            -> end_record;
        end
    endtask

    virtual task record_tr();
        forever begin
            @(begin_record);
            begin_tr(tr, "monitor");
            @(end_record);
            end_tr(tr);
        end
    endtask
endclass
