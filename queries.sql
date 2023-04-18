-- Создание таблиц
CREATE TABLE Regions (
  id serial PRIMARY KEY,
  Name varchar
);

CREATE TABLE Locations (
  id serial PRIMARY KEY,
  Address varchar,
  Region_id integer,
  FOREIGN KEY(Region_id) REFERENCES Regions(id)
);

CREATE TABLE Departments (
  id serial PRIMARY KEY,
  Name varchar,
  Location_id integer,
  Manager_id integer,
  FOREIGN KEY(Location_id) REFERENCES Locations(id)
);

CREATE TABLE Employees (
  id serial PRIMARY KEY,
  Name varchar,
  Last_name varchar,
  Hire_date DATE,
  Salary integer,
  Email varchar,
  Manager_id integer,
  Department_id integer,
  FOREIGN KEY(Department_id) REFERENCES Departments(id)
);


-- Показать работников у которых нет почты или почта не в корпоративном домене (домен dualbootpartners.com)
SELECT Name, Last_name
FROM Employees
WHERE Email IS NULL OR Email NOT IN "dualbootpartners.com";

-- Получить список работников нанятых в последние 30 дней
SELECT Name, Last_name, Hire_date
FROM Employees
WHERE EXTRACT(DAY FROM NOW() - Hire_date) <= 30;

-- Найти максимальную и минимальную зарплату по каждому департаменту
SELECT max(Employees.salary) AS max_salary, min(Employees.salary) AS min_salary, Departments.Name AS department_name
FROM Employees
INNER JOIN Departments ON Employees.Department_id = Departments.id
GROUP BY department_name;

-- Посчитать количество работников в каждом регионе
SELECT count(Employees.id) AS count_workers, Regions.Name AS region
FROM Employees
    INNER JOIN Departments ON Employees.Department_id = Departments.id
    INNER JOIN Locations ON Departments.Location_id = Locations.id
    INNER JOIN Regions ON Locations.Region_id = Regions.id
GROUP BY Regions.Name;

-- Показать сотрудников у которых фамилия длиннее 10 символов
SELECT Name, Last_name
FROM Employees
WHERE char_length(Last_name) > 10;

-- Показать сотрудников с зарплатой выше средней по всей компании
SELECT Employees.Name, Employees.Last_name, Employees.Salary
FROM Employees
WHERE Salary > (
    SELECT avg(Salary) AS avg_salary
    FROM Employees) avg_salary;
