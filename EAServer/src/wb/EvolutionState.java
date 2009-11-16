package wb;

import java.io.File;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.Result;
import javax.xml.transform.Source;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.apache.commons.math.stat.descriptive.DescriptiveStatistics;
import org.w3c.dom.DOMException;
import org.w3c.dom.Document;
import org.w3c.dom.Element;

import cma.CMAEvolutionStrategy;
import org.apache.commons.math.stat.descriptive.*;

public class EvolutionState {
	
	public Document document;
	public String status;
	
	public String getStatus() {
		return status;
	}


	public void setStatus(String status) {
		this.status = status;
	}

	public String resultsFileName = "C:\\ResultsXML.xml";
	
	public EvolutionState(){
		try {
			DocumentBuilderFactory documentBuilderFactory = DocumentBuilderFactory
					.newInstance();
			DocumentBuilder documentBuilder = documentBuilderFactory
					.newDocumentBuilder();
			document = documentBuilder.newDocument();
			Element rootElement = document.createElement("ea");
			document.appendChild(rootElement);
		} catch (DOMException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (ParserConfigurationException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	
	public Document getDocument() {
		return document;
	}

	public void setDocument(Document document) {
		this.document = document;
	}
	
	public void postEvaluationStatistics(final CMAEvolutionStrategy cmaes) {
		// be certain to call the hook on super!
		Runtime r = Runtime.getRuntime();
		long curU = r.totalMemory() - r.freeMemory();
		
		DescriptiveStatistics statistics = DescriptiveStatistics.newInstance();
		
		double[] fitness = cmaes.getRawFitness();
		for(int i=0; i < fitness.length; i++){
			statistics.addValue(fitness[i]);
		}
		
		Element genStat = document.createElement("genStat");
		genStat.setAttribute("EvalNum", String.valueOf(cmaes.getCountEval()));
		genStat.setAttribute("Iteration", String.valueOf(cmaes.getCountIter()));
		genStat.setAttribute("Max", String.valueOf(statistics.getMax()));
		genStat.setAttribute("Min", String.valueOf(statistics.getMin()));
		genStat.setAttribute("Mean", String.valueOf(statistics.getMean()));
		genStat.setAttribute("StdDev", String.valueOf(statistics.getStandardDeviation()));
		genStat.setAttribute("Variance", String.valueOf(statistics.getVariance()));
		//genStat.setAttribute("Best", String.valueOf(Util.IndividualToString(cmaes.getBestX())));
		
		
		//genStat.setAttribute("StdDev", String.valueOf(Util.IndividualToString(cmaes.getMeanX())));
		//genStat.setAttribute("Best", String.valueOf(Util.IndividualToString(cmaes.getBestX())));
		document.getDocumentElement().appendChild(genStat);
		//System.out.println("writing stats ");
		// print out best genome #3 individual in subpop 0
		/*
		 * int best = 0; double best_val = ((DoubleVectorIndividual)
		 * state.population.subpops[0].individuals[0]).genome[3]; for (int y =
		 * 1; y < state.population.subpops[0].individuals.length; y++) { //
		 * We'll be unsafe and assume the individual is a //
		 * DoubleVectorIndividual double val = ((DoubleVectorIndividual)
		 * state.population.subpops[0].individuals[y]).genome[3]; if (val >
		 * best_val) { best = y; best_val = val; } }
		 * 
		 * 
		 * 
		 * 
		 * state.population.subpops[0].individuals[best].printIndividualForHumans
		 * ( state, infoLog, Output.V_NO_GENERAL);
		 */
	}
	
	public void finalStatistics(final CMAEvolutionStrategy cmaes) {

		
	//	Element finalStat = document.createElement("finalStat");


		
	
			
	//	finalStat.setAttribute("bestFittness", String.valueOf(cmaes.getBestEvaluationNumber()));
	//	finalStat.setAttribute("bestIndividual", String.valueOf(cmaes.getBestSolution().getFitness()));
		

	
		
	//	document.getDocumentElement().appendChild(finalStat);
		
	//	writeXmlFile(document, resultsFileName );
	}	
	
    public static void writeXmlFile(Document doc, String filename) {
        try {
            // Prepare the DOM document for writing
            Source source = new DOMSource(doc);
    
            // Prepare the output file
            File file = new File(filename);
            Result result = new StreamResult(file);
    
            // Write the DOM document to the file
            Transformer xformer = TransformerFactory.newInstance().newTransformer();
            xformer.transform(source, result);
        } catch (TransformerConfigurationException e) {
        } catch (TransformerException e) {
        }
    }	
}
