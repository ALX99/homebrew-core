class PythonAwscrt < Formula
  desc "Python bindings for the AWS common runtime"
  homepage "https://github.com/awslabs/aws-crt-python"
  url "https://files.pythonhosted.org/packages/82/1b/b5578329a77fe06aa66645f3827a4f5c1291ad39925775b49343f209b5d5/awscrt-0.30.0.tar.gz"
  sha256 "e1a133430e71116e9c0f101b0d11227f47b7c561ad5303f5af00f6c33a16f382"
  license "Apache-2.0"

  depends_on "python-setuptools" => :build
  depends_on "python@3.13" => [:build, :test]
  depends_on "python@3.14" => [:build, :test]

  depends_on "aws-c-auth"
  depends_on "aws-c-cal"
  depends_on "aws-c-common"
  depends_on "aws-c-compression"
  depends_on "aws-c-event-stream"
  depends_on "aws-c-http"
  depends_on "aws-c-io"
  depends_on "aws-c-mqtt"
  depends_on "aws-c-s3"
  depends_on "aws-c-sdkutils"
  depends_on "aws-checksums"
  depends_on "openssl@3"

  on_linux do
    depends_on "aws-lc"
    depends_on "s2n"
  end

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.start_with?("python@") }
        .map { |f| f.opt_libexec/"bin/python" }
  end

  def install
    ENV["AWS_CRT_BUILD_USE_SYSTEM_LIBCRYPTO"] = "1"
    ENV["AWS_CRT_BUILD_USE_SYSTEM_LIBS"] = "1"

    pythons.each do |python3|
      system python3, "-m", "pip", "install", *std_pip_args, "."
    end
  end

  test do
    pythons.each do |python3|
      system python3, "-c", "import awscrt"
    end
  end
end
