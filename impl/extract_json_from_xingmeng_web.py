#!/usr/bin/python3
import sys
fname = sys.argv[1]

with open(fname) as f:
    cont = f.read()

def parse_val(line):
    rev = line[::-1]
    pos1 = rev.index('"')
    pos2 = rev.index('"', pos1+1)
    res = rev[pos1+1 : pos2]
    return res[::-1]

mark_pswd = '"password": "'
mark_obfs = '"obfs_param": "'
mark_prot = '"protocol_param": "'

for line in cont.split('\n'):
    if mark_pswd in line:
        pswd = parse_val(line)
    elif mark_obfs in line:
        obfs = parse_val(line)
    elif mark_prot in line:
        prot = parse_val(line)

print('SSR_ARGS:', pswd, obfs, prot)



# json_begin = '<pre style="color:#e83e8c">{'
# json_end = '}'
# 
# result = ''
# in_json = False
# for line in cont.split('\n'):
#     if json_begin in line:
#         in_json = True
#         result += '{' + '\n'
#     if json_end in line:
#         in_json = False
#         result += '}' + '\n'
#         break
#     if in_json:
#         result += line + '\n'





