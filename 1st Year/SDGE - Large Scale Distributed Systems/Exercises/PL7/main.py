#!/usr/bin/env python3
import math
import random

from ms import *

logging.getLogger().setLevel(logging.DEBUG)

# Node and peer info
node_id = None  # The node id
node_ids = {}  # The peer's node ids

# Node Data
messages = {}
top = []
F = 0
C = 0


def nop(msg):
    logging.debug(f"Ignoring {msg}")


def set_F():
    global F
    F = math.ceil(math.log(len(node_ids)))


def propogate(message):
    global node_id, messages, node_ids, F, C
    if messages in messages:
        messages[message] += 1
    else:
        messages[message] = 1
    sendToNodes(node_id, random.sample(node_ids, F + C), type='message', message=message)


def init(msg):
    global node_id, node_ids
    node_id = msg.body.node_id  # Nodo atual
    node_ids = msg.body.node_ids  # Todos os nodos ativos
    logging.info(f'Node {node_id} initialized {node_ids}')
    set_F()
    reply(msg, type='init_ok')


def topology(msg):
    global top, node_id
    reply(msg, type='topology_ok')


def broadcast(msg):
    propogate(msg.body.message)
    reply(msg, type='broadcast_ok')


def message(msg):
    if msg.body.message not in messages:
        propogate(msg.body.message)


def read(msg):
    global messages
    reply(msg, type='read_ok', messages=messages)


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
