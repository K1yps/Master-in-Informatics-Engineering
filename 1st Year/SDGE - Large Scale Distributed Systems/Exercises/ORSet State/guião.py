#!/usr/bin/env python


from threading import Thread

from ms import *

logging.getLogger().setLevel(logging.DEBUG)

node_id = None
node_ids = []
state = {}


def nop(msg):
    logging.debug(f"Ignoring {msg}")


def handle_init(msg):
    global node_id, node_ids
    node_id = msg.body.node_id
    node_ids = msg.body.node_ids
    logging.info(f'Node {node_id} initialized {node_ids}')
    reply(msg, type='init_ok')


def handle_read(msg):
    pass


def handle_write(msg):
    pass


def beacon():
    pass


handlers = {
    'init': handle_init,
    'read': nop,
    'remove': nop,
    'elements': nop,
    'join': nop,
}


def run():
    for msg in receiveAll():
        try:
            handlers[msg.body.type](msg)
        except (AttributeError, KeyError, TypeError):
            logging.error(f"Invalid message {msg}")


if __name__ == '__main__':
    (th := Thread(target=beacon, name="Beacon")).start()
    run()
