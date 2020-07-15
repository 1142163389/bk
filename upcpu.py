#!/usr/bin/env python3
while 1:
   try:
        username = input("please input ur name:")
        password = int(input("please input ur password:"))
        if not (username == "liuyu" and password == 123):
            print("\033[31;0muser or password is error,try again\033[0m")
            continue
        else:
            print("welcome")
            break
   except ValueError:
            print("\033[31;0mpassword must be int\033[0m")
            pass
   except (KeyboardInterrupt,EOFError):
            print("\n\033[32;0mbye-bye\033[0m")
            exit()
while 1:
    try:
        print("hello")
    except (IndentationError,KeyboardInterrupt,EOFError) as er:
        say = input("do u want exit?")
        if say == 'yes':
            break 
