<%@ page language="java" import="java.util.*" pageEncoding="UTF-8" %>
<%@ page import="com.cya.pojo.Type,com.cya.dao.AdminDao,com.cya.dao.TypeDao,com.cya.pojo.Book,com.cya.dao.BookDao,com.cya.pojo.Admin" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>

	<head>
		<meta charset="utf-8" />
		<title>图书管理-管理员系统</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<meta name="viewport" content="width=device-width, initial-scale=1">
		<link rel="stylesheet" href="${pageContext.request.contextPath}/books/css/bootstrap.css">
		<link rel="stylesheet" href="${pageContext.request.contextPath}/books/css/bootstrap-theme.css">
		<link rel="stylesheet" href="${pageContext.request.contextPath}/books/css/bootstrap-admin-theme.css">
		<script src="${pageContext.request.contextPath}/books/js/jquery-3.1.1.min.js"></script>
        <script src="${pageContext.request.contextPath}/books/js/bootstrap.min.js"></script>
        <script src="${pageContext.request.contextPath}/books/js/bootstrap-dropdown.min.js"></script>
        <script src="${pageContext.request.contextPath}/books/js/reader.js"></script>

        <script src="${pageContext.request.contextPath}/books/js/readerUpdateInfo.js"></script>
        <script src="${pageContext.request.contextPath}/books/js/readerUpdatePwd.js"></script>
        <script src="${pageContext.request.contextPath}/books/js/index.js"></script>
		<link rel="stylesheet" href="${pageContext.request.contextPath}/books/css/index.css" />
	</head>

	<body>
	
	<!-- 判断是否已经登录 -->
    <%
      Admin admin = new Admin();
      String aid = (String) session.getAttribute("aid");
      if(aid==null || aid.equals("")){
    	  //没有登录
    	  response.sendRedirect("../login.jsp"); //重定向到登录页面
          return ;
      }
      else{
    	  AdminDao admindao = new AdminDao();
          admin = admindao.get_AidInfo2(aid);
      }

    %>
		<div class="head">
			<img class="img" src="${pageContext.request.contextPath}/books/img/title-yellow1.png"></img>
			<div class="userName">
				<a href="${pageContext.request.contextPath}/books/admin/index.jsp"><% out.write(admin.getName());%></a>
			</div>
			<div class="daohang">
				<ul>
					<li style="margin-left: 100px;">
						<a href="${pageContext.request.contextPath}/books/admin/admin_books.jsp">图书管理</a>
					</li>
					<li>
						<a href="${pageContext.request.contextPath}/books/admin/admin_booksType.jsp">图书分类管理</a>
					</li>
					<li>
						<a href="${pageContext.request.contextPath}/books/admin/admin_borrows.jsp">图书借阅信息</a>
					</li>
					<li>
						<a href="${pageContext.request.contextPath}/books/admin/admin_history.jsp">图书归还信息</a>
					</li>
					
					<li>
						<a href="${pageContext.request.contextPath}/books/admin/admin_notice.jsp">公告管理</a>
					</li>
					
					<li>
						<a href="${pageContext.request.contextPath}/books/admin/admin_users.jsp">读者管理</a>
					</li>
					<li class="dropdown">
						<a href="#" class="" role="button" data-hover="dropdown">我的</a>
						<ul class="dropdown-menu">
                                <li><a href="#updateinfo" data-toggle="modal">个人资料</a></li>
                                <li><a href="#updatepwd" data-toggle="modal">修改密码</a></li>
                                <li><a href="${pageContext.request.contextPath}/ExitServlet?id=<%=aid %>&&status=aid">退出</a></li>
                         </ul>
					</li>
				</ul>
			</div>
		</div>
		<div style="width: 100%;float: left;height: 310px;"></div>
		<div class="body">
			<div class="content">

				<div class="right">
					
					<div class="container">
    <!-- left, vertical navbar & content -->
    <div class="row">
        
        <!-- content -->
        <div class="col-md-10">


            <div class="row">
                <div class="col-lg-12">
                    <div class="panel panel-default bootstrap-admin-no-table-panel">
                        <div class="panel-heading">
                            <div class="text-muted bootstrap-admin-box-title">查询</div>
                        </div>
                        <div class="bootstrap-admin-no-table-panel-content bootstrap-admin-panel-content collapse in">
                            <form class="form-horizontal" action="${pageContext.request.contextPath}/selectServlet" method="post">
                                <input type="hidden" name="tip" value="1">
                                <div class="col-lg-7 form-group">
                                    <label class="col-lg-4 control-label" for="query_bname">图书名称</label>
                                    <div class="col-lg-8">
                                        <input class="form-control" id="bookName" name="name" type="text" value="">
                                        <label class="control-label" for="query_bname" style="display: none;"></label>
                                    </div>
                                </div>
                                <div class="col-lg-3 form-group">

                                    <button type="submit" class="btn btn-primary" id="btn_query" onclick="">查询</button>
                                </div>
                                <div class="col-lg-3 form-group">

                                    <button type="button" class="btn btn-primary" id="btn_add" data-toggle="modal"
                                            data-target="#addModal">添加图书
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>


            <div class="row">
                <div class="col-lg-12">
                    <table id="data_list" class="table table-hover table-bordered" cellspacing="0" width="100%">
                        <thead>
                        <tr>
                            <th>图书号</th>
                            <th>图书类型</th>
                            <th>图书名称</th>
                            <th>作者名称</th>
                            <th>出版社</th>
                            <th>总数量</th>
                            <th>操作</th>

                        </tr>
                        </thead>


                        <!---在此插入信息-->
                        <%
                            ArrayList<Book> bookdata = new ArrayList<Book>();
                            bookdata = (ArrayList<Book>) request.getAttribute("data");
                            if (bookdata == null) {
                                BookDao bookdao = new BookDao();
                                bookdata = (ArrayList<Book>) bookdao.get_ListInfo();
                            }

                            for (Book bean : bookdata) {
                        %>
                        <tbody>
                        <td><%= bean.getCard() %>
                        </td>
                        <td><%= bean.getType() %>
                        </td>
                        <td><%= bean.getName() %>
                        </td>
                        <td><%= bean.getAutho() %>
                        </td>
                        <td><%= bean.getPress() %>
                        </td>
                        <td><%= bean.getNum() %>
                        </td>
                        <td>
                            <button type="button" class="btn btn-warning btn-xs" data-toggle="modal"
                                    data-target="#updateModal"
                                    id="btn_update"
                                    onclick="showInfo2('<%= bean.getBid() %>','<%= bean.getCard() %>','<%= bean.getType() %>','<%= bean.getName() %>'
                                            ,'<%= bean.getAutho() %>','<%= bean.getPress() %>','<%= bean.getNum() %>')">
                                修改
                            </button>
                            <button type="button" class="btn btn-danger btn-xs"
                                    onclick="deletebook(<%= bean.getBid() %>)">删除
                            </button>
                        </td>
                        </tbody>
                        <%} %>
                    </table>
                </div>
            </div>
        </div>
    </div>
    <script type="text/javascript">
        function showInfo2(bid, card, type, name, autho, press, num) {
            document.getElementById("updateISBN").value = card;
            document.getElementById("updateBookName").value = name;
            document.getElementById("updateAutho").value = autho;
            document.getElementById("updatePress").value = press;
            document.getElementById("updateBookType").value = type;
            document.getElementById("updateNum").value = num;
            document.getElementById("updateBookId").value = bid;
        }

        function deletebook(bid) {
            con = confirm("是否删除?");
            if (con == true) {
                location.href = "/manage_books/deleteServlet?bid=" + bid;
            }
        }
    </script>
</div>

				</div>
			</div> 

		</div>
	
	<div class="foot"><label class="lable">基于JavaWeb的图书借阅管理系统设计与实现</label></div>
	
	
	
	<!-------------------------个人资料模糊框------------------------------------->

<form class="form-horizontal" method="post" action="/manage_books/AdminServlet">   <!--保证样式水平不混乱-->
    <!-- 模态框（Modal） -->
    <div class="modal fade" id="updateinfo" tabindex="-1" role="dialog" aria-labelledby="ModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
                        &times;
                    </button>
                    <h4 class="modal-title" id="ModalLabel">
                        个人资料
                    </h4>
                </div>

                <div class="modal-body">

                    <!--正文-->
                    <input type="hidden" name="tip" value="2">
                    <input type="hidden" name="url" value="admin/admin_books">
                    <div class="form-group">
                        <label for="firstname" class="col-sm-3 control-label">真实姓名</label>
                        <div class="col-sm-7">
                            <input type="text" class="form-control" id="name" name="name" placeholder="请输入您的真实姓名"
                                   value='<% out.write(admin.getName());%>'>
                            <label class="control-label" for="name" style="display: none"></label>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="firstname" class="col-sm-3 control-label">手机号</label>
                        <div class="col-sm-7">
                            <input type="text" class="form-control" id="phone" name="phone" placeholder="请输入您的手机号"
                                   value='<% out.write(admin.getPhone());%>'>
                            <label class="control-label" for="phone" style="display: none"></label>
                        </div>
                    </div>


                    <div class="form-group">
                        <label for="firstname" class="col-sm-3 control-label">邮箱</label>
                        <div class="col-sm-7">
                            <input type="text" class="form-control" id="email" name="email" placeholder="请输入您的邮箱"
                                   value='<% out.write(admin.getEmail());%>'>
                            <label class="control-label" for="email" style="display: none"></label>
                        </div>
                    </div>

                    <!--正文-->


                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭
                    </button>
                    <button type="submit" class="btn btn-primary">
                        修改
                    </button>
                </div>
            </div><!-- /.modal-content -->
        </div><!-- /.modal -->
    </div>

</form>
<!-------------------------------------------------------------->

<!-------------------------------------------------------------->

<form class="form-horizontal" method="post" action="/manage_books/AdminServlet">   <!--保证样式水平不混乱-->
    <!-- 模态框（Modal） -->
    <div class="modal fade" id="updatepwd" tabindex="-1" role="dialog" aria-labelledby="myModalLabel"
         aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
                        &times;
                    </button>
                    <h4 class="modal-title" id="myModalLabel">
                        修改密码
                    </h4>
                </div>
                <div class="modal-body">

                    <!--正文-->
                    <input type="hidden" name="tip" value="1">
                    <input type="hidden" name="url" value="admin/admin_books">
                    <div class="form-group">
                        <label for="firstname" class="col-sm-3 control-label">原密码</label>
                        <div class="col-sm-7">
                            <input type="password" class="form-control" name="password" id="oldPwd"
                                   placeholder="请输入原密码">
                            <label class="control-label" for="oldPwd" style="display: none"></label>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="firstname" class="col-sm-3 control-label">新密码</label>
                        <div class="col-sm-7">
                            <input type="password" class="form-control" name="password2" id="newPwd"
                                   placeholder="请输入新密码">
                            <label class="control-label" for="newPwd" style="display: none"></label>
                        </div>
                    </div>

                    <!--正文-->
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭
                    </button>
                    <button type="submit" class="btn btn-primary">
                        修改
                    </button>
                </div>
            </div><!-- /.modal-content -->
        </div><!-- /.modal -->
    </div>

</form>
<!-------------------------------------------------------------->

 <!-------------------------------------------------------------->

    <!-- 修改模态框（Modal） -->
    <form class="form-horizontal" method="post" action="${pageContext.request.contextPath}/updateBookServlet">   <!--保证样式水平不混乱-->
        <div class="modal fade" id="updateModal" tabindex="-1" role="dialog" aria-labelledby="updateModalLabel"
             aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
                            &times;
                        </button>
                        <h4 class="modal-title" id="updateModalLabel">
                            修改图书信息
                        </h4>
                    </div>
                    <div class="modal-body">

                        <!---------------------表单-------------------->

                        <div class="form-group">
                            <label for="firstname" class="col-sm-3 control-label">图书号</label>
                            <div class="col-sm-7">
                                <input type="hidden" id="updateBookId" name="updatebid">
                                <input type="text" class="form-control" id="updateISBN" name="card" placeholder="请输入书号">
                                <label class="control-label" for="updateISBN" style="display: none;"></label>
                            </div>
                        </div>


                        <div class="form-group">
                            <label for="firstname" class="col-sm-3 control-label">图书名称</label>
                            <div class="col-sm-7">
                                <input type="text" class="form-control" id="updateBookName" name="name"
                                       placeholder="请输入图书名称">
                                <label class="control-label" for="updateBookName" style="display: none;"></label>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="firstname" class="col-sm-3 control-label">图书类型</label>
                            <div class="col-sm-7">
                                <select class="form-control" id="updateBookType" name="type"
                                        onPropertyChange="showValue(this.value)">
                                    <option value="-1">请选择</option>
                                    <%
                                        TypeDao typedao = new TypeDao();
                                        ArrayList<Type> data = (ArrayList<Type>) typedao.get_ListInfo();
                                        data = (ArrayList<Type>) typedao.get_ListInfo();
                                        for (Type bean : data) {
                                    %>
                                    <option value="<%= bean.getName() %>"><%= bean.getName() %>
                                    </option>
                                    <%} %>
                                </select>
                                <label class="control-label" for="updateBookType" style="display: none;"></label>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="firstname" class="col-sm-3 control-label">作者名称</label>
                            <div class="col-sm-7">
                                <input type="text" class="form-control" id="updateAutho" name="autho"
                                       placeholder="请输入作者名称">
                                <label class="control-label" for="updateAutho" style="display: none;"></label>
                            </div>
                        </div>


                        <div class="form-group">
                            <label for="firstname" class="col-sm-3 control-label">出版社</label>
                            <div class="col-sm-7">
                                <input type="text" class="form-control" id="updatePress" name="press"
                                       placeholder="请输入出版社">
                                <label class="control-label" for="updatePress" style="display: none;"></label>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="firstname" class="col-sm-3 control-label">总数量</label>
                            <div class="col-sm-7">
                                <input type="text" class="form-control" id="updateNum" name="num" placeholder="请输入总数量">
                                <label class="control-label" for="updatePress" style="display: none;"></label>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-default" data-dismiss="modal">关闭
                        </button>
                        <button type="submit" class="btn btn-primary">
                            修改
                        </button>
                    </div>
                </div><!-- /.modal-content -->
            </div><!-- /.modal -->
        </div>

    </form>
    <!-------------------------------------------------------------->


<!--------------------------------------添加的模糊框------------------------>
    <form class="form-horizontal" method="post" action="${pageContext.request.contextPath}/AddBookServlet">   <!--保证样式水平不混乱-->
        <!-- 模态框（Modal） -->
        <div class="modal fade" id="addModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel"
             aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
                            &times;
                        </button>
                        <h4 class="modal-title" id="myModalLabel">
                            添加新图书
                        </h4>
                    </div>
                    <div class="modal-body">

                        <!---------------------表单-------------------->

                        <div class="form-group">
                            <label for="firstname" class="col-sm-3 control-label">图书号</label>
                            <div class="col-sm-7">
                                <input type="text" class="form-control" id="addISBN" required="required" name="card"
                                       placeholder="请输入书号">
                                <label class="control-label" for="addISBN" style="display: none;"></label>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="firstname" class="col-sm-3 control-label">图书名称</label>
                            <div class="col-sm-7">
                                <input type="text" class="form-control" id="addBookName" required="required" name="name"
                                       placeholder="请输入图书名称">
                                <label class="control-label" for="addBookName" style="display: none;"></label>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="firstname" class="col-sm-3 control-label">图书类型</label>
                            <div class="col-sm-7">
                                <select class="form-control" id="addBookType" name="type">
                                    <option value="无分类">请选择</option>
                                    <%

                                        data = (ArrayList<Type>) typedao.get_ListInfo();
                                        for (Type bean : data) {
                                    %>
                                    <option value="<%= bean.getName() %>"><%= bean.getName() %>
                                    </option>
                                    <%} %>
                                </select>
                                <label class="control-label" for="addBookType" style="display: none;"></label>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="firstname" class="col-sm-3 control-label">作者名称</label>
                            <div class="col-sm-7">
                                <input type="text" class="form-control" id="addAutho" required="required" name="autho"
                                       placeholder="请输入作者名称">
                                <label class="control-label" for="addAutho" style="display: none;"></label>
                            </div>
                        </div>


                        <div class="form-group">
                            <label for="firstname" class="col-sm-3 control-label">出版社</label>
                            <div class="col-sm-7">
                                <input type="text" class="form-control" id="addPress" required="required" name="press"
                                       placeholder="请输入出版社">
                                <label class="control-label" for="addPress" style="display: none;"></label>
                            </div>
                        </div>


                        <div class="form-group">
                            <label for="firstname" class="col-sm-3 control-label">总数量</label>
                            <div class="col-sm-7">
                                <input type="text" class="form-control" id="addNum" required="required" name="num"
                                       placeholder="请输入图书总数量">
                                <label class="control-label" for="addNum" style="display: none;"></label>
                            </div>
                        </div>


                        <!---------------------表单-------------------->
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-default" data-dismiss="modal">关闭
                        </button>
                        <button type="submit" class="btn btn-primary">
                            添加
                        </button>
                    </div>
                </div><!-- /.modal-content -->
            </div><!-- /.modal -->
        </div>

    </form>
    <!--------------------------------------添加的模糊框------------------------>

	
</body>
	
	

</html>