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
// Module:     ucdp_common.ucdp_fifo
// Data Model: ucdp_common.ucdp_fifo.UcdpFifoMod
//
// =============================================================================

`begin_keywords "1800-2009"
`default_nettype none  // implicit wires are forbidden

module ucdp_fifo #( // ucdp_common.ucdp_fifo.UcdpFifoMod
  parameter integer width_p         = 8,
  parameter integer depth_p         = 8,
  parameter integer filling_width_p = $clog2(depth_p + 1)
) (
  // main_i
  input  wire                        main_clk_i,
  input  wire                        main_rst_an_i,         // Async Reset (Low-Active)
  // dft_mode_i: Test Control
  input  wire                        dft_mode_test_mode_i,  // Test Mode
  input  wire                        dft_mode_scan_mode_i,  // Logic Scan-Test Mode
  input  wire                        dft_mode_scan_shift_i, // Scan Shift Phase
  input  wire                        dft_mode_mbist_mode_i, // Memory Built-In Self-Test
  input  wire                        rd_en_i,
  input  wire                        wr_en_i,
  output logic                       empty_o,
  output logic                       full_o,
  input  wire  [width_p-1:0]         data_i,
  output logic [width_p-1:0]         data_o,
  output logic [filling_width_p-1:0] filling_o
);


// GENERATE INPLACE END head ===================================================



  localparam integer               ptr_width_p = $clog2(depth_p);
  localparam [ptr_width_p-1:0]     ptr_min_p = {ptr_width_p {1'b0}};
  localparam [ptr_width_p-1:0]     ptr_inc_p = 1;
  // lint_checking TROPCZ off
  localparam [ptr_width_p-1:0]     ptr_max_p = depth_p-1;
  // lint_checking TROPCZ on
  localparam [filling_width_p-1:0] filling_inc_p = {{filling_width_p-1 {1'b0}}, 1'b1};
  localparam [filling_width_p-1:0] depth_filling_p = depth_p[filling_width_p-1:0];

  // memory
  reg  [width_p-1:0] mem [depth_p-1:0] /*synthesis syn_ramstyle = "block_ram"*/;

  // control logic
  //lint_checking ONPNSG off
  reg  [ptr_width_p-1:0]     wr_ptr_r;
  reg  [ptr_width_p-1:0]     rd_ptr_r;
  //lint_checking ONPNSG on
  reg  [filling_width_p-1:0] filling_r;
  wire                       empty_s;
  wire                       full_s;
  wire                       rd_s;
  wire                       wr_s;

  // Common Signals
  assign empty_s = (filling_r == {filling_width_p {1'b0}}) ? 1'b1 : 1'b0;
  assign full_s  = (filling_r == depth_filling_p) ? 1'b1 : 1'b0;
  assign rd_s = rd_en_i & ~empty_s;
  assign wr_s = wr_en_i & ~full_s;

  //lint_checking POOBID off
  //lint_checking PRMFSM off
  // Write Pointer
  always_ff @(posedge main_clk_i or negedge main_rst_an_i) begin : proc_write_pointer
    if (main_rst_an_i == 1'b0) begin
      wr_ptr_r <= ptr_min_p;
    end else if (wr_s == 1'b1) begin
      if (wr_ptr_r == ptr_max_p) begin
        wr_ptr_r <= ptr_min_p;
      end else begin
        // lint_checking POIASG off
        wr_ptr_r <= wr_ptr_r + ptr_inc_p;
        // lint_checking POIASG on
      end
    end
  end

  // read pointer
  always_ff @(posedge main_clk_i or negedge main_rst_an_i) begin : proc_read_pointer
    if (main_rst_an_i == 1'b0) begin
      rd_ptr_r <= ptr_min_p;
    end else if (rd_s == 1'b1) begin
      if (rd_ptr_r == ptr_max_p) begin
        rd_ptr_r <= ptr_min_p;
      end else begin
        // lint_checking POIASG off
        rd_ptr_r <= rd_ptr_r + ptr_inc_p;
        // lint_checking POIASG on
      end
    end
  end

  // read mux
  assign data_o = mem[rd_ptr_r];

  // status
  always_ff @(posedge main_clk_i or negedge main_rst_an_i) begin : proc_filling_counter
    if (main_rst_an_i == 1'b0) begin
      filling_r <= {filling_width_p {1'b0}};
    end else if ((rd_s == 1'b1) && (wr_s == 1'b0)) begin
      // Read but no write.
      filling_r <= filling_r - filling_inc_p;
    end else if ((rd_s == 1'b0) && (wr_s == 1'b1)) begin
      // Write but no read.
      // lint_checking POIASG off
      filling_r <= filling_r + filling_inc_p;
      // lint_checking POIASG on
    end
  end
  //lint_checking PRMFSM on

  // write
  //lint_checking FFWNSR off
  always_ff @(posedge main_clk_i) begin: proc_mem
    if (wr_s == 1'b1) begin
      mem[wr_ptr_r] <= data_i;
    end
  end
  //lint_checking FFWNSR on
  //lint_checking POOBID on

  // output
  assign full_o    = full_s;
  assign empty_o   = empty_s;
  assign filling_o = filling_r;


// GENERATE INPLACE BEGIN tail() ===============================================
endmodule // ucdp_fifo

`default_nettype wire
`end_keywords
// GENERATE INPLACE END tail ===================================================
