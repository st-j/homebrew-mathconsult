require 'formula'

class Laspack <Formula
  url 'http://www.netlib.org/linalg/laspack.tgz'
  homepage 'http://www.mgnet.org/mgnet/Codes/laspack/html/laspack.html'
  sha256 '3bec92900e8fd60a962cb3b2e3d4fb7e55f00fd06b256683427e52cafc2286fa'
  version "1.12.2"
  
  def options
    [
      ['--tests', "Install test executables."],
      ["--universal", "Build universal binaries."]
    ]
  end

  def install
    ENV.universal_binary if ARGV.include? "--universal"
    inreplace Dir['**/makefile'] do |s|
      s.change_make_var! "LIBLOCAL", lib
      s.change_make_var! "INCLOCAL", include
      s.change_make_var! "BINLOCAL", bin
      s.change_make_var! "LIBROOT", lib
    end
    mkdir include
    mkdir lib
    pkgs = ['xc', 'laspack']
    if ARGV.include? "--tests"
      mkdir bin
      ENV.append 'CFLAGS', "-I#{include}"
      ENV.append 'LDFLAGS', "-L#{lib}"
      pkgs << 'laspack/examples/*'
    end
    Dir.glob(pkgs) do |pkg|
      system "cd #{pkg}; make clean; make install-local"
    end
    doc.install Dir['laspack/doc/*', 'laspack/html']
  end
end
