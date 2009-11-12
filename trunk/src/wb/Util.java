package wb;

import java.io.FileWriter;
import java.io.IOException;

public class Util {

	public static String WirteParamsFile(String params, String jobName) {
		
	   String filePath = "C:\\GAProject\\dgase\\EclipseWS\\ECJServer\\" + jobName + ".params";
	   
       try {
           FileWriter outFile = new FileWriter(filePath);     
           outFile.write(params);
           outFile.close();
       } catch (IOException e){
           e.printStackTrace();
       }
       
       return filePath;
	}

	public static int GetSeed() {
		return 5343;
	}

}
