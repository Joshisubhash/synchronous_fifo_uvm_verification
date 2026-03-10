import uvm_pkg::*; 
`include "uvm_macros.svh"
//`include "sequence_item.sv" 
//`include "rd_sequence.sv"

//`include "wr_sequence.sv" 
 
//`include "sequencer.sv" 
//`include "driver.sv" 
//`include "monitor.sv" 
//`include "agent.sv" 
//`include "scoreboard.sv" 
//`include "env.sv" 
//`include "test.sv" 
//`include "interface.sv"


module tb;

  logic clk;
  
  
  fifo_interface vif(clk);

  fifo dut(
    .clk(vif.clk),
    .rst(vif.rst),
    .data_in(vif.datain),
    .wr(vif.wen),
    .rd(vif.ren),
    .fifo_cnt(vif.fifo_cnt),
    .empty(vif.empty),
    .full(vif.full),
    .data_out(vif.dataout)
  );


fifo_assertion assert_inst(vif);

  always #5 clk = ~clk;

  initial begin
    clk = 0;
    vif.rst = 0;
  #20;
    vif.rst = 1;
  
  end

  initial begin
    uvm_config_db#(virtual fifo_interface)::set(null, "*", "vif", vif);
    run_test("test");
//     #100;
//     $finish;
  end
  
//   initial begin
//     #500;
//     $finish;
//   end

endmodule








interface fifo_interface(input logic clk);
  
  logic rst;
  logic wen,ren;
  logic [7:0] datain,dataout;
  logic empty,full;
  logic [3:0]fifo_cnt;
  
endinterface
  


module fifo_assertion(fifo_interface intf);
  
  
  //condtion for full check
  assert property(
    @(posedge intf.clk)
    disable iff(intf.rst)
    !(intf.wen && intf.full)  
  )else $error("fifo full error");
  
    //condition for empty check
    assert property(
      @(posedge intf.clk)
      disable iff(intf.rst)
      !(intf.ren && intf.empty)
    )else $error("fifo empty error");
      
      
      //condition for reset 
      assert property(
        @(posedge intf.clk)
        !intf.rst |=> (intf.empty && !intf.full && intf.fifo_cnt == 0)   
      )else $error("reset not set properly");
      

        
        
        //wrtie increment check
        assert property(
          @(posedge intf.clk)
          disable iff(intf.rst)
          (intf.wen && !intf.full) |=> (intf.fifo_cnt == $past(intf.fifo_cnt) + 1)
        )else $error("write increment problem");
      
          
          //read increment check
          assert property(
            @(posedge intf.clk)
            disable iff(intf.rst)
            //(intf.ren && !intf.empty)|=> (intf.fifo_cnt == $past(intf.fifo_cnt) + 1)
		(intf.ren && !intf.empty)
		|=> (intf.fifo_cnt == $past(intf.fifo_cnt) - 1)
          )else $error("read increment problem");
      
    
            //simultanuos read and write check
            assert property(
              @(posedge intf.clk)
              (intf.wen && intf.ren && !intf.full && !intf.empty)
              |-> (intf.fifo_cnt == $past(intf.fifo_cnt))
            
            )else $error("simultanous read write ocuured");  
  
  
  
  
  
endmodule
  
class seq_item extends uvm_sequence_item;
  `uvm_object_utils(seq_item) 
  
  
//   typedef enum {write, read,write_read} op_type;
//  rand op_type op;
  
  function new(string name="");
    super.new(name);
  endfunction
  
  rand logic [7:0]datain;
  rand logic wen;
  rand logic ren;
  
  
  logic [7:0] dataout;
  
  
 
  
endclass



class fifo_wr_sequence extends uvm_sequence#(seq_item);
  `uvm_object_utils(fifo_wr_sequence) 
  
//   seq_item seq;
  
  function new(string name="");
    super.new(name);
  endfunction
 
  
  task body();
    
    repeat(8)begin
    
    seq_item seq;
    
    seq = seq_item::type_id::create("seq");
    
      start_item(seq);
      assert(seq.randomize() with {
       wen == 1;
        ren == 0;
        
      });
      
       `uvm_info("WR_SEQ",$sformatf("Write generated datain=%0d", seq.datain),UVM_MEDIUM);
     
      
      finish_item(seq);
      
    end
    
    
  endtask
 
  
endclass









class fifo_rd_sequence extends uvm_sequence#(seq_item);
  `uvm_object_utils(fifo_rd_sequence) 
  
//   seq_item seq;
  
  function new(string name="");
    super.new(name);
  endfunction
 
  
  task body();
    
    `uvm_info("RD_SEQ","Read transaction generated",UVM_MEDIUM);
    
    repeat(8)begin
    
    seq_item seq;
    
    seq = seq_item::type_id::create("seq");
    
      start_item(seq);
      assert(seq.randomize() with {
         wen == 0;
        ren == 1;
        
      });
      
     
      
      finish_item(seq);
      
    end
    
    
  endtask
 
  
endclass



class fifo_wr_rd extends uvm_sequence#(seq_item);
  `uvm_object_utils(fifo_wr_rd) 
  
//   seq_item seq;
  
  function new(string name="");
    super.new(name);
  endfunction
 
  
  task body();
    
    `uvm_info("fifo write and read","fifo write and read",UVM_MEDIUM);
    
    repeat(8)begin
    
    seq_item seq;
    
    seq = seq_item::type_id::create("seq");
    
      start_item(seq);
      assert(seq.randomize() with {
         wen == 1;
        ren == 0;
        
      });
      
     
      
      finish_item(seq);
      
    end



repeat(8)begin
    
    seq_item seq;
    
    seq = seq_item::type_id::create("seq");
    
      start_item(seq);
      assert(seq.randomize() with {
         wen == 0;
        ren == 1;
        
      });
      
     
      
      finish_item(seq);
      
    end
    
    
  endtask
 
  
endclass





 
class fifo_random_seq extends uvm_sequence#(seq_item);

`uvm_object_utils(fifo_random_seq)

function new(string name="");
super.new(name);
endfunction

task body();

`uvm_info("RANDOM_SEQ","Random transaction generated",UVM_MEDIUM);

repeat(20) begin

seq_item seq;

seq = seq_item::type_id::create("seq");

start_item(seq);

assert(seq.randomize() with {
   wen || ren;
});

finish_item(seq);

end

endtask

endclass



class sim_wr_rd extends uvm_sequence#(seq_item);


`uvm_object_utils(sim_wr_rd)

function new(string name="");
super.new(name);
endfunction



task body();
`uvm_info("simultanous read and write"," simultanous read and write GENERATED",UVM_MEDIUM);

repeat(8)begin


seq_item seq;

seq = seq_item::type_id::create("seq");

start_item(seq);

assert (seq.randomize() with {
wen == 1;
ren == 1;
});

finish_item(seq);


end

endtask



endclass







 class fifo_empty_seq extends uvm_sequence #(seq_item);

`uvm_object_utils(fifo_empty_seq)

function new(string name="");
  super.new(name);
endfunction


task body();

`uvm_info("EMPTY_SEQ","FIFO EMPTY CONDITION TEST",UVM_MEDIUM);


// Step 1: Fill FIFO
repeat(16) begin

  seq_item seq;

  seq = seq_item::type_id::create("seq");

  start_item(seq);

  assert(seq.randomize() with {
    wen == 1;
    ren == 0;
  });

  finish_item(seq);

end


// Step 2: Empty FIFO
repeat(16) begin

  seq_item seq;

  seq = seq_item::type_id::create("seq");

  start_item(seq);

  assert(seq.randomize() with {
    wen == 0;
    ren == 1;
  });

  finish_item(seq);

end


// Step 3: Extra reads after empty
repeat(4) begin

  seq_item seq;

  seq = seq_item::type_id::create("seq");

  start_item(seq);

  assert(seq.randomize() with {
    wen == 0;
    ren == 1;
  });

  finish_item(seq);

end

endtask

endclass



class fifo_full_seq extends uvm_sequence #(seq_item);

`uvm_object_utils(fifo_full_seq)

function new(string name="");
  super.new(name);
endfunction


task body();

`uvm_info("FULL_SEQ","FIFO FULL CONDITION TEST",UVM_MEDIUM);

// Fill FIFO completely
repeat(16) begin

  seq_item seq;

  seq = seq_item::type_id::create("seq");

  start_item(seq);

  assert(seq.randomize() with {
    wen == 1;
    ren == 0;
  });

  finish_item(seq);

end


// Try extra writes after full
repeat(4) begin

  seq_item seq;

  seq = seq_item::type_id::create("seq");

  start_item(seq);

  assert(seq.randomize() with {
    wen == 1;
    ren == 0;
  });

  finish_item(seq);

end

endtask

endclass



 



class sequencer extends uvm_sequencer#(seq_item);
  `uvm_component_utils(sequencer) 
  
  
  function new(string name="",uvm_component parent);
    super.new(name,parent);
  endfunction
  
 
  
  
  
 
  
endclass




class driver extends uvm_driver#(seq_item);
  `uvm_component_utils(driver) 
  
   virtual  fifo_interface vif;
  
 
  
  function new(string name="",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);   
    
    
    if(!uvm_config_db#(virtual fifo_interface)::get(null,"*","vif",vif))begin
      `uvm_error("CONFIG","driver uvm config error");  
    end
  endfunction
  
  
  
 
  
  
  task run_phase(uvm_phase phase);
    
    seq_item item;
    
    vif.wen <= 0;
  vif.ren <= 0;
  vif.datain <= 0;

    forever begin
    
    seq_item_port.get_next_item(item);
    
      drive_transaction(item);  
      
    seq_item_port.item_done();
      `uvm_info("DRIVER","driver write operation complete",UVM_NONE);
      
    end
    
  endtask
  
  
  task drive_transaction(seq_item item);
    
    @(posedge vif.clk);
    
    if(item.wen && item.ren==0)begin
     @(posedge vif.clk);
      
      vif.wen <= 1;
    vif.ren <= 0;
    vif.datain <= item.datain;
      `uvm_info("DRIVER",$sformatf("write operation - vif.wen=%0d,item.wen =%0d, vif.ren=%0d,item.ren=%0d,vif.datain=%0d,item.datain=%0d",vif.wen,item.wen,vif.ren,item.ren,vif.datain,item.datain),UVM_MEDIUM);
    @(posedge vif.clk);
   vif.wen <= 0;
    end
    
    
    else if(item.ren && item.wen==0)begin
      vif.ren <= 1;
      vif.wen <= 0;
      
      `uvm_info("DRIVER",$sformatf("read operation - vif.ren = %0d, vif.wen=%0d, item-ren = %0d, item-wen = %0d",vif.ren,vif.wen,item.ren,item.wen),UVM_MEDIUM);
     
       @(posedge vif.clk);
   vif.ren <= 0;
       @(posedge vif.clk);
    end else if(item.ren && item.wen)begin

      vif.ren <= 1;
      vif.wen <= 1;
       
    `uvm_info("DRIVER",$sformatf("simultanous read and write vif.ren = %0d,vif.wen = %0d, item.ren = %0d, item.wen = %0d",vif.ren,vif.wen,item.ren,item.wen),UVM_MEDIUM);

   end else begin
    vif.wen = 0;
      vif.ren = 0;
      
    end
    
  endtask
 
  
endclass




class monitor extends uvm_monitor;
  `uvm_component_utils(monitor)

  virtual fifo_interface vif;

  uvm_analysis_port #(seq_item) ap;

  // Functional Coverage
  covergroup fifo_cg @(posedge vif.clk);

    option.per_instance = 1;

    cp_write : coverpoint vif.wen {
      bins write = {1};
    }

    cp_read : coverpoint vif.ren {
      bins read = {1};
    }

    cp_empty : coverpoint vif.empty {
      bins empty = {1};
    }

    cp_full : coverpoint vif.full {
      bins full = {1};
    }

    cp_fifo_count : coverpoint vif.fifo_cnt {

      bins empty = {0};
      bins low   = {[1:5]};
      bins mid   = {[6:10]};
      bins high  = {[11:14]};
      bins full  = {15};

    }

    wr_rd_cross : cross cp_write, cp_read;

  endgroup

  fifo_cg cg;


  function new(string name="", uvm_component parent);
    super.new(name,parent);
    ap = new("ap",this);
    cg = new();
  endfunction


  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if(!uvm_config_db#(virtual fifo_interface)::get(null,"*","vif",vif))
      `uvm_error("CONFIG","monitor config error")
  endfunction


  task run_phase(uvm_phase phase);

    seq_item item;

    forever begin

      @(posedge vif.clk);

      if(vif.wen) begin
        item = seq_item::type_id::create("item",this);
        item.wen = vif.wen;
        item.datain = vif.datain;
        ap.write(item);
      end

      if(vif.ren) begin
        item = seq_item::type_id::create("item",this);
        item.ren = vif.ren;

        @(posedge vif.clk);
        item.dataout = vif.dataout;
        ap.write(item);
      end

    end

  endtask

endclass

class scoreboard extends uvm_scoreboard;
  `uvm_component_utils(scoreboard) 
//   virtual fifo_interface vif;

  uvm_analysis_imp #(seq_item,scoreboard) imp;
 
  bit [7:0]fifo_queue[$];
  bit [7:0]expected;
  
  function new(string name="",uvm_component parent);
    super.new(name,parent);
     imp = new("imp",this);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);   

  endfunction
 
  function void write(seq_item item);
    `uvm_info("scoreboard","score board has started",UVM_NONE);
    
    if(item.wen && !item.ren)begin
      fifo_queue.push_back(item.datain);
      `uvm_info("scoreboard",$sformatf("item.datain-%0d ",item.datain),UVM_MEDIUM);
    end
    
    if(item.ren && !item.wen)begin
      
      if(fifo_queue.size() == 0)begin
        `uvm_error("scoreboard","fifo empty");
      end else begin
      
     expected =  fifo_queue.pop_front();
//       `uvm_info("scoreboard",$sformatf("%0d %0d",item.dataout,expected),UVM_MEDIUM);
      
        if(expected !== item.dataout)begin
        `uvm_error("scoreboard",$sformatf("expected-%0d, item.dataout-%0d",expected,item.dataout));
        
      end else begin
        `uvm_info("scoreboard",$sformatf("expected-%0d, item.dataout-%0d",expected,item.dataout),UVM_MEDIUM);
      end
      
      end
        
    end
    

  if(item.ren && item.wen)begin
  
     if(fifo_queue.size() == 0)begin
           fifo_queue.push_back(item.datain);
      end else begin
      
      expected = fifo_queue.pop_front();
         if(expected !== item.dataout)begin
        `uvm_error("scoreboard",$sformatf("expected-%0d, item.dataout-%0d",expected,item.dataout)); 
      end  
      fifo_queue.push_back(item.datain);
      

    end



  end
    
    
    
  endfunction
  
 
  
endclass




class agent extends uvm_agent;
  `uvm_component_utils(agent) 
  
  driver drv;
  sequencer seqr;
  monitor mon;
  
  virtual fifo_interface vif;

  
  function new(string name="",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    drv = driver::type_id::create("drv",this);
    seqr = sequencer::type_id::create("seq",this);
    mon = monitor::type_id::create("mon",this);
    
    
    
    
    if(!uvm_config_db#(virtual fifo_interface)::get(null,"*","vif",vif))begin
       `uvm_error("CONFIG","uvm_config not set in env");
    end
    
    
  endfunction
  
  
   function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
     drv.seq_item_port.connect(seqr.seq_item_export); 
  endfunction
  
  
  
 
  
endclass





class env extends uvm_env;
  `uvm_component_utils(env) 
  
  scoreboard score;
  agent agt;
  
   virtual  fifo_interface vif;
  
  function new(string name="",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    score = scoreboard::type_id::create("score",this);
    agt = agent::type_id::create("agt",this);
    
    if(!uvm_config_db#(virtual fifo_interface)::get(null,"*","vif",vif))begin
      `uvm_error("CONFIG","uvm_config not set in env");
    end
    
    
  endfunction
  
   
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    
    agt.mon.ap.connect(score.imp);
    
  endfunction
  
  
 
  
endclass






class test extends uvm_test;
  `uvm_component_utils(test)
  
  env environment;
 
 virtual  fifo_interface vif;
  
  function new(string name="",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  
  
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    environment = env::type_id::create("env",this);
    
    if(!(uvm_config_db#(virtual fifo_interface)::get(null,"*","vif",vif)))begin
      `uvm_error("CONFIG","uvm_config_db not set in test");
    end
    
  endfunction
  
  
  
  task run_phase(uvm_phase phase);
    
//     super.run_phase(phase);
     fifo_wr_sequence sequ_wr;
      
     fifo_rd_sequence sequ_rd;

     fifo_wr_rd sequ_wr_rd;


    sequ_wr = fifo_wr_sequence::type_id::create("sequ_wr",this);
  
    sequ_rd = fifo_rd_sequence::type_id::create("sequ_rd",this);
    
    sequ_wr_rd = fifo_wr_rd::type_id::create("sequ_wr_rd",this);
    
    phase.raise_objection(this);
    sequ_wr.start(environment.agt.seqr);
//     #50;
    sequ_rd.start(environment.agt.seqr);
#100;

sequ_wr_rd.start(environment.agt.seqr);
 
    phase.drop_objection(this);
    
  endtask
  
  
  
endclass


















class random_test extends uvm_test;
  `uvm_component_utils(random_test)
  
  env environment;
 
 virtual  fifo_interface vif;
  
  function new(string name="",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  
  
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    environment = env::type_id::create("env",this);
    
    if(!(uvm_config_db#(virtual fifo_interface)::get(null,"*","vif",vif)))begin
      `uvm_error("CONFIG","uvm_config_db not set in test");
    end
    
  endfunction
  
  
  
  task run_phase(uvm_phase phase);
    
//     super.run_phase(phase);
      
     fifo_random_seq sequ_rand;


    
    sequ_rand = fifo_random_seq::type_id::create("sequ_rand",this);
    
    phase.raise_objection(this);
    sequ_rand.start(environment.agt.seqr);
 
    phase.drop_objection(this);
    
  endtask
  
  
  
endclass

 












class stress_test extends uvm_test;
  `uvm_component_utils(stress_test)
  
  env environment;
 
 virtual  fifo_interface vif;
  
  function new(string name="",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  
  
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    environment = env::type_id::create("env",this);
    
    if(!(uvm_config_db#(virtual fifo_interface)::get(null,"*","vif",vif)))begin
      `uvm_error("CONFIG","uvm_config_db not set in test");
    end
    
  endfunction
  
  
  
  task run_phase(uvm_phase phase);
    
//     super.run_phase(phase);
      
    sim_wr_rd sequ_sim;
     
    fifo_empty_seq sequ_empty;

    fifo_full_seq sequ_full;


    sequ_sim = sim_wr_rd::type_id::create("sequ_sim",this);
    
    
    
    sequ_full = fifo_full_seq::type_id::create("sequ_full",this);
sequ_empty = fifo_empty_seq::type_id::create("sequ_empty",this);
    
    phase.raise_objection(this);
    sequ_sim.start(environment.agt.seqr);
 
    
    sequ_full.start(environment.agt.seqr);

  sequ_empty.start(environment.agt.seqr);

     
    phase.drop_objection(this);
    
  endtask
  
  
  
endclass











 
 
