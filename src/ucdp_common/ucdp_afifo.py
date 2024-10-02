#
# MIT License
#
# Copyright (c) 2024 nbiotcloud
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#

"""Asynchronous FIFO."""

import ucdp as u
from ucdp_glbl.dft import DftModeType

from ucdp_common.fileliststandard import HdlFileList
from ucdp_common.ucdp_sync import UcdpSyncMod


class UcdpAfifoMod(u.AMod):
    """
    Asynchronous FIFO.

    A-FIFO is designed according a paper from Clifford E. Cummings and Peter Alfke.
    The paper location is  http://www.sunburst-design.com/papers/CummingsSNUG2002SJ_FIFO1.pdf.
    """

    filelists: u.ClassVar[u.ModFileLists] = (HdlFileList(gen="inplace"),)

    def _build(self):
        # -----------------------------
        # Parameter
        # -----------------------------
        dwidth_p = self.add_param(u.IntegerType(default=8), "dwidth_p")
        awidth_p = self.add_param(u.IntegerType(default=4), "awidth_p")

        # -----------------------------
        # Port List
        # -----------------------------
        self.add_port(u.ClkRstAnType(), "clk0_i", title="Clock and Reset for clock domain 0")
        self.add_port(u.ClkRstAnType(), "clk1_i", title="Clock and Reset for clock domain 1")
        self.add_port(DftModeType(), "dft_mode_i", title="DFT Mode")

        self.add_port(WrType(awidth=awidth_p, dwidth=dwidth_p), "clk0_wr_i")
        self.add_port(RdType(awidth=awidth_p, dwidth=dwidth_p), "clk1_rd_o")

        UcdpSyncMod(self, "u_gray_ptr_clk0_sync", virtual=True)


class RdType(u.AStructType):
    """Read Type."""

    awidth: u.Param | int
    dwidth: u.Param | int

    def _build(self):
        self._add("ena", u.EnaType(), u.BWD, title="Read Enable")
        self._add("empty", u.BitType(default=1), title="Empty")
        self._add("data_avail", u.UintType(self.awidth), title="FIFO data avail")
        self._add("data", u.UintType(self.dwidth), title="Output Data Port")


class WrType(u.AStructType):
    """Write Type."""

    awidth: u.Param | int
    dwidth: u.Param | int

    def _build(self):
        self._add("ena", u.BitType(default=1), title="Write Enable")
        self._add("full", u.BitType(default=1), u.BWD, title="Full")
        self._add("space_avail", u.UintType(self.awidth), u.BWD, title="FIFO space avail")
        self._add("data", u.UintType(self.dwidth), title="Input Data Port")
