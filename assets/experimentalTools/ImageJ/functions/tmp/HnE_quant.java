/////////////////////////////////////////////////////////////////////////////////////////////
// start of macro

// setting threshold
threshold_min = 80;
threshold_max = 210;

// column header
print("name", "\t", "area", "\t", "mean", "\t", "min", "\t", "max", "\t", "std");


dir = getDirectory("Choose a Directory");

// function for analysis HnE with red blood cells
function HnE_Analysis(directory){
	fl = getFileList(dir);
	for (i=0;i<fl.length;i++) {
		if (endsWith(fl[i], ".tif"))
			open(fl[i]);
			dir = getDirectory("image");
			name = getTitle;

			lengthName = lengthOf(name);
			fileName = substring(name, 0, lengthName-4);
			newName = fileName+"_threshold";

			run("Colour Deconvolution", "vectors=H&E");
			selectWindow(name+"-(Colour_2)");
			rename(fileName+"_hematoxylin");
			run("Duplicate...", " ");
			rename(fileName+"_hematoxylin_threshold")
			setThreshold(threshold_min, threshold_max);
			setOption("BlackBackground", false);
			run("Convert to Mask");
			getStatistics(area, mean, min, max, std, histogram);
			print(name, "\t", area, "\t", mean, "\t", min, "\t", max, "\t", std);

			// save images
			selectWindow(fileName+"_hematoxylin");
			saveAs("Tiff", dir+fileName+"_hematoxylin.tiff");
			close()

			selectWindow(fileName+"_hematoxylin_threshold");
			saveAs("Tiff", dir+fileName+"_hematoxylin_threshold.tiff");
			close()

			close(name+"-(Colour_1)");
			close(name+"-(Colour_3)");
			close("Colour Deconvolution");
			close(name);
	}
}

HnE_Analysis(dir);

selectWindow("Log");
saveAs("Text", dir +"results" + ".txt"); 
close("Log");

// end of macro
/////////////////////////////////////////////////////////////////////////////////////////////
