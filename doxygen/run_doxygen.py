import argparse
import sys
import subprocess
import os
import tarfile

def run_doxgyen(args):
    cmd = [
            args.doxygen_tool,
            args.doxyfile
    ]
    try:
        out = subprocess.check_output(cmd)
        return out.decode('utf-8')
    except subprocess.CalledProcessError as e:
        print(e.output)
        raise e

def make_archive(srcdir, filename):
    with tarfile.open(filename, 'w:gz') as tar:
        tar.add(srcdir)
    return filename

def main(argv = sys.argv[1:]):
    parser = argparse.ArgumentParser()
    parser.add_argument('--doxyfile', required = True)
    parser.add_argument('--srcdir', required=True)
    parser.add_argument('--output', required=True)
    parser.add_argument('--doxygen_tool', required = True)
    args = parser.parse_args(argv)

    print(run_doxgyen(args))
    make_archive(args.srcdir, args.output)

if __name__ == '__main__':
    main()
