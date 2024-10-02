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

"""Clock Multiplexer."""

import ucdp as u

from ucdp_common.fileliststandard import HdlFileList


class SelType(u.AEnumType):
    """Select."""

    keytype: u.BitType = u.BitType()

    def _build(self) -> None:
        self._add(0, "a")
        self._add(1, "b")


class UcdpClkMuxMod(u.AMod):
    """
    Clock Mux.

    The logic is required for synthesis.
    """

    filelists: u.ClassVar[u.ModFileLists] = (HdlFileList(gen="inplace"),)

    def _build(self):
        # -----------------------------
        # Port List
        # -----------------------------
        self.add_port(u.ClkType(), "clka_i", title="Clock A")
        self.add_port(u.ClkType(), "clkb_i", title="Clock B")
        self.add_port(SelType(), "sel_i", title="Select", comment="Select")
        self.add_port(u.ClkType(), "clk_o", title="Clock output")

        self.add_type_consts(SelType())
