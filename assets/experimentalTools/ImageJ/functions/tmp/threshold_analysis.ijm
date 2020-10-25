// threshold setting
tmin = 20;
tmax = 200;

//output data setting
datafilename = "calv"+"_"+"8wk"+".txt";

// select target directory 
dir = getDirectory("Choose a Directory");

// Listing image file
fl = getFileType(dir, 'tif', false);

// Setting results variables
sArea=0;
sMean=0;
spArea=0;

for (i=0;i<fl.length;i++) {

	open(dir+fl[i]);

	filename = getTitle();	
	filenameIndex = indexOf(fl[i], ".tif"); 	
	selectName = substring(fl[i], 0, filenameIndex); 	
	
	selectWindow(filename);
	rename(selectName);
	
	run("Colour Deconvolution", "vectors=[Masson Trichrome]");
	selectWindow(selectName+"-(Colour_1)");
	rename(selectName+"_hem");
	run("Duplicate...", " ");
	rename(selectName+"_hem_thr");
	setThreshold(tmin, tmax);
	setOption("BlackBackground", false);
	run("Convert to Mask");
	
	run("Measure");
	Area = getResult("Area",0);
	Mean = getResult("Mean",0);
	pArea = getResult("%Area",0);
	integratedDensity = getResult("RawIntDen",0);
	stainedArea = (Area*pArea)/(sArea*spArea*10000);
	close("Results");

	print(selectName, sArea, sMean, spArea, Area, Mean, pArea, stainedArea, integratedDensity);

	// save images
	analysisDir = dir+"/Analysis/";
	File.makeDirectory(analysisDir);
	
	selectWindow(selectName);
	saveAs("Tiff", analysisDir+"/"+selectName+".tif");
	close();
	
	selectWindow(selectName+"_hem");
	saveAs("Tiff", analysisDir+"/"+selectName+"_hem.tif");
	close();

	selectWindow(selectName+"_hem_thr");
	saveAs("Tiff", analysisDir+"/"+selectName+"_hem_thr.tif");
	close();

	close(selectName+"-(Colour_2)");
	close(selectName+"-(Colour_3)");
	close("Colour Deconvolution");
	
}

selectWindow("Log");
saveAs("Text", dir + datafilename); 
close("Log");


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
