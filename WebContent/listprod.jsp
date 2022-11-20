<%@ page import="java.sql.*,java.net.URLEncoder" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<title>YOUR NAME Grocery</title>
</head>
<body>
	<div class = "header">
		<table style="margin-left:auto;margin-right:auto;""><th style = "padding:10px"><a href="listprod.jsp">Begin Shopping</a></th><th style = "padding:10px"><a href="listorder.jsp">List All Orders</a></th><th style = "padding:10px"><a href="showcart.jsp">See cart</a></th></table>
	</div>
<h1>Search for the products you want to buy:</h1>

<form method="get" action="listprod.jsp">
<input type="text" name="productName" size="50">
<input type="submit" value="Submit"><input type="reset" value="Reset"> (Leave blank for all products)
</form>

<h2>All products</h2>

<% // Get product name to search for
String name = request.getParameter("productName");
		
//Note: Forces loading of SQL Server driver
try
{	
	// Load driver class
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
}
catch (java.lang.ClassNotFoundException e)
{
	out.println("ClassNotFoundException: " +e);
}

// Variable name now contains the search string the user entered
// Use it to build a query and print out the resultset.  Make sure to use PreparedStatement!

// Make the connection
String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True;";
String uid = "sa";
String pw = "304#sa#pw"; 
Connection con = DriverManager.getConnection(url, uid, pw);
String sql;
if(name != null)
	sql = "SELECT productId, productName, productPrice FROM product WHERE productName LIKE '%" + name + "%'";
else
	sql = "SELECT productId, productName, productPrice FROM product";

PreparedStatement pstmt = con.prepareStatement(sql);
ResultSet rst = pstmt.executeQuery();
// Print out the ResultSet
out.print("<table>");
out.print("<tr><th></th><th>Product Name</th><th>Price</th></tr>" + "<br>");
while(rst.next())
{
	NumberFormat currFormat = NumberFormat.getCurrencyInstance();
	String prodid = rst.getString("productId");
	String prodname = rst.getString("productName");
	double prodprice = rst.getDouble("productPrice");
	out.print("<tr><td>"+"<a href=\"addcart.jsp?id=" + prodid + "&name=" + prodname + "&price=" + prodprice + "\"" + ">Add to cart</a>" + "</td>");
	out.print("<td>"+" " + rst.getString("productName")+ "</td>");
	out.print("<td>"+" "+ currFormat.format(rst.getDouble("productPrice")) + "</td></tr>");
}
out.print("</table>");
// Close connection
con.close();
%>
</body>
</html>