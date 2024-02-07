#!/usr/bin/env python3
import math
import random

from ms import *

logging.getLogger().setLevel(logging.DEBUG)

# Node and peer info
node_id = None  # The node id
node_ids = {}  # The peer's node ids

# Node Data
messages = set()
inbound = {}
top = []
F = 0
C = 0
K = 0


def nop(msg):
    logging.debug(f"Ignoring {msg}")


def set_F():
    global F
    F = math.ceil(math.log(len(node_ids))) + C


def propogate(message, ttl=0):
    global node_id, messages, node_ids, F, C
    sendToNodes(node_id, random.sample(node_ids, F), type='message', message=message, ttl=ttl + 1)


def reply_to(msg):
    global node_id
    send(node_id, msg.src, type='message', message=msg.message, ttl=0xfffffff0)


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
    msg.add(msg.body.message)
    propogate(msg.body.message)
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
    'have': do_i_want,
    'want': reply_to
}

if __name__ == '__main__':
    for msg in receiveAll():
        try:
            handlers[msg.body.type](msg)
        except (KeyError, AttributeError):
            logging.error(f"Invalid message or missing handler: {msg}")
