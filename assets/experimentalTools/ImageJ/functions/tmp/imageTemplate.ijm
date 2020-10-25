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

// get information in dialog
TemplateType = Dialog.getRadioButton();
NoOfColumn = Dialog.getNumber();
NoOfRow = Dialog.getNumber();
Magnification = Dialog.getNumber();
OutputName = Dialog.getString();

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

SLSizeL = newArray(SL.length*2);

for (j=0;j<SL.length;j++) {
	open(dir+SL[j]);
	SLSizeL[j*2] = getWidth();
	SLSizeL[j*2+1] = getHeight();
	close();
}

if (getmax(SLSizeL) > cell_width_image*Magnification) {
	cell_minification = floor(getmax(SLSizeL)/cell_width_image)+1;
	minify_boolean = true;
} else {
	cell_mangification = cell_width_image/getmax(SLSizeL);
}

if (minify_boolean) {
	print(getmax(SLSizeL)+", "+cell_width_image+", "+cell_minification);
} else {
	print(getmax(SLSizeL)+", "+cell_width_image+", "+cell_mangification);
}


newImage(OutputName, "RGB white", width, height, 1);


start = 20;
end = 20;

FL = getFileType(dir, "tif", false);
for (column=0;column<NoOfColumn;column++){
	for(row=0;row<NoOfRow;row++) {
		makeRectangle(start, end, cell_width_title, cell_height_title);
		run("Draw", "slice");
		makeRectangle(start, end+cell_height_title, cell_width_image, cell_height_image);
		run("Draw", "slice");
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
for (l=0;l<SL.length;l++) {
	if (samples[l] == 1) {
		drawString(substring(SL[l], 0, 8), start1, end1+cell_height_title);
		
		open(dir+SL[l]);
		wid = getWidth();
		hei = getHeight();
		run("Size...", "width="+wid/cell_minification+" height="+hei/cell_minification+" constrain average interpolation=Bilinear");
		makeRectangle(0, 0, wid/cell_minification, hei/cell_minification);		
		run("Copy");
		selectWindow(OutputName);
		makeRectangle(start1, end1+cell_height_title, wid/cell_minification, hei/cell_minification);		
		run("Paste");
		selectWindow(SL[l]);
		close();
		end1 = end1+cell_height_title+cell_height_image+10;		

	} else if(samples[l] == 2) {
		drawString(substring(SL[l], 0, 8), start2, end2+cell_height_title);
		
		open(dir+SL[l]);
		wid = getWidth();
		hei = getHeight();
		run("Size...", "width="+wid/cell_minification+" height="+hei/cell_minification+" constrain average interpolation=Bilinear");
		makeRectangle(0, 0, wid/cell_minification, hei/cell_minification);		
		run("Copy");
		selectWindow(OutputName);
		makeRectangle(start2, end2+cell_height_title, wid/cell_minification, hei/cell_minification);		
		run("Paste");
		selectWindow(SL[l]);
		close();
		end2 = end2+cell_height_title+cell_height_image+10;	
		
	} else if(samples[l] == 3) {
		drawString(substring(SL[l], 0, 8), start3, end3+cell_height_title);
		
		open(dir+SL[l]);
		wid = getWidth();
		hei = getHeight();
		run("Size...", "width="+wid/cell_minification+" height="+hei/cell_minification+" constrain average interpolation=Bilinear");
		makeRectangle(0, 0, wid/cell_minification, hei/cell_minification);		
		run("Copy");
		selectWindow(OutputName);
		makeRectangle(start3, end3+cell_height_title, wid/cell_minification, hei/cell_minification);		
		run("Paste");
		selectWindow(SL[l]);
		close();
		end3 = end3+cell_height_title+cell_height_image+10;	
	} else if(samples[l] == 4) {
		drawString(substring(SL[l], 0, 8), start4, end4+cell_height_title);
		
		open(dir+SL[l]);
		wid = getWidth();
		hei = getHeight();
		run("Size...", "width="+wid/cell_minification+" height="+hei/cell_minification+" constrain average interpolation=Bilinear");
		makeRectangle(0, 0, wid/cell_minification, hei/cell_minification);		
		run("Copy");
		selectWindow(OutputName);
		makeRectangle(start4, end4+cell_height_title, wid/cell_minification, hei/cell_minification);		
		run("Paste");
		selectWindow(SL[l]);
		close();
		end4 = end4+cell_height_title+cell_height_image+10;					
	}
}

selectWindow(OutputName);
saveAs("Tiff", dir+"/"+OutputName);
close();


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