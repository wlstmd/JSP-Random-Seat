<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%!
    private Connection getConnection() throws SQLException {
        String url = "jdbc:mysql://localhost:3306/students";
        String user = "root";
        String password = "jin009787~";
        return DriverManager.getConnection(url, user, password);
    }

    private List<String> getFriendsNames() {
        List<String> names = new ArrayList<>();
        try (Connection conn = getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery("SELECT name FROM students")) {
            while (rs.next()) {
                names.add(rs.getString("name"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        Collections.shuffle(names);
        return names;
    }
%>

<%
    List<String> friendsNames = getFriendsNames();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Random_SeatV2</title>
    <link rel="stylesheet" href="./styles/app.css">
    <style>
        .modal {
            display: none;
            position: fixed;
            z-index: 1;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            overflow: auto;
            background-color: rgba(0,0,0,0.4);
        }
        .modal-content {
            text-align: center;
            background-color: #fefefe;
            margin: 15% auto;
            padding: 20px;
            border: 1px solid #888;
            width: 50%;
            border-radius: 40px;
            position: relative;
        }
        .modal-content input {
        		border-radius: 40px;
        		box-shadow: 2px 2px 2px grey;
        		border: none;
        		padding: 10px;
        		margin: 5px
        }
        .close {
            color: #aaa;
            float: right;
            font-size: 28px;
            font-weight: bold;
            position: absolute;
            top: 10px;
            right: 20px;
        }
        .close:hover,
        .close:focus {
            color: black;
            text-decoration: none;
            cursor: pointer;
        }
    </style>
</head>
<body>
    <div id="header">
        <a href="main.jsp"><img src="https://i.namu.wiki/i/sEgsxYlPqTKaFyrVpzvQP7dYY8g-Qd8YlupLl6t-v8QwPpmUxIggPqwfdPupszKUlNh3WZuztw0Qkb-i-G9r8w.webp" alt="logo"></a>
        <h2>경소고 랜덤뽑기</h2>
    </div>
    <div id="nav">
        <h1>자리 랜덤 뽑기</h1>
        <p>초기화를 하고 진행해주세요.</p>
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
        <button id="pickRandomStudent">한명씩 뽑기</button>
        <button id="resetButton">초기화</button>
    </div>

    <div id="nameInputModal" class="modal">
        <div class="modal-content">
            <span class="close">&times;</span>
            <h2>19명의 이름을 입력해주세요</h2>
            <form id="nameInputForm">
                <% for (int i = 1; i <= 19; i++) { %>
                    <input type="text" name="name<%= i %>" placeholder="이름 <%= i %>"><br>
                <% } %>
                <button type="submit">제출</button>
            </form>
        </div>
    </div>

    <script>
        const tables = document.querySelectorAll('.table1, .table2, .table3, .table4, .table5, .table6');
        const pickRandomStudentButton = document.getElementById('pickRandomStudent');
        const resetButton = document.getElementById('resetButton');
        const modal = document.getElementById('nameInputModal');
        const nameInputForm = document.getElementById('nameInputForm');
        const closeBtn = document.querySelector('.close');

        let students = [
            <% for (String name : friendsNames) { %>
            '<%= name %>',
            <% } %>
        ];

        let selectedTable1 = null;
        let selectedTable2 = null;

        function shuffleArray(array) {
            for (let i = array.length - 1; i > 0; i--) {
                const j = Math.floor(Math.random() * (i + 1));
                [array[i], array[j]] = [array[j], array[i]];
            }
        }

        function showModal() {
            modal.style.display = "block";
        }

        function hideModal() {
            modal.style.display = "none";
        }

        function resetStudents() {
            students = [];
            tables.forEach(table => {
                table.textContent = '';
                table.style.backgroundColor = '';
            });
            selectedTable1 = null;
            selectedTable2 = null;
        }

        window.onload = function() {
            showModal();
        }

        resetButton.addEventListener('click', function() {
            resetStudents();
            showModal();
        });

        closeBtn.addEventListener('click', hideModal);

        window.onclick = function(event) {
            if (event.target == modal) {
                hideModal();
            }
        }

        nameInputForm.addEventListener('submit', function(e) {
            e.preventDefault();
            const formData = new FormData(nameInputForm);
            students = [];
            for (let pair of formData.entries()) {
                if (pair[1].trim() !== '') {
                    students.push(pair[1].trim());
                }
            }
            hideModal();
            shuffleArray(students);
        });

        pickRandomStudentButton.addEventListener('click', function () {
            if (students.length === 0) {
                alert("19명의 이름을 모두 입력해주세요.");
                showModal();
                return;
            }
            if (students.length > 0) {
                for (let i = 0; i < tables.length; i++) {
                    if (tables[i].textContent === '') {
                        tables[i].textContent = students.pop();
                        break;
                    }
                }
            }
        });

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