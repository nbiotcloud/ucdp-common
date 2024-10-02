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

import math

import ucdp as u
from humannum import Bytesize, bytesize_
from icdutil import num
from ucdp_glbl.dft import DftModeType

from ucdp_common.fileliststandard import HdlFileList
from ucdp_common.ucdp_fifo import UcdpFifoMod


class UcdpFifoAdvMod(u.ATailoredMod):
    """
    Advanced Synchronous FIFO.

    Dual port Memory with pointer management.

    If the `depth` exceeds `max_seg_depth` the FIFO is split into multiple segments internally.

    Keyword Args:
        depth (int):          Required. Depth in words
        width (int):          Required. Width in bits.
        max_filling (bool):   Add maximum filling level tracking
        readdatastage (bool): Add extra read stage at the end.
        max_seg_depth (int):  Maximum depth of one FIFO segment.

        >>> import ucdp as u
        >>> class MyMod(u.AMod):
        ...     def _build(self):
        ...         UcdpFifoAdvMod(self, "u_buf0", depth=320, width=16)
        ...         UcdpFifoAdvMod(self, "u_buf1", depth=320, width=16, max_filling=True)
        ...         UcdpFifoAdvMod(self, "u_buf2", depth=320, width=16, readdatastage=True)
        >>> my = MyMod(None, "u_my")
        >>> buf = my.get_inst("u_buf0")
        >>> buf.depth
        320
        >>> buf.width
        16
        >>> buf.size
        Bytesize('640 bytes')
        >>> buf.seg_depths
        (128, 128, 64)
        >>> buf.filling_width
        9

    """

    filelists: u.ClassVar[u.ModFileLists] = (HdlFileList(gen="full"),)

    depth: int
    width: int
    max_filling: bool = False
    readdatastage: bool = False
    max_seg_depth: int = 128

    @staticmethod
    def build_top(**kwargs: dict[str, str]) -> u.AMod:
        """Build example top module and return it."""
        return UcdpFifoAdvExampleMod()

    @property
    def size(self) -> Bytesize:
        """Size in bytes."""
        return bytesize_(self.depth * self.width / 8)

    @property
    def seg_depths(self) -> tuple[int, ...]:
        """Segment Splitting."""
        remainder = (self.depth % self.max_seg_depth) or self.max_seg_depth
        segs = int(math.ceil(self.depth / self.max_seg_depth))
        return (self.max_seg_depth,) * (segs - 1) + (remainder,)

    @property
    def filling_width(self) -> int:
        """Width of filling status in bits."""
        return get_filling_width(self.depth)

    def get_overview(self) -> str:
        """FIFO summary."""
        seg_depths = self.seg_depths
        if len(seg_depths) > 1:
            depths = "+".join(str(seg) for seg in seg_depths)
            return f"{self.depth}x{self.width} ({depths})x{self.width}={self.size}"
        return f"{self.depth}x{self.width} {self.size}"

    def _build(self) -> None:
        # -----------------------------
        # Port List
        # -----------------------------
        self.add_port(u.ClkRstAnType(), "main_i")
        self.add_port(DftModeType(), "dft_mode_i")
        self.add_port(u.EnaType(), "rd_ena_i", title="Read Enable")
        self.add_port(u.EnaType(), "wr_ena_i", title="Write Enable")

        self.add_port(u.BitType(default=1), "empty_o", title="Empty", descr="All internal FIFO segments are empty.")
        self.add_port(u.BitType(default=1), "full_o", title="Full", descr="All internal FIFO segments are full.")
        descr = "The first FIFO segment is not full, new data is accepted and stored."
        self.add_port(u.BitType(default=1), "accept_o", title="Accept", descr=descr)
        descr = "The last FIFO segment is not empty, valid data is available."
        self.add_port(u.BitType(default=1), "valid_o", title="Valid", descr=descr)
        self.add_port(u.UintType(self.width), "data_i", title="Input Data Port")
        self.add_port(u.UintType(self.width), "data_o", title="Output Data Port")
        self.add_port(u.UintType(self.filling_width), "filling_o", title="Fill status.")
        self.add_signal(u.UintType(self.filling_width), "filling_s")

        # -----------------------------
        # Segments
        # -----------------------------
        width_p = self.add_const(u.IntegerType(default=self.width), "width_p")
        if self.max_filling:
            self.add_port(u.BitType(), "max_filling_clr_i", title="Clear Max Filling Status")
            self.add_port(u.UintType(self.filling_width), "max_filling_o", title="Max Filling Status")
            self.add_flipflop(
                u.UintType(self.filling_width),
                "max_filling_r",
                clk="main_clk_i",
                rst_an="main_rst_an_i",
                rst="max_filling_clr_i == const('1b1')",
                nxt="ternary((filling_s > max_filling_r), filling_s, max_filling_r)",
            )

        # Segments
        seg_depths = self.seg_depths
        prev_idx = None
        for idx, depth in enumerate(seg_depths):
            name = "u_fifo%d" % idx
            filling_width = get_filling_width(depth)
            comment = "FIFO %d of %d (%s)" % (idx + 1, len(seg_depths), depth)
            fifo = UcdpFifoMod(
                self,
                name,
                comment=comment,
                paramdict={
                    "depth_p": depth,
                    "width_p": width_p,
                    "filling_width_p": filling_width,
                },
            )
            self.add_signal(u.BitType(), "empty%d_s" % idx)
            self.add_signal(u.BitType(), "full%d_s" % idx)
            self.add_signal(u.UintType(filling_width), "filling%d_s" % idx)
            fifo.con("main_i", "main_i")
            fifo.con("dft_mode_i", "dft_mode_i")
            fifo.con("empty_o", "empty%d_s" % idx)
            fifo.con("full_o", "full%d_s" % idx)
            fifo.con("filling_o", "filling%d_s" % idx)
            if prev_idx is not None:
                self.add_signal(u.BitType(), "to%d_s" % idx)
                # pylint: disable=bad-string-format-type
                self.route(f"to{idx}_s", f"cast(u_fifo{prev_idx}/rd_ena_i)")
                self.route(f"to{idx}_s", f"cast(u_fifo{idx}/wr_ena_i)")
                self.route("u_fifo%d/data_o" % prev_idx, "u_fifo%d/data_i" % idx)
            prev_idx = idx

        # write to first
        self.route("data_i", "u_fifo0/data_i")
        self.route("wr_ena_i", "u_fifo0/wr_ena_i")
        # read from last
        self.route(f"u_fifo{prev_idx}/rd_ena_i", "rd_ena_i")
        if not self.readdatastage:
            self.route(f"u_fifo{prev_idx}/data_o", "data_o")
        else:
            self.add_signal(u.UintType(self.width), "data_nxt_s")
            self.add_flipflop(
                u.UintType(self.width),
                "data_r",
                rst_an="main_rst_an_i",
                clk="main_clk_i",
                nxt="data_nxt_s",
                ena=f"(rd_ena_i & ~empty{prev_idx}_s)",
            )
            self.route(f"u_fifo{prev_idx}/data_o", "data_nxt_s")
            self.route("data_o", "data_r")


class UcdpFifoAdvExampleMod(u.AMod):
    """Example."""

    def _build(self) -> None:
        UcdpFifoAdvMod(self, "u_buf0", depth=320, width=16)
        UcdpFifoAdvMod(self, "u_buf1", depth=320, width=16, max_filling=True)
        UcdpFifoAdvMod(self, "u_buf2", depth=320, width=16, readdatastage=True)


def get_filling_width(depth: int) -> int:
    """Required width of filling signal for FIFO `depth`."""
    return num.calc_unsigned_width(depth + 1)
