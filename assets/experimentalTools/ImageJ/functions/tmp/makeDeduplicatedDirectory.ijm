dir = getDirectory("Choose a Directory");

analysisDir = makeDedupDirectory(dir, "HnE_Analysis/");

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
print(analysisDir);