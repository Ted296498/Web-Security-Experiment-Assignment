<%@ page language="java" import="java.util.*" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="com.cya.pojo.Notice,com.cya.dao.NoticeDao,com.cya.pojo.Admin,com.cya.pojo.History,com.cya.dao.BookDao,com.cya.dao.AdminDao" %>
<!DOCTYPE html>
<html>

	<head>
		<meta charset="utf-8" />
		<title>图书管理系统</title>
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
		<link rel="stylesheet" href="${pageContext.request.contextPath}/books/css/index.css" />
	</head>

	<body>
	
	<!-- 判断是否已经登录 -->
  <%
  Admin admin = new Admin();
  String uid = (String) session.getAttribute("uid");
  if(uid==null || uid.equals("")){
	  //没有登录
	  response.sendRedirect("../login.jsp"); //重定向到登录页面
      return ;
  }
  else{
	  AdminDao admindao = new AdminDao();
      admin = admindao.get_AidInfo2(uid);
  }


   %>

		<div class="head">
			<img class="img" src="${pageContext.request.contextPath}/books/img/title-yellow1.png"></img>
			<div class="userName">
				<a href="${pageContext.request.contextPath}/books/user/index.jsp"><% out.write(admin.getName());%></a>
			</div>
			<div class="daohang">
				<ul>
					<li style="margin-left: 100px;">
						<a href="${pageContext.request.contextPath}/books/user/select.jsp">图书查询</a>
					</li>
					<li>
						<a href="${pageContext.request.contextPath}/books/user/borrow.jsp">借阅信息</a>
					</li>
					<li>
						<a href="${pageContext.request.contextPath}/books/user/history.jsp">借阅历史</a>
					</li>
					<li class="dropdown">
						<a href="#" class="" role="button" data-hover="dropdown">我的</a>
						<ul class="dropdown-menu">
                                <li><a href="#updateinfo" data-toggle="modal">个人资料</a></li>
                                <li><a href="#updatepwd" data-toggle="modal">修改密码</a></li>
                                <li><a href="/manage_books/ExitServlet?id=<%=uid %>&&status=uid">退出</a></li>
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
                            <div class="text-muted bootstrap-admin-box-title">当前借阅信息</div>
                        </div>

                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-lg-12">

                </div>
            </div>
            <div class="row">
                <div class="col-lg-12">
                    <table id="data_list" class="table table-hover table-bordered" cellspacing="0" width="100%">
                        <thead>
                        <tr>
                            <th>图书号</th>
                            <th>图书名称</th>
                            <th>读者账号</th>
                            <th>读者名称</th>
                            <th>借阅日期</th>
                            <th>截止还书日期</th>
                            <th>操作</th>
                        </tr>
                        </thead>
                        <%
                            ArrayList<History> bookdata = new ArrayList<History>();
                            bookdata = (ArrayList<History>) request.getAttribute("data");
                            if (bookdata == null) {
                                BookDao bookdao = new BookDao();
                                bookdata = (ArrayList<History>) bookdao.get_HistoryListInfo(1, uid);
                            }
                            for (History bean : bookdata) {
                        %>
                        <tbody>
                        <td><%= bean.getCard() %>
                        </td>
                        <td><%= bean.getBookname() %>
                        </td>
                        <td><%= bean.getAdminname() %>
                        </td>
                        <td><%= bean.getUsername() %>
                        </td>
                        <td><%= bean.getBegintime() %>
                        </td>
                        <td><%= bean.getEndtime() %>
                        </td>
                        <td>
                            <button type="button" class="btn btn-info btn-xs" data-toggle="modal"
                                    onclick="haibook(<%= bean.getHid() %>,'<%= bean.getEndtime() %>')">还书
                            </button>
                        </td>
                        </tbody>
                        <%} %>
                    </table>
                </div>
            </div>
            <script type="text/javascript">
                function haibook(hid,endtime) {
                	
                	var date = new Date();
                	var year = date.getFullYear();    //  返回的是年份
                	var month = date.getMonth() + 1;  //  返回的月份上个月的月份，记得+1才是当月
                	var dates = date.getDate();       //  返回的是几号
                	console.log(new Date(year+"-"+month+"-"+dates)>new Date(endtime));
                	if(new Date(year+"-"+month+"-"+dates)>new Date(endtime)){
                		alert("超过截止还书日期："+endtime+"，请联系管理员！");
                		return ;
                	}
                	
                    con = confirm("是否还书?");
                    if (con == true) {
                        location.href = "/manage_books/borrowServlet?tip=2&show=1&hid=" + hid;
                    }
                }
            </script>
        </div>
    </div>
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
                    <input type="hidden" name="url" value="user/borrow">
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
                    <input type="hidden" name="url" value="user/borrow">
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

	
	
	</body>

</html>