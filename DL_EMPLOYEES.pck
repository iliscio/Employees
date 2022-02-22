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

   Type TEmployeesRef Is Ref Cursor Return TEmployeeRec;

   Type TEmployeeList Is Table Of TEmployeeRec;

   Function GetEmployeesList Return TEmployeeList;

   Function GetEmployeesList_Ref Return TEmployeesRef;

   Function GetEmployeeById(P_EmployeeId Number) Return TEmployeeRec;

   Function GetEmployeeById_Ref(P_EmployeeId Number) Return TEmployeesRef;

   Procedure SaveEmployee(P_EmployeeRec Employees%Rowtype);

END DL_EMPLOYEES;
/
CREATE OR REPLACE PACKAGE BODY DL_EMPLOYEES IS

-- Returns a list of all Employees in the database
   Function GetEmployeesList Return TEmployeeList Is
   
      V_EmployeeList TEmployeeList;
   
   BEGIN

      Select Emp.Employee_Id, Emp.First_Name, Emp.Last_Name, Emp.Email, Emp.Phone_Number 
        Bulk Collect Into V_EmployeeList From Employees Emp;

      Return V_EmployeeList;
      
   END GetEmployeesList;


-- Returns a Ref Cursor of all Employees in the database
   Function GetEmployeesList_Ref Return TEmployeesRef Is

      c_EmployeeList TEmployeesRef;

   Begin

      Open c_EmployeeList For Select Emp.Employee_Id, Emp.First_Name, Emp.Last_Name, Emp.Email,
                                     Emp.Phone_Number From Employees Emp;

      Return c_EmployeeList;

   End GetEmployeesList_Ref;


-- Returns a record of an employee by Employee_Id
   Function GetEmployeeById(P_EmployeeId Number) Return TEmployeeRec Is

      V_Employee TEmployeeRec;

   Begin

      Select Emp.Employee_Id, Emp.First_Name, Emp.Last_Name, Emp.Email, Emp.Phone_Number Into V_Employee
        From Employees Emp
       Where Emp.Employee_Id = P_EmployeeId;

      Return V_Employee;

   End GetEmployeeById;


-- Returns a Ref Cursor of an employee by Employee_Id
   Function GetEmployeeById_Ref(P_EmployeeId Number) Return TEmployeesRef Is

      C_Employee TEmployeesRef;

   Begin

      Open C_Employee For Select Emp.Employee_Id, Emp.First_Name, Emp.Last_Name, Emp.Email, Emp.Phone_Number
                            From Employees Emp
                           Where Emp.Employee_Id = P_EmployeeId;

      Return C_Employee;

   End GetEmployeeById_Ref;


-- Procedure created in order to insert or update employees into the database.
--    If the parameter P_EmployeeRec.Employee_Id is not null then the record will be updated, 
--  otherwise it will be inserted 
   Procedure SaveEmployee(P_EmployeeRec Employees%Rowtype) Is
   
      v_EmployeeRec Employees%Rowtype Default P_EmployeeRec;
   
   Begin
   
      If v_EmployeeRec.Employee_Id Is Not Null Then
      
         Update Employees Set Row = v_EmployeeRec Where Employee_Id = v_EmployeeRec.Employee_Id;

         Commit;

      Else

         v_EmployeeRec.Employee_Id := EMPLOYEES_SEQ.nextval;

         Insert Into Employees Values v_EmployeeRec;
         
         Commit;

      End If;
   
   End SaveEmployee;

END DL_EMPLOYEES;
/
