package wb;

import org.apache.activemq.ActiveMQConnectionFactory;
import org.w3c.dom.Attr;
import org.w3c.dom.Element;
import org.w3c.dom.NamedNodeMap;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import javax.jms.Connection;
import javax.jms.DeliveryMode;
import javax.jms.Destination;
import javax.jms.ExceptionListener;
import javax.jms.JMSException;
import javax.jms.Message;
import javax.jms.MessageConsumer;
import javax.jms.MessageProducer;
import javax.jms.Session;
import javax.jms.TextMessage;


import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import org.apache.log4j.Logger;
import org.apache.log4j.PropertyConfigurator;
/**
 * Hello world!
 */
public class Main {
	
	static Logger logger = Logger.getLogger(Main.class.getName());

	public static void main(String[] args) throws Exception {
		PropertyConfigurator.configure("log4j.properties");
		
		logger.debug("here");
		System.out.println(Main.class.getName());
		
		EaServer eaServer = new EaServer();
		MessageServer messageServer = new MessageServer();
		messageServer.setMessageProtocol(new MessageProtocol(eaServer));
		messageServer.Start();
	}

	public static void thread(Runnable runnable, boolean daemon) {
		Thread brokerThread = new Thread(runnable);
		brokerThread.setDaemon(daemon);
		brokerThread.start();
	}

	public static void wirteFile(String text) {

		try {
			FileWriter outFile = new FileWriter(
					"C:\\GAProject\\dgase\\EclipseWS\\ECJServer\\default.params");
			outFile.write(text);
			outFile.close();
		} catch (IOException e) {
			e.printStackTrace();
		}

	}

}
