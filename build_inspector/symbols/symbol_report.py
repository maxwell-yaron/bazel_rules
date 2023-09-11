import argparse
import sys
import json
import re

class Symbol:
    def __init__(self, tp, sym):
        self.type = tp
        self.symbol = sym

    def defined(self):
        return self.type == 'T'

    def undefined(self):
        return self.type == 'U'

    def __hash__(self):
        return hash((self.type, self.symbol))

    def __eq__(self, other):
        return self.type == other.type and self.symbol == other.symbol

class SimpleEncoder(json.JSONEncoder):
    def default(self, o):
        return o.__dict__

def parse_line(l):
    try:
        l = re.sub('[0-9a-f]{4,}', '', l).strip()
        out = l.split()
        return Symbol(out[0], out[1])
    except:
        pass

def is_valid(l):
    try:
        l = l.strip()
        if l == '':
            return False;
        if re.match(r'^.*\:$', l):
            return False
        return True
    except:
        return False

def load_symbols(files):
    out = set()
    for fn in files:
        with open(fn, 'r') as f:
            syms = [parse_line(l) for l in f.readlines() if is_valid(l)]
            out.update(syms)
    return list(out)

def main(argv = sys.argv[1:]):
    parser = argparse.ArgumentParser()
    parser.add_argument('--json', required = True)
    parser.add_argument('--target', required = True)
    parser.add_argument('--outfile', required = True)
    args = parser.parse_args(argv)

    data = json.loads(args.json)

    symbols = {k: load_symbols(v) for k,v in data.items()}
    target = symbols.pop(args.target)
    out = {'target': target, 'symbols':symbols}

    with open(args.outfile, 'w') as f:
        f.write(json.dumps(out, indent = 2, cls = SimpleEncoder))

if __name__ == '__main__':
    main()
