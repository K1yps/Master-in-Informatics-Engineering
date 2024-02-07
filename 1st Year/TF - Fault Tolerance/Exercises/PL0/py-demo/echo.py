#!/usr/bin/env python

# Simple 'echo' workload in Python for Maelstrom

import logging

from ms import send, receive

logging.getLogger().setLevel(logging.DEBUG)

while True:
    msg = receive()
    if not msg:
        break

    if msg['body']['type'] == 'init':
        next_id = 1
        node_id = msg['body']['node_id']
        node_ids = msg['body']['node_ids']
        logging.info('node %s initialized', node_id)

        send({
            'dest': msg['src'],
            'src': node_id,
            'body': {
                'type': 'init_ok',
                'msg_id': next_id,
                'in_reply_to': msg['body']['msg_id']
            }
        })
        next_id += 1
    elif msg['body']['type'] == 'echo':
        logging.info('echoing %s', msg['body']['echo'])

        send({
            'dest': msg['src'],
            'src': node_id,
            'body': {
                'type': 'echo_ok',
                'msg_id': next_id,
                'in_reply_to': msg['body']['msg_id'],
                'echo': msg['body']['echo']
            }
        })
        next_id += 1
    else:
        logging.warning('unknown message type %s', msg['type'])
