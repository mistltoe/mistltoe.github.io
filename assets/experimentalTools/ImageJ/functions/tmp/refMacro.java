/////////////////////////////////////////////////////////////////////////////////////
// 참고용 마크로
// https://forum.image.sc/t/using-duplicates-in-imagej-macros/992/6
macro "select area  [f1]"{
original = getImageID();
run("Duplicate...", " ");
copy = getImageID();
run("Subtract Background...", "rolling=25 light");
run("Smooth");
setMinAndMax(19, 237);

run("Scale...", "x=.1 y=.1 interpolation=Bilinear average create title=ScaledDown.tif");
run("8-bit");
setAutoThreshold("Li");
run("Convert to Mask");
run("Analyze Particles...", "size=50000-Infinity circularity=0.10-1.00 show=Masks exclude include in_situ");
setThreshold(133, 255);
run("Create Selection");
run("Enlarge...", "enlarge=-6");
run("Scale... ", "x=10 y=10");
run("Properties... ", "name=[Mask] position=none stroke=green width=0 fill=none");		
run("Add to Manager");
Mask = roiManager("count")-1;


selectWindow(' .tif');
roiManager("Select", mask);
run("Set Measurements...", "area bounding area_fraction display add redirect=None decimal=3");
run("Measure");

setBackgroundColor(255, 255, 255);
run("Clear Outside");

}


macro "deconvolution  [f2]"{ 
run("Colour Deconvolution", "vectors=[H DAB]");
selectWindow(".tif-(Colour_1)");
run("Duplicate...", "title=NSelection.tif");
setThreshold(0, 210);
run("Convert to Mask");
setOption("BlackBackground", false);
run("Convert to Mask");
run("Fill Holes");
run("Make Binary");
run("Convert to Mask");
run("Analyze Particles...", "size=0-3500 circularity=0.00-1.00 show=Masks display exclude include summarize in_situ");
run("Create Selection");
run("Properties... ", "name=[NSelection] position=none stroke=green width=0 fill=none");		
run("Add to Manager");
run("Select None");


}

macro "analysis  [f3]"{ 

selectWindow(".tif-(Colour_2)");
run("Duplicate...", " "); 
rename("Colour_2-smoothing")
run("Gaussian Blur...", "sigma=20");
run("Invert");
imageCalculator("Add", "Colour_2-smoothing","OriginalTissue.tif-(Colour_2)");
run("Duplicate...", " "); // duplicate DAB (originalTissue.tif-(colour_2)-1
rename("Colour_2-smoothing-thresholded")
setAutoThreshold("RenyiEntropy");
run("Convert to Mask");

imageCalculator("AND create", "Colour_2-smoothing-thresholded","NucleusSelection.tif");
rename("Filtered.tif");
selectWindow("Filtered.tif");
run("Make Binary");
rename("analyzed.tif");
run("Analyze Particles...", "size=10-80 circularity=0.01-1.00 show=Masks display exclude include summarize in_situ");
run("Make Binary");
run("Create Selection");
run("Properties... ", "name=[Filtered] position=none stroke=green width=0 fill=none");		
run("Add to Manager");
run("Select None");

selectWindow("Colour_2-smoothing-thresholded"); 
run("Make Binary");
rename(getImageID + "Particles analyzed-smoothed.tif");
run("Analyze Particles...", "size=10-80 circularity=0.01-1.00 show=Masks display exclude include summarize in_situ");
run("Make Binary");
run("Create Selection");
run("Properties... ", "name=[Smooth] position=none stroke=green width=0 fill=none");		
run("Add to Manager");
run("Select None");
run("Close All");
}


// http://imagej.1557.x6.nabble.com/Saving-Log-window-as-a-csv-file-but-not-a-txt-file-td5012505.html
run("Input/Output...", "jpeg=100 gif=-1 file=.csv copy_column copy_row save_column save_row"); 

// http://imagej.1557.x6.nabble.com/How-to-save-log-files-statistics-using-macro-help-td4999708.html
// A better way to do this is to write the values and counts to the Results window and then save it. Here is an example : 

  if (bitDepth==8) run("16-bit"); 
  getHistogram (values, counts, 32); 
  run("Clear Results"); 
  for(i=0; i< values.length; i++) { 
     setResult("Bin Start", i, values[i]); 
     setResult("Count", i, counts[i]); 
  } 
  updateResults; 
  path = getDirectory("home") + "counts.txt"; 
  saveAs("Results", path); 

If the images are all the same size, open them as a virtual stack and run this macro: 

  run("Clear Results"); 
  for (img=1; img<=nSlices; img++) { 
     setSlice(img); 
     getHistogram(values, counts, 32); 
     for(i=0; i< values.length; i++) { 
        setResult("Image", i, img); 
        setResult("Bin Start", i, values[i]); 
        setResult("Count", i, counts[i]); 
      } 
  } 
  updateResults; 
  path = getDirectory("home") + "counts.txt"; 
  saveAs("Results", path); 


  // If the images are all the same size, open them as a virtual stack and run this macro: 

  run("Clear Results"); 
  for (img=1; img<=nSlices; img++) { 
     setSlice(img); 
     getHistogram(values, counts, 32); 
     for(i=0; i< values.length; i++) { 
        setResult("Image", i, img); 
        setResult("Bin Start", i, values[i]); 
        setResult("Count", i, counts[i]); 
      } 
  } 
  updateResults; 
  path = getDirectory("home") + "counts.txt"; 
  saveAs("Results", path);  
  
  
// You can open a folder of images as a virtual stack by dragging it onto the "ImageJ" window and checking "Use virtual stack" in the dialog. With 8-bit images, this macro requires the 1.47b 
// daily build, which fixes a bug that caused the getHistogram() macro function to not work if the number of bins was not 256. 
// Use this macro if the images are not all the same size: 

  dir = getDirectory("Choose a Directory "); 
  list = getFileList(dir); 
  run("Clear Results"); 
  setBatchMode(true); 
  row = 0; 
  for (i=0; i<list.length; i++) { 
     showProgress(i, list.length); 
     open(dir+list[i]); 
     getHistogram(values, counts, 32); 
     for(bin=0; bin< values.length; bin++) { 
        setResult("Label", row, list[i]); 
        setResult("Bin", row, bin+1); 
        setResult("Bin Start", row, values[bin]); 
        setResult("Count", row, counts[bin]); 
        row++; 
      } 
      close; 
  } 
  setOption("ShowRowNumbers", false); 
  updateResults; 
  path = getDirectory("home") + "counts.txt"; 
  saveAs("Results", path); 

// so you want to have one data column for each image file? 
// You can easily modify Wayne's macro: 

  dir = getDirectory("Choose a Directory "); 
  list = getFileList(dir); 
  run("Clear Results"); 
  setBatchMode(true); 
  row = 0; 
  for (i=0; i<list.length; i++) { 
     showProgress(i, list.length); 
     open(dir+list[i]); 
     getHistogram(values, counts, 32, 0, 255); 
     for(bin=0; bin< values.length; bin++) { 
        //setResult("Label", row, list[i]); 
        row = bin; 
        if (i==0) { 
           setResult("Bin", row, bin+1); 
           setResult("Bin Start", row, values[bin]); 
        } 
        setResult(list[i], row, counts[bin]); 
        // alternatively: 
        //setResult(File.nameWithoutExtension, row, counts[bin]); 
        row++; 
      } 
      close; 
  } 
  setOption("ShowRowNumbers", false); 
  updateResults; 
  path = getDirectory("home") + "counts.txt"; 
  saveAs("Results", path); 




