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
  parameter integer dwidth_p = 8,
  parameter integer awidth_p = 4
) (
  // clk0_i
  input  wire                 clk0_clk_i,
  input  wire                 clk0_rst_an_i,         // Async Reset (Low-Active)
  // clk1_i
  input  wire                 clk1_clk_i,
  input  wire                 clk1_rst_an_i,         // Async Reset (Low-Active)
  // dft_mode_i: Test Control
  input  wire                 dft_mode_test_mode_i,  // Test Mode
  input  wire                 dft_mode_scan_mode_i,  // Logic Scan-Test Mode
  input  wire                 dft_mode_scan_shift_i, // Scan Shift Phase
  input  wire                 dft_mode_mbist_mode_i, // Memory Built-In Self-Test
  // clk0_wr_i
  input  wire                 clk0_wr_ena_i,
  output logic                clk0_wr_full_o,
  output logic [awidth_p-1:0] clk0_wr_space_avail_o,
  input  wire  [dwidth_p-1:0] clk0_wr_data_i,
  // clk1_rd_o
  input  wire                 clk1_rd_ena_i,
  output logic                clk1_rd_empty_o,
  output logic [awidth_p-1:0] clk1_rd_data_avail_o,
  output logic [dwidth_p-1:0] clk1_rd_data_o
);



  // ------------------------------------------------------
  //  Local Parameter
  // ------------------------------------------------------
  // edge_spec
  localparam integer       edge_spec_width_p   = 2;
  localparam logic   [1:0] edge_spec_min_p     = 2'h0;
  localparam logic   [1:0] edge_spec_max_p     = 2'h3;
  localparam logic   [1:0] edge_spec_none_e    = 2'h0;
  localparam logic   [1:0] edge_spec_rise_e    = 2'h1;
  localparam logic   [1:0] edge_spec_fall_e    = 2'h2;
  localparam logic   [1:0] edge_spec_any_e     = 2'h3;
  localparam logic   [1:0] edge_spec_default_p = 2'h0;

// GENERATE INPLACE END head ===================================================


// lint_checking CLKINF on
// lint_checking MULMCK on

  // lint_checking PRMVAL off
  localparam depth_p = 1 << (awidth_p-1);
  // lint_checking PRMVAL on

  wire [awidth_p-1:0] wr_ptr_s;
  wire [awidth_p-1:0] wr_ptr_gray_s;
  wire [awidth_p-1:0] rd_ptr_s;
  wire [awidth_p-1:0] rd_ptr_gray_s;
  wire                rd_empty_s;
  wire [awidth_p-1:0] rd_ptr_gray_clk0_sync_s;
  wire [awidth_p-1:0] rd_data_avail_clk1_s;
  wire [awidth_p-1:0] wr_ptr_clk1_sync_s;
  wire [awidth_p-1:0] wr_ptr_gray_clk1_sync_s;
  wire [awidth_p-1:0] wr_space_avail_clk0_s;

  reg                 wr_full_s;

  reg  [dwidth_p-1:0] mem_r [depth_p-1:0] /*synthesis syn_ramstyle = "block_ram"*/;
  reg  [awidth_p-1:0] wr_ptr_r /* synthesis syn_allow_retiming = 0 */;
  reg  [awidth_p-1:0] wr_ptr_gray_r /* synthesis syn_allow_retiming = 0 */;
  reg                 wr_full_r /* synthesis syn_allow_retiming = 0 */;
  reg  [awidth_p-1:0] wr_space_avail_clk0_r /* synthesis syn_allow_retiming = 0 */;

  reg  [awidth_p-1:0] rd_ptr_r /* synthesis syn_allow_retiming = 0 */;
  reg  [awidth_p-1:0] rd_ptr_gray_r /* synthesis syn_allow_retiming = 0 */;
  reg                 rd_empty_r /* synthesis syn_allow_retiming = 0 */;
  reg  [awidth_p-1:0] rd_data_avail_clk1_r /* synthesis syn_allow_retiming = 0 */;

  // lint_checking RPTVAR off
  // lint_checking NOLOCL off
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
  // lint_checking NOLOCL on
  // lint_checking RPTVAR on

  // output assignment
  // lint_checking CLKDMN off
  assign clk0_wr_full_o        = wr_full_r;
  assign clk0_wr_space_avail_o = wr_space_avail_clk0_r[awidth_p-1:0];
  assign clk1_rd_empty_o       = rd_empty_r;
  assign clk1_rd_data_o        = mem_r[rd_ptr_r[awidth_p-2:0]];
  assign clk1_rd_data_avail_o  = rd_data_avail_clk1_r[awidth_p-1:0];
  // lint_checking CLKDMN on

  // FIFO array - clock clk0 domain
  // lint_checking FFWNSR CLKDMN off
  // lint_checking MULMCK off
  always_ff @(posedge clk0_clk_i) begin : proc_mem
    if (clk0_wr_ena_i && !wr_full_r) begin
      mem_r[wr_ptr_r[awidth_p-2:0]] <= clk0_wr_data_i;
    end
  end
  // lint_checking MULMCK on
  // lint_checking FFWNSR CLKDMN on

  // assignment of clock clk0 domain
  // lint_checking UELOPR off
  // lint_checking POIASG off
  assign wr_ptr_s              = wr_ptr_r + (~wr_full_r & clk0_wr_ena_i);
  assign wr_ptr_gray_s         = (wr_ptr_s>>1) ^ wr_ptr_s;
  assign wr_space_avail_clk0_s = depth_p - (wr_ptr_r - gray2bin_f(rd_ptr_gray_clk0_sync_s));
  // lint_checking POIASG on
  // lint_checking UELOPR on

  // wr_full detection
  integer i, j, k;
  // lint_checking MULBAS off
  reg [awidth_p-1:0] wr_full_vec_s;
  // lint_checking MULBAS on

  // lint_checking IMPDTC off
  // lint_checking TRUNCZ off
  // lint_checking CONSTC off
  always_comb begin : wr_full_proc
    wr_full_vec_s = 0;

    for (i = awidth_p - 1; i >= 0; i = i - 1) begin
      wr_full_vec_s[i] = (wr_ptr_gray_s[i] != rd_ptr_gray_clk0_sync_s[i]) ? 1'b1 : 1'b0;
    end

    if (awidth_p > 2) begin
      for (j = awidth_p - 3; j >= 0; j = j - 1) begin
        wr_full_vec_s[j] = (wr_ptr_gray_s[j] == rd_ptr_gray_clk0_sync_s[j]) ? 1'b1 : 1'b0;
      end
    end

    wr_full_s = 1'b1;
    for (k = awidth_p - 1; k >= 0; k = k - 1) begin
      if (wr_full_vec_s[k] == 1'b0) begin
        wr_full_s = 1'b0;
      end
    end
  end
  // lint_checking CONSTC on
  // lint_checking TRUNCZ on
  // lint_checking IMPDTC on

  // clk0 clock domain registers
  always_ff @(posedge clk0_clk_i or negedge clk0_rst_an_i) begin : proc_clk0
    if (clk0_rst_an_i == 1'b0) begin
      wr_ptr_r              <= {awidth_p{1'b0}};
      wr_ptr_gray_r         <= {awidth_p{1'b0}};
    end else begin
      //lint_checking CLKDMN off
      wr_ptr_gray_r         <= wr_ptr_gray_s;
      //lint_checking CLKDMN on
      wr_ptr_r              <= wr_ptr_s;
    end
  end

  wire clk0_clk_alias_s;
  assign clk0_clk_alias_s = clk0_clk_i;
  //this process contains the 'backward' facing signals of this FIFO.
  //although technically the same clock, we use this assign-alias to have
  //a constraint hookup for linting, as we cannot have these signals declared
  //as being part of the target domain. We then waive the 'ghost' violation which
  //occurs as part of the linting clock domain constraint.
  always_ff @(posedge clk0_clk_alias_s or negedge clk0_rst_an_i) begin : proc_clk0_alias
    if (clk0_rst_an_i == 1'b0) begin
      wr_full_r             <= 1'b0;
      wr_space_avail_clk0_r <= {awidth_p{1'b0}};
    end else begin
      //lint_checking CLKDMN off
      //lint_checking SHFTNC off
      // lint_checking MULMCK off
      wr_full_r             <= wr_full_s;
      //lint_checking SHFTNC on
      // lint_checking MULMCK on
      wr_space_avail_clk0_r <= wr_space_avail_clk0_s;
      //lint_checking CLKDMN on
    end
  end

  // clk0 clock domain sync modules
  // lint_checking UNCONN off
  // lint_checking DIFSIG off
  ucdp_sync #(.norstvalchk_p(1'b1)) u_rd_ptr_gray_clk0_sync [awidth_p-1:0] (
    .main_clk_i(clk0_clk_i),
    .main_rst_an_i(clk0_rst_an_i),
    .dft_mode_test_mode_i (dft_mode_test_mode_i ),
    .dft_mode_scan_mode_i(dft_mode_scan_mode_i),
    .dft_mode_scan_shift_i(dft_mode_scan_shift_i),
    .dft_mode_mbist_mode_i(dft_mode_mbist_mode_i),
    .d_i(rd_ptr_gray_r),
    .q_o(rd_ptr_gray_clk0_sync_s),
    .edge_o()
  );
  // lint_checking UNCONN on
  // lint_checking DIFSIG on

  // assignment of clock clk1 domain
  // lint_checking UELOPR off
  // lint_checking POIASG off
  assign rd_ptr_s             = rd_ptr_r + ((~rd_empty_r & clk1_rd_ena_i) ? 'd1 : 'd0);
  // lint_checking POIASG on
  // lint_checking UELOPR on
  assign rd_ptr_gray_s        = (rd_ptr_s>>1) ^ rd_ptr_s;
  assign rd_empty_s           = (rd_ptr_gray_s == wr_ptr_gray_clk1_sync_s);
  assign wr_ptr_clk1_sync_s   = gray2bin_f(wr_ptr_gray_clk1_sync_s);
  assign rd_data_avail_clk1_s = wr_ptr_clk1_sync_s - rd_ptr_s;

  // clk1 clock domain registers
  always_ff @(posedge clk1_clk_i or negedge clk1_rst_an_i) begin : proc_clk1
    if (clk1_rst_an_i == 1'b0) begin
      rd_ptr_r             <= {awidth_p{1'b0}};
      rd_ptr_gray_r        <= {awidth_p{1'b0}};
      rd_empty_r           <= 1'b1;
      rd_data_avail_clk1_r <= {awidth_p{1'b0}};
    end else begin
      // lint_checking CLKDMN off
      rd_ptr_gray_r        <= rd_ptr_gray_s;
      rd_data_avail_clk1_r <= rd_data_avail_clk1_s;
      // lint_checking CLKDMN on
      // lint_checking MULMCK off
      rd_ptr_r             <= rd_ptr_s;
      // lint_checking MULMCK on
      rd_empty_r           <= rd_empty_s;
    end
  end

  // clk0 clock domain sync modules
  // lint_checking UNCONN off
  // lint_checking DIFSIG off
  ucdp_sync #(.norstvalchk_p(1'b1)) u_wr_ptr_gray_clk1_sync [awidth_p-1:0] (
    .main_clk_i(clk1_clk_i),
    .main_rst_an_i(clk1_rst_an_i),
    .dft_mode_test_mode_i (dft_mode_test_mode_i ),
    .dft_mode_scan_mode_i(dft_mode_scan_mode_i),
    .dft_mode_scan_shift_i(dft_mode_scan_shift_i),
    .dft_mode_mbist_mode_i(dft_mode_mbist_mode_i),
    .d_i(wr_ptr_gray_r),
    .q_o(wr_ptr_gray_clk1_sync_s),
    .edge_o()
  );
  // lint_checking UNCONN on
  // lint_checking DIFSIG on

// lint_checking MCKDMN on


// GENERATE INPLACE BEGIN tail() ===============================================
endmodule // ucdp_afifo

`default_nettype wire
`end_keywords
// GENERATE INPLACE END tail ===================================================
