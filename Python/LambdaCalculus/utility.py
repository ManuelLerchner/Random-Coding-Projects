from colorama import Style


def printColor(str, color, *args, **kwargs):
    print(f"{color}{str}{Style.RESET_ALL}", *args, **kwargs)
