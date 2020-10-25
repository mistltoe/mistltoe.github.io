/////////////////////////////////////////////////////////////////////////////////////////////
// start of macro

// Run recorder
run("Record...");

// Settings
tmin = 110;
tmax = 255;

fileNameEndTrim = 4;

sHeight = 5000;
sWidth = 5000;

// column header
print();
print("Basic protocol")
print("1. Image source: tiff files exported from mrxs(3DHISTECH Ltd.) by ParanormicViewer");
print("2. Image Scale: large(5000 x 5000 in femur image or 4000 x 12000 in calvaria), resize(25% x 25%)");
print("3. Colour deconvolution: H&E -> Colour_2 for cytosol area (hematoxylin stain)");
print("4. Calculation of stained Area = (Area*pArea)/(sArea*spArea*10000)");
print("name", "\t", "sArea", "\t", "sMean", "\t", "spArea", "\t", "area", "\t", "mean", "\t", "pArea", "\t", "stainedArea", "\t", "integratedDensity");

dir = getDirectory("Choose a Directory");

bone_Analysis(dir);

dataDir = dir+"/data";
File.makeDirectory(dataDir);

selectWindow("Log");
saveAs("Text", dataDir +"results" + ".txt"); 
close("Log");


// function for analysis HnE with red blood cells
function bone_Analysis(directory){
	
	fl = getFileList(directory);

	// Export directory
	expDir = directory+"/Large";
	rotDir = directory+"/Rotate";	
	HnEDir = expDir+"/fibrosisAnalysis";
	resizeDir = directory+"/Large_resize";

	File.makeDirectory(expDir);
	File.makeDirectory(rotDir);
	File.makeDirectory(HnEDir);
	File.makeDirectory(resizeDir);

	// setting results variables
	sArea=0;
	sMean=0;
	spArea=0;

	for (i=0;i<fl.length;i++) {
		if (endsWith(fl[i], ".tif")) {
				
			lengthName = lengthOf(fl[i]);
			fileName = substring(fl[i], 0, lengthName-fileNameEndTrim);
			expName = fileName+"_large";
			resizeName = expName+"_resize";
			selectName = expName+"_select";

			// Open image and select ROI(region of interest)
			run("Bio-Formats Importer", "check_for_upgrades open="+ directory+fl[i] +" autoscale color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
			name = getTitle;

			run("Grid...", "grid=Lines area=50000000000 color=Cyan bold center");
			run("Rotate... ");
			run("Grid...", "grid=Lines area=50000000000 color=Cyan bold center");
			run("Rotate... ");
			
			makeRectangle(4536, 2220, sHeight, sWidth);
			waitForUser("Select ROI in image");
			run("Copy to System");
			run("System Clipboard");
			selectWindow("Clipboard");			
			rename(expName);

			// Save images
			saveAs("Tiff", expDir+"/"+expName+".tif");
			run("Duplicate...", " ");
			rename(resizeName);
			run("Size...", "width=1250 height=1250 constrain average interpolation=Bilinear");
			saveAs("Tiff", resizeDir+"/"+resizeName+".tif");
			close();
			selectWindow(name);
			saveAs("Tiff", rotDir+"/"+name+"_rotate.tif");
			close();

			// HnE analysis
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

			print(fileName, sArea, sMean, spArea, Area, Mean, pArea, stainedArea, integratedDensity);

			// save images
			selectWindow(selectName);
			saveAs("Tiff", HnEDir+"/"+selectName+".tif");
			close();
			
			selectWindow(selectName+"_hematoxylin");
			saveAs("Tiff", HnEDir+"/"+selectName+"_hematoxylin.tif");
			close();

			selectWindow(selectName+"_hematoxylin_threshold");
			saveAs("Tiff", HnEDir+"/"+selectName+"_hematoxylin_threshold.tif");
			close();

			close(selectName+"-(Colour_2)");
			close(selectName+"-(Colour_3)");
			close("Colour Deconvolution");
			close(expName+".tif");
		}
	}
}

// end of macro
/////////////////////////////////////////////////////////////////////////////////////////////