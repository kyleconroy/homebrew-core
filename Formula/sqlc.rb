class Sqlc < Formula
  desc "Generate type safe Go from SQL"
  homepage "https://sqlc.dev/"
  url "https://github.com/kyleconroy/sqlc/archive/v1.6.0.tar.gz"
  sha256 "a95a123f29a71f5a2eea0811e4590d59cbc92eccd407abe93c110c738fc4740b"
  license "MIT"
  head "https://github.com/kyleconroy/sqlc.git"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/sqlc"
  end

  test do
    (testpath/"sqlc.json").write <<~SQLC
      {
        "version": "1",
        "packages": [
          {
            "name": "db",
            "path": ".",
            "queries": "query.sql",
            "schema": "query.sql",
            "engine": "postgresql"
          }
        ]
      }
    SQLC

    (testpath/"query.sql").write <<~SQL.squish
      CREATE TABLE foo (bar text);

      -- name: SelectFoo :many
      SELECT * FROM foo;
    SQL

    system bin/"sqlc", "generate"
  end
end
