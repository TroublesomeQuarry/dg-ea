package wb;

import javax.xml.transform.Source;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamSource;
import javax.xml.transform.stream.StreamResult;
import java.io.*;
import java.net.URL;
import java.util.Properties;

import javax.xml.transform.*;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.w3c.dom.Document;

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
	
    public static String DocToString(Document doc) {
        String ret = "";
    	try {
            // Prepare the DOM document for writing
            Source source = new DOMSource(doc);
            
            StringWriter stringOut = new StringWriter ();   
            Result result = new StreamResult(stringOut);
            // Write the DOM document to the file
            Transformer xformer = TransformerFactory.newInstance().newTransformer();
            xformer.transform(source, result);
            ret = stringOut.toString();
        } catch (TransformerConfigurationException e) {
        	ret = e.getMessage();
        } catch (TransformerException e) {
        	ret = e.getMessage();
        }
        
        return ret;
    }
    
    public static String IndividualToString(double[] ind){
    	String s = "";
    	
    	if(ind!=null && ind.length > 0){
	    	for(int i = 0; i < ind.length; i++){
	    		s = s + String.valueOf(ind[i]) + ",";
	    	}
	    	s = s.substring(0, s.length()-1);
    	}
    	
    	return s;
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
	
	public static String getConfigProperty(String name){
		
		Properties configFile = new Properties();
		try {
			URL url = ClassLoader.getSystemResource("config.properties"); 		
			configFile.load(url.openStream());
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return configFile.getProperty(name);

	}
}