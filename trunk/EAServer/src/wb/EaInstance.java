package wb;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.Iterator;
import java.util.Properties;
import java.util.Vector;
import org.apache.log4j.Logger;
import org.apache.log4j.PropertyConfigurator;


import cma.CMAEvolutionStrategy;
import cma.fitness.IObjectiveFunction;

public class EaInstance {
	static Logger logger = Logger.getLogger(MessageServer.class.getName());
	private String jobId = null;
	private Thread playThread = null;
	private String status = null;
	final String[] clArgs = new String[1];
	boolean threadIsToStop;
	boolean playing = false;
	boolean paused = false;
	int result;
	int seed;
	private EvolutionState state = null;
	Object cleanupLock = new Object();
	boolean _step = false;
	Properties params = new Properties();

	public EaInstance(String parametersFile, String JobId, int Seed) {
		PropertyConfigurator.configure("log4j.properties");
		this.setJobId(JobId);
		this.setSeed(Seed);
		state = new EvolutionState();		
		logger.debug(parametersFile);
		try {
			params.load(new ByteArrayInputStream(parametersFile.getBytes()));
		} catch (IOException e) {
			logger.error(e);
		}
		params.getProperty("population");
	}



	public int getSeed() {
		return seed;
	}

	public void setSeed(int seed) {
		this.seed = seed;
	}

	public String getJobId() {
		return jobId;
	}

	public void setJobId(String jobId) {
		this.jobId = jobId;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public Thread getThread() {
		return playThread;
	}

	public void setThread(Thread thread) {
		this.playThread = thread;
	}

	public EvolutionState getState() {
		return state;
	}

	public void setState(EvolutionState state) {
		this.state = state;
	}

	void killPlayThread() {
		tellThreadToStop();		
		try {
			if (playThread != null) {
				while (playThread.isAlive()) {
					try {
						playThread.interrupt();
					}
					// Ignore security exceptions resulting from
					// attempting to interrupt a thread.
					// TODO Explain this better.
					catch (SecurityException ex) {
					}
					playThread.join(50);
				}

				playThread = null;
			}
		} catch (InterruptedException ex) {
			logger.error(ex);
			logger.info("Interrupted while killing the play thread.  Shouldn't happen.");
		}
	}

	void setStep(boolean step) {
		_step = step;
	}

	boolean isThreadToStop() {
		return threadIsToStop;
	}	
	
	void tellThreadToStop() {
		this.status = "stopping";
		threadIsToStop = true;
	}
	
	
	void spawnPlayThread(){

		threadIsToStop = false;

		Runnable run = new Runnable() {
			public void run() {
				try {
				state = new EvolutionState();
				state.setStatus("Initializing");
				
				IObjectiveFunction fitfun = new Rosenbrock();
				CMAEvolutionStrategy cmaes = new CMAEvolutionStrategy();
				cmaes.readProperties(); // read options, see file CMAEvolutionStrategy.properties
				//cma.setDimension(11); // overwrite some loaded properties
				//cma.setInitialX(0.5); // in each dimension, also setTypicalX can be used
				//cma.setInitialStandardDeviation(0.2); // also a mandatory setting 
				
				
				cmaes.options.stopFitness = 1e-9;       // optional setting
				logger.debug(params.toString());
				if(params.containsKey("PopSizeValue")){
					
					cmaes.parameters.setPopulationSize(Integer.parseInt((params.getProperty("PopSizeValue"))));
				}
				
				if(params.containsKey("EvaluationsValue")){
					
					cmaes.options.stopMaxFunEvals = Integer.parseInt((params.getProperty("EvaluationsValue")));
				}				
				
				if(params.containsKey("GenerationDevValue")){
					cmaes.setInitialStandardDeviation(Double.parseDouble((params.getProperty("GenerationDevValue"))));
				}
				
				
				
			
				// initialize cma and get fitness array to fill in later
				double[] fitness = cmaes.init();  // new double[cma.parameters.getPopulationSize()];

				// initial output to files
				cmaes.writeToDefaultFilesHeaders(0); // 0 == overwrites old files
			
				state.setStatus("Running");
					while(cmaes.stopConditions.getNumber() == 0) {

			            // --- core iteration step ---
						double[][] pop = cmaes.samplePopulation(); // get a new population of solutions
						for(int i = 0; i < pop.length; ++i) {    // for each candidate solution i
			            	// a simple way to handle constraints that define a convex feasible domain  
			            	// (like box constraints, i.e. variable boundaries) via "blind re-sampling" 
			            	                                       // assumes that the feasible domain is convex, the optimum is  
							while (!fitfun.isFeasible(pop[i]))     //   not located on (or very close to) the domain boundary,  
								pop[i] = cmaes.resampleSingle(i);    //   initialX is feasible and initialStandardDeviations are  
			                                                       //   sufficiently small to prevent quasi-infinite looping here
			                // compute fitness/objective value	
							fitness[i] = fitfun.valueOf(pop[i]); // fitfun.valueOf() is to be minimized
						}
						cmaes.updateDistribution(fitness);         // pass fitness array to update search distribution
			            // --- end core iteration step ---
						
						// output to files and console 
						cmaes.writeToDefaultFiles();
						int outmod = 150;
						if (cmaes.getCountIter() % (15*outmod) == 1)
							cmaes.printlnAnnotation(); // might write file as well
						if (cmaes.getCountIter() % outmod == 1)
							cmaes.println(); 
						
						state.postEvaluationStatistics(cmaes);
					}
					state.setStatus("Finishing");
					cmaes.setFitnessOfMeanX(fitfun.valueOf(cmaes.getMeanX())); // updates the best ever solution 

					// final output
					cmaes.writeToDefaultFiles(1);
					cmaes.println();
					cmaes.println("Terminated due to");
					for (String s : cmaes.stopConditions.getMessages())
						cmaes.println("  " + s);
					cmaes.println("best function value " + cmaes.getBestFunctionValue() 
							+ " at evaluation " + cmaes.getBestEvaluationNumber());		
					
					state.finalStatistics(cmaes);
					state.setStatus("Complete");
				} catch (Exception e) {
					logger.equals(e);
				}


		};
		};
		playThread = new Thread(run);
		
		playThread.start();
	}




	

	boolean getStep() {
		return _step;
	}

	void setPaused(boolean paused) {
		this.paused = paused;
	}

	boolean isPaused() {
		return paused;
	}

	void finishAndCleanup() {
		synchronized (cleanupLock) {
			paused = false;
			playing = false;
			_step = false;
		}
	}

	void pausePlayThread() {
		setPaused(true);
	}

	void resumePlayThread() {
		synchronized (playThread) {
			setPaused(false);
			playThread.notify();
		}
	}
	
	

}
