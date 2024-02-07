#!/usr/bin/env python

import logging
from queue import Queue, Empty
from random import sample

from ms import receiveAll, reply, send

logging.getLogger().setLevel(logging.DEBUG)

node_id = None
node_ids = {}

dicionario = {}  # key -> (value, timestamp)
requests = Queue()  # Armazena pedidos de clientes

# VARIÁVEIS PARA TRATAR 1 PEDIDO DE CADA VEZ
current = None  # Guarda o pedido atual

remaining = 0  # Indica o numero de respostas que faltam receber
awnser = None  # Resposta atual, ainda por validar


# Gerar um quorum aleatorio sem repeticoes
def quorum_r():
    return sample(node_ids, len(node_ids) // 2 + 1)

def quorum_w():
    return sample(node_ids, len(node_ids) // 2)

def update_current():
    global current, requests, awnser
    try:
        current = requests.get_nowait()
    except Empty:
        current = None
    awnser = None


def start_request(msg):
    global current
    current = msg
    quorum_r = quorum()  # Todos eles exigem leituras
    if msg.body.type == 'read':
        for node in quorum_r:
            send(node_id, node, type='quorum_r', key=current.body.key)
    elif msg.body.type == 'write':

        pass
    elif msg.body.type == 'cas':
        pass


def read(quorum, key):
    global node_id, remaining
    remaining = len(quorum)
    for node in quorum:
        send(node_id, node, type="quorum_r", key=key)


class Node:
    current = None
    

    def run(self):
        for msg in receiveAll:

            try:
                current = current or requests.get_nowait()
            except Empty:



            if msg.body.type in ['read', 'write', 'cas']:
                current = current or requests.put(msg)
            elif msg.body.type in 'init':
                

def run():
    for msg in receiveAll():
        
        # Queue Managment

        if msg.body.type in ['read', 'write', 'cas']:
            if current:
                requests.put(msg)
            else:
                current = msg

        # Message Processing
        if msg.body.type == 'init':  # Init message - Inicializa o servidor
            node_id = msg.body.node_id  # Nodo atual
            node_ids = msg.body.node_ids  # Todos os nodos ativos
            logging.info('node %s initialized', node_id)

            reply(msg, type='init_ok')


        elif msg.body.type == 'quorum_r':  # Mensagem quorum de leitura
            key = msg.body.key
            try:
                value, timestamp = dicionario.get(key)
                reply(msg, type='quorum_r_ok', key=key, value=value, timestamp=timestamp)
            except KeyError:
                reply(msg, type='r_error', text=f"Key {key} is invalid.")

        elif msg.body.type == 'quorum_w':  # Mensagem quorum de escrita
            key = msg.body.key
            try:
                value, current_timestamp = dicionario[key]
                if msg.body.timestamp > current_timestamp:
                    dicionario[key] = (msg.body.value, msg.body.timestamp)

            except KeyError:
                dicionario[key] = (msg.body.value, msg.body.timestamp)

        if msg.body.type == 'quorum_r_ok':

            if awnser is None or awnser[1] < msg.body.timestamp:
                awnser = (msg.body.value, msg.body.timestamp)

            remaining -= 0
            if remaining <= 0:
                reply(current, type='read_ok', value=awnser[0])
                update_current()



        else:
            logging.warning('unknown message type %s', msg['body']['type'])


if __name__ == '__main__':
    run()
