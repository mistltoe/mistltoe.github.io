/////////////////////////////////////////////////////////////////////////////////////////////
// User setting
/////////////////////////////////////////////////////////////////////////////////////////////



/////////////////////////////////////////////////////////////////////////////////////////////
// Main program
/////////////////////////////////////////////////////////////////////////////////////////////


// select target directory 
targetDirectory = getDirectory("Choose a Directory");

// get file list in target directory
imageFileList = getFileType(targetDirectory, 'tif', false);


for (i = 0;i<imageFileList.length;i++) {

	// Open image and select ROI(region of interest)
	run("Bio-Formats Importer", "check_for_upgrades open="+ directory+fl[i] +" autoscale color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
	name = getTitle;
	run("RGB Color");
	selectWindow(name);
	close();
	selectWindow(name+" (RGB)");
	rename(rotateName);



/////////////////////////////////////////////////////////////////////////////////////////////
// Function definication
/////////////////////////////////////////////////////////////////////////////////////////////

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

// end of macro
/////////////////////////////////////////////////////////////////////////////////////////////