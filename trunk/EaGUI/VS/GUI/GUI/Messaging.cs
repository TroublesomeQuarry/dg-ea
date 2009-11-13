using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;


using Spring.Messaging.Nms;
using Apache.NMS.ActiveMQ;
using Apache.NMS;
using Spring.Messaging.Nms.Support.Destinations;
using Spring.Messaging.Nms.Listener;
using System.Collections;


namespace GUI.ActiveMq
{
    public class Messaging
    {
        private const string URI = "tcp://localhost:61616";
        private const string DESTINATION = "FOO.BAR";
        private const int TIMEOUT_SECS = 500;

        public IMapMessage EcjRequest(String jobName, String verb, String body)
        {
            IMapMessage ecjResponse;
            ConnectionFactory connectionFactory = new ConnectionFactory(URI);
            try
            {
                using (IConnection connection = connectionFactory.CreateConnection())
                {
                    using (ISession session = connection.CreateSession())
                    {
                        ITemporaryQueue queue = session.CreateTemporaryQueue();
                        using (IMessageConsumer consumer = session.CreateConsumer(queue))
                        {
                            IMapMessage message = session.CreateMapMessage();
                            message.Body.SetString("VERB", verb);
                            message.Body.SetString("BODY", body);
                            message.Body.SetString("JOBNAME", jobName);
                            message.NMSReplyTo = queue;
                            string correlationId = Guid.NewGuid().ToString();
                            message.NMSCorrelationID = correlationId;
                            using (IMessageProducer producer = session.CreateProducer())
                            {
                                NmsDestinationAccessor destinationResolver = new NmsDestinationAccessor();
                                IDestination destination = destinationResolver.ResolveDestinationName(session, DESTINATION);
                                producer.Send(destination, message);
                            }
                            IMessage response = consumer.Receive(TimeSpan.FromSeconds(TIMEOUT_SECS));
                            ecjResponse = response as IMapMessage;    
                         
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                throw new ApplicationException("Failed to send request", ex);
            }
            return ecjResponse;
        }   
    }

}
