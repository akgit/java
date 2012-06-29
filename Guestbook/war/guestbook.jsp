<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="javax.jdo.PersistenceManager" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ page import="guestbook.Greeting" %>
<%@ page import="guestbook.PMF" %>

<html>
    <head>
        <link type="text/css" rel="stylesheet" href="/stylesheets/main.css" />
    </head>
    
    <body>
        <p><b><font size=4>テスト掲示板</font></b></p>
        <%
            UserService userService = UserServiceFactory.getUserService();
            User user = userService.getCurrentUser();
            if (user != null) {
        %>
        <p><%= user.getNickname() %> さん、こんにちは。[
        <a href="<%= userService.createLogoutURL(request.getRequestURI()) %>">sign out</a> ]</p>
        <%
            } else {
        %>
        <p>こんにちは。<br>書き込みする場合は、Googleアカウントでサインインしてください。[
        <a href="<%= userService.createLoginURL(request.getRequestURI()) %>">Sign in</a> ]</p>
        <%
            }
        %>

        <form action="/sign" method="post">
        <table>
            <tr>
            <td>投稿者</td>
            <td><input type="text" name="name" size="31" maxlength="255"></input></td>
            </tr>
            <tr>
            <td>E-Mail</td>
            <td><input type="text" name="name" size="31" maxlength="255"></input></td>
            </tr>
            <tr>
            <td>題名</td>
            <td><input type="text" name="name" size="31" maxlength="255"></input></td>
            </tr>
        </table>

        <div><textarea name="content" rows="6" cols="60"></textarea></div>
        <input type="submit" value="書き込み"></input>
        <input type="reset" value="取り消し"></input></div>
        </form>
        <br>
        
        <%
            PersistenceManager pm = PMF.get().getPersistenceManager();
            String query = "select from " + Greeting.class.getName()+ " order by date desc ";
            List<Greeting> greetings = (List<Greeting>) pm.newQuery(query).execute();
            if (greetings.isEmpty()) {
        %>
        <p>The guestbook has no messages.</p>
        <%
            } else {
                for (Greeting g : greetings) {
                    if (g.getAuthor() == null) {
        %>
                        <p>An anonymous person&nbsp;&nbsp;<%= g.getDate() %></p>
        <%
                    } else {
        %>
                        <p><%= g.getAuthor().getNickname() %>&nbsp;&nbsp;<%= g.getDate() %></p>
        <%
                    }
        %>
        <blockquote><%= g.getContent() %></blockquote>
        <%
                }
            }
            pm.close();
        %>
    
        <br>
        <div>
        <img src="http://code.google.com/appengine/images/appengine-silver-120x30.gif" alt="Powered by Google App Engine" />
        </div>

    </body>
</html>