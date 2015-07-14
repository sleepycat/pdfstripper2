# Pdfstripper2

This is the latest version of the code behind
http://www.pdf-permissions-remover.com/

The original was written in Ruby and hosted on Dreamhost, until they
"upgraded" their server and broke my carefully crafted world.

This version is written in Elixir using the Phoenix web framework.

To start your new Phoenix application:

1. Install dependencies with `mix deps.get`
2. Start Phoenix endpoint with `mix phoenix.server`

Now you can visit `localhost:4000` from your browser.

There is a Docker container built with the Dockerfile in the project
root. You can pull and run the app locally with the command:

```sh
docker run -t -p=4000:4000 mikewilliamson/pdfstripper
firefox localhost:4000
```
