<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link href="../../bootstrap/css/bootstrap.min.css" rel="stylesheet">
<script src="../../js/jquery-3.4.1.js"></script>
<script src="../../bootstrap/js/bootstrap.min.js"></script>
<script src="../../js/function.js"></script>
<title>회원가입</title>
</head>
<body>

	<div class="container">
		<form class="form-horizontal" method="post" name="memInsForm" action="memberInsertPro.jsp">
			<div class="form-group">
				<div class="col-sm-2"></div>
				<div class="col-sm-8">
					<h2 align="center" style="margin-top: 40px; margin-bottom: 30px;"><b>회원가입</b></h2>
				</div>
			</div>
			<div class="form-group">
				<label class="control-label col-sm-2">
					아&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;이&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;디
				</label>
				<div class="col-sm-3">
					<input type="text" class="form-control" id="id" name="id" maxlength="16" placeholder="Enter ID">
				</div>
				<input class="btn btn-danger btn-sm" type="button" name="confirm_id" value="ID 중복확인"
					onclick="confirmId(document.memInsForm.id.value)">
			</div>
			<div class="form-group">
				<label class="control-label col-sm-2">
					비&nbsp;&nbsp;&nbsp;밀&nbsp;&nbsp;&nbsp;번&nbsp;&nbsp;&nbsp;호
				</label>
				<div class="col-sm-3">
					<input type="password" class="form-control" id="passwd" name="passwd" maxlength="16"
						placeholder="Enter Password">
				</div>
			</div>
			<div class="form-group">
				<label class="control-label col-sm-2">비밀번호&nbsp;&nbsp;확인</label>
				<div class="col-sm-3">
					<input type="password" class="form-control" id="repasswd" name="repasswd" maxlength="16"
						placeholder="Enter Password">
				</div>
			</div>
			<div class="form-group">
				<label class="control-label col-sm-2">
					이&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;름
				</label>
				<div class="col-sm-3">
					<input type="text" class="form-control" id="name" name="name" maxlength="16" placeholder="Enter Name">
				</div>
			</div>
			<div class="form-group">
				<label class="control-label col-sm-2">
					주&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;소
				</label>
				<div class="col-sm-7">
					<input type="text" class="form-control" id="address" name="address" maxlength="100"
					placeholder="Enter Address">
				</div>
			</div>
			<div class="form-group">
         		<label class="control-label col-sm-2">
         			전&nbsp;&nbsp;&nbsp;화&nbsp;&nbsp;&nbsp;번&nbsp;&nbsp;&nbsp;호
         		</label>
         		<div class="col-sm-2">
            		<select class="form-control" name="tel1">
               		<option value="010">010</option>
               		<option value="011">011</option>
               		<option value="017">017</option>
               		<option value="018">018</option>
               		<option value="019">019</option>
            		</select>
         		</div>
         		<div class="input-group col-sm-3">
            		<div class="input-group-addon">-</div>
            		<div>
               			<input type="text" class="form-control col-sm-1" name="tel2" maxlength="4" placeholder="TEL" />
            		</div>
            		<div class="input-group-addon">-</div>
            		<div>
               			<input type="text" class="form-control col-sm-1" name="tel3" maxlength="4" placeholder="TEL" />
            		</div>
         		</div>
         		<div class="form-group">
             		<label class="control-label col-sm-2">회원가입&nbsp;&nbsp;동의</label>
             		<div class="col-sm-10">
                 		<label class="radio-inline">
                     		<input type="radio" id="registerYn" name="registerYn" value="Y" checked>
                 		</label>
                  		<label class="radio-inline">
                     		<input type="radio" id="registerYn" name="registerYn" value="N">
                 		</label>
             		</div>
         		</div>
         		<div class="alert alert-info fade in col-sm-offset-2 col-sm-10"><strong>[ 도서쇼핑몰의 개인 정보 수집 및 이용 안내 ]</strong>
         			<p>
         				<h5>개인 정보 제3자 제공 동의<br>
             			① 개인정보를 제공받는 자 : BookShop<br>
             			② 개인정보를 제공받는 자의 개인 정보 이용 목적 : 영업관리, 설문조사 및 프로모션, 이벤트, 경품 제공, eDM발송, 행사 관련 마케팅<br>
             			③ 제공하는 개인정보 항목 : 이름, 이메일 주소, 회사명, 직무/직책, 연락처<br>
             			④ 개인정보를 제공받는 자의 개인 정보 보유 및 이용 기간 :
        				개인정보 취급 목적을 달성하여 더 이상 개인정보가 불필요하게 된 경우이거나 5년이 지나면 지체없이 해당 정보를 파기할 것입니다.<br>
            			귀하는 위와 같은 BookShop의 개인정보 수집 및 이용정책에 동의하지 않을 수 있으나,
            			BookShop으로부터 솔루션, 최신 IT정보, 행사초청안내 등의 유용한 정보를 제공받지 못 할 수 있습니다.<br>
             		 	개인정보 보호에 대한 자세한 내용은 http://www.BookShop.com을 참조바랍니다.
         				</h5>
         			</p>
         			<div class="checkbox">
             			<label>
                 			<input type="checkbox" id="is_subscribed" name="is_subscribed" value="o"/>
             			</label> BookShop의 개인 정보 수집 및 이용에 동의합니다.
         			</div>
         		</div>
      		</div>
      		<div class="form-group">
          		<div class="col-sm-offset-2 col-sm-10">
              		<button type="button" class="btn btn-primary" onclick="memberInsertCheckForm(this.form)">회원가입</button>
          		</div>
      		</div>
		</form>
	</div>

</body>
</html>