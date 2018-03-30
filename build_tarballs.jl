using BinaryBuilder

# Collection of sources required to build SAASGP4Builder
sources = [
    "https://github.com/benelsen/SAASGP4Builder.jl/raw/master/src/SGP4_small_V7.8_LINUX64.tar.gz" => "36bf3c1df0d5ed5dae59ac464548c15a888fcda256d93950a95b8bf39cc42f1a",
]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir

mkdir $prefix/lib

cp Lib/SGP4_Open_License.txt $prefix/lib/

# cp Lib/lib_external/* $prefix/lib/
# cp Lib/lib_external/libdl.so.2 $prefix/lib/
# cp Lib/lib_external/ld-linux-x86-64.so.2 $prefix/lib/
# cp Lib/lib_external/libpthread.so.0 $prefix/lib/

cp Lib/libifcore.so.5 $prefix/lib/
cp Lib/libifcoremt.so.5 $prefix/lib/
cp Lib/libifport.so.5 $prefix/lib/
cp Lib/libimf.so $prefix/lib/
cp Lib/libintlc.so.5 $prefix/lib/
# cp Lib/libiomp5.so $prefix/lib/
cp Lib/libsvml.so $prefix/lib/

mv Lib/DllMain.dll $prefix/lib/DllMain.so
mv Lib/EnvConst.dll $prefix/lib/EnvConst.so
mv Lib/AstroFunc.dll $prefix/lib/AstroFunc.so
mv Lib/TimeFunc.dll $prefix/lib/TimeFunc.so
mv Lib/Tle.dll $prefix/lib/Tle.so
mv Lib/Sgp4Prop.dll $prefix/lib/Sgp4Prop.so
"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = [
    BinaryProvider.Linux(:x86_64, :glibc, :blank_abi)
]

# The products that we will ensure are always built
products(prefix) = [
    LibraryProduct(prefix, "DllMain", :dllmain),
    LibraryProduct(prefix, "EnvConst", :envconst),
    LibraryProduct(prefix, "AstroFunc", :astrofunc),
    LibraryProduct(prefix, "TimeFunc", :timefunc),
    LibraryProduct(prefix, "Tle", :tle),
    LibraryProduct(prefix, "Sgp4Prop", :sgp4prop),
]

# Dependencies that must be installed before this package can be built
dependencies = []

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, "SAASGP4", sources, script, platforms, products, dependencies)
