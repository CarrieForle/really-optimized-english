from sys import exit

top = (6, 7)
topmid = (5, 8)
belowmid = (5, 6)
below = (5, 5)

la = (top, topmid, belowmid, below)

print('Use ANSI for best accuracy')

with open("google-10000-english.txt", 'r') as f:
    words = ''.join(_ for _ in f.read() if _ != '\n')
    
with open("layout.txt", 'r') as f:
    layout = f.read().split('\n')

if (len(layout) != 4 or 
    len(layout[0]) != top[0] + top[1] or 
    len(layout[1]) != topmid[0] + topmid[1] or 
    len(layout[2]) != belowmid[0] + belowmid[1] or 
    len(layout[3]) != below[0] + below[1]):
    input('Invalid layout')
    exit()

l = 0
r = 0

for i in range(len(layout)):
    for j in range(len(layout[i])):
        print(layout[i][j], end=' ')
    print()

for letter in words:
    for i in range(len(layout) - 1, -1, -1):
        for j in range(len(layout[i])):
            if letter == layout[i][j]:
                m = j
                n = i
                break
            
    if m < la[n][0]:
        l += 1
    else:
        r += 1
input(f'{l} | {r} | {abs(l - r)}')