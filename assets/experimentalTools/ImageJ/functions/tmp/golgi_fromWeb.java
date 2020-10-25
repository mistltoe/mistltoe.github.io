// https://forum.image.sc/t/how-to-combine-a-macro-with-manual-commands/372
// I’d like to draw a polygonal outline around the cells and create a mask. ImageJ shall count the number of cells (if possible?!) and tell me how many vesicles were found in cell 1, 2 and 3. After that I’d like to do the same kind of thing but with the Golgi - instead of the whole cell.
 // Right now I wrote I macro for counting the total number of particles in the image (as shown below).



run("Close All");
run("Options...", "iterations=1 count=1 black edm=Overwrite");


// Choose a directory that contains nothing but the source images
dir = getDirectory("Take your pick...");

list = getFileList(dir);

resultPath = dir + File.separator + "Edited"

File.makeDirectory(resultPath);

fileWithoutEnding = "";

for (i=0; i<list.length; i++) {
	fileName = list[i];
	fileWithoutEnding = replace(fileName, "\\.[A-Za-z]+$", "");
	
	path = dir+fileName;
	
	if (!File.isDirectory(path)) {
		
		// Edit the Golgi channel.
		open(path);
		run("Z Project...", "projection=[Max Intensity]");
		run("Duplicate...", "duplicate channels=2");
		run("Gaussian Blur...", "sigma=5 scaled");
		run("Auto Threshold", "method=Otsu white");
		run("Make Binary");
		golgiRawFile = fileWithoutEnding + "_1_Golgi Raw" + ".tif";
		saveAs("Tiff", resultPath + File.separator + golgiRawFile);
		
		// Edit the vWF channel		
		open(path);
		run("Z Project...", "projection=[Max Intensity]");
		run("Duplicate...", "duplicate channels=3");
		maxRedFile = fileWithoutEnding + "_2_Max Red_" + ".tif";
		saveAs("Tiff", resultPath + File.separator + maxRedFile);
		run("Subtract Background...", "rolling=8");
		run("Median...", "radius=2"); 
		run("Auto Threshold", "method=Moments white");
		run("Watershed Irregular Features", "erosion=20");
		run("Make Binary");
		vwfRawFile = fileWithoutEnding + "_3_VWF Raw" + ".tif";
		saveAs("Tiff", resultPath + File.separator + vwfRawFile);



		// Show all particles that are only in the Golgi network
		imageCalculator("min create", vwfRawFile, golgiRawFile);
		vwfGolgiFile = fileWithoutEnding + "_4a_VWF Golgi" + ".tif";
		saveAs("Tiff", resultPath + File.separator + vwfGolgiFile);

		// Define the size of your objects of interest (Golgi):
		selectWindow(vwfGolgiFile);

		// TO DO: Draw the shape of a Golgi with polygon tool (by hand)


		
		// Select round vWF (Golgi area)
		run("Analyze Particles...", "size=0.1-2.5 circularity=0.75-1.00 clear summarize add"); 
		run("From ROI Manager");
		run("Flatten");
		vwfCircleGolgiFile = fileWithoutEnding + "_4b_VWF circle Golgi" + ".tif";
		saveAs("Tiff", resultPath + File.separator + vwfCircleGolgiFile);
		selectWindow(vwfGolgiFile);
		// Select elongated vWF (Golgi area)
		run("Analyze Particles...", "size=0-infinity circularity=0.0-0.74 clear summarize add"); 
		run("From ROI Manager");
		run("Flatten");
		vwfElongGolgiFile = fileWithoutEnding + "_4c_VWF elong Golgi" + ".tif";
		saveAs("Tiff", resultPath + File.separator + vwfElongGolgiFile);

		
		// TO DO: Draw the shape of a cell with polygon tool (by hand)

		
		// Define the size of your objects of interest (total):
		selectWindow(vwfRawFile);
		// Select round vWF (total)
		run("Analyze Particles...", "size=0.1-2.5 circularity=0.75-1.00 clear summarize add"); 
		run("From ROI Manager");
		run("Flatten");
		vwfCircleFile = fileWithoutEnding + "_5a_VWF circle" + ".tif";
		saveAs("Tiff", resultPath + File.separator + vwfCircleFile);
		selectWindow(vwfRawFile);
		// Select elongated vWF (total)
		run("Analyze Particles...", "size=0-infinity circularity=0.0-0.81 clear summarize add"); 
		run("From ROI Manager");
		run("Flatten");
		vwfElongFile = fileWithoutEnding + "_5b_VWF elong" + ".tif";
		saveAs("Tiff", resultPath + File.separator + vwfElongFile);


		// Define the size of your objects of interest (total):
		imageCalculator("xor create", vwfRawFile, vwfGolgiFile);
		vwfCytoFile = fileWithoutEnding + "_6a_VWF cytoplasm" + ".tif";
		saveAs("Tiff", resultPath + File.separator + vwfCytoFile);
		selectWindow(vwfCytoFile);
		// Select round vWF (Cytoplasm)
		run("Analyze Particles...", "size=0.1-2.5 circularity=0.75-1.00 clear summarize add"); 
		run("From ROI Manager");
		run("Flatten");
		vwfCircleCytoFile = fileWithoutEnding + "_6b_VWF circle cytoplasm" + ".tif";
		saveAs("Tiff", resultPath + File.separator + vwfCircleCytoFile);
		selectWindow(vwfCytoFile);
		// Select elongated vWF (Cytoplasm)
		run("Analyze Particles...", "size=0-infinity circularity=0.0-0.81 clear summarize add"); 
		run("From ROI Manager");
		run("Flatten");
		vwfElongCytoFile = fileWithoutEnding + "_6c_VWF elong cytoplasm" + ".tif";
		saveAs("Tiff", resultPath + File.separator + vwfElongCytoFile);

		// TO DO: Subtract counts that are in 'round' and 'elongated'
		
		
		print("Edited: " + fileName);
		
		run("Close All");
	}
}

selectWindow("Summary");
resultFile = resultPath + File.separator + fileWithoutEnding + "_7_Summary" + ".xls";
run("Text...", "save=["+ resultFile +"]");
	
print("All images edited.");