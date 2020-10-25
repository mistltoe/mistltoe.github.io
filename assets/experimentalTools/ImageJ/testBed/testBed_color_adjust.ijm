/////////////////////////////////////////////////////////////////////////////////////////////
// User setting
/////////////////////////////////////////////////////////////////////////////////////////////


// Target image
imageType = "tif";

//contrast = 0.25;

/////////////////////////////////////////////////////////////////////////////////////////////
// Main program
/////////////////////////////////////////////////////////////////////////////////////////////


// select target directory 
targetDirectory = getDirectory("Choose a Directory");

startDirectory = targetDirectory+"/start";
File.makeDirectory(startDirectory);

colorAdjestedDirectory = targetDirectory+"/ColAdj";
File.makeDirectory(colorAdjestedDirectory);

drawDirectory = targetDirectory+"/draw";
File.makeDirectory(drawDirectory);


// get file list in target directory
imageFileList = getFileType(startDirectory, imageType, true);


for (i = 0;i<imageFileList.length;i++) {
	open(startDirectory+"/"+imageFileList[i]); 
	name = getTitle;
	fileName = substring(name, 0, lengthOf(name)-4);	
	run("Brightness/Contrast...");
	waitForUser("adjust color");

	saveAs("Tiff", colorAdjestedDirectory+"/"+fileName+"_BC_Min40.tif");
	close();
}


/////////////////////////////////////////////////////////////////////////////////////////////
// Function definication
/////////////////////////////////////////////////////////////////////////////////////////////


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


/////////////////////////////////////////////////////////////////////////////////////////////
// Rotate image

function rotateImage(fileName) {

	selectWindow(fileName+".tif");

	/////////////////////////////////////////////////////////////////////////////////////////////
	// Rotate dialog1
	// Number of checkbox
	rows = 5;
	columns = 1;
	n = rows*columns;

	// Labels and defaults
	labels = newArray("None", "Horizon", "Vertical", "Right", "Left");
	defaults = newArray(false, false, false, false, false);

	//Create checkbox
	Dialog.create("Rotation option");
	Dialog.addCheckboxGroup(rows,columns,labels,defaults);
	Dialog.show();

	if (Dialog.getCheckbox() == 0) {
		if (Dialog.getCheckbox() == 0){
			run("Flip Horizontally");				
		}

		if (Dialog.getCheckbox() == 0) {
			run("Flip Vertically");
		}

		if (Dialog.getCheckbox() == 0) {
			run("Rotate 90 Degrees Right");				
		}
		
		if (Dialog.getCheckbox() == 0) {
			run("Rotate 90 Degrees Left");				
		}
	}

	/////////////////////////////////////////////////////////////////////////////////////////////
	// Rotate dialog2
	//Create addnumber
	Dialog.create("Rotation option");
	Dialog.addMessage("Input rotation degree");
	Dialog.addNumber("Degree: ", 0);
	Dialog.show();

	run("Rotate... ", "angle="+Dialog.getNumber()+" grid=1 interpolation=Bilinear");

	/////////////////////////////////////////////////////////////////////////////////////////////
	// Rotate dialog3
	//Create addnumber
	Dialog.create("Rotation option");
	Dialog.addMessage("Input rotation degree");
	Dialog.addNumber("Degree: ", 0);
	Dialog.show();

	run("Rotate... ", "angle="+Dialog.getNumber()+" grid=1 interpolation=Bilinear");

	//run("Rotate...");
	
}

/////////////////////////////////////////////////////////////////////////////////////////////
// Generate start image

function GenStartImage(outDirectory, fileName, sWidth, sHeight) {	
	
		selectWindow(fileName+".tif");
		
		makeRectangle(0, 0, sWidth, sHeight);
		waitForUser("Select ROI in image");
		run("Copy to System", "stack");
		run("System Clipboard", "stack");
		selectWindow("Clipboard");
		saveAs("Tiff", outDirectory+"/"+fileName+"_start.tif");

}



/////////////////////////////////////////////////////////////////////////////////////////////
// Select square area

function selectArea(outDirectory, fileName, times, sWidth, sHeight) {
	
	
	selectWindow(fileName+"_start.tif");
	

	// select 1
	makeRectangle(0, 0, sWidth, sHeight);
	waitForUser("Select first area");	

	// Export first select area as tif image
	run("Copy");
	run("Internal Clipboard");
	selectWindow("Clipboard");			
	saveAs("Tiff", outDirectory+"/"+fileName+"sel_1.tif");
	close();

	selectWindow(fileName+"_start.tif");			
	run("Draw", "slice");

	// select 2
	makeRectangle(0, 0, sWidth/2, sHeight/2);
	waitForUser("Select first area");	

	// Export first select area as tif image
	run("Copy");
	run("Internal Clipboard");
	selectWindow("Clipboard");			
	saveAs("Tiff", outDirectory+"/"+fileName+"sel_2.tif");
	close();

	selectWindow(fileName+"_start.tif");			
	run("Draw", "slice");


	selectWindow(fileName+"_start.tif");			
	saveAs("Tiff", outDirectory+"/"+fileName+"_draw.tif");	
	close();
}


// end of macro
/////////////////////////////////////////////////////////////////////////////////////////////