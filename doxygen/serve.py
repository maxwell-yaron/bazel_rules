from http.server import HTTPServer, SimpleHTTPRequestHandler
import tempfile
import tarfile
import os
import argparse
import sys

def get_handler(directory):
    class HTTPRequestHandler(SimpleHTTPRequestHandler):
        def __init__(self, *args, **kwargs):
            py_version = sys.version_info
            if(py_version.major >= 3 and py_version.minor >= 8):
                super().__init__(*args, directory=directory, **kwargs)
            else:
                os.chdir(directory)
                super().__init__(*args, **kwargs)
    return HTTPRequestHandler

def run_server(directory, port):
    server = HTTPServer
    addr = ('',port)
    handler = get_handler(directory)
    httpd = server(addr, handler)
    try:
        httpd.serve_forever()
    except KeyboardInterrupt:
        pass
    httpd.server_close()

def main(argv = sys.argv[1:]):
    parser = argparse.ArgumentParser()
    parser.add_argument('--tarfile', required = True)
    parser.add_argument('--port', type=int, default=8000)
    parser.add_argument('--dirname', required = True)
    parser.add_argument('--execpath', required = True)
    args = parser.parse_args(argv)

    with tempfile.TemporaryDirectory() as d:
        with tarfile.open(args.tarfile) as tar:
            tar.extractall(d)
        execdir = os.path.dirname(args.execpath)
        path = os.path.join(d,execdir,args.dirname,'html')
        run_server(path, port = args.port)

if __name__ == '__main__':
    main()
