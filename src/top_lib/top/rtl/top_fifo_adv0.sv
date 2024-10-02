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
// Module:     top_lib.top_fifo_adv0
// Data Model: ucdp_common.ucdp_fifo_adv.UcdpFifoAdvMod
//
//
// 60x17 127 bytes
//
// =============================================================================

`begin_keywords "1800-2009"
`default_nettype none  // implicit wires are forbidden

module top_fifo_adv0 ( // ucdp_common.ucdp_fifo_adv.UcdpFifoAdvMod
  // main_i
  input  wire         main_clk_i,
  input  wire         main_rst_an_i,         // Async Reset (Low-Active)
  // dft_mode_i: Test Control
  input  wire         dft_mode_test_mode_i,  // Test Mode
  input  wire         dft_mode_scan_mode_i,  // Logic Scan-Test Mode
  input  wire         dft_mode_scan_shift_i, // Scan Shift Phase
  input  wire         dft_mode_mbist_mode_i, // Memory Built-In Self-Test
  input  wire         rd_ena_i,
  input  wire         wr_ena_i,
  output logic        empty_o,
  output logic        full_o,
  output logic        accept_o,
  output logic        valid_o,
  input  wire  [16:0] data_i,
  output logic [16:0] data_o,
  output logic [5:0]  filling_o
);



  // ------------------------------------------------------
  //  Local Parameter
  // ------------------------------------------------------
  localparam integer width_p = 17;


  // ------------------------------------------------------
  //  Signals
  // ------------------------------------------------------
  logic [5:0] filling_s;
  logic       empty0_s;
  logic       full0_s;
  logic [5:0] filling0_s;


  // ------------------------------------------------------
  //  FIFO 1 of 1 (60)
  // ------------------------------------------------------
  ucdp_fifo #(
    .width_p        (17),
    .depth_p        (60),
    .filling_width_p(6 )
  ) u_fifo0 (
    // main_i
    .main_clk_i           (main_clk_i           ),
    .main_rst_an_i        (main_rst_an_i        ), // Async Reset (Low-Active)
    // dft_mode_i: Test Control
    .dft_mode_test_mode_i (dft_mode_test_mode_i ), // Test Mode
    .dft_mode_scan_mode_i (dft_mode_scan_mode_i ), // Logic Scan-Test Mode
    .dft_mode_scan_shift_i(dft_mode_scan_shift_i), // Scan Shift Phase
    .dft_mode_mbist_mode_i(dft_mode_mbist_mode_i), // Memory Built-In Self-Test
    .rd_ena_i             (rd_ena_i             ),
    .wr_ena_i             (wr_ena_i             ),
    .empty_o              (empty0_s             ),
    .full_o               (full0_s              ),
    .data_i               (data_i               ),
    .data_o               (data_o               ),
    .filling_o            (filling0_s           )
  );

  // ------------------------------------------------------
  //  Chain Logic
  // ------------------------------------------------------

  // ------------------------------------------------------
  //  Status
  // ------------------------------------------------------
  assign empty_o = empty0_s;
  assign full_o = full0_s;
  assign accept_o = ~full0_s;
  assign valid_o = ~empty0_s;
  assign filling_s = filling0_s;
  assign filling_o = filling_s;

endmodule // top_fifo_adv0

`default_nettype wire
`end_keywords
