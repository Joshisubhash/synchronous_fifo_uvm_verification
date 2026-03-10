module fifo (
    input  logic        clk,
    input  logic        rst,
    input  logic [7:0]  data_in,
    input  logic        wr,
    input  logic        rd,

    output logic [3:0]  fifo_cnt,
    output logic        empty,
    output logic        full,
    output logic [7:0]  data_out
);

  parameter DEPTH = 16;
  parameter ADDR_WIDTH = 4;

  logic [7:0] mem [DEPTH-1:0];

  logic [ADDR_WIDTH-1:0] wr_ptr;
  logic [ADDR_WIDTH-1:0] rd_ptr;

  //---------------------------------------
  // WRITE LOGIC
  //---------------------------------------
  always_ff @(posedge clk or negedge rst) begin
    if(!rst) begin
      wr_ptr <= 0;
    end
    else if(wr && !full) begin
      mem[wr_ptr] <= data_in;
      wr_ptr <= wr_ptr + 1;
    end
  end


  //---------------------------------------
  // READ LOGIC
  //---------------------------------------
  always_ff @(posedge clk or negedge rst) begin
    if(!rst) begin
      rd_ptr <= 0;
      data_out <= 0;
    end
    else if(rd && !empty) begin
      data_out <= mem[rd_ptr];
      rd_ptr <= rd_ptr + 1;
    end
  end


  //---------------------------------------
  // FIFO COUNT LOGIC
  //---------------------------------------
  always_ff @(posedge clk or negedge rst) begin
    if(!rst)
      fifo_cnt <= 0;

    else begin
      case ({wr && !full, rd && !empty})
        2'b10: fifo_cnt <= fifo_cnt + 1;  // write only
        2'b01: fifo_cnt <= fifo_cnt - 1;  // read only
        default: fifo_cnt <= fifo_cnt;    // no change
      endcase
    end
  end


  //---------------------------------------
  // STATUS FLAGS
  //---------------------------------------
  assign empty = (fifo_cnt == 0);
  assign full  = (fifo_cnt == DEPTH-1);

endmodule
