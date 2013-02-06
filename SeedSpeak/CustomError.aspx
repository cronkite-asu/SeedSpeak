<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CustomError.aspx.cs" Inherits="SeedSpeak.CustomError" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        Sorry, an unexpected error occurred while processing your request.<br />
        We are very sorry for inconvenience.
        <br />
        <br />
        <% string url = "http://" + Request.ServerVariables["SERVER_NAME"].ToString();%>
        Plese <a href="<%=url%>/Member/Dashboard">redirect</a> yourself on homepage.
        <br />
        <br />
        Thank You<br />
        SeedSpeak
    </div>
    </form>
</body>
</html>
