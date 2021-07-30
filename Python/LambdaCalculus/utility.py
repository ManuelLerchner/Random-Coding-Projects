from colorama import Style
import time


def printColor(str, color, *args, **kwargs):
    print(f"{color}{str}{Style.RESET_ALL}", *args, **kwargs)


def timeIt(func):
    def wrap(*args, **kwargs):
        tstart = time.time()
        res = func(*args, **kwargs)
        tend = time.time()
        print(f"Took {tend-tstart} s")
        return res

    return wrap
