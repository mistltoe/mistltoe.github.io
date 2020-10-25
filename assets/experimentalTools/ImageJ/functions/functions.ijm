
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

function rotateImage(fileAddress){

	selectWindow(fileAddress);

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




