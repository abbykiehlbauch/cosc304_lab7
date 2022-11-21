<html>
    <head><title>Password Protected Page</title></head>
        <body>
            <%@ include file="auth.jsp"%>
            <%
            String user = (String)session.getAttribute("authenticatedUser");
            out.println("<h1>You have access to this page: "+user+"</h1>");
            %>
        </body>
</html>