package wb;

import javax.xml.transform.Source;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamSource;
import javax.xml.transform.stream.StreamResult;
import java.io.*;

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

	public static void createParameterFile(String xml, String xsltPath, String outPath) throws Exception {

        File xmlFile = new File(xml);
        File xsltFile = new File(xsltPath);

        // JAXP reads data using the Source interface
        Source xmlSource = new StreamSource(xmlFile);
        Source xsltSource = new StreamSource(xsltFile);

        // the factory pattern supports different XSLT processors
        TransformerFactory transFact =
                TransformerFactory.newInstance();
        Transformer trans = transFact.newTransformer(xsltSource);

        trans.transform(xmlSource, new StreamResult(outPath));
    }
	
}
