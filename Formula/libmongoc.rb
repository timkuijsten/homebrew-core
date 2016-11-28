class Libmongoc < Formula
  desc "Cross Platform MongoDB Client Library for C"
  homepage "http://mongoc.org/"
  url "https://github.com/mongodb/mongo-c-driver/releases/download/1.4.2/mongo-c-driver-1.4.2.tar.gz"
  sha256 "9154d8f6b3261f785a19d1f81506fb911c985f26dfdc9b19082e1bc7af479afb"

  bottle do
    cellar :any
    sha256 "0d03f284d1cd524904e72457ae3ead1d05e644bb4f811bd1155456270b475182" => :sierra
    sha256 "b5eb2d6853d8cb4c49d21bc24ac0f19f7023fe2e69bbbe6f09d199e37340515e" => :el_capitan
    sha256 "9778915da0d362a4fe4e8c17ab1614cfe53d4c2f9cbe9a7c3ae6062fa8f3560c" => :yosemite
  end

  head do
    url "https://github.com/mongodb/mongo-c-driver.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build

  conflicts_with "libbson",
                 :because => "libmongoc comes with a bundled libbson"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--enable-man-pages",
                          "--enable-ssl=darwin"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <bson.h>
      int main() {
        bson_t *b;
        if (!bson_init_from_json(b, "{}", -1, NULL))
          return 1;
        bson_destroy(b);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lbson-1.0", "-I#{include}/libbson-1.0", "-o", "test"
    system "./test"
  end
end
