/////////////////////////////////////////////////////////////////////////////////////////////
// start of macro

// Run recorder
run("Record...");

// start of dialog ///////////////////////////////////////
// Load dialog for user-set
Dialog.create("Analysis option");

Dialog.addMessage("Need high capacity of RAM, minimum: 16 GB, recommeneded: 32 GB")

Dialog.addMessage("\n");
Dialog.addMessage("1. Tiled tiff image export from mrxs(3DHISTECH Ltd.)");
Dialog.addMessage("2. Tiff image: read for analysis");

startItems = newArray("1", "2");
Dialog.addRadioButtonGroup("Start where you are?", startItems, 1, 2, "2");

Dialog.addMessage("\n");
targetTissue = newArray("femora", "calvarium");
Dialog.addRadioButtonGroup("Analysis which you are", targetTissue, 1, 2, "femora");

Dialog.addMessage("\n");
Dialog.addMessage("HnE: Hematoxylin in HnE");
Dialog.addMessage("MT: Fibrosis in Masson Trichrome");
analysisItems = newArray("HnE", "MT");
Dialog.addRadioButtonGroup("Analysis which you are", analysisItems, 1, 2, "HnE");

Dialog.addMessage("\n");
Dialog.addNumber("Trim end of file name (without file extension)", 0, 0, 2, "char");

Dialog.addMessage("\n");
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
	sWidth = 5000;
	sHeight = 5000;
	
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

	
} else if (analysisOption == "calvarium")  {
	
	// Selection area
	sWidth = 12000;
	sHeight = 4000;
	
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
	fl = getFileList(directory);

	// Setting results variables
	sArea=0;
	sMean=0;
	spArea=0;

	for (i=0;i<fl.length;i++) {
		if (endsWith(fl[i], ".tif")) {
			
			// Image manipulation and analysis
			if (startOption == 1){
				
			lengthName = lengthOf(fl[i]);
			fileName = substring(fl[i], 0, lengthName-fileNameEndTrim-4);
			expName = fileName+"_large";
			resizeName = expName+"_resize";
			selectName = expName+"_select";

			// Open image and select ROI(region of interest)
			run("Bio-Formats Importer", "check_for_upgrades open="+ directory+fl[i] +" autoscale color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
			name = getTitle;

			
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
				if (Dialog.getCheckbox() == 0)
				run("Flip Horizontally");
				if (Dialog.getCheckbox() == 0)
				run("Flip Vertically");
				if (Dialog.getCheckbox() == 0)
				run("Rotate 90 Degrees Right");
				if (Dialog.getCheckbox() == 0)
				run("Rotate 90 Degrees Left");
			}		
			
			run("Grid...", "grid=Lines area=50000000000 color=Cyan bold center");
			run("Rotate... ");
			
			makeRectangle(4536, 2220, sWidth, sHeight);
			waitForUser("Select ROI in image");
			run("Copy to System");
			run("System Clipboard");
			selectWindow("Clipboard");			
			rename(expName);

			// Save images
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
			
			rotDir = directory+"/Rotate";
			File.makeDirectory(rotDir);
			selectWindow(name);
			saveAs("Tiff", rotDir+"/"+name+"_rotate.tif");
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
				rename(selectName+"_hematoxylin");
				run("Duplicate...", " ");
				rename(selectName+"_hematoxylin_threshold");
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
				analysisDir = makeDedupDirectory(expDir+"HnEAnalysis/)";
				
				selectWindow(selectName);
				saveAs("Tiff", analysisDir+"/"+selectName+".tif");
				close();
				
				selectWindow(selectName+"_hematoxylin");
				saveAs("Tiff", analysisDir+"/"+selectName+"_hematoxylin.tif");
				close();

				selectWindow(selectName+"_hematoxylin_threshold");
				saveAs("Tiff", analysisDir+"/"+selectName+"_hematoxylin_threshold.tif");
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
				selectWindow("Clipboard");			
				rename(selectName);

				run("Colour Deconvolution", "vectors=[Masson Trichrome]");
				selectWindow(selectName+"-(Colour_1)");
				rename(selectName+"_hematoxylin");
				run("Duplicate...", " ");
				rename(selectName+"_hematoxylin_threshold");
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
				analysisDir = expDir+"HnEAnalysis/";

				selectWindow(selectName);
				saveAs("Tiff", analysisDir+"/"+selectName+".tif");
				close();
				
				selectWindow(selectName+"_hematoxylin");
				saveAs("Tiff", analysisDir+"/"+selectName+"_hematoxylin.tif");
				close();

				selectWindow(selectName+"_hematoxylin_threshold");
				saveAs("Tiff", analysisDir+"/"+selectName+"_hematoxylin_threshold.tif");
				close();

				close(selectName+"-(Colour_2)");
				close(selectName+"-(Colour_3)");
				close("Colour Deconvolution");
				close(expName+".tif");
			}
		}
	}
}
// end of main function ///////////////////////////////////////

// make deduplicated directory
function makeDedupDirectory(dir, subdir) {
	list = getFileList(dir);
	existDirList = newArray(list.length);
	count = 0;
	existDirString = "\n";
	
	for (i=0; i<list.length; i++) {
		//print(list[i]);
		if (File.isDirectory(dir+list[i]) == 1) {
			existDirList[count] = list[i];
			if(count%2 != 1) {
				existDirString = existDirString+list[i]+";";
			} else {
				existDirString = existDirString+list[i]+";\n";
			}
			
			count++;
		} 
	}
	existDirList = Array.slice(existDirList, 0, count);
	
	for (j=0; j<existDirList.length; j++) {
		
		if(existDirList[j] == subdir) {
		
		Dialog.create("Directory exist !!!");
		Dialog.addMessage("Overwrite? or New name? or Choose new directory?");
		fileItems = newArray("overwrite", "newname", "choose");
		Dialog.addRadioButtonGroup("\tWhat are you want?", fileItems, 1, 3, "newname");

		Dialog.addMessage("\nIf you select newname");
		Dialog.addMessage("Existed directory: "+existDirString);
		Dialog.addMessage("Insert new name");
		Dialog.addString("New name: ", "");
		
		Dialog.show();

		fileDest = Dialog.getRadioButton();
		
			if(fileDest == "overwrite") {
				finalDir = dir+subdir;
			} else if (fileDest == "newname") {
				finalDir = dir+Dialog.getString();
				
			} else if (fileDest == "choose") {
				finalDir = getDirectory("Choose a Directory");
			} else {
				exit();
			}
		break;
				
		} else {
			finalDir = dir+subdir;
		}
	}
	File.makeDirectory(finalDir);
	return finalDir;
}

// end of macro
/////////////////////////////////////////////////////////////////////////////////////////////