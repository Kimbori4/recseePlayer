<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.net.URLEncoder"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <title>RecSee 3rd API</title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge, chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1">
	<%! 
		public String XssFilter(String value) {
			if (value == null) {
				return value;
			}
			value = value.replaceAll("<", "&lt;").replaceAll(">", "&gt;");
		    value = value.replaceAll("\\(", "&#40;").replaceAll("\\)", "&#41;");
		    value = value.replaceAll("'", "&#39;");
		    value = value.replaceAll("eval\\((.*)\\)", "");
		    value = value.replaceAll("[\\\"\\\'][\\s]*javascript:(.*)[\\\"\\\']", "\"\"");
		    value = value.replaceAll("script", "");
		    return value;
		}
	%>
    <%
	   	request.setCharacterEncoding("utf-8");
	    	String method = request.getMethod();
	   	String queryStr	= request.getQueryString();
	   	if("GET".equals(method) && queryStr != null) {
		%>
	   		<script>
	   			//alert("잘못된 페이지 접근입니다.");
	   			//document.location.href="/recseePlayer/";
	   		</script>
   		<%
	   	}
		String SEQNO = XssFilter(request.getParameter("SEQNO"));
		String callKey = XssFilter(request.getParameter("callKey"));
		String mSEQNO = XssFilter(request.getParameter("mSEQNO"));
	   	String uniqueid = XssFilter(request.getParameter("uniqueid"));
	   	String agendid = XssFilter(request.getParameter("agent_id"));
	   	String sso = XssFilter(request.getParameter("sso"));
	   	String USERID = XssFilter(request.getParameter("USERID"));
	   	String CALLID = XssFilter(request.getParameter("CALLID"));
	   	String RDATE = XssFilter(request.getParameter("RDATE"));
		String reqCode = XssFilter(request.getParameter("reqCode"));
	
	/* 20200710 bella 추가 */
	   	String recVolume = XssFilter(request.getParameter("recVolume"));	
	   	String listenId = XssFilter(request.getParameter("listenId"));	
	   	String lang = XssFilter(request.getParameter("lang"));
	
	   	String startPoint = XssFilter(request.getParameter("startPoint"));
	   	String startTime = XssFilter(request.getParameter("startTime"));
	   	String endTime = XssFilter(request.getParameter("endTime"));
	   	String key = XssFilter(request.getParameter("key"));
	   	
	   /* 20200819 justin 추가*/
	   	String ext = XssFilter(request.getParameter("ext"));
	   
	   // 20201209 bella 추가
	   String downType = XssFilter(request.getParameter("downType"));
	   String custPhone = XssFilter(request.getParameter("custPhone"));
	   
	   // GS home 사용 파라미터 (SEQNO, downType, custNum, ext, recVolume)
	%>
	<!--CSS-->

	<!--JS-->
    <script src="js/jquery-2.1.3.min.js"></script>
    <script>
    /*  http://10.62.130.119/recsee/interface/recsee_player.html?USERID=CCB0571&CALLID=006a02ecf6fe3d9a&RDATE=20200512 */
 	window.resizeTo(520,560);

	var rc_player; 
	var downType = '<%=downType%>'; // 다운로드 권한 파라미터 (0: 미사용, 1: 사용)
	$(function() {
    	rc_player = new RecseePlayer({
	             target 		: "#playerObj"	// 플레이어를 표출 할 target
	            ,requestIp 		: "localhost"   // rsfft가 설치된 서버 ip
	            ,http				: "http"
        });
    	
    	var uniqueid='<%=uniqueid %>'; //감성분석 스팟청취를 위한 초
    	
    	var SEQNO='<%=SEQNO%>'; //콜키
    	var callKey='<%=callKey%>'; //콜키
    	var mSEQNO='<%=mSEQNO%>'; //모바일 콜키
    	var agendid='<%=agendid%>'; //사번
    	var sso='<%=sso%>'; //사번	
    	var USERID='<%=USERID%>';
    	var CALLID='<%=CALLID%>';
    	var RDATE ='<%=RDATE%>';
    	var key ='<%=key%>';
    	var ext = '<%=ext%>';
    	var custPhone = '<%=custPhone%>';
    	var reqCode = '<%=reqCode%>'; // 메리츠 부분저장 사용 코드 (1 : 메티스, 2. 스마트 플러스)
    	
   		var flag = "GS"
   		var mobileFlag = "N";
		if (mSEQNO != null && mSEQNO != 'null' && mSEQNO != '') {
			mobileFlag = "Y";
			callKey = mSEQNO;
		} else if (SEQNO != null && SEQNO != 'null' && SEQNO != '') {
			callKey = SEQNO;
		}
    	/* 
    	 * UCS : 유세스 파트너스
    	 * MRZ : 메리츠화재   
    	*/
    	var startPoint ='<%=startPoint%>';
    	var startTime ='<%=startTime%>';
    	var endTime ='<%=endTime%>';
		/* 20200710 bella 추가 */
    	var recVolume ='<%=recVolume%>';
    	// GS홈쇼핑 wfm 연동 시 볼륨이 작다고해서 강제로 증폭시킴
    	recVolume = "10";
    	
    	var listenId ='<%=listenId%>';
    	if (listenId == null || listenId == 'null' || listenId == '') {
    		listenId = "Unknown";
    	}
    	var lang ='<%=lang%>';
    	if (lang != null && lang != 'null' && lang == 'en') {
    		lang = 'en';
    	}
    	
    	if(callKey!=null && callKey!='null' && ext != null && ext != 'null' && ext != ''){
    		rc_player.GSFileListen(callKey, recVolume, ext, custPhone); // callKey : 청취 , recVolume : 볼륨 증폭 , listenId : 이력 관리, lang : 이력 기록 언어 옵션   	
    	}else if(callKey!=null && callKey!='null'){
    		rc_player.FileListen(callKey,recVolume,listenId,lang,mobileFlag); // callKey : 청취 , recVolume : 볼륨 증폭 , listenId : 이력 관리, lang : 이력 기록 언어 옵션   	
    	}else if(ext != null && ext != 'null') {
    		rc_player.RealTimeListen(ext);    	
    	}else if(uniqueid!=null && uniqueid!='null')
    		rc_player.MariaFileListen(uniqueid);
    	else if(callKey!=null && callKey!='null' && agendid!=null && agendid!='null' && sso!=null && sso!='null')
    		rc_player.KyoboFileListen(callKey,agendid,sso); 
    	else if(CALLID!=null && CALLID!='null' && RDATE!=null && RDATE!='null')
    		rc_player.UCSFileListen(USERID,CALLID,RDATE)
    	else if(key != null && key != 'null')
    		rc_player.DirectFileListen(key);
    	
    	if(startPoint != null && startPoint !='null'){ 
    		rc_player.stPoint(startPoint); 
    	} 
    	if(startTime != null && startTime !='null' && endTime != null && endTime !='null'){
    		rc_player.sTeT(startTime, endTime); 
    	}
    });
	</script>
    <script src="js/recsee_player/recsee_player.js"></script>
    <style>
    #recInfoObj {
    	width: 100%;
    	height:50%;
    	float:left;
    }
    #recInfoHeader {
    	width: 100px;
    	height: auto;
    	margin:20px 10px 0;
    	font-size:10pt;
    	font-weight:bold;
    }
    #recInfoTable {
    	width: calc(100% - 18px);
    	height: auto;
    	border:1px solid lightgray;
    	border-top:2px solid #329ADF;
    	margin:10px;
    	font-size:10pt;
    	border-collapse: collapse;
    }
    .recInfoRow {
    	width: 100%;
    	height: 30px;
    	margin: 0;
    }
    .recInfoTitle {
    	width: 30%;
    	border:1px solid lightgray;
    	font-weight:bold;
    	padding: 5px 10px; 
    	background-color: #eeeeee;
    }
    .recInfoValue {
    	width: 70%;
    	border:1px solid lightgray;
    	padding: 5px 10px; 
    }
    
    #playerObj {
    	height:210px;
    }
    </style>
</head>
<body>
<div id="playerObj"></div>
<div id="recInfoObj">
	<div id="recInfoHeader">녹취 이력 정보</div>
	<table id="recInfoTable" >
		<tr class="recInfoRow"><td class="recInfoTitle">녹취 일시</td><td class="recInfoValue" id="recDate"></td></tr>
		<tr class="recInfoRow"><td class="recInfoTitle">통화 시간</td><td class="recInfoValue" id="recTtime"></td></tr>
		<tr class="recInfoRow"><td class="recInfoTitle">상담원 명(ID)</td><td class="recInfoValue" id="agentId"></td></tr>
		<tr class="recInfoRow"><td class="recInfoTitle">내선 번호</td><td class="recInfoValue" id="extNum"></td></tr>
		<tr class="recInfoRow"><td class="recInfoTitle">고객 번호</td><td class="recInfoValue" id="custPhone"></td></tr>
		<tr class="recInfoRow"><td class="recInfoTitle">CON ID</td><td class="recInfoValue" id="callId"></td></tr>
		<tr class="recInfoRow"><td class="recInfoTitle">파일 명</td><td class="recInfoValue" id="fileName"></td></tr>
	</table>
</div>
</body>
</html>
