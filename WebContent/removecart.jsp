<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%
// Get the current list of products
@SuppressWarnings({"unchecked"})
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

if (productList == null)
{	// No products currently in list.  Create a list.
	productList = new HashMap<String, ArrayList<Object>>();
}

// Get product information
String id = request.getParameter("id");

productList.remove(id);

if(productList.isEmpty())
{
    session.setAttribute("productList",null);
}
else
{
    session.setAttribute("productList", productList);
}
%>
<jsp:forward page="showcart.jsp" />