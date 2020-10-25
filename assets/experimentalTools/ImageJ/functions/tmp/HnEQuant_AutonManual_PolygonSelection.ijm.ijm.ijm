/////////////////////////////////////////////////////////////////////////////////////////////
// start of macro

// setting threshold
threshold_min = 80;
threshold_max = 210;

// column header
print("Basic protocol")
print("1. Image source: tiff files exported from mrxs(3DHISTECH Ltd.) by ParanormicViewer");
print("2. Image Scale: large(5000 x 5000), resize(25% x 25%)");
print("3. Colour deconvolution: H&E -> Colour_2 for cytosol area (hematoxylin stain)");
print("4. Calculation of stained Area = (Area*pArea)/(sArea*spArea*10000)");
print("name", "\t", "sArea", "\t", "sMean", "\t", "spArea", "\t", "area", "\t", "mean", "\t", "pArea", "\t", "stainedArea", "\t", "integratedDensity");

dir = getDirectory("Choose a Directory");

// function for analysis HnE with red blood cells
function HnE_Analysis(directory){
	fl = getFileList(directory);
	
	// setting results variables
	sArea=0;
	sMean=0;
	spArea=0;

	for (i=0;i<fl.length;i++) {
		if (endsWith(fl[i], ".tif")) {
			open(fl[i]);
			name = getTitle;

			lengthName = lengthOf(name);
			fileName = substring(name, 0, lengthName-4);
			newName = fileName+"_threshold";
			selectName = fileName+"_select";
			
			setTool("polygon");
			waitForUser;
			
			run("Create Mask");
			run("Measure");
			sArea = getResult("Area",0);
			sMean = getResult("Mean",0);
			spArea = getResult("%Area",0);
			close("Mask");
			close("Results");
			selectWindow(name);
			run("Copy");
			run("Internal Clipboard");
			selectWindow("Clipboard");			
			rename(selectName);

			run("Colour Deconvolution", "vectors=H&E");
			selectWindow(selectName+"-(Colour_2)");
			rename(selectName+"_hematoxylin");
			run("Duplicate...", " ");
			rename(selectName+"_hematoxylin_threshold");
			setThreshold(threshold_min, threshold_max);
			setOption("BlackBackground", false);
			run("Convert to Mask");
			
			run("Measure");
			Area = getResult("Area",0);
			Mean = getResult("Mean",0);
			pArea = getResult("%Area",0);
			integratedDensity = getResult("RawIntDen",0);
			stainedArea = (Area*pArea)/(sArea*spArea*10000);
			close("Results");

			print(name, sArea, sMean, spArea, Area, Mean, pArea, stainedArea, integratedDensity);

			// save images
			selectWindow(selectName);
			saveAs("Tiff", directory+selectName+".tiff");
			close();
			
			selectWindow(selectName+"_hematoxylin");
			saveAs("Tiff", directory+selectName+"_hematoxylin.tiff");
			close();

			selectWindow(selectName+"_hematoxylin_threshold");
			saveAs("Tiff", directory+selectName+"_hematoxylin_threshold.tiff");
			close();

			close(selectName+"-(Colour_1)");
			close(selectName+"-(Colour_3)");
			close("Colour Deconvolution");
			close(name);
		}
	}
}

HnE_Analysis(dir);

selectWindow("Log");
saveAs("Text", dir +"results" + ".txt"); 
close("Log");

// end of macro
/////////////////////////////////////////////////////////////////////////////////////////////
