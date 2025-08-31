package database;
import java.sql.*;

public class Utility 
{
		public String url="jdbc:oracle:thin:@coestudb.qu.edu.qa:1521/STUD.qu.edu.qa";
		public String user="aa2207121";
		public String pass="aa2207121";
		public Connection conn;
		public Statement stmt;
		public PreparedStatement pstmt;
		public ResultSet rs;
		
	public Utility() throws SQLException 
	{
		conn=DriverManager.getConnection(url, user, pass);
		stmt=conn.createStatement();
	}
	
	
	public String[] getData(int dno) throws SQLException
	{
		String result[]=new String[2];
		String sql="select dname,loc from dept where deptno="+dno;
		rs=stmt.executeQuery(sql);
		if(rs.next())
		{
			result[0]=rs.getString(1);
			result[1]=rs.getString(2);
		}
		return result;
	}
	
	public void terminate() throws SQLException
	{
		System.out.println("Terminate Connection ");
		conn.close();
		System.exit(0);
	}

}
