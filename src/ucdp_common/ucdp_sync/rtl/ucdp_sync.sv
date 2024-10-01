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
// Module:     ucdp_common.ucdp_sync
// Data Model: ucdp_common.ucdp_sync.UcdpSyncMod
//
// =============================================================================

`begin_keywords "1800-2009"
`default_nettype none  // implicit wires are forbidden

module ucdp_sync #( // ucdp_common.ucdp_sync.UcdpSyncMod
  parameter logic [1:0] edge_type_p   = 2'h0,
  parameter logic       rstval_p      = 1'b0,
  parameter logic       norstvalchk_p = 1'b0
) (
  // main_i
  input  wire  main_clk_i,
  input  wire  main_rst_an_i, // Async Reset (Low-Active)
  input  wire  d_i,
  output logic q_o,
  output logic edge_o
);


// GENERATE INPLACE END head ===================================================

// lint_checking USEPRT on

  // Synchronizer
  wire q_s;

  generate if (rstval_p == 1'b0) begin : proc_sync_zero
    cld_sync_leaf_zero u_sync_leaf (
      .clk_i       (clk_i                ),
      .rst_an_i    (rst_an_i             ),
      .scan_shift_i(dft_mode_scan_shift_i),
      .d_i         (d_i                  ),
      .q_o         (q_s                  )
    );
  end else begin : proc_sync_one
    cld_sync_leaf_one u_sync_leaf (
      .clk_i       (clk_i                ),
      .rst_an_i    (rst_an_i             ),
      .scan_shift_i(dft_mode_scan_shift_i),
      .d_i         (d_i                  ),
      .q_o         (q_s                  )
    );
  end endgenerate

  assign q_o = q_s;


  // Edge Detection
  reg q_r;

  always @ (posedge clk_i or negedge rst_an_i) begin : proc_stage
    if (rst_an_i == 1'b0) begin
      q_r <= #`dly {rstval_p};
    end else begin
      q_r <= #`dly q_s;
    end
  end

  // lint_checking CONSTC off
  always_comb begin : proc_edge
    case (edge_type_p)
      // disable block coverage here, the toggle coverage on the ports is sufficient
      // pragma coverage block = off
      2'd3    : edge_o = q_r ^ q_s; // any edge
      2'd2    : edge_o = q_r & ~q_s; // falling edge
      2'd1    : edge_o = ~q_r & q_s; // rising edge
      default : edge_o = 1'b0;
      // pragma coverage block = on
    endcase // edge_type_p
  end
  // lint_checking CONSTC on

`ifdef SIM
  // pragma coverage off
  reg checked_r = 1'b0;
  reg warned_r = 1'b0;

  always @ (posedge rst_an_i) begin : proc_rst_check
    if ((rst_an_i == 1'b1) && (norstvalchk_p == 1'b0)) begin
      checked_r <= 1'b1;
      if (d_i != rstval_p) begin
        if (warned_r == 1'b0) begin
          warned_r <= 1'b1;
          $display($time, "ps\tCLD_SYNC\tWARNING: Reset Value Mismatch %m");
        end
      end
    end
  end
  // pragma coverage on
`endif

// GENERATE INPLACE BEGIN tail() ===============================================
endmodule // ucdp_sync

`default_nettype wire
`end_keywords
// GENERATE INPLACE END tail ===================================================
