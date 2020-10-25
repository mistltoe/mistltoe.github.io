// select target directory 
dir = getDirectory("Choose a Directory");


// start of main function ///////////////////////////////////////
function bone_Analysis(directory){
	
	// Listing image file
	fl = getFileType(directory, 'tif', false);	

	for (i=0;i<fl.length;i++) {
			
		lengthName = lengthOf(fl[i]);
		fileName = substring(fl[i], 0, lengthName-12);
		expName = fileName+"_big";
		resizeName = expName+"_res";
		selectName = expName+"_sel";
		rotateName = expName+"_rot";			

		// Open image and select ROI(region of interest)
		run("Bio-Formats Importer", "check_for_upgrades open="+ directory+fl[i] +" autoscale color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
		name = getTitle;
		run("RGB Color");
		selectWindow(name);
		close();
		selectWindow(name+" (RGB)");
		
		waitForUser("Select ROI in image");
		
		run("Copy");
		run("Internal Clipboard");
		saveAs("Tiff", dir+"/"+name+" (RGB).tif");

		close();
		close();
	}
}

bone_Analysis(dir);



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
