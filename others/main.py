with open("google-10000-english.txt", 'r') as f:
    rawWords = f.read()

words = tuple(rawWords.split('\n'))
letterCount = len(rawWords) - len(words) + 1
print(f"{len(words)} words have loaded, accounting for {letterCount} letters.\n")
letters = {}
lettersByWords = {}
twoLetters = {}
twoLettersByWords = {}
CtwoLetters = {}
CtwoLettersByWords = {}
isTwoLettersIntialized = False

for word in words:
    appeared = set()
    for letter in word:
        if not letter in letters:
            letters[letter] = 1
        else:
            letters[letter] += 1
        
        if not letter in appeared:
            if not letter in lettersByWords:
                lettersByWords[letter] = 1
            else:
                lettersByWords[letter] += 1
            appeared.add(letter)

for word in words:
    if len(word) == 1:
        continue
    appeared = set()
    Cappeared = set()
    for i in range(len(word) - 1):
        twoL = word[i:i + 2]
        if not twoL in twoLetters:
            twoLetters[twoL] = 1
        else:
            twoLetters[twoL] += 1
        CtwoL = ''.join(sorted(twoL))
        if not CtwoL in CtwoLetters:
            CtwoLetters[CtwoL] = 1
        else:
            CtwoLetters[CtwoL] += 1
            
        if not twoL in appeared:
            if not twoL in twoLettersByWords:
                twoLettersByWords[twoL] = 1
            else:
                twoLettersByWords[twoL] += 1
            appeared.add(twoL)
        if not CtwoL in Cappeared:
            if not CtwoL in CtwoLettersByWords:
                CtwoLettersByWords[CtwoL] = 1
            else:
                CtwoLettersByWords[CtwoL] += 1
            Cappeared.add(CtwoL)

def f(a, b):
    rate = len(b) / letterCount;
    print(f"{a}: {len(b):04} | {rate * 100:07.4f}%")
    return len(b), rate

while True:
    inp = input("> ");
    if inp == '!leave':
        break
    elif inp == '!':
        # for word in words:
            # for letter in word:
                # if not letter in letters:
                    # letters[letter] = 1
                # else:
                    # letters[letter] += 1
        for letter, val in sorted(letters.items(), key=lambda e: e[1], reverse=True):
            print(f"{letter}: {val:04} | {val / letterCount * 100:07.4f}% | {lettersByWords[letter]:04} | {lettersByWords[letter] / len(words) * 100:07.4f}%")
    elif inp.startswith('!!'):
        # if not isTwoLettersIntialized:
            # for word in words:
                # if len(word) == 1:
                    # continue
                # for i in range(len(word) - 1):
                    # twoL = word[i:i + 2]
                    # if not twoL in twoLetters:
                        # twoLetters[twoL] = 1
                    # else:
                        # twoLetters[twoL] += 1
            # isTwoLettersIntialized = True
        try:
            num = min(int(inp[2:]), len(twoLetters))
        except:
            num = 10 if inp[2:] != 'a' else len(twoLetters)
        for i, (key, val) in enumerate(sorted(twoLetters.items(), key=lambda e: e[1], reverse=True)):
            if i >= num:
                break
            print(f"{key}: {val:04} | {val / (letterCount - len(words)) * 100:07.4f}% | {twoLettersByWords[key]:04} | {twoLettersByWords[key] / len(words) * 100:07.4f}%")
    elif inp.startswith('~~'):
        try:
            num = min(int(inp[2:]), len(CtwoLetters))
        except:
            num = 10 if inp[2:] != 'a' else len(CtwoLetters)
        for i, (key, val) in enumerate(sorted(CtwoLetters.items(), key=lambda e: e[1], reverse=True)):
            if i >= num:
                break
            print(f"{key}: {val:04} | {val / (letterCount - len(words)) * 100:07.4f}% | {CtwoLettersByWords[key]:04} | {CtwoLettersByWords[key] / len(words) * 100:07.4f}%")
    elif inp.startswith('~') and len(inp) == 2:
        inp = inp[1]
        print(f" {inp}: {letters[inp]:04} | {letters[inp] / letterCount * 100:07.4f}% | {lettersByWords[inp]:04} | {lettersByWords[inp] / len(words) * 100:07.4f}%")
        for key, val in sorted(dict((k, v) for k, v, in CtwoLetters.items() if inp in k).items(), key=lambda e: e[1], reverse=True):
            print(f"{key}: {val:04} | {val / (letterCount - len(words)) * 100:07.4f}% | {CtwoLettersByWords[key]:04} | {CtwoLettersByWords[key] / len(words) * 100:07.4f}%")
    elif len(inp) >= 3 and inp.isalpha():
        s = sum(letters[_] for _ in inp)
        print(f'{s} | {s / letterCount * 100:.4f}%')
    elif len(inp) == 2 and inp.isalpha():
        reversedInp = inp[::-1]
        # if not isTwoLettersIntialized:
            # a = f(inp, tuple(_ for _ in words if inp in _))
            # b = f(reversedInp, tuple(_ for _ in words if reversedInp in _))
            # print(f"    {a[0] + b[0]:04} | {(a[1] + b[1]) * 100:.4f}%")
        # else:
        a = twoLetters.get(inp, 0)
        b = twoLetters.get(inp, 0) / (letterCount - len(words))
        c = twoLetters.get(reversedInp, 0)
        d = twoLetters.get(reversedInp, 0) / (letterCount - len(words))
        e = twoLettersByWords.get(inp, 0)
        f = twoLettersByWords.get(inp, 0) / len(words)
        g = twoLettersByWords.get(reversedInp, 0)
        h = twoLettersByWords.get(reversedInp, 0) / len(words)
        i = letters[inp[0]] + letters[inp[1]]
        j = (letters[inp[0]] + letters[inp[1]]) / letterCount
        print(f"{inp}: {a:04} | {b * 100:07.4f}% | {e:04} | {f * 100:07.4f}%")
        print(f"{reversedInp}: {c:04} | {d * 100:07.4f}% | {g:04} | {h * 100:07.4f}%")
        print(f"    {a + c:04} | {(b + d) * 100:07.4f}% | {e + g:04} | {(f + h) * 100:07.4f}%")
        print(f"   {i:5} | {j * 100:07.4f}%")
    elif len(inp) == 1 and inp.isalpha():
        # wordWithInp = tuple(_ for _ in words if inp in _)
        # if not inp in letters:
            # letters[inp] = 0
            # for word in words:
                # for letter in word:
                    # if letter == inp:
                        # letters[inp] += 1
        # if not isTwoLettersIntialized:
            # d = {}
            # for word in wordWithInp:
                # if len(word) == 1:
                    # continue
                # wordLoc = word.index(inp)
                # if wordLoc > 0:
                    # a = word[wordLoc - 1:wordLoc+1]
                    # if not a in d:
                        # d[a] = 1
                    # else:
                        # d[a] += 1
                # if wordLoc < len(word) - 1:
                    # b = word[wordLoc:wordLoc + 2]
                    # if not b in d:
                        # d[b] = 1
                    # else:
                        # d[b] += 1
            # print(f" {inp}: {letters[inp]:04} | {letters[inp] / letterCount * 100:.4f}%")
            # for key, val in sorted(d.items(), key=lambda e: e[1], reverse=True):
                # print(f"{key}: {val:04} | {val / letterCount * 100:.4f}%")
        # else:
        print(f" {inp}: {letters[inp]:04} | {letters[inp] / letterCount * 100:07.4f}% | {lettersByWords[inp]:04} | {lettersByWords[inp] / len(words) * 100:07.4f}%")
        for key, val in sorted(dict((k, v) for k, v, in twoLetters.items() if inp in k).items(), key=lambda e: e[1], reverse=True):
            print(f"{key}: {val:04} | {val / (letterCount - len(words)) * 100:07.4f}% | {twoLettersByWords[key]:04} | {twoLettersByWords[key] / len(words) * 100:07.4f}%")
    print()