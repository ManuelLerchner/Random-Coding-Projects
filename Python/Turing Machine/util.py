from colorama.ansi import Fore
from colorama import Style


def formatColor(str, color):
    return f"{color}{str}{Style.RESET_ALL}"
