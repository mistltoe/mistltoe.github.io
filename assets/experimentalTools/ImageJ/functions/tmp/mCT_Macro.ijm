// First image (3D)
name = "B6"+"_In";
run("System Clipboard");
run("Rotate... ", "angle=90 grid=1 interpolation=Bilinear");

//setTool("rectangle");
makeRectangle(166, 22, 600, 600);
waitForUser("Select area")

selectWindow("Clipboard");
run("Copy");
run("Internal Clipboard");
selectWindow("Clipboard");
saveAs("Tiff", "I:/boneDefect/mCT/"+name+"_3D.tif");
close();
saveAs("Tiff", "I:/boneDefect/mCT/"+name+"_3D_sel.tif");
close();

// Second image(BW)
waitForUser("Copy BW image")
run("System Clipboard");
run("Rotate... ", "angle=90 grid=1 interpolation=Bilinear");

makeRectangle(68, 21, 600, 600);
waitForUser("Select BWl area")

run("Copy");
run("Internal Clipboard");
saveAs("Tiff", "I:/boneDefect/mCT/"+name+"_BW_sel.tif");
selectWindow(name+"_BW_sel.tif")
close();

selectWindow("Clipboard");
saveAs("Tiff", "I:/boneDefect/mCT/"+name+"_BW.tif");
selectWindow(name+"_BW.tif")
close();

// Third image(BW)
waitForUser("Copy colored image")

run("System Clipboard");
run("Rotate... ", "angle=90 grid=1 interpolation=Bilinear");

makeRectangle(68, 21, 600, 600);
waitForUser("Select col area")

run("Copy");
run("Internal Clipboard");
saveAs("Tiff", "I:/boneDefect/mCT/"+name+"_Col_sel.tif");
selectWindow(name+"_Col_sel.tif")
close();

selectWindow("Clipboard");
saveAs("Tiff", "I:/boneDefect/mCT/"+name+"_Col.tif");
selectWindow(name+"_Col.tif")
close();