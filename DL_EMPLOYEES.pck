CREATE OR REPLACE PACKAGE DL_EMPLOYEES IS


/*
   This package has been created in order to store all codes that will be responsible to 
 read or write data into the database.
 
  
*/

   Type TEmployeeRec Is Record (EmpId        employees.employee_id%Type
                               ,EmpFirstName employees.first_name%Type
                               ,EmpLastName  employees.last_name%Type
                               ,EmpMail      employees.email%Type
                               ,EmpPhone     employees.phone_number%Type
                               );
                               
   Type TEmployeeList Is Table Of TEmployeeRec;
                               
   Type TEmployeeRef Is Ref Cursor Return TEmployeeRec;

   Function GetEmployeesList Return TEmployeeList;

   Function GetEmployeeById(P_EMP_ID Number) Return TEmployeeRec;


END DL_EMPLOYEES;
/
CREATE OR REPLACE PACKAGE BODY DL_EMPLOYEES IS


-- Returns a list of all Employees in the database
   FUNCTION GetEmployeesList RETURN TEmployeeList IS
   
      V_EmployeeList TEmployeeList;
   
   BEGIN
   
      Select Emp.Employee_Id, Emp.First_Name, Emp.Last_Name, Emp.Email, Emp.Phone_Number 
        Bulk Collect Into V_EmployeeList
        From Employees Emp;
      
      Return V_EmployeeList;
      
   END GetEmployeesList;

-- Returns a Ref Cursor of all Employees in the database
   FUNCTION GetEmployeesList_Ref RETURN TEmployeeList IS
   
      V_EmployeeList TEmployeeList;
   
   BEGIN
   
      Select Emp.Employee_Id, Emp.First_Name, Emp.Last_Name, Emp.Email, Emp.Phone_Number 

        Bulk Collect Into V_EmployeeList
        From Employees Emp;
      
      Return V_EmployeeList;
      
   END GetEmployeesList_Ref;


-- Returns a record of an employee by Employee_Id
   Function GetEmployeeById(P_EMP_ID Number) Return TEmployeeRec Is
   
      V_Employee TEmployeeRec;
   
   Begin
   
      Select Emp.Employee_Id, Emp.First_Name, Emp.Last_Name, Emp.Email, Emp.Phone_Number Into V_Employee
        From Employees Emp
       Where Emp.Employee_Id = P_EMP_ID;
   
      Return V_Employee;
   
   End GetEmployeeById;

-- Returns a Ref Cursor of an employee by Employee_Id
   Function GetEmployeeById_Ref(P_EMP_ID Number) Return TEmployeeRef Is

      C_Employee TEmployeeRef;

   Begin

      Open C_Employee For Select Emp.Employee_Id, Emp.First_Name, Emp.Last_Name, Emp.Email, Emp.Phone_Number
                            From Employees Emp
                           Where Emp.Employee_Id = P_EMP_ID;

      Return C_Employee;

   End GetEmployeeById_Ref;

END DL_EMPLOYEES;
/
