import  time
import pickle
import os

def cunqian(filename,now,rresult):
    try:
        cunru = float(input('请输入存入的金额:'))
        beizhu = input("请输入备注:").strip()
        yue = rresult[-1][-2] + cunru
        shuju = [now, 0, cunru, yue, beizhu]
        with open(filename,'rb') as f:
            result = pickle.load(f)
        result.append(shuju)
        with open(filename,'wb') as f2:
            pickle.dump(result,f2)
    except  (ValueError) as e:
        print("\033[31;0m请输入数字金额\033[0m")
        cunqian(filename,now,rresult)

def quqian(filename,now,rresult):
    try:
        while 1:
            quchu = float(input('请输入取出的金额:'))
            beizhu = input("请输入备注:")
            yue = rresult[-1][-2]-quchu
            if yue >= 0:
                break
            else:
                print("对不起，余额不足，您卡里可取余额为%s元" % rresult[-1][-2])
        shuju = [now, quchu, 0, yue, beizhu]
        with open(filename,'rb') as f:
            result = pickle.load(f)
        result.append(shuju)
        with open(filename,'wb') as f2:
            pickle.dump(result,f2)
    except (ValueError) as e:
        print('\033[31;0m请输入数字金额\033[0m')
        quqian(filename,now,rresult)

def select(*args):
    print('\033[32;0m["%s"\t\t %s\t\t    %s\t\t%s    \t%s]\033[0m' % (now,"取出","存入","余额","备注"))
    with open(args[0],'rb') as f:
        result = pickle.load(f)
        for i in result:
            print(f"  \033[32;0m{i[0]}  ","%10.2f\t  %10.2f  %10.2f\t   " % (i[1],i[2],i[3]),f"{i[-1]}\033[0m")

    print(f"您剩余%.2f元" % result[-1][-2])

def show_mean(filename=r'D:\a.txt'):

    show = """(0)退出
(1)存钱
(2)取钱
(3)查询
请输入对应数字进行操作："""
    global shuju1,now
    cmds = {1:cunqian,2:quqian,3:select}
    try:
        while 1:
            get_show = int(input(show).strip())
            if get_show not in [0,1,2,3]:
                print("\033[31;0m错误，请输入数字0/1/2/3进行操作\033[0m")
                continue
            if get_show == 0:
                print("\033[32;0mBye-bye\033[0m")
                break
            now = time.strftime("%Y-%m-%d %H:%M:%S")
            shuju1 = [[now, 0, 0, 0, "初始"]]
            if not os.path.exists(filename):
                with open(filename,'wb') as f:
                    pickle.dump(shuju1,f)
            with open(filename,'rb') as f1:
                rresult = pickle.load(f1)
            cmds[get_show](filename,now,rresult)

    except (EOFError,) as e:
        print("\033[32;0mbyebye\033[0m")
    except (ValueError) as e2:
        print("\033[31;0m输入错误，请输入编号里的数字进行选择\033[0m")
        show_mean()

if __name__ == '__main__':

    show_mean()
    
























