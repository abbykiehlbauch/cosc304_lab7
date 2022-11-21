<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<title>Sierra's Grocery Order List</title>
</head>
<body>

<h1>Order List</h1>

<%
//Note: Forces loading of SQL Server driver
try
{	// Load driver class
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
}
catch (java.lang.ClassNotFoundException e)
{
	out.println("ClassNotFoundException: " +e);
}

// Useful code for formatting currency values:
NumberFormat currFormat = NumberFormat.getCurrencyInstance();
// out.println(currFormat.format(5.0);  // Prints $5.00

// Make connection

String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
String uid = "sa";
String pw = "304#sa#pw";
Connection con = DriverManager.getConnection(url, uid, pw);
String sql1;
String sql2;

// Write query to retrieve all order summary records
try 
{
	sql1 = "SELECT orderId, customer.customerId, firstName, lastName, totalAmount" + " FROM ordersummary JOIN customer ON ordersummary.customerId=customer.customerId";
	PreparedStatement pstmt1 = con.prepareStatement(sql1);
	ResultSet rst1 = pstmt1.executeQuery();
	out.println("<table border='2px' border-style='ridge'><tr><td class='tableheader'><b>Order ID</b></td><td class='tableheader'><b>Customer ID</b></td><td class='tableheader'><b>Customer Name</b></td><td class='tableheader'><b>Total Amount</b></td></tr>");
	while(rst1.next())
	{
		int ordID = rst1.getInt("orderId");
		String custID = rst1.getString("customerId");
		String custFirst = rst1.getString("firstName");
		String custLast = rst1.getString("lastName");
		String custName = custFirst + " " + custLast;
		double total = rst1.getDouble("totalAmount");


		out.println("<tr><td>" + ordID + "</td><td>" + custID + "</td><td>" + custName + "</td><td>" + currFormat.format(total) + "</td></tr>");
		out.println("<tr><td colspan=5 align='right'><table border='2px' border-style='ridge'>");
		out.println("<tr><td class='tableheader'><b>Product Id</b></td><td class='tableheader'><b>Quantity</b></td><td class='tableheader'><b>Price</b></td></tr>");
		sql2 = "SELECT productId, quantity, price FROM orderproduct WHERE orderId = " + ordID;
		PreparedStatement pstmt2 = con.prepareStatement(sql2);
		ResultSet rst2 = pstmt2.executeQuery();
		while(rst2.next())
		{
			String productID = rst2.getString("productId");
			String quant = rst2.getString("quantity");
			double price_ = rst2.getDouble("price");
			out.println("<tr><td align='center'>" + productID + "</td><td align='center'>" + quant + "</td><td align='center'>" + currFormat.format(price_) + "</td></tr>");
		}
		out.println("</table></td></tr>");
	}
	out.print("</table>");
}
catch (Exception e)
{
	out.print("SQLException: " + e);
}

// For each order in the ResultSet

	// Print out the order summary information
	// Write a query to retrieve the products in the order
	//   - Use a PreparedStatement as will repeat this query many times
	// For each product in the order
	// Write out product information 

// Close connection
con.close();
%>

</body>
</html>


