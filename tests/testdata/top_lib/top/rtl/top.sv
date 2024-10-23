// =============================================================================
//
// THIS FILE IS GENERATED!!! DO NOT EDIT MANUALLY. CHANGES ARE LOST.
//
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
// Module:     top_lib.top
// Data Model: top_lib.top.TopMod
//
// =============================================================================

`begin_keywords "1800-2009"
`default_nettype none  // implicit wires are forbidden

module top();



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


  // ------------------------------------------------------
  //  ucdp_common.ucdp_clk_buf: u_clk_buf
  // ------------------------------------------------------
  ucdp_clk_buf u_clk_buf (
    .clk_i(1'b0), // TODO
    .clk_o(    )  // TODO
  );


  // ------------------------------------------------------
  //  ucdp_common.ucdp_clk_mux: u_clk_mux
  // ------------------------------------------------------
  ucdp_clk_mux u_clk_mux (
    .clka_i(1'b0), // TODO
    .clkb_i(1'b0), // TODO
    .sel_i (1'b0), // TODO - Select
    .clk_o (    )  // TODO
  );


  // ------------------------------------------------------
  //  ucdp_common.ucdp_clk_or: u_clk_or
  // ------------------------------------------------------
  ucdp_clk_or u_clk_or (
    .clka_i(1'b0), // TODO
    .clkb_i(1'b0), // TODO
    .clk_o (    )  // TODO
  );


  // ------------------------------------------------------
  //  ucdp_common.ucdp_clk_gate: u_clk_gate
  // ------------------------------------------------------
  ucdp_clk_gate u_clk_gate (
    .clk_i(1'b0), // TODO
    .en_i (1'b0), // TODO
    .clk_o(    )  // TODO
  );


  // ------------------------------------------------------
  //  ucdp_common.ucdp_latch: u_latch
  // ------------------------------------------------------
  ucdp_latch u_latch (
    // main_i
    .main_clk_i           (1'b0      ), // TODO
    .main_rst_an_i        (1'b0      ), // TODO - Async Reset (Low-Active)
    // dft_mode_i: Test Control
    .dft_mode_test_mode_i (1'b0      ), // TODO - Test Mode
    .dft_mode_scan_mode_i (1'b0      ), // TODO - Logic Scan-Test Mode
    .dft_mode_scan_shift_i(1'b0      ), // TODO - Scan Shift Phase
    .dft_mode_mbist_mode_i(1'b0      ), // TODO - Memory Built-In Self-Test
    .ld_i                 (1'b0      ), // TODO
    .d_i                  ({1 {1'b0}}), // TODO - Data Input
    .q_o                  (          )  // TODO - Data Output
  );


  // ------------------------------------------------------
  //  ucdp_common.ucdp_sync: u_sync0
  // ------------------------------------------------------
  ucdp_sync #(
    .rstval_p(1'b0)
  ) u_sync0 (
    // tgt_i
    .tgt_clk_i            (1'b0), // TODO
    .tgt_rst_an_i         (1'b0), // TODO - Async Reset (Low-Active)
    // dft_mode_i: Test Control
    .dft_mode_test_mode_i (1'b0), // TODO - Test Mode
    .dft_mode_scan_mode_i (1'b0), // TODO - Logic Scan-Test Mode
    .dft_mode_scan_shift_i(1'b0), // TODO - Scan Shift Phase
    .dft_mode_mbist_mode_i(1'b0), // TODO - Memory Built-In Self-Test
    .d_i                  (1'b0), // TODO - Data Input
    .q_o                  (    ), // TODO - Data Output
    .edge_o               (    )  // TODO - Edge Output
  );


  // ------------------------------------------------------
  //  ucdp_common.ucdp_sync: u_sync1
  // ------------------------------------------------------
  ucdp_sync #(
    .rstval_p(1'b1)
  ) u_sync1 (
    // tgt_i
    .tgt_clk_i            (1'b0), // TODO
    .tgt_rst_an_i         (1'b0), // TODO - Async Reset (Low-Active)
    // dft_mode_i: Test Control
    .dft_mode_test_mode_i (1'b0), // TODO - Test Mode
    .dft_mode_scan_mode_i (1'b0), // TODO - Logic Scan-Test Mode
    .dft_mode_scan_shift_i(1'b0), // TODO - Scan Shift Phase
    .dft_mode_mbist_mode_i(1'b0), // TODO - Memory Built-In Self-Test
    .d_i                  (1'b0), // TODO - Data Input
    .q_o                  (    ), // TODO - Data Output
    .edge_o               (    )  // TODO - Edge Output
  );


  // ------------------------------------------------------
  //  ucdp_common.ucdp_afifo: u_afifo
  // ------------------------------------------------------
  ucdp_afifo u_afifo (
    // src_i
    .src_clk_i            (1'b0      ), // TODO
    .src_rst_an_i         (1'b0      ), // TODO - Async Reset (Low-Active)
    // tgt_i
    .tgt_clk_i            (1'b0      ), // TODO
    .tgt_rst_an_i         (1'b0      ), // TODO - Async Reset (Low-Active)
    // dft_mode_i: Test Control
    .dft_mode_test_mode_i (1'b0      ), // TODO - Test Mode
    .dft_mode_scan_mode_i (1'b0      ), // TODO - Logic Scan-Test Mode
    .dft_mode_scan_shift_i(1'b0      ), // TODO - Scan Shift Phase
    .dft_mode_mbist_mode_i(1'b0      ), // TODO - Memory Built-In Self-Test
    .src_wr_en_i          (1'b0      ), // TODO
    .src_wr_data_i        ({8 {1'b0}}), // TODO
    .src_wr_full_o        (          ), // TODO
    .src_wr_space_avail_o (          ), // TODO
    .tgt_rd_en_i          (1'b0      ), // TODO
    .tgt_rd_data_o        (          ), // TODO
    .tgt_rd_empty_o       (          ), // TODO
    .tgt_rd_data_avail_o  (          )  // TODO
  );


  // ------------------------------------------------------
  //  ucdp_common.ucdp_sfifo: u_sfifo
  // ------------------------------------------------------
  ucdp_sfifo u_sfifo (
    // src_i
    .src_clk_i            (1'b0      ), // TODO
    .src_rst_an_i         (1'b0      ), // TODO - Async Reset (Low-Active)
    // dft_mode_i: Test Control
    .dft_mode_test_mode_i (1'b0      ), // TODO - Test Mode
    .dft_mode_scan_mode_i (1'b0      ), // TODO - Logic Scan-Test Mode
    .dft_mode_scan_shift_i(1'b0      ), // TODO - Scan Shift Phase
    .dft_mode_mbist_mode_i(1'b0      ), // TODO - Memory Built-In Self-Test
    .wr_en_i              (1'b0      ), // TODO
    .wr_data_i            ({8 {1'b0}}), // TODO
    .wr_full_o            (          ), // TODO
    .wr_space_avail_o     (          ), // TODO
    .rd_en_i              (1'b0      ), // TODO
    .rd_data_o            (          ), // TODO
    .rd_empty_o           (          ), // TODO
    .rd_data_avail_o      (          )  // TODO
  );

endmodule // top

`default_nettype wire
`end_keywords
