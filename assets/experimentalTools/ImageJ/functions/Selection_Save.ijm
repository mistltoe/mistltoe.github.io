filename = getTitle();
makeRectangle(0, 0, 1000, 1000);
waitForUser("Select?");
run("Copy");
run("Internal Clipboard");
saveAs("Tiff", "select1_"+filename);
close("select1_"+filename);

run("Line Width...", "line=10");
run("Draw", "slice");	

makeRectangle(0, 0, 1000, 1000);
waitForUser("Select?");
run("Copy");
run("Internal Clipboard");
saveAs("Tiff", "select2_"+filename);
close("select2_"+filename);

run("Line Width...", "line=10");
run("Draw", "slice");	
saveAs("Tiff", "draw_"+filename);	
close("draw_"+filename);