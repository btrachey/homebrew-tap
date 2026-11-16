class TailTones < Formula
  desc "Sonify application logs: tail + tee + live audio severity bed"
  homepage "https://github.com/btrachey/tail-tones-scala"
  # The source repo is private; cloning it needs GitHub credentials (brew
  # reuses the `gh` token or any configured git credential helper).
  # No livecheck: the repo is private, so tag queries would 404 unauthenticated.
  # Bump by re-tagging upstream, then updating tag:/revision: here.
  url "https://github.com/btrachey/tail-tones-scala.git",
      tag:      "v0.1.0",
      revision: "2c75029ee761c258b11acdf7ceb5c4e92f80b50a"
  head "https://github.com/btrachey/tail-tones-scala.git", branch: "main"

  depends_on "llvm" => :build
  depends_on "openjdk" => :build
  depends_on "sbt" => :build

  # sbt/coursier resolve the Scala + Scala Native toolchain from Maven
  # Central during the build; caches live in the fake $HOME that the build
  # sandbox provides.
  allow_network_access! :build

  def install
    ENV["CI"] = "TRUE"
    # Scala Native's Discover reads LLVM_BIN and expects the *bin* directory
    # (verified: LLVM_BIN=<prefix> fails with "'clang' not found";
    # LLVM_BIN=<prefix>/bin resolves clang/clang++).
    ENV["LLVM_BIN"] = formula_opt_bin("llvm")

    system "sbt", "-batch", "-Dsbt.log.noformat=true", "-Dsbt.server.autostart=false", "nativeLink"

    binary = Dir["target/scala-*/tail-tones"].first
    raise "sbt nativeLink produced no binary under target/scala-*/" if binary.nil?

    bin.install binary
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tail-tones --version")

    # The tee contract: with the null backend, stdout is byte-for-byte the input.
    (testpath/"app.log").write <<~LOG
      2026-11-15T12:00:00Z INFO starting
      2026-11-15T12:00:01Z ERROR boom
    LOG
    assert_equal File.read(testpath/"app.log"),
                 shell_output("#{bin}/tail-tones --backend null -q #{testpath/"app.log"}")
  end
end
