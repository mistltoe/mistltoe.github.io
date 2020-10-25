// Selection area
width = 500;
height = 500;

// Line width
lineWidth = 15;

// Line color (0,0,0:black)
CR = 0;
CG = 0;
CB = 0;

// Choose directory
dir = getDirectory("Choose a Directory");

// get specific type of images
fl = getFileType(dir, 'tif', false);

// Setting line color and width
run("Line Width...", "line="+lineWidth);
setForegroundColor(CR, CG, CB);

// Working
for (i=0;i<fl.length;i++) {
	
	lengthName = lengthOf(fl[i])-4;
	fileName = substring(fl[i], 0, lengthName-4);
	expNameLarge = fileName+"_Draw";
	expNameSel1 = fileName+"_sel1";
	expNameSel2 = fileName+"_sel2";
	// open file	
	open(fl[i]);

	makeRectangle(0, 0, width, height);
	waitForUser("Select first area");	

	// Export first select area as tif image
	run("Copy");
	run("Internal Clipboard");
	selectWindow("Clipboard");			
	saveAs("Tiff", dir+"/"+expNameSel1+".tif");
	close();

	selectWindow(fl[i]);			
	run("Draw", "slice");
	waitForUser("Select another area");	

	// Export last select area as tif image
	run("Copy");
	run("Internal Clipboard");
	selectWindow("Clipboard");			
	saveAs("Tiff", dir+"/"+expNameSel2+".tif");
	close();

	selectWindow(fl[i]);			
	run("Draw", "slice");
	saveAs("Tiff", dir+"/"+expNameLarge+".tif");	
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