# ！/usr/bin/env python
# -*-coding:Utf-8 -*-
# Time: 17 Oct 2024 11:22
# Name: edit.py
# Author: CHAU SHING SHING HAMISH

import pywikibot
import re

raw_txt = './reports/report1.txt'
page_text = '* 生成時間：~~~~~\n'

bad_pattern = re.compile(r'\{\{(受限[制製]文件|[Bb]ad\s?image|[Rr]estricted use)\}\}')
site = pywikibot.Site('zh', 'wikipedia')

with open(raw_txt, 'r') as infile:
    for line in infile:
        line = line.strip()
        print(line, end='\t')
        page_text += f'# [[:File:{line}]]'
        if bad_pattern.search(pywikibot.Page(site, 'File:'+line).text):
            page_text += '（受限制文件）'
            print('R')
        page_text += '\n'
        print()


report_page = pywikibot.Page(site, 'Wikipedia:資料庫報告/檔案描述頁')

report_page.text = page_text
report_page.save('[[Wikipedia:机器人/申请/Hamish-bot/8|T8]]：生成本地存在檔案描述的維基共享資源文件列表')
