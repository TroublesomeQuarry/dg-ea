package wb;

import javax.jms.JMSException;

import javax.jms.MapMessage;
import javax.jms.Message;
import javax.jms.Session;
import javax.jms.TextMessage;
import org.apache.log4j.Logger;
import org.apache.log4j.PropertyConfigurator;

public class MessageProtocol {
	private EaServer eaServer;
	static Logger logger = Logger.getLogger(MessageProtocol.class.getName());

	public MessageProtocol(EaServer ecj) {
		PropertyConfigurator.configure("log4j.properties");
		this.eaServer = ecj;
	}

	public Message handleProtocolMessage(MapMessage request, Session session) {

			try {

				String verb = request.getString("VERB");
				String body = request.getString("BODY");
				String jobName = request.getString("JOBNAME");
				String stats = "";
				
				logger.info("Request - jobName : " + jobName + " verb : " + verb);
				logger.debug("Message Body " + body);
				
				if (verb.equals("GetStatus")) {
					MapMessage response = session.createMapMessage();
					response.setString("BODY", eaServer.GetStatus(jobName));
					response.setString("STATUS", "success");
					return response;
					
				}else if (verb.equals("GetStatistics")) {
					TextMessage response = session.createTextMessage();
					stats = eaServer.GetStatistics(jobName);
					stats = "<![CDATA[" + stats + "]]>";
					response.setText(stats);
					return response;
					
				} else if (verb.equals("AddJob")) {
					MapMessage response = session.createMapMessage();
					eaServer.AddJob(body, jobName);
					response.setString("STATUS", "success");
					return response;

				} else if (verb == "StopJob") {
					MapMessage response = session.createMapMessage();
					eaServer.StopJob(jobName);
					response.setString("STATUS", "success");
					return response;

				} else if (verb == "PauseJob") {
					MapMessage response = session.createMapMessage();
					eaServer.PauseJob(jobName);
					response.setString("STATUS", "success");
					return response;
					
				} else if (verb == "StopJob") {
					MapMessage response = session.createMapMessage();
					eaServer.StopJob(jobName);
					response.setString("STATUS", "success");
					return response;
				}
				
				 
				
			} catch (JMSException e) {
				// TODO Auto-generated catch block
				logger.error("Error in message protocol");
				logger.error(e);
			}
			return null;
			
	}
}
