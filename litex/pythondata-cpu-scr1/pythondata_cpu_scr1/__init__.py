import os.path
__dir__ = os.path.split(os.path.abspath(os.path.realpath(__file__)))[0]
data_location = os.path.join(__dir__, "verilog")
src = "https://github.com/syntacore/scr1.git"

# Module version
version_str = "2024.09.post0"
version_tuple = (2024,9,0)
try:
    from packaging.version import Version as V
    pversion = V("2024.09.post0")
except ImportError:
    pass

# Data version info
data_version_str = "2024.09.post0"
data_version_tuple = (2024,9,0)
try:
    from packaging.version import Version as V
    pdata_version = V("2024.09.post0")
except ImportError:
    pass
data_git_hash = "4d3708c2d198e4cb9ad705ed05b688fe5cb05787"
data_git_describe = "v2024.09-4d3708c"
data_git_msg = """\
commit 4d3708c2d198e4cb9ad705ed05b688fe5cb05787
Author: Stanislav <stanislav.kokoulin@syntacore.com>
Date:   Thu Sep 26 14:59:37 2024 +0300

    binutils: illegal operands on latest binutils 2.42

"""

# Tool version info
tool_version_str = "2024.09.post0"
tool_version_tuple = (2024, 9, 0)
try:
    from packaging.version import Version as V
    ptool_version = V("2024.09.post0")
except ImportError:
    pass


def data_file(f):
    """Get absolute path for file inside pythondata_cpu_scr1."""
    fn = os.path.join(data_location, f)
    fn = os.path.abspath(fn)
    if not os.path.exists(fn):
        raise IOError("File {f} doesn't exist in pythondata_cpu_scr1".format(f))
    return fn
