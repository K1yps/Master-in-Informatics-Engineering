#!/usr/bin/env python

from asyncore import read
import logging
from json import dumps, loads
from sys import stdin
from xml.sax import handler

logging.getLogger().setLevel(logging.DEBUG)


class Node_old:
    msg_id = 0
    node_id = None
    node_ids = {}

    def __init__(self, getter, setter, ) -> None:
        self.get = getter
        self.set = setter

    def __next_msg_id(self):
        self.msg_id += 1
        return self.msg_id - 1

    def __reply(self, msg, type, **body):
        body['msg_id'] = self.__next_msg_id()
        body['in_reply_to'] = msg['body']['msg_id']
        body['type'] = type
        return {'src': msg['dest'], 'dest': msg['src'], 'body': body}

    @staticmethod
    def __error(msg, code, text=''):
        return {'src': msg['dest'], 'dest': msg['src'],
                'body': {'type': 'error', 'in_reply_to': msg['body']['msg_id'], 'code': code, 'text': text}}

    def init(self, node_id, node_ids):
        self.node_id = node_id
        self.node_ids = node_ids

    def handle(self, msg):
        r = None
        body = msg['body']
        tp = body['type']

        if tp == 'init':
            self.init(body['node_id'], body['node_ids'])
            logging.info(f"Node_old {self.node_id} initialized")
            r = self.__reply(msg, 'init_ok')

        elif tp == 'read':
            r = self.__reply(msg, 'read_ok', value=self.get(body['key']))

        elif tp == 'write':
            self.set(body['key'], body['value'])
            r = self.__reply(msg, 'write_ok')

        elif tp == 'cas':
            current = self.get(body['key'])
            if current is None:
                r = self.__error(msg, 20, f"Key {body['key']} is not registered")
            elif current != body['from']:
                r = self.__error(msg, 22, f"Key {body['key']} contains value {current} insted of {body['from']}")
            else:
                self.set(body['key'], body['to'])
                r = self.__reply(msg, 'cas_ok')

        elif tp == 'MyMsg':
            logging.info(f"Custom message from {msg['src']}")
        else:
            logging.warning(f"Unkown Message : {msg['type'].strip()}")
        return r


def receive_all():
    while data := stdin.readline():
        logging.debug("Received %s", data.strip())
        yield loads(data)


def send(msg):
    data = dumps(msg)
    logging.debug(f"Sending {data}")
    print(data, flush=True)


if __name__ == '__main__':
    a = {}
    n = Node_old
(a.get, lambda x, y: a.update({x: y}))

    for msg in receive_all():
        res = n.handle(msg)
        logging.debug(a)
        if res is not None:
            send(res)

class Node:

    def __init__(self):
        data = {}
        node_id = None
        node_ids = {}

    def __reply(self, msg, type, **body):
        body['msg_id'] = self.__next_msg_id()
        body['in_reply_to'] = msg['body']['msg_id']
        body['type'] = type
        return {'src': msg['dest'], 'dest': msg['src'], 'body': body}


    def handle(self,msg):
        r = None
        body = msg['body']
        tp = body['type']

        if tp == 'init':
            self.node_id = body['node_id']
            self.node_ids = body['node_ids']
            logging.info(f"Node {self.node_id} initialized")
            r = self.__reply(msg, 'init_ok')

        elif tp == 'read':
            r = self.__reply(msg, 'read_ok', value=self.get(body['key']))

        elif tp == 'write':
            self.set(body['key'], body['value'])
            r = self.__reply(msg, 'write_ok')

        elif tp == 'cas':
            current = self.get(body['key'])
            if current is None:
                r = self.__error(msg, 20, f"Key {body['key']} is not registered")
            elif current != body['from']:
                r = self.__error(msg, 22, f"Key {body['key']} contains value {current} insted of {body['from']}")
            else:
                self.set(body['key'], body['to'])
                r = self.__reply(msg, 'cas_ok')

        elif tp == 'MyMsg':
            logging.info(f"Custom message from {msg['src']}")
        else:
            logging.warning(f"Unkown Message : {msg['type'].strip()}")
        return r


