aa = newArray(1,4,7,4,8,9);

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

// get minimum value in array 
function getmin(inputarray) {
	for (k=0;k<inputarray.length;k++) {
		if (k ==0) {
			min = inputarray[0];
		} else {
			min = minOf(min, inputarray[k]);
		}
	}
	return(min);
}

// get array from text file
// http://imagej.1557.x6.nabble.com/read-values-from-txt-file-td3689457.html
function arrayfromtxt(
	pathfile=File.openDialog("Choose the file to Open:"); 
	filestring=File.openAsString(pathfile); 
	rows=split(filestring, "\n"); 
	x=newArray(rows.length); 
	y=newArray(rows.length); 
	for(i=0; i<rows.length; i++){ 
		columns=split(rows[i],"\t"); 
		x[i]=columns[0]; 
		y[i]=parseInt(columns[1]); 
	} 
	Array.print(x);
	Array.print(y);
)

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