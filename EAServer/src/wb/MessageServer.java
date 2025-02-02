package wb;


import org.apache.activemq.broker.BrokerService;
import org.apache.log4j.Logger;
import org.apache.log4j.PropertyConfigurator;
import org.apache.activemq.ActiveMQConnectionFactory;

import javax.jms.*;

public class MessageServer implements MessageListener {
    private static int ackMode;
    private static String messageQueueName;
    private static String messageBrokerUrl;

    private Session session;
    private boolean transacted = false;
    private MessageProducer replyProducer;
    private MessageProtocol messageProtocol;
    
    static Logger logger = Logger.getLogger(MessageServer.class.getName());

    public MessageProtocol getMessageProtocol() {
		return messageProtocol;
	}

    public void setMessageProtocol(MessageProtocol messageProtocol) {
		this.messageProtocol = messageProtocol;
	}

	static {
        messageBrokerUrl = "tcp://localhost:61616";
        messageQueueName = "FOO.BAR";
        ackMode = Session.AUTO_ACKNOWLEDGE;
    }

    public MessageServer() {
    	PropertyConfigurator.configure("log4j.properties");
        try {
            //This message broker is embedded
            BrokerService broker = new BrokerService();
            broker.setPersistent(false);
            broker.setUseJmx(false);
            broker.addConnector(messageBrokerUrl);
            broker.start();
        } catch (Exception e) {
        	logger.error(e);
        }

        //Delegating the handling of messages to another class, instantiate it before setting up JMS so it
        //is ready to handle messages
 
        
    }
    
    public void Start(){
    	this.setupMessageQueueConsumer();
    }

    private void setupMessageQueueConsumer() {
    	logger.info("Starting Server");
        ActiveMQConnectionFactory connectionFactory = new ActiveMQConnectionFactory(messageBrokerUrl);
        Connection connection;
        try {
            connection = connectionFactory.createConnection();
            connection.start();
            this.session = connection.createSession(this.transacted, ackMode);
            Destination adminQueue = this.session.createQueue(messageQueueName);

            //Setup a message producer to respond to messages from clients, we will get the destination
            //to send to from the JMSReplyTo header field from a Message
            this.replyProducer = this.session.createProducer(null);
            this.replyProducer.setDeliveryMode(DeliveryMode.NON_PERSISTENT);

            //Set up a consumer to consume messages off of the admin queue
            MessageConsumer consumer = this.session.createConsumer(adminQueue);
            consumer.setMessageListener(this);
        } catch (JMSException e) {
        	logger.error(e);
        }
       
    }

    public void onMessage(Message request) {
    	logger.info("Got message");
        try {

            if (request instanceof MapMessage) {
            	MapMessage req = (MapMessage) request;
                Message response = this.messageProtocol.handleProtocolMessage(req, this.session);
                //System.out.println("message status " + response.getString("STATUS"));
               // System.out.println("message body " + response.getString("BODY"));
                response.setJMSCorrelationID(request.getJMSCorrelationID());

                //Send the response to the Destination specified by the JMSReplyTo field of the received message,
                //this is presumably a temporary queue created by the client
                this.replyProducer.send(request.getJMSReplyTo(), response);                
            }

            //Set the correlation ID  from the received message to be the correlation id of the response message
            //this lets the client identify which message this is a response to if it has more than
            //one outstanding message to the server

        } catch (JMSException e) {
        	logger.error(e);
        }
    }

//    public static void main(String[] args) {
//        new MessageServer();
//    }
}

