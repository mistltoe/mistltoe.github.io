// select target directory 
dir = getDirectory("Choose a Directory");

fl = getFileType(dir, 'tif', false);
for (i=0;i<fl.length;i++) {
	open(fl[i]);
	filename = getTitle();
	
	// Rotate dialog ///////////////
	Dialog.create("Rotation option");
	Dialog.addMessage("Input rotation degree");
	Dialog.addNumber("Degree: ", 0);
	Dialog.show();
	
	run("Rotate... ", "angle="+Dialog.getNumber()+" grid=1 interpolation=Bilinear");	
	
	// Select area(4800*1600)
	makeRectangle(0, 0, 4800, 1600);
	waitForUser("Select?");
	run("Copy");
	run("Internal Clipboard");
	saveAs("Tiff", filename);
	
	
	// Select area 1
	makeRectangle(0, 0, 1000, 1000);
	waitForUser("Select?");
	run("Copy");
	run("Internal Clipboard");
	saveAs("Tiff", "select1_"+filename);
	close("select1_"+filename);
	
	run("Line Width...", "line=10");
	run("Draw", "slice");	
	
	// Select area 2
	makeRectangle(0, 0, 1000, 1000);
	waitForUser("Select?");
	run("Copy");
	run("Internal Clipboard");
	saveAs("Tiff", "select2_"+filename);
	close("select2_"+filename);
	
	run("Line Width...", "line=10");
	run("Draw", "slice");	
	saveAs("Tiff", "draw_"+filename);	
	
	run("Size...", "width=2400 height=800 constrain average interpolation=Bilinear");	
	saveAs("Tiff", "resize_draw_"+filename);	
	
	close("resize_draw_"+filename);
	close();
}

// List specific type of File
// dir: target directory, fileExtension: file extension, displayList: print list or not , boolean
function getFileType(dir, fileExtension, displayList) {
fileList = getFileList(dir);
returnedFileList = newArray(0);     //this list stores all files found to have the extension and is returned at the end of the function
if(lengthOf(fileExtension) > 0) {
	for (i = 0; i < fileList.length; i++) {
		if (endsWith(fileList[i],fileExtension)) returnedFileList = Array.concat(returnedFileList,fileList[i]);
		}
	print(returnedFileList.length + " file(s) found with extension " + fileExtension + ".");
	if (displayList) {Array.show("All files - filtered for " + fileExtension, returnedFileList);} 
	} else {
	returnedFileList = fileList;	
	}
return returnedFileList;
}