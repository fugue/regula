# Regula Server Example

This shows how to run Regula as a web service. It accepts zip file uploads
containing IaC templates to be evaluated. Each upload is unpacked, Regula rules
are run against the files within the zip, and the Regula report is returned.

## How to run the server

 * [Install Go](https://golang.org/doc/install)
 * Build this program: `cd regula/server && go build`
 * Run the server: `./server`

## How to run the client

An example client is [upload.sh](./upload.sh). It zips up the example_inputs
directory and posts it to the server.
