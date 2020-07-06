class Omake < Formula
  desc "Build system designed for scalability, portability, and concision"
  homepage "http://projects.camlcity.org/projects/omake.html"
  url "https://github.com/ocaml-omake/omake/archive/omake-0.10.3.tar.gz"
  sha256 "5f42aabdb4088b5c4e86c7a08e235dc7d537fd6b3064852154303bb92f5df70e"
  license "GPL-2.0-only"
  head "https://github.com/ocaml-omake/omake.git"

  depends_on "ocaml" => [:build, :test]
  depends_on "ocaml-findlib" => :test

  conflicts_with "oil", :because => "both install 'osh' binaries"
  conflicts_with "etsh", :because => "both install 'osh' binaries"

  def install
    system "./configure", "-prefix", prefix
    system "make", "install"
  end

  test do
    # example run adapted from the documentation's "quickstart guide"
    system bin/"omake", "--install"
    (testpath/"hello_code.c").write <<~EOF
      #include <stdio.h>

      int main(int argc, char **argv)
      {
          printf("Hello, world!\\n");
          return 0;
      }
    EOF
    rm testpath/"OMakefile"
    (testpath/"OMakefile").write <<~EOF
      CC = #{ENV.cc}
      CFLAGS += #{ENV.cflags}
      CProgram(hello, hello_code)
      .DEFAULT: hello$(EXE)
    EOF
    system bin/"omake", "hello"
    assert_equal shell_output(testpath/"hello"), "Hello, world!\n"
  end
end
