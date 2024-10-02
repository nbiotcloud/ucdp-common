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


class UcdpFifoMod(u.AMod):
    """
    Synchronous FIFO.
    """

    filelists: u.ClassVar[u.ModFileLists] = (HdlFileList(gen="inplace"),)

    def _build(self) -> None:
        # -----------------------------
        # Parameter List
        # -----------------------------
        width_p = self.add_param(u.IntegerType(default=8), "width_p", title="data width.")
        depth_p = self.add_param(u.IntegerType(default=8), "depth_p", title="depth.")
        filling_width_p = self.add_param(u.IntegerType(default=u.log2(depth_p + 1)), "filling_width_p")

        # -----------------------------
        # Port List
        # -----------------------------
        self.add_port(u.ClkRstAnType(), "main_i")
        self.add_port(DftModeType(), "dft_mode_i")
        self.add_port(u.EnaType(), "rd_en_i", title="Read Enable")
        self.add_port(u.EnaType(), "wr_en_i", title="Write Enable")

        self.add_port(u.BitType(default=1), "empty_o", title="Empty")
        self.add_port(u.BitType(default=1), "full_o", title="Full")
        self.add_port(u.UintType(width_p), "data_i", title="Input Data Port")
        self.add_port(u.UintType(width_p), "data_o", title="Output Data Port")
        self.add_port(u.UintType(filling_width_p), "filling_o", title="Fill status.")
