#!/usr/bin/env python

import webbrowser
import time
try:
  import SimpleHTTPServer
except:
  import http.server as SimpleHTTPServer

# start mini HTTP daemon.
SimpleHTTPServer.test(HandlerClass=SimpleHTTPServer.SimpleHTTPRequestHandler)
