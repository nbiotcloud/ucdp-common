// GENERATE INPLACE BEGIN head() ===============================================
// =============================================================================
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
// Module:     ucdp_common.ucdp_latch
// Data Model: ucdp_common.ucdp_latch.UcdpLatchMod
//
// =============================================================================

`begin_keywords "1800-2009"
`default_nettype none  // implicit wires are forbidden

module ucdp_latch #( // ucdp_common.ucdp_latch.UcdpLatchMod
  parameter integer               width_p  = 1,
  parameter logic   [width_p-1:0] rstval_p = {width_p {1'b0}}
) (
  // main_i
  input  wire                main_clk_i,
  input  wire                main_rst_an_i, // Async Reset (Low-Active)
  input  wire                ld_i,
  input  wire  [width_p-1:0] d_i,
  output logic [width_p-1:0] q_o
);


// GENERATE INPLACE END head ===================================================

// lint_checking CLKINF on

  `ifdef FPGA
  //on FPGA latches as registers causes the tools to run in circles, so we replace it with a classic flop
  reg [width_p-1:0] q_r;

  always_ff @(posedge clk_i or negedge rst_an_i) begin : proc_flop
    if(rst_an_i == 1'b0) begin
      q_r <= rstval_p;
    end else if (ld_i == 1'b1) begin
      q_r <= d_i;
    end
  end

  assign q_o = (ld_i == 1'b1) ? d_i : q_r;
  `else
  wire [width_p-1:0] nxt_s = (rst_an_i == 1'b0) ? rstval_p : d_i;
  wire               ld_s  = ~rst_an_i | (ld_i & ~clk_i) | dft_mode_scan_mode_i;
  reg  [width_p-1:0] q_l;

  // latch
  // lint_checking LATINF off
  always_comb begin : proc_latch
    if (ld_s) begin
      q_l <= nxt_s;
    end
  end
  // lint_checking LATINF on

  assign q_o = q_l;
  `endif


// GENERATE INPLACE BEGIN tail() ===============================================
endmodule // ucdp_latch

`default_nettype wire
`end_keywords
// GENERATE INPLACE END tail ===================================================
