def functionA():
    print("a1")
    from test import functionB
    print("a2")
    functionB()
    print("a3")

def functionB():
    print("b")

print("t1")
# if __name__ == "__main__":
print("m1")
functionA()
print("m2")
print("t2")