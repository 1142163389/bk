import  os
import sys

def get_fname1(fname1):
    set_fname1 = set()
    with open(fname1, 'r') as f1:
        for i in f1:
            set_fname1.add(i)
    return set_fname1

def get_fname2(fname2):
    set_fname2 = set()
    with open(fname2, 'r') as f2:
        for i in f2:
            set_fname2.add(i)
    return set_fname2

def wfname(fname):
    wresult1 = get_fname1(fname1)
    wresult2 = get_fname2(fname2)
    result = (wresult2 - wresult1)
    with open(fname,'w') as f:
        f.writelines(result)
    print("比对完成，请到%s去查看" % fname)
    exit()

if __name__ == '__main__':
    fname1 = sys.argv[1]
    fname2 = sys.argv[2]
    while True:
        if not os.path.exists(fname1) or  not os.path.exists(fname2):
            print("\033[31;0m%s或者%s不存在\033[0m" % (fname1,fname2))
            exit()
        else:
            break

    result_log = sys.argv[3]
    while True:
        if os.path.exists(result_log):
            print("\033[31;0m该文件已经存在\033[0m")
            exit()
        wfname(result_log)

###运行python + 多出的日志的文件路径 + 少的日志名字 + 存入文件名字（若文件较大，需要等待，请勿结束进程）

