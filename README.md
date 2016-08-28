Objectives
==========

1. Create a mixed elixir/erlang application that utilizes the `cowboy`
   webserver library to serve multiple `hello world` style HTML pages over
   HTTP as well as HTTPS.
   Implement the application in a way that it serves it's content on two
   ports per protocol for both, elixir and erlang (thus 8 servers: 2x erl+http
   2x erl+https, 2x elixir+http, 2x elixir+https).

2. Each webserver defines handlers for three urls, "/", "/hello-world/" and
   "/hello-random/". "/" serves an index page for the server with links pointing
   to the other two. "/hello-world/" serves just "Hello world!".
   "/hello-random/" serves a message in the format "Hello {random}!" where
   "{random}" is substitued with a random string. Each handler retrieves the
   random string from a process which picks an item from a predefined list
   defined in it's modules source.
