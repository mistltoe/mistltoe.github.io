/////////////////////////////////////////////////////////////////////////////////////////////
// start of macro

// Run recorder
run("Record...");

// start of dialog ///////////////////////////////////////
// Load dialog for user-set
Dialog.create("Analysis options");

Dialog.setInsets(0, 0, 0); 
Dialog.addMessage("----------------------------------------------------------------------------------------------"); 
Dialog.setInsets(0, 0, 0); 
Dialog.addMessage("Need high capacity of RAM, minimum: 16 GB, recommeneded: 32 GB")

Dialog.setInsets(0, 0, 0); 
Dialog.addMessage("----------------------------------------------------------------------------"); 
Dialog.setInsets(0, 0, 0); 
Dialog.addMessage("1. Tiled tiff image export from mrxs(3DHISTECH Ltd.)");
Dialog.setInsets(0, 0, 0); 
Dialog.addMessage("2. Tiff image: read for analysis");
startItems = newArray("1", "2");
Dialog.setInsets(0, 0, 0); 
Dialog.setInsets(0, 0, 0); 
Dialog.addRadioButtonGroup("Start where you are?", startItems, 1, 2, "1");

targetTissue = newArray("femora", "calvarium");
Dialog.setInsets(0, 0, 0); 
Dialog.addMessage("----------------------------------------------------------------------------"); 
Dialog.setInsets(0, 0, 0); 
Dialog.addRadioButtonGroup("Analysis which you are", targetTissue, 1, 2, "femora");
Dialog.setInsets(0, 0, 0); 

Dialog.addMessage("----------------------------------------------------------------------------"); 
Dialog.setInsets(0, 0, 0); 
Dialog.addMessage("HnE: Hematoxylin in HnE");
Dialog.setInsets(0, 0, 0); 
Dialog.addMessage("MT: Fibrosis in Masson Trichrome");
Dialog.setInsets(0, 0, 0); 
Dialog.addMessage("None: No analysis");
analysisItems = newArray("HnE", "MT", "None");
Dialog.setInsets(0, 0, 0); 
Dialog.setInsets(0, 0, 0); 
Dialog.addRadioButtonGroup("Analysis which you are", analysisItems, 1, 2, "MT");

Dialog.setInsets(0, 0, 0); 
Dialog.addMessage("----------------------------------------------------------------------------"); 
Dialog.setInsets(0, 0, 0); 
Dialog.addNumber("Trim end of file name (without file extension)", 8, 0, 2, "char");
Dialog.setInsets(0, 0, 0); 
Dialog.addMessage("If file is end with '_Caption.tif' input 8");

Dialog.setInsets(0, 0, 0); 
Dialog.addMessage("----------------------------------------------------------------------------"); 
Dialog.setInsets(0, 0, 0); 
Dialog.addCheckbox("Do you want to set threshold?", false);
Dialog.addSlider("Threshold min:", 0, 255, 0);
Dialog.addSlider("Threshold max:", 0, 255, 255);

Dialog.show();

// get information in dialog
startOption = Dialog.getRadioButton();
tissueOption = Dialog.getRadioButton();
analysisOption = Dialog.getRadioButton();
isThreshold = Dialog.getCheckbox();
fileNameEndTrim = Dialog.getNumber();

// macro setting by user-setting
if (isThreshold == 1) {
	
	// Threshold minimum and maximum in user-set
	tmin = Dialog.getNumber();
	tmax = Dialog.getNumber();
	
} else if (tissueOption == "femora")  {
	
	// Selection area
	sWidth = 2500;
	sHeight = 2500;
	
	if (analysisOption == "HnE") {
		// Threshold minimum and maximum in pre-set
		tmin = 80;
		tmax = 210;
	} else if (analysisOption == "MT") {
		// Threshold minimum and maximum in pre-set
		tmin = 110;
		tmax = 255;
	} else {
	}

	
} else if (tissueOption == "calvarium")  {
	
	// Selection area
	sWidth = 6000;
	sHeight = 2000;
	
	if (analysisOption == "HnE") {
		// Threshold minimum and maximum in pre-set
		tmin = 20;
		tmax = 200;
	} else if (analysisOption == "MT") {
		// Threshold minimum and maximum in pre-set
		tmin = 110;
		tmax = 255;
	} else {
	}
	
} else {
}
// End of dialog ///////////////////////////////////////


// column header
print("width: "+sWidth+", height: "+sHeight);
print("Basic protocol");
print("1. Image source: tiff files exported from mrxs(3DHISTECH Ltd.) by ParanormicViewer");
print("2. Image Scale: large(5000 x 5000 in femur image or 4000 x 12000 in calvaria), resize(25% x 25%)");
print("3. Colour deconvolution: H&E -> Colour_2 for cytosol area (hematoxylin stain)");
print("4. Calculation of stained Area = (Area*pArea)/(sArea*spArea*10000)");
print("name", "\t", "sArea", "\t", "sMean", "\t", "spArea", "\t", "area", "\t", "mean", "\t", "pArea", "\t", "stainedArea", "\t", "integratedDensity");

// select target directory 
dir = getDirectory("Choose a Directory");

// analysis
bone_Analysis(dir, startOption);

// report
dataDir = dir+"/data";
File.makeDirectory(dataDir);

selectWindow("Log");
saveAs("Text", dataDir +"results" + ".txt"); 
close("Log");

// start of main function ///////////////////////////////////////
function bone_Analysis(directory, startOption){
	
	// Listing image file
	fl = getFileType(directory, 'tif', false);
	
	// Load dialog for skipping
	Dialog.create("Skip option");
	
	Dialog.addMessage("Where are you want to jump? 0 means non-skip")
	Dialog.addMessage("View list of files in log window")
	print("file no \t file name");
	for(l=0;l<fl.length;l++){
		print(l+" \t "+fl[l]);
	}
	Dialog.addMessage("\n")
	Dialog.addSlider("Threshold min:", 0, fl.length, 0);
	Dialog.show();
	
	i = Dialog.getNumber();	

	// Setting results variables
	sArea=0;
	sMean=0;
	spArea=0;

	for (i;i<fl.length;i++) {
			
		// Image manipulation and analysis
		if (startOption == 1){
			
		lengthName = lengthOf(fl[i]);
		fileName = substring(fl[i], 0, lengthName-fileNameEndTrim-4);
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
		rename(rotateName);	
		
		// Rotate dialog ///////////////
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
		
		// Rotate dialog2 ///////////////
		//Create addnumber
		Dialog.create("Rotation option");
		Dialog.addMessage("Input rotation degree");
		Dialog.addNumber("Degree: ", 0);
		Dialog.show();

		run("Rotate... ", "angle="+Dialog.getNumber()+" grid=1 interpolation=Bilinear");

		// Rotate dialog3 ///////////////
		//Create addnumber
		Dialog.create("Rotation option");
		Dialog.addMessage("Input rotation degree");
		Dialog.addNumber("Degree: ", 0);
		Dialog.show();

		run("Rotate... ", "angle="+Dialog.getNumber()+" grid=1 interpolation=Bilinear");		
		
		//run("Rotate...");			
		makeRectangle(4536, 2220, sWidth, sHeight);
		waitForUser("Select ROI in image");
		run("Copy to System", "stack");
		run("System Clipboard", "stack");
		selectWindow("Clipboard");			
		rename(expName);

		// Save images		
		rotDir = directory+"Rotate";
		File.makeDirectory(rotDir);
		selectWindow(rotateName);			
		saveAs("Tiff", rotDir+"/"+rotateName+".tif");
		close();
		
		expDir = directory+"/Large";
		File.makeDirectory(expDir);
		saveAs("Tiff", expDir+"/"+expName+".tif");
		run("Duplicate...", " ");
		
		resizeDir = directory+"/Large_resize";
		File.makeDirectory(resizeDir);
		rename(resizeName);
		run("Size...", "width=1250 height=1250 constrain average interpolation=Bilinear");
		saveAs("Tiff", resizeDir+"/"+resizeName+".tif");
		close();

		
		// Direct analysis
		} else if (startOption == 2) {
			open(fl[i]);
			imageName = getTitle();
			lengthName = lengthOf(imageName);
			expName = substring(imageName, 0, lengthName-fileNameEndTrim-4);
			expDir = directory;
			selectName = expName+"_select";
		}
		
		// HnE analysis
		if (analysisOption == "HnE") {
			selectWindow(expName+".tif");
			setTool("polygon");
			waitForUser("Select implant area in image");
			
			run("Create Mask");
			run("Measure");
			sArea = getResult("Area",0);
			sMean = getResult("Mean",0);
			spArea = getResult("%Area",0);
			close("Mask");
			close("Results");
			selectWindow(expName+".tif");
			run("Copy");
			run("Internal Clipboard");
			selectWindow("Clipboard");			
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

			print(expName, sArea, sMean, spArea, Area, Mean, pArea, stainedArea, integratedDensity);

			// save images
			analysisDir = expDir+"/HnEAnalysis/";
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
			close(expName+".tif");
		
		// Masson trichrome analysis
		} else if (analysisOption == "MT") {
			selectWindow(expName+".tif");
			setTool("polygon");
			waitForUser("Select implant area in image");
			
			run("Create Mask");
			run("Measure");
			sArea = getResult("Area",0);
			sMean = getResult("Mean",0);
			spArea = getResult("%Area",0);
			close("Mask");
			close("Results");
			selectWindow(expName+".tif");
			run("Copy");
			run("Internal Clipboard");
			
			selectWindow(expName+".tif");
			close(expName+".tif");
			
			selectWindow("Clipboard");		
			rename(selectName);

			run("Colour Deconvolution", "vectors=[Masson Trichrome]");
			selectWindow(selectName+"-(Colour_2)");
			close(selectName+"-(Colour_2)");
			selectWindow(selectName+"-(Colour_3)");
			close(selectName+"-(Colour_3)");
			selectWindow("Colour Deconvolution");
			close("Colour Deconvolution");

			analysisDir = expDir+"/fibrosisAnalysis/";
			File.makeDirectory(analysisDir);		
			selectWindow(selectName);
			saveAs("Tiff", analysisDir+"/"+selectName+".tif");
			close();
			
			selectWindow(selectName+"-(Colour_1)");
			rename(selectName+"_hem");
			run("Duplicate...", " ");
			selectWindow(selectName+"_hem");
			saveAs("Tiff", analysisDir+"/"+selectName+"_hem.tif");
			close();
			
			selectWindow(selectName+"_hem-1");
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

			print(expName, sArea, sMean, spArea, Area, Mean, pArea, stainedArea, integratedDensity);

			// save images
			selectWindow(selectName+"_hem_thr");
			saveAs("Tiff", analysisDir+"/"+selectName+"_hem_thr.tif");
			close();
		} else if (analysisOption == "None") {
			close();
		}
	}
}
// end of main function ///////////////////////////////////////



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