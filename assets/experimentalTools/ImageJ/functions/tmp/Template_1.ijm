// select working directory 
dir = getDirectory("Choose a working directory");

// start of dialog ///////////////////////////////////////
Dialog.create("Template setting (based on A4");

Dialog.setInsets(0, 0, 0); 
Dialog.addMessage("----------------------------------------------------------------------------"); 
Dialog.setInsets(0, 0, 0); 
Dialog.addMessage("Portrailt or landscape"); 
Dialog.setInsets(0, 0, 0); 
sizeItems = newArray("portrailt", "landscape");
Dialog.addRadioButtonGroup("Template type", sizeItems, 1, 2, "portrailt");

Dialog.setInsets(0, 0, 0);
Dialog.addMessage("----------------------------------------------------------------------------"); 
Dialog.setInsets(0, 0, 0); 
Dialog.addMessage("template");
Dialog.addNumber("Number of column", 4);
Dialog.addNumber("Number of row", 6);

Dialog.setInsets(0, 0, 0); 
Dialog.addMessage("----------------------------------------------------------------------------"); 
Dialog.setInsets(0, 0, 0); 
Dialog.addMessage("Default size: 840*1188 or 1188*840 (3.8 MB)");
Dialog.addSlider("Magnification", 1, 40, 0);

Dialog.setInsets(0, 0, 0); 
Dialog.addMessage("----------------------------------------------------------------------------"); 
Dialog.setInsets(0, 0, 0); 
Dialog.addString("Output file name: ", "outputFile.tif");

Dialog.show();

// fonts setting
setFont("TimesNewRoman", 40, "bold");

// get information in dialog
TemplateType = Dialog.getRadioButton();
NoOfColumn = Dialog,getNumber();
NoOfRow = Dialog,getNumber();
Magnification = Dialog.getNumber();
OutputName = Dialog.getString() 

if (TemplateType == "portrailt") {
	width = 840*Magnification;
	height = 1188*Magnification;
	
	cell_width_image = 160*Magnification;
	cell_height_image = 160*Magnification;

	cell_width_title = 160*Magnification;
	cell_height_title = 20*Magnification;	
		
} else if (TemplateType == "landscape") {
	width = 1188*Magnification;
	height = 840*Magnification;
}
newImage(OutputName, "RGB white", width, height, 1);
saveAs("Tiff", dir+"/"+OutputName);

sourceDir = dir+"source";
sourceFL = getFileType(sourceDir, "tif", false);
start = 20;
end = 50;
for (i=0;i<sourceFL.length;i++) {
//for (i=0;i<3;i++) {
	if (indexOf(sourceFL[i], "thr") >= 0) {
		//print(i+": "+sourceFL[i]);
	} else if (indexOf(sourceFL[i], "hem") >= 0) {
		//print(i+": "+sourceFL[i]);
	} else if (indexOf(sourceFL[i], "select") >= 0) {
		drawString(substring(sourceFL[i], 5, 7), start, end);
		//print(i+": "+sourceFL[i]);
		open(sourceDir+"\\"+sourceFL[i]);
		wid = getWidth();
		hei = getHeight();
		run("Size...", "width="+wid/10+" height="+hei/10+" constrain average interpolation=Bilinear");
		
		//draw figure name
		
		
		makeRectangle(0, 0, wid/10, hei/10);		
		run("Copy");
		selectWindow(OutputName);
		makeRectangle(start, end+50, wid/10, hei/10);		
		run("Paste");
		
		selectWindow(sourceFL[i]);
		close();
		end+=350;
	}
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

// end of macro
/////////////////////////////////////////////////////////////////////////////////////////////