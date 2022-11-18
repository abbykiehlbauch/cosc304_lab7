<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<title>YOUR NAME Grocery Order Processing</title>
</head>
<body>

<% 


// Get customer id
String custId = request.getParameter("customerId");
out.println("this is the id" + custId);

@SuppressWarnings({"unchecked"})
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

// Determine if valid customer id was entered
if(custId == null || custId.equals(""))
	out.println("<h1>Invalid customer id, try again.</h1>");
else if (productList == null)
	out.println("<h1>There is nothing in your cart.</h1>");
else
{
	int num;
	try
	{
		num = Integer.parseInt(custId);
	}
	catch(Exception e)
	{
		out.println("<h1>Invalid customer id</h1>");
		return;
	}
}
// Make connection
String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True;";
String uid = "sa";
String pw = "304#sa#pw"; 
Connection con = DriverManager.getConnection(url, uid, pw);

String sql1 = ("SELECT customerId, firstName, lastName FROM customer WHERE customerId = ? AND customerId IN(SELECT customerId FROM customer)");
PreparedStatement pstmt1 = con.prepareStatement(sql1);
pstmt1.setInt(1,Integer.parseInt(custId));
ResultSet validId = pstmt1.executeQuery();
//int orderId = 0;
String name = "";
if(!validId.next())
{
	out.println("<h1>Invalid customer id</h1>");
}
else
{
	custName = rst.getString(2) + rst.getString(3);
	String sql2 = "INSERT INTO OrderSummary (customerId, totalAmount, orderDate, orderId) VALUES ?, ?, ?, ?";
	
	// Use retrieval of auto-generated keys.
	PreparedStatement pstmt2 = con.prepareStatement(sql2, Statement.RETURN_GENERATED_KEYS);			
	pstmt2.setInt(1, Integer.parseInt(custId));
	pstmt2.setTimestamp(2, new java.sql.Timestamp(new Date().getTime()));
	pstmt2.executeUpdate();
	ResultSet keys = pstmt.getGeneratedKeys();
	keys.next();
	int orderId = keys.getInt(1);

	
	// Save order information to database

	// Insert each item into OrderProduct table using OrderId from previous INSERT
	String sql3 = "INSERT INTO OrderProduct (orderId, productId, quantity, price VALUES ?, ?, ?, ?");
	PreparedStatement pstmt3 = con.prepareStatement(sql3);
	pstmt3.setInt(1, orderId);
	pstmt3.setInt(2, Integer.parseInt(productId));
	pstmt3.setInt(3, qty);
	pstmt3.setString(4, price);
	pstmt3.executeUpdate();

	// Update total amount for order record
	String sql4 = "UPDATE OrderSummary SET totalAmount = ? WHERE orderId=?";
	PreparedStatement pstmt4 = con.prepareStatement(sql4);
	pstmt4.setDouble(1, total);
	pstmt4.setInt(2, OrderId);
	pstmt4.executeUpdate();

}






// Here is the code to traverse through a HashMap
// Each entry in the HashMap is an ArrayList with item 0-id, 1-name, 2-quantity, 3-price

/*
	Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
	while (iterator.hasNext())
	{ 
		Map.Entry<String, ArrayList<Object>> entry = iterator.next();
		ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
		String productId = (String) product.get(0);
        String price = (String) product.get(2);
		double pr = Double.parseDouble(price);
		int qty = ( (Integer)product.get(3)).intValue();
            ...
	}
*/

// Print out order summary

// Clear cart if order placed successfully
con.close();
%>
</BODY>
</HTML>

