// https://github.com/stoeter/Fiji-Tools-for-HCS/blob/master/Development/Functions/getFileType.ijm
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
