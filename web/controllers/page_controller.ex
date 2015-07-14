require IEx

defmodule Pdfstripper2.PageController do
  use Pdfstripper2.Web, :controller

  plug :action

  def index(conn, _params) do
    conn |> render "index.html"
  end

  # XXX: refactor this into separate functions
  def process conn, params do
    {type, exit} = System.cmd "file", ["-b", params["pdf"].path]
    if String.match?(type, ~r/\APDF document, version \d\.\d\n\z/) do
      {:ok, _tempfile, tempfile_path} = Tempfile.open
      options = [
        "-q", "-dNOPAUSE", "-dSAFER", "-dBATCH", "-sDEVICE=pdfwrite",
        "-sOutputFile=#{tempfile_path}", "-c .setpdfwrite", "-f", params["pdf"].path
      ]

      finished_filename = output_filename(params["pdf"].filename)
      {result, _exit_status} = System.cmd("/usr/bin/gs", options)
      conn
      |> put_resp_header("content-type", "application/pdf")
      |> put_resp_header("content-disposition", "attachment; filename=#{finished_filename}")
      |> send_file(200, tempfile_path)
    else
      conn
      |> put_flash(:error, "That does not appear to be a PDF.")
      |> redirect to: "/"
    end
  end

  defp output_filename current do
    [filename, _extensions] = String.split(current, ".")
    "#{filename}_fixed.pdf"
  end

end
