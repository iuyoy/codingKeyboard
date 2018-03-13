import os
import sys
from PIL import Image

iosSizes = [[20,1],[20,2],[20,3],[29,1],[29,2],[29,3],[40,1],[40,2],[40,3],[60,2],[60,3],[76,1],[76,2],[83.5,2],[1024,1]]

def resizeIcon(filename, folder = 'icons'):
    icon = Image.open(filename).convert("RGBA")
    if icon.size[0] != icon.size[1]:
        print('Icon file must be a rectangle!')
        return
    if not os.path.isdir(folder):
        os.mkdir(folder)
    for size, multiply in iosSizes:
        newSize = int(size*multiply)
        im = icon.resize((newSize, newSize), Image.BILINEAR)
        im.save('{}/{}_{}@{}x.png'.format(folder, filename.split('.')[0], size, multiply))
    print('Done!')

if __name__ == '__main__':
    if(len(sys.argv)==0):
        print("Please set the original icon name.")
    else:
        filename = sys.argv[1]
        folder = 'icons'
        if(len(sys.argv)>2):
            folder = sys.argv[2]
        resizeIcon(filename, folder)
