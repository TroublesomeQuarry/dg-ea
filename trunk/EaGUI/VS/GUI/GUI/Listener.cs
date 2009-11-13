using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

using Spring.Messaging.Nms;
using Apache.NMS.ActiveMQ;
using Apache.NMS;
using Spring.Messaging.Nms.Support.Destinations;
using Spring.Messaging.Nms.Core;
using Spring.Messaging.Nms.Listener;

namespace GUI.ActiveMq
{
    class Listener : IMessageListener
    {
        private readonly SimpleMessageListenerContainer container;

        public Listener(SimpleMessageListenerContainer container)
        {
            this.container = container;
            Console.WriteLine("Listener created.");
        }

        #region IMessageListener Members

        public void OnMessage(IMessage message)
        {
            using (ISession session = this.container.ConnectionFactory.CreateConnection().CreateSession())
            {
                Console.WriteLine("Message Received.");
                ITextMessage textMessage = message as ITextMessage;
                string incomingText = textMessage.Text;
                Console.WriteLine("Message: {0}", incomingText);
                string outgoingText = string.Format("Thanks for sending the following message: {0}", incomingText);

                IDestination destination = message.NMSReplyTo;
                if (destination != null)
                {
                    ITextMessage response = session.CreateTextMessage(outgoingText);
                    response.NMSCorrelationID = message.NMSCorrelationID;
                    using (IMessageProducer producer = session.CreateProducer(destination))
                    {
                        producer.Send(response);
                    }
                }
            }
        }

        #endregion
    }

}
