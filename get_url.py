import urllib.request, urllib.error
from bs4 import BeautifulSoup
import re
import xlwt

def main(first_url, path):  # 主要执行框架内容的函数
    global findaddr, findname, findjj, findyy, findpj, findimg, findpf
    findaddr = re.compile(r'<a href="(.*?)">')  # 链接地址
    findname = re.compile(r'<span class="title">(.*)</span>')  # 名字
    findjj = re.compile(r'<span class="inq">(.*)</span>')  # 简介
    findyy = re.compile(r'<p class="">(.*?)</p>', re.S)  # 演员
    findpj = re.compile(r'<span>(\d+)人评价</span>')  # 评价
    findimg = re.compile(r'<img alt="(.*?)" class="" src="(.*?)" width="100"/>', re.S)  # t图片地址
    findpf = re.compile(r'<span class="rating_num" property="v:average">(.*)</span>')  # 评分

    data = get_html(first_url)
    save_data(path, data)

def get_html(first_url):  # 传入真实地址，获取到网页内容进行解析，得到一个返回值
    global findaddr, findname, findjj, findyy, findpj, findimg, findpf
    data = []
    for i in range(10):
        url = first_url + str(i * 25)
        html = BeautifulSoup(get_url(url), "html.parser")
        for j in html.find_all("div", class_="item"):
            mv_data = []
            j = str(j)

            addr = re.findall(findaddr, j)[0]
            mv_data.append(addr)

            name = re.findall(findname, j)
            if len(name) == 1:
                cname = name
                mv_data.append(cname)
                mv_data.append("")
            elif 1 < len(name) <= 2:
                cname = name[0]
                fname = name[1]
                mv_data.append(cname)
                mv_data.append(fname)
            else:
                print("数据分析有误，请重新整理逻辑编写代码")
                exit()

            jj = re.findall(findjj, j)
            if len(jj) != 0:
                jj = jj[0].replace("。", "")
                mv_data.append(jj)
            else:
                mv_data.append("")

            yy = re.findall(findyy, j)[0].strip()
            yy = re.sub("/", "", yy)
            yy = re.sub("(.*)<br>(.*)", "", yy).strip()
            mv_data.append(yy)

            pj = re.findall(findpj, j)[0]
            mv_data.append(pj)

            img = (re.findall(findimg, j))[0][1]
            mv_data.append(img)

            pf = re.findall(findpf, j)[0]
            mv_data.append(pf)

            data.append(mv_data)
    return data

def get_url(url):  # 打开网页获取到所有内容
    try:
        headers = {
            "User-Agent": "Mozilla / 5.0(Windows NT 10.0;WOW64) AppleWebKit / 537.36(KHTML, likeGecko) Chrome / 63.0.3239.132 Safari / 537.36"
        }
        req = urllib.request.Request(url=url, headers=headers)
        request = urllib.request.urlopen(req).read().decode()
        return request
    except urllib.error.URLError as e:
        if hasattr(e, "code"):
            print(e.code)
        if hasattr(e, "reason"):
            print(e.reason)
        exit()

def save_data(savepath, data):  # 将分析好的数据保存到excel
    excel_obj = xlwt.Workbook("utf-8")
    savedata = excel_obj.add_sheet("豆瓣电影top250", cell_overwrite_ok=True)
    colm = ("电影链接", "电影名字", "英文名字", "注释", "类型", "评分人数", "图片地址", "评分")

    for i in range(len(data)):
        print("已经保存了{num}条数据".format(num=i + 1))
        for j in range(len(colm)):
            savedata.write(0, j, colm[j])
            savedata.write(i + 1, j, data[i][j])
    excel_obj.save(savepath)

if __name__ == '__main__':
    first_url = "https://movie.douban.com/top250?start="
    path = r"D:/mv.xls"
    main(first_url, path)
    print(f"数据已成功保存到\033[32;0m{path}\033[0m")
