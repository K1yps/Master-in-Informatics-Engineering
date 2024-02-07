#!/usr/bin/env python

import logging
from ms import *

logging.getLogger().setLevel(logging.DEBUG)

node_id = None
node_ids = set()

vv = {}
clocks = {}
msgs = []

def broadcast(**body):
  sendToMultiple(node_id,node_ids,**body)

def handle_init(msg):
  global node_id, node_ids, vv
  node_id = msg.body.node_id
  node_ids = msg.body.node_ids
  vv = {n:0 for n in node_ids}
  logging.info(f'Node {node_id} initialized {node_ids}')
  reply(msg, type='init_ok')


def handle_cbcast(msg):
  vv[node_id] += 1
  reply(msg, type= "cbcast_ok", messages =  msgs)
  msgs.clear()
  broadcast(type = "fwd_msg", vv = vv, message = msg.body.message)

def handle_fwd_msg(msg):
  msgs.append(msg.body.message)


def handle(msg):
    handlers = {
      'init' : handle_init,
      'cbcast': handle_cbcast,
      'fwd_msg': handle_fwd_msg,
    }
    handlers[msg.body.type](msg)

if __name__ == '__main__':
  for msg in receiveAll():
    if msg:
      handle(msg)