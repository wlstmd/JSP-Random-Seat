<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>

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
        #main {
            display: flex;
            justify-content: center;
            gap: 20px;
        }
        .column {
            display: flex;
            flex-direction: column;
            gap: 10px;
        }
        .table {
            width: 100px;
            height: 60px;
            border: 1px solid #ccc;
            display: flex;
            justify-content: center;
            align-items: center;
            cursor: pointer;
			background-color: rgb(219, 167, 98);
			border: 2px solid black;
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
        <p>초기화를 하고 진행해주세요</p>
    </div>
    <div id="section">
        <div id="boader">
            <p>칠판</p>
        </div>
    </div>
    <div id="main">
        <div class="column">
            <div class="table"></div>
            <div class="table"></div>
            <div class="table"></div>
            <div class="table"></div>
        </div>
        <div class="column">
            <div class="table"></div>
            <div class="table"></div>
            <div class="table"></div>
            <div class="table"></div>
        </div>
        <div class="column">
            <div class="table"></div>
            <div class="table"></div>
            <div class="table"></div>
            <div class="table"></div>
        </div>
        <div class="column">
            <div class="table"></div>
            <div class="table"></div>
            <div class="table"></div>
            <div class="table"></div>
        </div>
        <div class="column">
            <div class="table"></div>
            <div class="table"></div>
            <div class="table"></div>
        </div>
    </div>
    <div id="button">
        <button id="fillTables">학생 이름 랜덤 배치</button>
        <button id="resetButton">초기화</button>
    </div>

    <div id="nameInputModal" class="modal">
        <div class="modal-content">
            <span class="close">&times;</span>
            <h2>19명의 이름을 입력해주세요</h2>
            <form id="nameInputForm">
                <% for (int i = 1; i <= 19; i++) { %>
                    <input type="text" name="name<%= i %>" placeholder="이름 <%= i %>" required><br>
                <% } %>
                <button type="submit">제출</button>
            </form>
        </div>
    </div>

    <script>
        const tables = document.querySelectorAll('.table');
        const fillTablesButton = document.getElementById('fillTables');
        const resetButton = document.getElementById('resetButton');
        const modal = document.getElementById('nameInputModal');
        const nameInputForm = document.getElementById('nameInputForm');
        const closeBtn = document.querySelector('.close');

        let students = [];
        let selectedTable = null;

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
            selectedTable = null;
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
                students.push(pair[1]);
            }
            hideModal();
            shuffleArray(students);
        });

        fillTablesButton.addEventListener('click', function () {
            if (students.length === 19) {
                shuffleArray(students);
                tables.forEach((table, index) => {
                    if (index < students.length) {
                        table.textContent = students[index];
                        table.style.backgroundColor = '';
                    }
                });
                selectedTable = null;
            } else {
                alert('19명의 이름을 모두 입력해주세요.');
                showModal();
            }
        });

        tables.forEach(table => {
            table.addEventListener('click', () => {
                if (!selectedTable) {
                    selectedTable = table;
                    selectedTable.style.backgroundColor = 'rgb(210, 141, 50)';
                } else if (selectedTable !== table) {
                    const temp = selectedTable.textContent;
                    selectedTable.textContent = table.textContent;
                    table.textContent = temp;

                    selectedTable.style.backgroundColor = '';
                    table.style.backgroundColor = '';

                    selectedTable = null;
                } else {
                    selectedTable.style.backgroundColor = '';
                    selectedTable = null;
                }
            });
        });
    </script>
</body>
</html>