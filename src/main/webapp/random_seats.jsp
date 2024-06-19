<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Collections"%>
<%@ page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%!
    private List<String> friendsNames = new ArrayList<>();

	public void jspInit() {
	    List<String> uniqueNames = new ArrayList<>();
	    for (int i = 1; i <= 19; i++) {
	        uniqueNames.add(String.valueOf(i));
	    }
	    Collections.shuffle(uniqueNames);
	    friendsNames = uniqueNames;
	}
%>

<%!
    public List<String> getFriendsNames() {
        return friendsNames;
    }
%>

<%
    jspInit();
    List<String> friendsNames = getFriendsNames();
    Collections.shuffle(friendsNames);
%>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Random_SeatV2</title>
<!--     <link rel="icon" type="image/png" href="/assets/images/logo.png"> -->
    <link rel="stylesheet" href="./styles/app.css">
</head>

<body>
    <div id="header">
        <a href="main.jsp"><img
                src="https://i.namu.wiki/i/sEgsxYlPqTKaFyrVpzvQP7dYY8g-Qd8YlupLl6t-v8QwPpmUxIggPqwfdPupszKUlNh3WZuztw0Qkb-i-G9r8w.webp"
                alt="logo"></a>
        <h2>경소고 랜덤뽑기</h2>
    </div>
    <div id="nav">
        <h1>자리 랜덤 뽑기</h1>
        <p>초기화를 하고 진행해주세요</p>
    </div>
    <div id="section">
        <div id="boader">
            <p>칠판</p>
        </div>
    </div>
    <div id="main">
        <div id="left">
            <span>
                <div class="table1" id="table1-0"></div>
                <div class="table1 table2" id="table1-1"></div>
            </span>
            <span>
                <div class="table1" id="table1-2"></div>
                <div class="table1 table2" id="table1-3"></div>
            </span>
            <span>
                <div class="table1" id="table1-4"></div>
                <div class="table1 table2" id="table1-5"></div>
            </span>
        </div>
        <div id="center">
            <span>
                <div class="table3 table_center" id="table3-0"></div>
                <div class="table3 table4" id="table3-1"></div>
            </span>
            <span class="">
                <div class="table3 table_center" id="table3-2"></div>
                <div class="table3 table4" id="table3-3"></div>
            </span>
            <span class="">
                <div class="table3" id="table3-4"></div>
                <div class="table3 table4" id="table3-5"></div>
                <div class="table3 table4" id="table3-6"></div>
            </span>
        </div>
        <div id="right">
            <span>
                <div class="table5 table6" id="table5-0"></div>
                <div class="table5" id="table5-1"></div>
            </span>
            <span>
                <div class="table5 table6" id="table5-2"></div>
                <div class="table5" id="table5-3"></div>
            </span>
            <span>
                <div class="table5 table6" id="table5-4"></div>
                <div class="table5" id="table5-5"></div>
            </span>
        </div>
    </div>
    <div id="button">
        <button id="fillTables">학생 이름 랜덤 배치</button>
        <button onClick="window.location.reload()">초기화</button>
    </div>

    <script>
        const tables = document.querySelectorAll('.table1, .table2, .table3, .table4, .table5, .table6');

        const students = [
            <% for (String name : friendsNames) { %>
            '<%= name %>',
            <% } %>
        ];

        document.getElementById('fillTables').addEventListener('click', function () {
            let availableStudents = [...students];
            tables.forEach(table => {
                const randomIndex = Math.floor(Math.random() * availableStudents.length);
                table.textContent = availableStudents.splice(randomIndex, 1);
            });
        });

        // 테이블 클릭 시 교환 기능
        let selectedTable1 = null;
        let selectedTable2 = null;

        tables.forEach(table => {
            table.addEventListener('click', () => {
                if (!selectedTable1) {
                    selectedTable1 = table;
                    selectedTable1.style.backgroundColor = 'rgb(210, 141, 50)';
                } else if (!selectedTable2) {
                    selectedTable2 = table;

                    const temp = selectedTable1.textContent;
                    selectedTable1.textContent = selectedTable2.textContent;
                    selectedTable2.textContent = temp;

                    selectedTable1.style.backgroundColor = 'rgb(219, 167, 98)';
                    selectedTable1 = null;
                    selectedTable2 = null;
                }
            });
        });
    </script>
</body>

</html>