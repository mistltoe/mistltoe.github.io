// First image (3D)
name = "FD8W-Q6"+"_In";
run("System Clipboard");
run("Rotate... ", "angle=90 grid=1 interpolation=Bilinear");

//setTool("rectangle");
makeRectangle(166, 22, 500, 500);
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
run("Rotate... ", "angle=180 grid=1 interpolation=Bilinear");

makeRectangle(68, 21, 250, 250);
waitForUser("Select vertical area")

run("Copy");
run("Internal Clipboard");
saveAs("Tiff", "I:/boneDefect/mCT/"+name+"_BW_v.tif");
selectWindow(name+"_BW_v.tif")
close();

selectWindow("Clipboard");
//setTool("rectangle");
makeRectangle(455, 632, 200, 200);
waitForUser("Select horizonal area")
run("Copy");
run("Internal Clipboard");
saveAs("Tiff", "I:/boneDefect/mCT/"+name+"_BW_h.tif");
selectWindow(name+"_BW_h.tif")
close();
selectWindow("Clipboard");
saveAs("Tiff", "I:/boneDefect/mCT/"+name+"_BW.tif");
selectWindow(name+"_BW.tif")
close();

// Third image(BW)
waitForUser("Copy colored image")
run("System Clipboard");
run("Rotate... ", "angle=180 grid=1 interpolation=Bilinear");

makeRectangle(68, 21, 250, 250);
waitForUser("Select vertical area")

run("Copy");
run("Internal Clipboard");
saveAs("Tiff", "I:/boneDefect/mCT/"+name+"_Col_v.tif");
selectWindow(name+"_Col_v.tif")
close();

selectWindow("Clipboard");
//setTool("rectangle");
makeRectangle(455, 632, 200, 200);
waitForUser("Select horizonal area")
run("Copy");
run("Internal Clipboard");
saveAs("Tiff", "I:/boneDefect/mCT/"+name+"_Col_h.tif");
selectWindow(name+"_Col_h.tif")
close();
selectWindow("Clipboard");
saveAs("Tiff", "I:/boneDefect/mCT/"+name+"_Col.tif");
selectWindow(name+"_Col.tif")
close();