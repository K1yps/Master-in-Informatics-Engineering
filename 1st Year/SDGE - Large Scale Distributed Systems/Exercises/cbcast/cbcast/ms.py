# Minimal support for Maelstrom node programs

import logging
from json import loads, dumps
from sys import stdin
from types import SimpleNamespace as sn

msg_id = 0  # The id of the last msg taht was sent

# Publishes a message labeling its origin as 'src', it's destination as 'dest' and it's body as 'body'
def send(src, dest, **body):
    global msg_id
    data = dumps(sn(dest=dest, src=src, body=sn(msg_id=(msg_id := msg_id + 1), **body)), default=vars)
    logging.debug("sending %s", data)
    print(data, flush=True)

def sendToMultiple(src, nodes, **body):
    for node in nodes:
        send(src, node, **body)


# Sends a reply with a general reply body
def reply(request, **body):
    send(request.dest, request.src, in_reply_to=request.body.msg_id, **body)


# Iterates over all incoming messages, as soon as tey are available
def receiveAll():
    while data := stdin.readline():
        logging.debug("received %s", data.strip())
        yield loads(data, object_hook=lambda x: sn(**x))

def receive():
    data = stdin.readline()
    if data is not None:
        logging.debug("received %s", data.strip())
        return loads(data, object_hook=lambda x: sn(**x))
    return data

