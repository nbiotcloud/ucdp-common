#
# MIT License
#
# Copyright (c) 2024-2025 nbiotcloud
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

"""Synchronizer Leaf Cell."""

import ucdp as u
from ucdp_glbl.dft import ScanShiftType

from ucdp_common.fileliststandard import HdlFileList


class UcdpSyncLeafZeroMod(u.AMod):
    """
    Synchronizer Leaf Zell, 1'b0 at Reset.

    This leaf cell contains the actual synchronizer stage.
    It is meant to be replaced by library cells during synthesis.
    """

    filelists: u.ClassVar[u.ModFileLists] = (HdlFileList(gen="inplace"),)

    def _build(self) -> None:
        # -----------------------------
        # Port List
        # -----------------------------
        self.add_port(u.ClkRstAnType(), "tgt_i")
        self.add_port(ScanShiftType(), "scan_shift_i")
        self.add_port(u.BitType(), "d_i", title="data input", descr="data input")
        self.add_port(u.BitType(), "q_o", title="data output", descr="data output")
