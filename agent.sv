class agent extends uvm_agent;
    sequencer sqr;
    driver    drv;
    monitor   mon;

    uvm_analysis_port #(packet_in) item_collected_port;

    `uvm_component_utils(agent)

    function new(string name = "agent", uvm_component parent = null);
        super.new(name, parent);
        item_collected_port = new("item_collected_port", this);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        mon = monitor::type_id::create("mon", this);
        sqr = sequencer::type_id::create("sqr", this);
        drv = driver::type_id::create("drv", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        mon.item_collected_port.connect(item_collected_port);
        drv.seq_item_port.connect(sqr.seq_item_export);
    endfunction
endclass: agent
