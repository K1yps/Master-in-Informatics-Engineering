import threading
from concurrent.futures import ThreadPoolExecutor, Executor


class CCTimer:
    """
    Implements a simple Cyclic Timer functionality
    """

    def __init__(self, task=None, time: float = None, executor: Executor = None):
        # Public
        self.task = task
        self.time = time
        # Private
        self.__cond = threading.Condition()
        self.__active = False
        self.__executor = executor or ThreadPoolExecutor(1, thread_name_prefix='Heartbeat_')

    def setter(self, **kwargs):
        """ A setter for all the timer's arguments\n
            Can be used to update a running timer"""
        if 'task' in kwargs:
            self.task = kwargs['task']
        if 'time' in kwargs:
            self.time = kwargs['time']

    def run(self):
        """Overrides the current thread with the cyclic timer for the specified task"""
        self.__cond.acquire()
        try:
            self.__active = True
            while self.__active:
                if not self.__cond.wait(self.time):
                    self.task()
        finally:
            self.__cond.release()

    def start(self, wait=True):
        """Attempts to start the timer for the specified task"""
        self.__cond.acquire()
        try:
            if self.__active:
                if wait:
                    self.__cond.wait()
                else:
                    return False
            self.__active = True
            self.__executor.submit(self.run)
            return True
        finally:
            self.__cond.release()

    def stop(self):
        """Stops the timer"""
        self.__cond.acquire()
        try:
            self.__active = False
        finally:
            self.__cond.notify_all()
            self.__cond.release()

    def reset(self, **kwargs):
        """Stops the timer, changes the given parameters if they are present and starts the timer again"""
        self.stop()
        self.setter(**kwargs)
        self.start()
