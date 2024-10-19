// GENERATE INPLACE BEGIN head() ===============================================
//
//  MIT License
//
//  Copyright (c) 2024 nbiotcloud
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//
// =============================================================================
//
// Module:     ucdp_common.ucdp_afifo
// Data Model: ucdp_common.ucdp_afifo.UcdpAfifoMod
//
// =============================================================================

`begin_keywords "1800-2009"
`default_nettype none  // implicit wires are forbidden

module ucdp_afifo #( // ucdp_common.ucdp_afifo.UcdpAfifoMod
  parameter logic [31:0] dwidth_p = 32'h00000008,
  parameter logic [31:0] awidth_p = 32'h00000004
) (
  // src_i
  input  wire                            src_clk_i,
  input  wire                            src_rst_an_i,         // Async Reset (Low-Active)
  // tgt_i
  input  wire                            tgt_clk_i,
  input  wire                            tgt_rst_an_i,         // Async Reset (Low-Active)
  input  wire                            src_wr_en_i,
  input  wire  [dwidth_p-32'h00000001:0] src_wr_data_i,
  output logic                           src_wr_full_o,
  output logic [awidth_p-32'h00000001:0] src_wr_space_avail_o,
  input  wire                            tgt_rd_en_i,
  output logic [dwidth_p-32'h00000001:0] tgt_rd_data_o,
  output logic                           tgt_rd_empty_o,
  output logic [awidth_p-32'h00000001:0] tgt_rd_data_avail_o
);



  // ------------------------------------------------------
  //  Local Parameter
  // ------------------------------------------------------
  localparam logic   [31:0] depth_p             = 32'h00000001 << (awidth_p - 32'h00000001);
  // edge_spec
  localparam integer        edge_spec_width_p   = 2;
  localparam logic   [1:0]  edge_spec_min_p     = 2'h0;
  localparam logic   [1:0]  edge_spec_max_p     = 2'h3;
  localparam logic   [1:0]  edge_spec_none_e    = 2'h0;
  localparam logic   [1:0]  edge_spec_rise_e    = 2'h1;
  localparam logic   [1:0]  edge_spec_fall_e    = 2'h2;
  localparam logic   [1:0]  edge_spec_any_e     = 2'h3;
  localparam logic   [1:0]  edge_spec_default_p = 2'h0;

// GENERATE INPLACE END head ===================================================

// A-FIFO is designed according a paper from Clifford E. Cummings and Peter Alfke.
// The paper location is  http://www.sunburst-design.com/papers/CummingsSNUG2002SJ_FIFO1.pdf.


  logic [dwidth_p-1:0] mem_r [depth_p-1:0];
  logic [awidth_p-1:0] src_wr_ptr_s;
  logic [awidth_p-1:0] src_wr_ptr_r;
  logic [awidth_p-1:0] src_wr_ptr_gray_s;
  logic [awidth_p-1:0] src_wr_ptr_gray_r;
  logic                src_wr_full_s;
  logic                src_wr_full_r;
  logic [awidth_p-1:0] src_wr_space_avail_s;
  logic [awidth_p-1:0] src_wr_space_avail_r;
  logic [awidth_p-1:0] src_rd_ptr_gray_sync_s;

  logic [awidth_p-1:0] tgt_rd_ptr_s;
  logic [awidth_p-1:0] tgt_rd_ptr_r;
  logic [awidth_p-1:0] tgt_rd_ptr_gray_s;
  logic [awidth_p-1:0] tgt_rd_ptr_gray_r;
  logic                tgt_rd_empty_s;
  logic                tgt_rd_empty_r;
  logic [awidth_p-1:0] tgt_rd_data_avail_s;
  logic [awidth_p-1:0] tgt_rd_data_avail_r;
  logic [awidth_p-1:0] tgt_wr_ptr_gray_sync_s;
  logic [awidth_p-1:0] tgt_wr_ptr_sync_s;


  function automatic [awidth_p-1:0] gray2bin_f;
    input [awidth_p-1:0] gray_s;
    integer     i;

    begin
      // MSB is always identical
      gray2bin_f[awidth_p-1] = gray_s[awidth_p-1];

      for (i = awidth_p - 2; i >= 0; i = i - 1) begin
        gray2bin_f[i] = gray_s[i] ^ gray2bin_f[i+1];
      end
    end
  endfunction

  // --- source clock domain ---------------------------------------------------

  assign src_wr_ptr_s         = src_wr_ptr_r + (((~src_wr_full_r & src_wr_en_i) == 1'b1) ? 1 : 0);
  assign src_wr_ptr_gray_s    = (src_wr_ptr_s >> 1) ^ src_wr_ptr_s;
  assign src_wr_space_avail_s = depth_p - (src_wr_ptr_s - gray2bin_f(src_rd_ptr_gray_sync_s));

  // source clock domain sync modules
  ucdp_sync #(.edge_type_p(edge_spec_none_e), .norstvalchk_p(1'b1)) u_src_rd_ptr_gray_sync [awidth_p-1:0] (
    .clk_i(src_clk_i),
    .rst_an_i(src_rst_an_i),
    .d_i(tgt_rd_ptr_gray_r),
    .q_o(src_rd_ptr_gray_sync_s),
    .edge_o()
  );

  always_ff @(posedge src_clk_i or negedge src_rst_an_i) begin : proc_wr_ptr
    if (src_rst_an_i == 1'b0) begin
      src_wr_ptr_r              <= {awidth_p{1'b0}};
      src_wr_ptr_gray_r         <= {awidth_p{1'b0}};
    end else begin
      src_wr_ptr_gray_r         <= src_wr_ptr_gray_s;
      src_wr_ptr_r              <= src_wr_ptr_s;
    end
  end


  always_comb begin : proc_wr_full
    if (awidth_p > 2) begin
        src_wr_full_s = (src_wr_ptr_gray_s[awidth_p-1] != src_rd_ptr_gray_sync_s[awidth_p-1]) &&
                        (src_wr_ptr_gray_s[awidth_p-2] != src_rd_ptr_gray_sync_s[awidth_p-2]) &&
                        (src_wr_ptr_gray_s[awidth_p-3:0] == src_rd_ptr_gray_sync_s[awidth_p-3:0]);
    end else begin
        src_wr_full_s = ~(|(src_wr_ptr_gray_s & src_rd_ptr_gray_sync_s)); // all bits are different
    end
  end

  wire src_clk_alias_s;
  assign src_clk_alias_s = src_clk_i;
  // this process contains the 'backward' facing signals of this FIFO.
  // although technically the same clock, we use this assign-alias to have
  // a constraint hookup for linting, as we cannot have these signals declared
  // as being part of the target domain. We then waive the 'ghost' violation which
  // occurs as part of the linting clock domain constraint.
  always_ff @(posedge src_clk_alias_s or negedge src_rst_an_i) begin : proc_src_alias
    if (src_rst_an_i == 1'b0) begin
      src_wr_full_r        <= 1'b0;
      src_wr_space_avail_r <= 1'b0;
    end else begin
      src_wr_full_r        <= src_wr_full_s;
      src_wr_space_avail_r <= src_wr_space_avail_s;
    end
  end

  assign src_wr_full_o = src_wr_full_r;
  assign src_wr_space_avail_o = src_wr_space_avail_r;


  // FIFO array
  always_ff @(posedge src_clk_i) begin : proc_mem
    if ((src_wr_en_i == 1'b1) && (src_wr_full_r == 1'b0)) begin
      mem_r[src_wr_ptr_r[awidth_p-2:0]] <= src_wr_data_i;
    end
  end



  // --- target clock domain ---------------------------------------------------

  assign tgt_rd_ptr_s         = tgt_rd_ptr_r + (((~tgt_rd_empty_r & tgt_rd_en_i) == 1'b1) ? 1 : 0);
  assign tgt_rd_ptr_gray_s    = (tgt_rd_ptr_s >> 1) ^ tgt_rd_ptr_s;
  assign tgt_wr_ptr_sync_s    = gray2bin_f(tgt_wr_ptr_gray_sync_s);
  assign tgt_rd_empty_s       = (tgt_rd_ptr_gray_s == tgt_wr_ptr_gray_sync_s);
  assign tgt_rd_data_avail_s = tgt_wr_ptr_sync_s - tgt_rd_ptr_s;

  always_ff @(posedge tgt_clk_i or negedge tgt_rst_an_i) begin : proc_rd_ptr
    if (tgt_rst_an_i == 1'b0) begin
      tgt_rd_ptr_r        <= {awidth_p{1'b0}};
      tgt_rd_ptr_gray_r   <= {awidth_p{1'b0}};
      tgt_rd_empty_r      <= 1'b1;
      tgt_rd_data_avail_r <= {awidth_p{1'b0}};
    end else begin
      tgt_rd_ptr_r        <= tgt_rd_ptr_s;
      tgt_rd_ptr_gray_r   <= tgt_rd_ptr_gray_s;
      tgt_rd_empty_r      <= tgt_rd_empty_s;
      tgt_rd_data_avail_r <= tgt_rd_data_avail_s;
    end
  end

  // target clock domain sync modules
  ucdp_sync #(.edge_type_p(edge_spec_none_e), .norstvalchk_p(1'b1)) u_tgt_wr_ptr_sync [awidth_p-1:0] (
    .clk_i(tgt_clk_i),
    .rst_an_i(tgt_rst_an_i),
    .d_i(src_wr_ptr_gray_r),
    .q_o(tgt_wr_ptr_gray_sync_s),
    .edge_o()
  );


  assign tgt_rd_data_o        = mem_r[tgt_rd_ptr_r[awidth_p-2:0]];
  assign tgt_rd_empty_o       = tgt_rd_empty_r;
  assign tgt_rd_data_avail_o  = tgt_rd_data_avail_r;

// GENERATE INPLACE BEGIN tail() ===============================================
endmodule // ucdp_afifo

`default_nettype wire
`end_keywords
// GENERATE INPLACE END tail ===================================================
