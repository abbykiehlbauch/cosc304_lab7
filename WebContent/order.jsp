<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import = "java.util.Date" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<title>YOUR NAME Grocery Order Processing</title>
</head>
<body>
	<div class = "header">
		<table style="margin-left:auto;margin-right:auto;""><th style = "padding:10px"><a href="listprod.jsp">Begin Shopping</a></th><th style = "padding:10px"><a href="listorder.jsp">List All Orders</a></th><th style = "padding:10px"><a href="showcart.jsp">See cart</a></th></table>
	</div>
<% 


// Get customer id
String custId = request.getParameter("customerId");

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
	// Make connection
	try
	{

		String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True;";
		String uid = "sa";
		String pw = "304#sa#pw"; 
		Connection con = DriverManager.getConnection(url, uid, pw);

		String sql1 = ("SELECT customerId, firstName, lastName FROM customer WHERE customerId = ? AND customerId IN(SELECT customerId FROM customer)");
		PreparedStatement pstmt1 = con.prepareStatement(sql1);
		pstmt1.setInt(1,Integer.parseInt(custId));
		ResultSet validId = pstmt1.executeQuery();
		int orderId = 0;
		String name = "";
		if(!validId.next())
		{
			out.println("<h1>Invalid customer id</h1>");
		}
		else
		{
			name = validId.getString(2) +" "+ validId.getString(3);
			// Save order information to database
			String sql2 = "INSERT INTO OrderSummary (customerId, orderDate) VALUES (?,?)";

			// Use retrieval of auto-generated keys.
			PreparedStatement pstmt2 = con.prepareStatement(sql2, Statement.RETURN_GENERATED_KEYS);			
			pstmt2.setInt(1, Integer.parseInt(custId));
			pstmt2.setTimestamp(2, new java.sql.Timestamp(new Date().getTime()));
			pstmt2.executeUpdate();
			ResultSet keys = pstmt2.getGeneratedKeys();
			keys.next();
			orderId = keys.getInt(1);

			out.println("<h2>Your order</h2>");
			out.println("<table><tr><th>Product Id</th><th>Product Name</th><th>Quantity</th><th>Price</th><th>Subtotal</th></tr>");
			double total = 0;
			Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
			while (iterator.hasNext())
			{ 
				// Print out order summary
				//TO DO: fix formatting
				Map.Entry<String, ArrayList<Object>> entry = iterator.next();
				ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
				String productId = (String) product.get(0);
				out.println("<tr><td>"+productId+"</td>");
				String price = (String) product.get(2);
				out.println("<td align = \"center\">"+product.get(1)+"</td>");
				int qty = ( (Integer)product.get(3)).intValue();
				out.println("<td align = \"center\">"+qty+"</td>");
				double pr = Double.parseDouble(price);
				out.println("<td align = \"center\">"+pr+"</td>");
				out.println("<td>"+pr*qty+"</td>");
				out.println("</tr>");
				
				total = total + (pr*qty);
					
				// Insert each item into OrderProduct table using OrderId from previous INSERT
				String sql3 = "INSERT INTO OrderProduct (orderId, productId, quantity, price) VALUES (?, ?, ?, ?)";
				PreparedStatement pstmt3 = con.prepareStatement(sql3);
				pstmt3.setInt(1, orderId);
				pstmt3.setInt(2, Integer.parseInt(productId));
				pstmt3.setInt(3, qty);
				pstmt3.setString(4, price);
				pstmt3.executeUpdate();
			}
			out.println("<tr><td></td><td></td><td></td><th>Order Total:</th><td>"+total+"</td></tr>");

			out.println("</table>");
			// Update total amount for order record
			String sql4 = "UPDATE OrderSummary SET totalAmount = ? WHERE orderId=?";
			PreparedStatement pstmt4 = con.prepareStatement(sql4);
			pstmt4.setDouble(1, total);
			pstmt4.setInt(2, orderId);
			pstmt4.executeUpdate();

			out.println("<h2>Order completed. Will be shipped soon...</h2>");
			out.println("<h2>Your order reference number is:"+orderId+"</h2>");
			out.println("<h2>Shipping to customer: "+custId+" Name: "+name+"</h2>");

		}

		// Clear cart if order placed successfully
		session.setAttribute("productList", null);
		con.close();

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
	}
	catch (SQLException ex)
	{
		out.println(ex);
	}
}
%>
<h2><a href="shop.html">Back to Main Page</a></h2>

</BODY>
</HTML>

