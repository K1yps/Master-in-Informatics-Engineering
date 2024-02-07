#!/usr/bin/env python3

from ms import *

logging.getLogger().setLevel(logging.DEBUG)

# Node and peer info
node_id = None  # The node id
node_ids = {}  # The peer's node ids

# Node Data
messages = set()
inbound = {}
top = {}


def nop(msg):
    logging.debug(f"Ignoring {msg}")


def init(msg):
    global node_id, node_ids
    node_id = msg.body.node_id  # Nodo atual
    node_ids = msg.body.node_ids  # Todos os nodos ativos
    logging.info(f'Node {node_id} initialized {node_ids}')
    reply(msg, type='init_ok')


def topology(msg):
    global top, node_id
    reply(msg, type='topology_ok')


def broadcast(msg):
    msg.add(msg.body.message)
    pass
    reply(msg, type='broadcast_ok')


def message(msg):
    if msg.body.message not in messages:
        propogate(msg.body, inbound.pop(msg.body.message, msg.body.ttl + 1))


def read(msg):
    global messages
    reply(msg, type='read_ok', messages=messages)


def do_i_want(msg):
    pass


# Basic structure, will change based on Leader/Follower/Candidate status
handlers = {
    'init': init,
    'topology': topology,
    'broadcast': broadcast,
    'read': read,
    'message': message,
}

if __name__ == '__main__':
    for msg in receiveAll():
        try:
            handlers[msg.body.type](msg)
        except (KeyError, AttributeError):
            logging.error(f"Invalid message or missing handler: {msg}")
