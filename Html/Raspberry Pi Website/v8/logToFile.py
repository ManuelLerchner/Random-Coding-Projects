import logging


logging.basicConfig(filename="logs.txt",
                    filemode='a',
                    format='%(asctime)s    %(name)s %(levelname)s     %(message)s',
                    datefmt=r'%Y-%m-%d  %H:%M:%S',
                    level=logging.DEBUG)


def log(text):
    logging.info(text)
