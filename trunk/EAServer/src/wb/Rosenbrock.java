package wb;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.Types;
import cma.*;
import cma.fitness.IObjectiveFunction;
import java.sql.*;
import com.microsoft.sqlserver.jdbc.SQLServerResultSet;
import org.apache.log4j.Logger;
import org.apache.log4j.PropertyConfigurator;

/** The very well-known Rosenbrock objective function to be minimized. 
 */
class Rosenbrock implements IObjectiveFunction { // meaning implements methods valueOf and isFeasible
	static Logger logger = Logger.getLogger(Rosenbrock.class.getName());
	public static Connection con =  getConn();
	 
	public Rosenbrock(){
		PropertyConfigurator.configure("log4j.properties");
	}
	public double valueOf (double[] x) {
		double res = 0;

		
		 Statement stmt = null;
         ResultSet rs = null;   
         Connection conn = null;
         try
         {
         	
       	  //Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
 		 // conn = DriverManager.getConnection("jdbc:sqlserver://DEVARAJP-R;databaseName=quant;user=ga;password=amnesia;");            	
         	
             CallableStatement proc =
             	con.prepareCall(" EXEC dbo.usp_wb_GetScore4 ?, ?, ?, ?, ?, ?, ?, ?, ?, ? ");
             proc.registerOutParameter(1, Types.NUMERIC); 
             proc.setDouble(2, x[0]);
             proc.setDouble(3, x[1]);
             proc.setDouble(4, x[2]);
             proc.setDouble(5, x[3]);
             proc.setDouble(6, x[4]);
             proc.setDouble(7, x[6]);
             proc.setDouble(8, x[7]);
             proc.setDouble(9, x[8]);
             proc.setDouble(10, x[9]);

             proc.execute();
                  
             res = proc.getDouble(1);
         }
          catch (Exception e) {
			logger.error("Error in evaluation");
			logger.error(e);
              
           }          
	          finally {
	             if (rs != null) try { rs.close(); } catch(Exception e) {}
	             if (stmt != null) try { stmt.close(); } catch(Exception e) {}
	          }
		
		
		
		return res;
	}
	public boolean isFeasible(double[] x) {return true; } // entire R^n is feasible
	
    private static Connection getConn()
    {
    	System.out.println("getting connection");
    	Connection _con = null;
    	  try
          {      		  
    		  Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
    		  _con = DriverManager.getConnection(Util.getConfigProperty("connectionstring"));
          }
          catch (Exception e) {
  			logger.error("Error getting connection " + Util.getConfigProperty("connectionstring"));
			logger.error(e);              
           }    
    	return _con;
    }	
}
