# https://stackoverflow.com/questions/5794640/how-to-convert-xcf-to-png-using-gimp-from-the-command-line
# https://gist.github.com/jfcamel/1033515
# http://gimpchat.com/viewtopic.php?f=9&t=15024

import glob
import pdb

source_folder = "I:/boneDefect/2wks(2018)/HE/PannoramicViewerExport/large_resize/jpg"
jpgList = glob.glob(source_folder  + "/*.jpg")
jpgList[0]
imgFile = jpgList[0].replace("\\", "/")
type(jpgList)

for jpgFile in jpgList:
	print jpgFile
	
img = pdb.gimp_file_load(imgFile, imgFile)
img = gimp-file-load(imgFile, imgFile)
img1 = file-jpeg-load(imgFile, imgFile)

img = pdb.gimp_file_load(imgFile, "")

print "imgFile: " + imgFile





import glob
source_folder = "/home/pecesaquadros/Desktop/T/"
dest_folder = "/home/pecesaquadros/Desktop/T2/"

def auto(source_folder, dest_folder):
    for filename in glob(source_folder  + "/*.JPG"):
        img = pdb.gimp_file_load(source_folder + filename, source_folder + filename)
        pdb.gimp_image_rotate(img,0)
        pdb.gimp_image_convert_grayscale(img)
        drawable = pdb.gimp_image_get_active_drawable(img)
        pdb.gimp_brightness_contrast(drawable, 28,100)
        disp = pdb.gimp_display_new(img)
        yield img
        pdb.gimp_image_merge_visible_layers(img, CLIP_TO_IMAGE)
        pdb.gimp_file_save(img, img.layers[0], dest_folder + filename, dest_folder + filename)
        pdb.gimp_display_delete(disp)
        pdb.gimp_image_delete(img)  # drops the image from gimp memory

seq = auto(source_folder, dest_folder)
next(seq)