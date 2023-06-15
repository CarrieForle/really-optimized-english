# Xarty - an ecgonomic layout attempt

![Xarty-the-layout](https://github.com/CarrieForle/xarty/assets/53133715/ec364811-a7a1-4aa1-abd5-59597699a80f)

```

` 1 2 3 4 5 6 7 8 9 0 - = 
   V H S G B J M O U ; [ ] \
    X A R T Y K N E I W '
     Z F L D Q C P , . /
```

Xarty is a keyboard layout aimed for typing English in a comfortable and quick manner, which doesn't take the compatibility to other languages and shortcut friendliness into account.<br> 
<br>
The key placement is heavily based on [first20hours/google-10000-english](https://github.com/first20hours/google-10000-english).

## Downloads

See [Releases](https://github.com/CarrieForle/xarty/releases).

## Installing

See [Wiki](https://github.com/CarrieForle/xarty/wiki/How-to-install).

## Why is the layout *like this?*

1. Typing with pinkies is **awful**, so this is a six-finger (index, middle, ring) dominant layout.
2. The priority is most used keys being reachable with the the 6 fingers while being as comfortable with [Bigram](https://en.wikipedia.org/wiki/Bigram). The best scenario is the 2 keys being typed with separate hands. The worst is it have to be typed with the same finger, followed by pinky to ring and up pinky to the down outmost index and vise versa. The layout is arranged in a way to have a balance between most common [Bigrams](https://en.wikipedia.org/wiki/Bigram) typed with different hands and most common keys typed with the 6 fingers.
3. The left hand, in theory, will work more in the long term. Precisely, about `150 per 10,000 keys pressed`. That is, if you do not consider the punctuation. While there seems to have no agreement in punctuation frequency, after I examined the different researches I found on the internet, somewhere in `230 ~ 300 per 10,000 keys pressed` is reasonable. You might think this turns out that the layout is, in fact, putting more pressure on the right hand since every punctuation except exclamation mark is on the right, and you will be right. Unfortunately, this is the best I can get without breaking point \#2 or entirely rearrange the layout.

## Why ANSI?

I'm using ANSI.

## The current state

I'm writing an AHK script that not only implements the layout, but also **Extend layers** and **Compose** because there is an bug in EPKL that conflicts with the Chinese input method I'm using. The script is aimed to resolve the problem and while not compromising the 2 features I used in EPKL.
