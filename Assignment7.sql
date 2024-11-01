/*

Assignment 6

Part 3

1.	Create a scalar function that takes a date and returns the Month name of that date.

*/

create function 
getMonthFromDate(@theDate varchar(20))
returns varchar(2)
begin 
declare @dateRes varchar(2)
select @dateRes =  MONTH(@theDate)
return @dateRes

end


select dbo.getMonthFromDate('12-23-2024')


/*

Assignment 6

Part 3

2. Create a multi-statements table-valued function that takes 2 integers and returns the values between them.

*/

CREATE FUNCTION GetNumbersBetween (@Start INT, @End INT)
RETURNS @Numbers TABLE (Number INT)
AS
BEGIN
  DECLARE @Current INT;

  SET @Current = @Start;

  WHILE @Current <= @End
  BEGIN
    INSERT INTO @Numbers (Number)
    VALUES (@Current);

    SET @Current = @Current + 1;
  END;

  RETURN;
END;


select * from GetNumbersBetween(9,25)


/*

Assignment 6

Part 3

3. Create a table-valued function that takes Student No and returns Department Name with Student full name.

*/


CREATE FUNCTION GetStudentData (@stu_id INT)
RETURNS @res TABLE (departmentName varchar(20),studentFName varchar(20))
AS
BEGIN
 
 insert into @res
 select dp.Dept_Name,CONCAT(st.St_Fname,' ',st.St_Lname)
 from Student st inner join Department dp
 on st.Dept_Id = dp.Dept_Id and st.St_Id = @stu_id
  
  RETURN;
END;


select * from GetStudentData(7)


/*

Assignment 6

Part 3

4.	Create a scalar function that takes Student ID and returns a message to user 
a.	If first name and Last name are null then display 'First name & last name are null'
b.	If First name is null then display 'first name is null'
c.	If Last name is null then display 'last name is null'
d.	Else display 'First name & last name are not null'
*/

create function 
isNullName(@stu_id int)
returns varchar(40)
begin
declare @str1 varchar(40)
declare @str2 varchar(40)
declare @res varchar(40)
select @str1 = St_Fname,@str2 = St_Lname
from student
where St_Id = @stu_id
if @str1 is null and @str2 is null
set @res =  'First name & last name are null'
else if @str1 is null and @str2 is not null
set @res =  'first name is null'
else if @str1 is not null and @str2 is null
set @res = 'last name is null'
else
set @res =  'First name & last name are not null'
return @res
end


select dbo.isNullName(1111)


/*

Assignment 6

Part 3

5.	Create a function that takes an integer which represents the format of the Manager hiring date and displays department name, Manager Name and hiring date with this format.   
*/

CREATE or alter FUNCTION managerDepartment (@hiringDate date)
RETURNS @md TABLE (depName varchar(20),manName varchar(20),hDate date)
AS
BEGIN
 insert into @md
 select Dept_Manager,Dept_Name,Manager_hiredate
 from Department
 where Manager_hiredate = @hiringDate
  RETURN;
END;


select * from dbo.managerDepartment('2008-05-04')








/*

Assignment 6

Part 3

6.	Create multi-statement table-valued function that takes a string
a.	If string='first name' returns student first name
b.	If string='last name' returns student last name 
c.	If string='full name' returns Full Name from student table  (Note: Use “ISNULL” function)  
*/

CREATE FUNCTION displayName (@name varchar(15))
RETURNS @Names TABLE (Name varchar(15))
AS
BEGIN
  
 if @name in ('first name')
 insert into @Names(Name)
 select ISNULL(St_Fname,'unknown')
 from Student
 else if @name in ('last name')
 insert into @Names(Name)
 select ISNULL(St_Lname,'unknown')
 from Student

  else if @name in ('full name')
 insert into @Names(Name)
 select CONCAT(ISNULL(St_Fname,'unknown'),' ',ISNULL(St_Lname,'unknown'))
 from Student
  RETURN;
END;


select * from dbo.displayName('first name')
select * from dbo.displayName('last name')
select * from dbo.displayName('full name')


/*

Assignment 6

Part 3

7.	Create function that takes project number and display all employees in this project (Use MyCompany DB)
*/

CREATE FUNCTION getProjectEmployees (@pNumber int)
RETURNS @Names TABLE (Name varchar(15))
AS
BEGIN

insert into @Names(Name)
select CONCAT(e.Fname,' ',e.Lname)
from project p inner join works_for wf
on p.Pnumber = wf.Pno and p.Pnumber = @pNumber
inner join Employee e
on e.SSN = wf.ESSn
  
  RETURN;
END;

select * from dbo.getProjectEmployees(100)


/*

Assignment 7

Part 1.1

1.	 Create a view that displays the student's full name, course name if the student has a grade more than 50. 
*/

create or alter view studCourseGrade(fullName,courseName)
as
select CONCAT(s.St_Fname,' ',s.St_Lname),c.Crs_Name
from Student s inner join Stud_Course sc
on s.St_Id = sc.St_Id inner join Course c
on c.Crs_Id = sc.Crs_Id
where sc.Grade > 50


select * from studCourseGrade



/*

Assignment 7

Part 1.1

2.	 Create an Encrypted view that displays manager names and the topics they teach.  
*/

create or alter view managerTopic(fullName,topicName)
with encryption
as
select i.Ins_Name,t.Top_Name
from Instructor i inner join Ins_Course ic
on i.Ins_Id = ic.Ins_Id inner join course c
on c.Crs_Id = ic.Crs_Id inner join Topic t
on t.Top_Id = c.Top_Id


select * from dbo.managerTopic

/*

Assignment 7

Part 1.1

3.	Create a view that will display Instructor Name, Department Name for the ‘SD’ or ‘Java’ Department “use Schema binding” and describe what is the meaning of Schema Binding
*/

CREATE VIEW InstructorDeptView
WITH SCHEMABINDING
AS
SELECT 
  i.Ins_Name,
  d.Dept_Name
FROM dbo.Instructor i
INNER JOIN dbo.Department d ON i.Dept_Id = d.Dept_Id
WHERE d.Dept_Name IN ('SD', 'Java');

select * from dbo.InstructorDeptView

/*
Schema binding is an optional clause used when creating views in some database systems, typically relational databases. It ensures a tighter relationship between the view definition and the underlying tables it references.
*/


/*

Assignment 7

Part 1.1

4. Create a view “V1” that displays student data for students who live in Alex or Cairo
*/

create or alter view v1(stID,stFullName,stAddress,stAge)
as
select St_Id,CONCAT(St_Fname,' ',St_Lname),St_Address,St_Age
from Student
where St_Address in ('Alex','Cairo')
with check option



select * from dbo.v1

Update V1 set stAddress='tanta'
Where stAddress='alex';


/*

Assignment 7

Part 1.1

5.	Create a view that will display the project name and the number of employees working on it. (Use Company DB)
*/

create or alter view projectEmployees(projectName,NoOfEmployees)
as
select p.ProjectName,COUNT(e.EmpNo)
from HR.Employee e inner join dbo.Works_on wo
on e.EmpNo = wo.EmpNo inner join HR.Project p
on p.ProjectNo = wo.ProjectNo
group by p.ProjectName


select * from dbo.projectEmployees



/*

Assignment 7

Part 1.2

1.	Create a view named   “v_clerk” that will display employee Number ,project Number, the date of hiring of all the jobs of the type 'Clerk' DB)
*/

create or alter view v_clerk(Employee_Number,Project_Number,Hiring_Date)
as
select e.EmpNo,p.ProjectNo,wo.Enter_Date
from HR.Employee e inner join dbo.Works_on wo
on e.EmpNo = wo.EmpNo inner join HR.Project p
on p.ProjectNo = wo.ProjectNo
where lower(wo.Job) = 'clerk'


select * from dbo.v_clerk 


/*

Assignment 7

Part 1.2

2. Create view named  “v_without_budget” that will display all the projects data without budget
*/
create or alter view v_without_budget(Project_Number,Project_Name)
as
select ProjectNo,ProjectName
from HR.Project


select * from dbo.v_without_budget


/*

Assignment 7

Part 1.2

3.	Create view named  “v_count “ that will display the project name and the Number of jobs in it
*/

create or alter view v_count(Project_Name,Number_of_jobs)
as

select p.ProjectName,COUNT(wo.Job)
from HR.Project p inner join Works_on wo
on wo.ProjectNo = p.ProjectNo
group by p.ProjectName

select * from dbo.v_count

/*

Assignment 7

Part 1.2

4. Create view named ” v_project_p2” that will display the emp# s for the project# ‘p2’ . (use the previously created view  “v_clerk”)
*/

create or alter view v_project_p2(Emp_Num,Pro_Num)
as
select Employee_Number,Project_Number
from dbo.v_clerk
where Project_Number = 2

select * from dbo.v_project_p2

/*

Assignment 7

Part 1.2

5.	modify the view named  “v_without_budget”  to display all DATA in project p1 and p2
*/
alter view  v_without_budget(Project_Number,Project_Name,Budget)
as
select ProjectNo,ProjectName,Budget
from HR.Project


select * from dbo.v_without_budget

/*

Assignment 7

Part 1.2

6.	Delete the views  “v_ clerk” and “v_count”
*/

DROP VIEW  dbo.v_clerk,dbo.v_count;

/*

Assignment 7

Part 1.2

7.	Create view that will display the emp# and emp last name who works on deptNumber is ‘d2’
*/

create or alter view  EmployeeDepartment(Employee_Number,Employee_Last_Name,Department_Number)
as
select e.EmpNo,e.EmpLname,d.DeptNo
from HR.Employee e inner join Company.Department d
on e.DeptNo = d.DeptNo and d.DeptNo = 2

select * from dbo.EmployeeDepartment  -- no employee does exist in department 2 btw

/*

Assignment 7

Part 1.2

8.	Display the employee  lastname that contains letter “J” (Use the previous view created in Q#7)
*/

select *
from dbo.EmployeeDepartment
where lower(Employee_Last_Name) like '%j%'

/*

Assignment 7

Part 1.2

9.	Create view named “v_dept” that will display the department# and department name
*/
create or alter view  v_dept(Department_Number,Department_Name)
as 
select DeptNo,DeptName
from Company.Department
union all
select DeptNo,DeptName
from dbo.Department


select * from dbo.v_dept


/*

Assignment 7

Part 1.2

10.	using the previous view try enter new department data where dept# is ’d4’ and dept name is ‘Development’
*/

insert into dbo.v_dept(Department_Number,Department_Name) values (4,'Development')


/*

Assignment 7

Part 1.2

11.	Create view name “v_2006_check” that will display employee Number, the project 
Number where he works and the date of joining the project which 
must be from the first of January and the last of December 2006.
this view will be used to insert data so make 
sure that the coming new data must match the condition.
*/
create or alter view v_2006_check(Employee_Number,Project_Number)
as
select e.EmpNo,p.ProjectNo
from HR.Employee e inner join dbo.Works_on wo
on e.EmpNo = wo.EmpNo inner join HR.Project p
on p.ProjectNo = wo.ProjectNo and format(wo.Enter_Date,'yyyy') = 2006   --no 2006 hiredate btw

select * from dbo.v_2006_check

/*


Assignment 7

Part 2

1.	Create a stored procedure to show the number of students per department.[use ITI DB] 
*/

create or alter proc sp_student_department
as
select COUNT(s.St_Id),d.Dept_Name
from Student s inner join Department d
on s.Dept_Id = d.Dept_Id
group by d.Dept_Name


exec sp_student_department

/*


Assignment 7

Part 2

2.	Create a stored procedure that will check 
for the Number of employees in the project 100 
if they are more than 3 print message to the user 
“'The number of employees in the project 100 is 3 or more'” 
if they are less display a message to the user 
“'The following employees work for the project 100'” 
in addition to the first name and last name of each one. [MyCompany DB] 
*/





create or alter proc sp_employee_project
as
declare @empNum int 
set @empNum = (
select COUNT(e.SSN)
from Project p inner join Works_for wf
on p.Pnumber = wf.Pno and p.Pnumber = 100 inner join Employee e
on e.SSN = wf.ESSn
)
if @empNum >3
select 'The number of employees in the project 100 is 3 or more'
else
select CONCAT( e.Fname,' ',e.Lname) as ['The following employees work for the project 100']
from Project p inner join Works_for wf
on p.Pnumber = wf.Pno and p.Pnumber = 100 inner join Employee e
on e.SSN = wf.ESSn

exec sp_employee_project


/*


Assignment 7

Part 2

3.	Create a stored procedure that will 
be used in case an old 
employee has left the project and a new one becomes his 
replacement. The procedure should take 3 parameters 
(old Emp. number, new Emp. number and the project number) 
and it will be used to update works_on table. [MyCompany DB] 
*/

CREATE PROCEDURE UpdateWorksOn (@old_emp_num int, @new_emp_num int, @project_id int)
AS
  /* Update works_on table to replace old employee with new one */
  UPDATE Works_for
  SET ESSn = @new_emp_num
  WHERE ESSn = @old_emp_num
    AND Pno = @project_id;

  /* Check if update affected any rows */
  IF @@ROWCOUNT = 0
  select 'There is no old employee with such an id'

  exec UpdateWorksOn 2,2,3


  /*


Assignment 7

Part 2

4.	Create an Audit table with the following structure 
ProjectNo 	UserName 	ModifiedDate 	Budget_Old 	Budget_New 
100	Dbo 	2008-01-31	95000 	200000 

This table will be used to audit the update trials on the Budget column (Project table, SD32-Company DB)
Example:
If a user updated the budget column then the project number, username that made that update, 
the date of the modification and the value of the old and the new budget will be inserted into the Audit table
Note: This process will take place only if the user updated the budget column

*/

CREATE TABLE Budget_Update_Audit (
  ProjectNo INT NOT NULL,
  UserName VARCHAR(50) NOT NULL,
  ModifiedDate DATETIME NOT NULL,
  Budget_Old DECIMAL(10,2) not  NULL,
  Budget_New DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (ProjectNo, ModifiedDate)  
);

drop table Budget_Update_Audit

CREATE TABLE Budget_Update_Audit (
  ProjectNo varchar(10) references HR.Project(ProjectNo) not null,
  UserName VARCHAR(50) NOT NULL,
  ModifiedDate DATETIME NOT NULL,
  Budget_Old DECIMAL(10,2) not  NULL,
  Budget_New DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (ProjectNo, ModifiedDate)  
);




/*
Assignment 7

Part 3

1.	Create a stored procedure that calculates the sum of a given range of numbers
*/




CREATE PROCEDURE GetSumRange (
  @Start INT,
  @End INT
)
AS
BEGIN
  DECLARE @Sum INT;
  SET @Sum = (@Start + @End) * (@End - @Start + 1) / 2;

  SELECT @Sum AS TotalSum;
END;

exec GetSumRange 9,25
/*

Assignment 7

Part 3

2.	Create a stored procedure that calculates the area of a circle given its radius
*/
CREATE PROCEDURE GetCircleArea (
  @Radius DEC(10,2) 
)
AS
BEGIN
  DECLARE @Pi DEC(10,2) = 3.14159; 
  DECLARE @Area DEC(10,2);

  SET @Area = @Pi * @Radius * @Radius;

  SELECT @Area AS CircleArea;
END;

exec GetCircleArea 7





/*

Assignment 7

Part 3
3.	Create a stored procedure that calculates the age category based
on a person's age 
( Note: IF Age < 18 then Category is Child and if  Age >= 18 AND Age < 60 then Category is Adult otherwise  Category is Senior)
*/



CREATE PROCEDURE GetAgeCategory 
(
  @Age INT
)
AS
BEGIN
  DECLARE @Category NVARCHAR(10);

  IF @Age < 18
  BEGIN
    SET @Category = 'Child';
  END
  ELSE IF @Age >= 18 AND @Age < 60
  BEGIN
    SET @Category = 'Adult';
  END
  ELSE
  BEGIN
    SET @Category = 'Senior';
  END

  SELECT @Category AS Category;
END;

exec GetAgeCategory 25



/*

Assignment 7

Part 3
4.	Create a stored procedure that determines the maximum, minimum, and average of a given set of numbers 
( Note : set of numbers as Numbers = '5, 10, 15, 20, 25')
*/


CREATE PROCEDURE GetNumberStats
(
  @Numbers VARCHAR(50)
)
AS
BEGIN
  DECLARE @T TABLE (Number varchar(50));

  INSERT INTO @T (Number)
  SELECT *
  FROM STRING_SPLIT(@Numbers, ',');

  SELECT 
    MAX(CONVERT(float, Number)) AS Maximum,
    MIN(CONVERT(float, Number)) AS Minimum,
    AVG(CONVERT(float, Number)) AS Average
  FROM @T;
END;


exec GetNumberStats '5,10,15,20,25'