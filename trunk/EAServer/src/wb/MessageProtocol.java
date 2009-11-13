package wb;

import javax.jms.JMSException;
import javax.jms.MapMessage;

public class MessageProtocol {
	private EaServer eaServer;

	public MessageProtocol(EaServer ecj) {
		this.eaServer = ecj;
	}

	public void handleProtocolMessage(MapMessage request, MapMessage response) {

			try {

				String verb = request.getString("VERB");
				String body = request.getString("BODY");
				String jobName = request.getString("JOBNAME");
				String stats = "";
				
				if (verb.equals("GetStatus")) {
					response.setString("BODY", eaServer.GetStatus(jobName));
					
				}else if (verb.equals("GetStatistics")) {
					stats = eaServer.GetStatistics(jobName);
					response.setString("BODY", stats);
					
				} else if (verb.equals("AddJob")) {
					eaServer.AddJob(body, jobName);

				} else if (verb == "StopJob") {
					eaServer.StopJob(jobName);

				} else if (verb == "PauseJob") {
					eaServer.PauseJob(jobName);
					
				} else if (verb == "StopJob") {
					eaServer.StopJob(jobName);
					
				}
				
				response.setString("STATUS", "success");
				
			} catch (JMSException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			
			
	}
}
