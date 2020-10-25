samples = newArray(5,5,5,4,4,4,4,4,4,2,1,1,2,2,2,2,2,2,2,1,1,3,3,3,3,3,3,3,3);

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
Dialog.addMessage("Select tag"); 
Dialog.setInsets(0, 0, 0); 
tagItems = newArray("select", "hem", "thr");
Dialog.addRadioButtonGroup("tag type", tagItems, 1, 3, "select");

Dialog.setInsets(0, 0, 0);
Dialog.addMessage("----------------------------------------------------------------------------"); 
Dialog.setInsets(0, 0, 0); 
Dialog.addMessage("template");
Dialog.addNumber("Number of column", 4);
Dialog.addNumber("Number of row", 8);

Dialog.setInsets(0, 0, 0); 
Dialog.addMessage("----------------------------------------------------------------------------"); 
Dialog.setInsets(0, 0, 0); 
Dialog.addMessage("Default size: 840*1188 or 1188*840 (3.8 MB)");
Dialog.addSlider("Magnification", 3, 40, 0);


Dialog.show();

// get information in dialog
TemplateType = Dialog.getRadioButton();
TagType = Dialog.getRadioButton();
NoOfColumn = Dialog.getNumber();
NoOfRow = Dialog.getNumber();
Magnification = Dialog.getNumber();
OutputName = "Total_"+TagType+".tif";

if (TemplateType == "portrailt") {
	width = 190*NoOfColumn*Magnification+20;
	height = 190*NoOfRow*Magnification+20;
	
	cell_width_image = 160*Magnification;
	cell_height_image = 160*Magnification;

	cell_width_title = 160*Magnification;
	cell_height_title = 20*Magnification;	
		
} else if (TemplateType == "landscape") {
	width = 1188*Magnification;
	height = 840*Magnification;
}


// fonts setting
setFont("TimesNewRoman", 20*Magnification, "bold");

FL = getFileType(dir, "tif", false);

TL = newArray(29);
HL = newArray(29);
SL = newArray(29);

Ti = 0;
Hi = 0;
Si = 0;

for (i=0;i<FL.length;i++) {
//for (i=0;i<3;i++) {
	if (indexOf(FL[i], "thr") >= 0) {
		print(FL[i]);
		TL[Ti] = FL[i];
		Ti++;
	} else if (indexOf(FL[i], "hem") >= 0) {
		HL[Hi] = FL[i];
		Hi++;
	} else if (indexOf(FL[i], "select") >= 0) {
		SL[Si] = FL[i];
		Si++;
	}
}


if (TagType =="select") {
	drawimages(SL);	
} else if (TagType =="hem") {
	drawimages(HL);	
} else if (TagType =="thr") {
	drawimages(TL);	
}


function drawimages(inputList) {

	inputListSizeL = newArray(inputList.length*2);

	for (j=0;j<inputList.length;j++) {
		open(dir+inputList[j]);
		inputListSizeL[j*2] = getWidth();
		inputListSizeL[j*2+1] = getHeight();
		close();
	}

	if (getmax(inputListSizeL) > cell_width_image*Magnification) {
		cell_minification = floor(getmax(inputListSizeL)/cell_width_image)+1;
		minify_boolean = true;
	} else {
		cell_mangification = cell_width_image/getmax(inputListSizeL);
	}

	if (minify_boolean) {
		print(getmax(inputListSizeL)+", "+cell_width_image+", "+cell_minification);
	} else {
		print(getmax(inputListSizeL)+", "+cell_width_image+", "+cell_mangification);
	}


	newImage(OutputName, "RGB white", width, height, 1);


	start = 20;
	end = 20;

	FL = getFileType(dir, "tif", false);
	for (column=0;column<NoOfColumn;column++){
		for(row=0;row<NoOfRow;row++) {
			makeRectangle(start, end, cell_width_title, cell_height_title);
			run("Draw", "inputListice");
			makeRectangle(start, end+cell_height_title, cell_width_image, cell_height_image);
			run("Draw", "inputListice");
			end = end+cell_height_title+cell_height_image+10;		
		}
		end = 20;
		start = 20 + (cell_width_image+20)*(column+1);		
	}

	start1 = 20;
	end1 = 20;
	start2 = (cell_width_image+20)*1+20;
	end2 = 20;
	start3 = (cell_width_image+20)*2+20;
	end3 = 20;
	start4 = (cell_width_image+20)*3+20;
	end4 = 20;


	// Draw images
	for (l=0;l<inputList.length;l++) {
		if (samples[l] == 1) {
			drawString(substring(inputList[l], 0, 8), start1, end1+cell_height_title);
			
			open(dir+inputList[l]);
			wid = getWidth();
			hei = getHeight();
			run("Size...", "width="+wid/cell_minification+" height="+hei/cell_minification+" constrain average interpolation=Bilinear");
			makeRectangle(0, 0, wid/cell_minification, hei/cell_minification);		
			run("Copy");
			selectWindow(OutputName);
			makeRectangle(start1, end1+cell_height_title, wid/cell_minification, hei/cell_minification);		
			run("Paste");
			selectWindow(inputList[l]);
			close();
			end1 = end1+cell_height_title+cell_height_image+10;		

		} else if(samples[l] == 2) {
			drawString(substring(inputList[l], 0, 8), start2, end2+cell_height_title);
			
			open(dir+inputList[l]);
			wid = getWidth();
			hei = getHeight();
			run("Size...", "width="+wid/cell_minification+" height="+hei/cell_minification+" constrain average interpolation=Bilinear");
			makeRectangle(0, 0, wid/cell_minification, hei/cell_minification);		
			run("Copy");
			selectWindow(OutputName);
			makeRectangle(start2, end2+cell_height_title, wid/cell_minification, hei/cell_minification);		
			run("Paste");
			selectWindow(inputList[l]);
			close();
			end2 = end2+cell_height_title+cell_height_image+10;	
			
		} else if(samples[l] == 3) {
			drawString(substring(inputList[l], 0, 8), start3, end3+cell_height_title);
			
			open(dir+inputList[l]);
			wid = getWidth();
			hei = getHeight();
			run("Size...", "width="+wid/cell_minification+" height="+hei/cell_minification+" constrain average interpolation=Bilinear");
			makeRectangle(0, 0, wid/cell_minification, hei/cell_minification);		
			run("Copy");
			selectWindow(OutputName);
			makeRectangle(start3, end3+cell_height_title, wid/cell_minification, hei/cell_minification);		
			run("Paste");
			selectWindow(inputList[l]);
			close();
			end3 = end3+cell_height_title+cell_height_image+10;	
		} else if(samples[l] == 4) {
			drawString(substring(inputList[l], 0, 8), start4, end4+cell_height_title);
			
			open(dir+inputList[l]);
			wid = getWidth();
			hei = getHeight();
			run("Size...", "width="+wid/cell_minification+" height="+hei/cell_minification+" constrain average interpolation=Bilinear");
			makeRectangle(0, 0, wid/cell_minification, hei/cell_minification);		
			run("Copy");
			selectWindow(OutputName);
			makeRectangle(start4, end4+cell_height_title, wid/cell_minification, hei/cell_minification);		
			run("Paste");
			selectWindow(inputList[l]);
			close();
			end4 = end4+cell_height_title+cell_height_image+10;					
		}
	}


	outputImage = dir+"/outputImage/";
	File.makeDirectory(outputImage);		
	selectWindow(OutputName);
	saveAs("Tiff", outputImage+OutputName);
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

// get maximum value in array 
function getmax(inputarray) {
	for (k=0;k<inputarray.length;k++) {
		if (k ==0) {
			max = inputarray[0];
		} else {
			max = maxOf(max, inputarray[k]);
		}
	}
	return(max);
}

// end of macro
/////////////////////////////////////////////////////////////////////////////////////////////