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
    if String.match?("PDF document, version 1.1", ~r/\APDF document, version \d\.\d\n\z/) do
      #XXX: create a tempfile for the output.
      options = [
        "-q", "-dNOPAUSE", "-dSAFER", "-dBATCH", "-sDEVICE=pdfwrite",
        "-sOutputFile=fixed1.pdf", "-c .setpdfwrite", "-f", params["pdf"].path
      ]

      [filename, _extensions] = String.split(params["pdf"].filename, ".")
      finished_filename = "#{filename}_fixed.pdf"
      {result, _exit_status} = System.cmd("/usr/bin/gs", options)
      conn
      |> put_resp_header("content-type", "application/pdf")
      |> put_resp_header("content-disposition", "attachment; filename=#{finished_filename}")
      |> send_file(200, "fixed1.pdf")
    else
      conn
      |> put_status(400)
      |> text "That is not a PDF."
    end
  end

end
