package wb;

import javax.jms.JMSException;
import javax.jms.MapMessage;
import javax.jms.Message;
import javax.jms.Session;
import javax.jms.TextMessage;

public class MessageProtocol {
	private EaServer eaServer;

	public MessageProtocol(EaServer ecj) {
		this.eaServer = ecj;
	}

	public Message handleProtocolMessage(MapMessage request, Session session) {

			try {

				String verb = request.getString("VERB");
				String body = request.getString("BODY");
				String jobName = request.getString("JOBNAME");
				String stats = "";
				
				
				
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
				e.printStackTrace();
			}
			return null;
			
	}
}
