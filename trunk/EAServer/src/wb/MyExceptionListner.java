package wb;

import javax.jms.ExceptionListener;
import javax.jms.JMSException;

public class MyExceptionListner implements ExceptionListener {
	   public MyExceptionListner(){
		   
	   }
    public synchronized void onException(JMSException ex) {
        System.out.println("JMS Exception occured.  Shutting down client.");
    }  
}
