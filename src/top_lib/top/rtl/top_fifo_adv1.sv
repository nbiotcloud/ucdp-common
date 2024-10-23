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
// Module:     top_lib.top_fifo_adv1
// Data Model: ucdp_common.ucdp_fifo_adv.UcdpFifoAdvMod
//
//
// 576x32 (128+128+128+128+64)x32=2.25 KB
//
// =============================================================================

`begin_keywords "1800-2009"
`default_nettype none  // implicit wires are forbidden

module top_fifo_adv1 ( // ucdp_common.ucdp_fifo_adv.UcdpFifoAdvMod
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
  input  wire  [31:0] data_i,
  output logic [31:0] data_o,
  output logic [9:0]  filling_o
);



  // ------------------------------------------------------
  //  Local Parameter
  // ------------------------------------------------------
  localparam integer width_p = 32;


  // ------------------------------------------------------
  //  Signals
  // ------------------------------------------------------
  logic [9:0]         filling_s;
  logic               empty0_s;
  logic               full0_s;
  logic [7:0]         filling0_s;
  logic               empty1_s;
  logic               full1_s;
  logic [7:0]         filling1_s;
  logic               to1_s;
  logic               empty2_s;
  logic               full2_s;
  logic [7:0]         filling2_s;
  logic               to2_s;
  logic               empty3_s;
  logic               full3_s;
  logic [7:0]         filling3_s;
  logic               to3_s;
  logic               empty4_s;
  logic               full4_s;
  logic [6:0]         filling4_s;
  logic               to4_s;
  logic [width_p-1:0] fifo0_data_o_s;
  logic [width_p-1:0] fifo1_data_o_s;
  logic [width_p-1:0] fifo2_data_o_s;
  logic [width_p-1:0] fifo3_data_o_s;


  // ------------------------------------------------------
  //  FIFO 1 of 5 (128)
  // ------------------------------------------------------
  ucdp_fifo #(
    .width_p        (32 ),
    .depth_p        (128),
    .filling_width_p(8  )
  ) u_fifo0 (
    // main_i
    .main_clk_i           (main_clk_i           ),
    .main_rst_an_i        (main_rst_an_i        ), // Async Reset (Low-Active)
    // dft_mode_i: Test Control
    .dft_mode_test_mode_i (dft_mode_test_mode_i ), // Test Mode
    .dft_mode_scan_mode_i (dft_mode_scan_mode_i ), // Logic Scan-Test Mode
    .dft_mode_scan_shift_i(dft_mode_scan_shift_i), // Scan Shift Phase
    .dft_mode_mbist_mode_i(dft_mode_mbist_mode_i), // Memory Built-In Self-Test
    .rd_ena_i             (to1_s                ),
    .wr_ena_i             (wr_ena_i             ),
    .empty_o              (empty0_s             ),
    .full_o               (full0_s              ),
    .data_i               (data_i               ),
    .data_o               (fifo0_data_o_s       ),
    .filling_o            (filling0_s           )
  );


  // ------------------------------------------------------
  //  FIFO 2 of 5 (128)
  // ------------------------------------------------------
  ucdp_fifo #(
    .width_p        (32 ),
    .depth_p        (128),
    .filling_width_p(8  )
  ) u_fifo1 (
    // main_i
    .main_clk_i           (main_clk_i           ),
    .main_rst_an_i        (main_rst_an_i        ), // Async Reset (Low-Active)
    // dft_mode_i: Test Control
    .dft_mode_test_mode_i (dft_mode_test_mode_i ), // Test Mode
    .dft_mode_scan_mode_i (dft_mode_scan_mode_i ), // Logic Scan-Test Mode
    .dft_mode_scan_shift_i(dft_mode_scan_shift_i), // Scan Shift Phase
    .dft_mode_mbist_mode_i(dft_mode_mbist_mode_i), // Memory Built-In Self-Test
    .rd_ena_i             (to2_s                ),
    .wr_ena_i             (to1_s                ),
    .empty_o              (empty1_s             ),
    .full_o               (full1_s              ),
    .data_i               (fifo0_data_o_s       ),
    .data_o               (fifo1_data_o_s       ),
    .filling_o            (filling1_s           )
  );


  // ------------------------------------------------------
  //  FIFO 3 of 5 (128)
  // ------------------------------------------------------
  ucdp_fifo #(
    .width_p        (32 ),
    .depth_p        (128),
    .filling_width_p(8  )
  ) u_fifo2 (
    // main_i
    .main_clk_i           (main_clk_i           ),
    .main_rst_an_i        (main_rst_an_i        ), // Async Reset (Low-Active)
    // dft_mode_i: Test Control
    .dft_mode_test_mode_i (dft_mode_test_mode_i ), // Test Mode
    .dft_mode_scan_mode_i (dft_mode_scan_mode_i ), // Logic Scan-Test Mode
    .dft_mode_scan_shift_i(dft_mode_scan_shift_i), // Scan Shift Phase
    .dft_mode_mbist_mode_i(dft_mode_mbist_mode_i), // Memory Built-In Self-Test
    .rd_ena_i             (to3_s                ),
    .wr_ena_i             (to2_s                ),
    .empty_o              (empty2_s             ),
    .full_o               (full2_s              ),
    .data_i               (fifo1_data_o_s       ),
    .data_o               (fifo2_data_o_s       ),
    .filling_o            (filling2_s           )
  );


  // ------------------------------------------------------
  //  FIFO 4 of 5 (128)
  // ------------------------------------------------------
  ucdp_fifo #(
    .width_p        (32 ),
    .depth_p        (128),
    .filling_width_p(8  )
  ) u_fifo3 (
    // main_i
    .main_clk_i           (main_clk_i           ),
    .main_rst_an_i        (main_rst_an_i        ), // Async Reset (Low-Active)
    // dft_mode_i: Test Control
    .dft_mode_test_mode_i (dft_mode_test_mode_i ), // Test Mode
    .dft_mode_scan_mode_i (dft_mode_scan_mode_i ), // Logic Scan-Test Mode
    .dft_mode_scan_shift_i(dft_mode_scan_shift_i), // Scan Shift Phase
    .dft_mode_mbist_mode_i(dft_mode_mbist_mode_i), // Memory Built-In Self-Test
    .rd_ena_i             (to4_s                ),
    .wr_ena_i             (to3_s                ),
    .empty_o              (empty3_s             ),
    .full_o               (full3_s              ),
    .data_i               (fifo2_data_o_s       ),
    .data_o               (fifo3_data_o_s       ),
    .filling_o            (filling3_s           )
  );


  // ------------------------------------------------------
  //  FIFO 5 of 5 (64)
  // ------------------------------------------------------
  ucdp_fifo #(
    .width_p        (32),
    .depth_p        (64),
    .filling_width_p(7 )
  ) u_fifo4 (
    // main_i
    .main_clk_i           (main_clk_i           ),
    .main_rst_an_i        (main_rst_an_i        ), // Async Reset (Low-Active)
    // dft_mode_i: Test Control
    .dft_mode_test_mode_i (dft_mode_test_mode_i ), // Test Mode
    .dft_mode_scan_mode_i (dft_mode_scan_mode_i ), // Logic Scan-Test Mode
    .dft_mode_scan_shift_i(dft_mode_scan_shift_i), // Scan Shift Phase
    .dft_mode_mbist_mode_i(dft_mode_mbist_mode_i), // Memory Built-In Self-Test
    .rd_ena_i             (rd_ena_i             ),
    .wr_ena_i             (to4_s                ),
    .empty_o              (empty4_s             ),
    .full_o               (full4_s              ),
    .data_i               (fifo3_data_o_s       ),
    .data_o               (data_o               ),
    .filling_o            (filling4_s           )
  );

  // ------------------------------------------------------
  //  Chain Logic
  // ------------------------------------------------------
  assign to1_s = ~empty0_s & ~full1_s;
  assign to2_s = ~empty1_s & ~full2_s;
  assign to3_s = ~empty2_s & ~full3_s;
  assign to4_s = ~empty3_s & ~full4_s;

  // ------------------------------------------------------
  //  Status
  // ------------------------------------------------------
  assign empty_o = empty0_s & empty1_s & empty2_s & empty3_s & empty4_s;
  assign full_o = full0_s & full1_s & full2_s & full3_s & full4_s;
  assign accept_o = ~full0_s;
  assign valid_o = ~empty4_s;
  assign filling_s = filling0_s + filling1_s + filling2_s + filling3_s + filling4_s;
  assign filling_o = filling_s;

endmodule // top_fifo_adv1

`default_nettype wire
`end_keywords
