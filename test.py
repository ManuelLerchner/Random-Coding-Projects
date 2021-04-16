def kaboom(i, iter):
    print(i, iter)

    if i < 3:
        kaboom(i+1, iter+1)
    print(i, iter)


kaboom(1, 1)
