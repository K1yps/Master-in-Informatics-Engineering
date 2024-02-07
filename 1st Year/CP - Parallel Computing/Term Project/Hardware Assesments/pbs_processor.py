import re

import sys

with open(sys.argv[1], "r") as file:
    text = file.read()
    text = re.sub(r'\s*(properties|ntype|status|note).*', '', text)
    text = re.sub(r'( |\t)', '', text)
    text = re.sub(r'\n(np|state)=', ' ', text)    
    text = re.sub(r'\n\n', '\n', text)

    fds = {}

    for (node, state, num) in re.findall(r' *([A-Za-z\-0-9]+) ([A-Za-z\-0-9]+) (\d*).*', text):
        num = int(num)
        if num in fds:
            fds[num].append((node,state))
        else:
            fds[num] = [(node,state)]

    for num in sorted(fds):
        print(num)
        for node, state in fds[num]:
            print('\t', node.ljust(19),' ', state)
