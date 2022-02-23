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
   
   Function GetEmployeeByName_Ref(P_EmpFirstName Employees.first_name%Type, P_EmpLastName Employees.last_name%Type) Return TEmployeesRef;
   
   Function GetEmployeeByName(P_EmpFirstName Employees.first_name%Type, P_EmpLastName Employees.last_name%Type) Return TEmployeeRec;

   Procedure SaveEmployee(P_EmployeeRec Employees%Rowtype);

   Procedure DeleteEmployeeById(P_EmployeeId Number);

END DL_EMPLOYEES;
/
CREATE OR REPLACE PACKAGE BODY DL_EMPLOYEES IS


-- Returns a record of an employee by First_Name and Last_Name
   Function GetEmployeeByName(P_EmpFirstName Employees.first_name%Type, P_EmpLastName Employees.last_name%Type) Return TEmployeeRec Is

      V_Employee TEmployeeRec;

   Begin

      DL_LOGS.SaveLogs(P_logMessage => 'Starting DL_EMPLOYEES.GetEmployeeByName function', P_logDbmessage => Null,P_logDate => Sysdate);

      V_Employee := Null;

      DL_LOGS.SaveLogs(P_logMessage => 'Selecting employee from Employees Table By Name: '||P_EmpFirstName||' '||P_EmpLastName,P_logDbmessage => Null,P_logDate => Sysdate);

      Select Emp.Employee_Id, Emp.First_Name, Emp.Last_Name, Emp.Email, Emp.Phone_Number Into V_Employee
        From Employees Emp
       Where Emp.First_Name = P_EmpFirstName
         And Emp.Last_Name  = P_EmpLastName;

      DL_LOGS.SaveLogs(P_logMessage => 'Returning employee data from DL_EMPLOYEES.GetEmployeeByName function',P_logDbmessage => Null,P_logDate => Sysdate);

      Return V_Employee;

   Exception
      When Too_Many_Rows Then
         DL_LOGS.SaveLogs(P_logMessage => 'Two or more employees was returned by Name: '||P_EmpFirstName||' '||P_EmpLastName,P_logDbmessage => Sqlerrm,P_logDate => Sysdate);
         Raise_Application_Error(-20001,'Two or more employees was returned with the same Name. Check the logs.',True);
      When NO_DATA_FOUND Then
         DL_LOGS.SaveLogs(P_logMessage => 'No employee found with Name: '||P_EmpFirstName||' '||P_EmpLastName,P_logDbmessage => Sqlerrm,P_logDate => Sysdate);
         Raise_Application_Error(-20001,'No Employee has been found. Check the logs.',True);
      When Others Then
         DL_LOGS.SaveLogs(P_logMessage => 'Aborting DL_EMPLOYEES.GetEmployeeByName, an error has occurred while function execution',P_logDbmessage => Sqlerrm,P_logDate => Sysdate);
         Raise_Application_Error(-20001,'An error has occurred while GetEmployeeByName function execution. Check the logs.',True);
   End GetEmployeeByName;


-- Returns a Ref Cursor of an employee by First_Name and Last_Name
   Function GetEmployeeByName_Ref(P_EmpFirstName Employees.first_name%Type, P_EmpLastName Employees.last_name%Type) Return TEmployeesRef Is

      C_Employee TEmployeesRef;

   Begin
  
      DL_LOGS.SaveLogs(P_logMessage => 'Starting DL_EMPLOYEES.GetEmployeeByName_Ref function',P_logDbmessage => Null,P_logDate => Sysdate);

      C_Employee := Null;

      DL_LOGS.SaveLogs(P_logMessage => 'Opening the cursor with Name: '||P_EmpFirstName||' '||P_EmpLastName,P_logDbmessage => Null,P_logDate => Sysdate);

      Open C_Employee For Select Emp.Employee_Id, Emp.First_Name, Emp.Last_Name, Emp.Email, Emp.Phone_Number
                            From Employees Emp
                           Where Emp.First_Name = P_EmpFirstName
                             And Emp.Last_Name  = P_EmpLastName;

      DL_LOGS.SaveLogs(P_logMessage => 'Returning Memory Reference of data from DL_EMPLOYEES.GetEmployeeByName_Ref',P_logDbmessage => Null,P_logDate => Sysdate);

      Return C_Employee;

   Exception
      When Others Then
         DL_LOGS.SaveLogs(P_logMessage => 'Aborting DL_EMPLOYEES.GetEmployeeByName_Ref, an error has occurred while function execution',P_logDbmessage => Sqlerrm,P_logDate => Sysdate);
         Raise_Application_Error(-20001,'An error has occurred while GetEmployeeById_Ref function execution. Check the logs.',True);
   End GetEmployeeByName_Ref;


-- Returns a list of all Employees in the database
   Function GetEmployeesList Return TEmployeeList Is
   
      V_EmployeeList TEmployeeList;
   
   Begin
   
      DL_LOGS.SaveLogs(P_logMessage => 'Starting DL_EMPLOYEES.GetEmployeesList function',P_logDbmessage => Null,P_logDate => Sysdate);

      V_EmployeeList := Null;

      DL_LOGS.SaveLogs(P_logMessage => 'Selecting all employees from Employees Table',P_logDbmessage => Null,P_logDate => Sysdate);
                
      Select Emp.Employee_Id, Emp.First_Name, Emp.Last_Name, Emp.Email, Emp.Phone_Number 
        Bulk Collect Into V_EmployeeList From Employees Emp;

      DL_LOGS.SaveLogs(P_logMessage => 'Returning data from DL_EMPLOYEES.GetEmployeesList function',P_logDbmessage => Null,P_logDate => Sysdate);

      Return V_EmployeeList;
      
   Exception
      When Others Then
         DL_LOGS.SaveLogs(P_logMessage   => 'Aborting DL_EMPLOYEES.GetEmployeesList, an error has occurred while function execution',P_logDbmessage => Sqlerrm,P_logDate => Sysdate);         
         Raise_Application_Error(-20001,'An error has occurred while GetEmployeesList function execution. Check the logs.',True);
   END GetEmployeesList;


-- Returns a Ref Cursor of all Employees in the database
   Function GetEmployeesList_Ref Return TEmployeesRef Is

      c_EmployeeList TEmployeesRef;

   Begin

      DL_LOGS.SaveLogs(P_logMessage => 'Starting DL_EMPLOYEES.GetEmployeesList_Ref function',P_logDbmessage => Null,P_logDate => Sysdate);

      c_EmployeeList := Null;

      DL_LOGS.SaveLogs(P_logMessage => 'Opening the cursor',P_logDbmessage => Null,P_logDate => Sysdate);

      Open c_EmployeeList For Select Emp.Employee_Id, Emp.First_Name, Emp.Last_Name, Emp.Email,
                                     Emp.Phone_Number From Employees Emp;

      DL_LOGS.SaveLogs(P_logMessage => 'Returning Memory Reference of data from DL_EMPLOYEES.GetEmployeesList_Ref',P_logDbmessage => Null,P_logDate => Sysdate);

      Return c_EmployeeList;

   Exception
      When Others Then
         DL_LOGS.SaveLogs(P_logMessage => 'Aborting DL_EMPLOYEES.GetEmployeesList_Ref, an error has occurred while function execution',P_logDbmessage => Sqlerrm,P_logDate => Sysdate);
         Raise_Application_Error(-20001,'An error has occurred while GetEmployeesList_Ref function execution. Check the logs.',True);
   End GetEmployeesList_Ref;


-- Returns a record of an employee by Employee_Id
   Function GetEmployeeById(P_EmployeeId Number) Return TEmployeeRec Is

      V_Employee TEmployeeRec;

   Begin

      DL_LOGS.SaveLogs(P_logMessage => 'Starting DL_EMPLOYEES.GetEmployeeById function',P_logDbmessage => Null,P_logDate => Sysdate);

      V_Employee := Null;

      DL_LOGS.SaveLogs(P_logMessage => 'Selecting employee from Employees Table By Id: '||P_EmployeeId,P_logDbmessage => Null,P_logDate => Sysdate);

      Select Emp.Employee_Id, Emp.First_Name, Emp.Last_Name, Emp.Email, Emp.Phone_Number Into V_Employee
        From Employees Emp
       Where Emp.Employee_Id = P_EmployeeId;

      DL_LOGS.SaveLogs(P_logMessage => 'Returning employee data from DL_EMPLOYEES.GetEmployeeById function', P_logDbmessage => Null, P_logDate => Sysdate);

      Return V_Employee;

   Exception
      When Too_Many_Rows Then
         DL_LOGS.SaveLogs(P_logMessage => 'Two or more employees was returned by id: '||P_EmployeeId, P_logDbmessage => Sqlerrm, P_logDate => Sysdate);
         Raise_Application_Error(-20001,'Two or more employees was returned with the same ID. Check the logs.',True);
      When NO_DATA_FOUND Then
         DL_LOGS.SaveLogs(P_logMessage => 'No employee found with id: '||P_EmployeeId, P_logDbmessage => Sqlerrm, P_logDate => Sysdate);
         Raise_Application_Error(-20001,'No Employee has been found. Check the logs.',True);
      When Others Then
         DL_LOGS.SaveLogs(P_logMessage => 'Aborting DL_EMPLOYEES.GetEmployeeById, an error has occurred while function execution', P_logDbmessage => Sqlerrm, P_logDate => Sysdate);
         Raise_Application_Error(-20001,'An error has occurred while GetEmployeeById function execution. Check the logs.',True);
   End GetEmployeeById;


-- Returns a Ref Cursor of an employee by Employee_Id
   Function GetEmployeeById_Ref(P_EmployeeId Number) Return TEmployeesRef Is

      C_Employee TEmployeesRef;

   Begin
   
      DL_LOGS.SaveLogs(P_logMessage => 'Starting DL_EMPLOYEES.GetEmployeeById_Ref function', P_logDbmessage => Null, P_logDate => Sysdate);

      C_Employee := Null;

      DL_LOGS.SaveLogs(P_logMessage => 'Opening the cursor with employee_id: '||P_EmployeeId,P_logDbmessage => Null,P_logDate => Sysdate);

      Open C_Employee For Select Emp.Employee_Id, Emp.First_Name, Emp.Last_Name, Emp.Email, Emp.Phone_Number
                            From Employees Emp
                           Where Emp.Employee_Id = P_EmployeeId;

      DL_LOGS.SaveLogs(P_logMessage => 'Returning Memory Reference of data from DL_EMPLOYEES.GetEmployeeById_Ref', P_logDbmessage => Null, P_logDate => Sysdate);

      Return C_Employee;

   Exception
      When Others Then
         DL_LOGS.SaveLogs(P_logMessage => 'Aborting DL_EMPLOYEES.GetEmployeeById_Ref, an error has occurred while function execution', P_logDbmessage => Sqlerrm, P_logDate => Sysdate);
         Raise_Application_Error(-20001,'An error has occurred while GetEmployeeById_Ref function execution. Check the logs.',True);
   End GetEmployeeById_Ref;


-- Procedure created in order to insert or update employees into the database.
--    If the parameter P_EmployeeRec.Employee_Id is not null then the record will be updated, 
--  otherwise it will be inserted 
   Procedure SaveEmployee(P_EmployeeRec Employees%Rowtype) Is
   
      v_EmployeeRec Employees%Rowtype Default P_EmployeeRec;
   
   Begin
   
      DL_LOGS.SaveLogs(P_logMessage => 'Starting DL_EMPLOYEES.SaveEmployee procedure', P_logDbmessage => Null, P_logDate => Sysdate);

      DL_LOGS.SaveLogs(P_logMessage => 'Checking if the Employee_id is null', P_logDbmessage => Null, P_logDate => Sysdate);
   
      If v_EmployeeRec.Employee_Id Is Not Null Then
      
         DL_LOGS.SaveLogs(P_logMessage => 'Updating the records with the employee_id: '||v_EmployeeRec.Employee_Id, P_logDbmessage => Null, P_logDate => Sysdate);
      
         Update Employees Set Row = v_EmployeeRec Where Employee_Id = v_EmployeeRec.Employee_Id;

         DL_LOGS.SaveLogs(P_logMessage => 'Commiting. '||Sql%Rowcount||' rows updated.', P_logDbmessage => Null, P_logDate => Sysdate);

         Commit;

      Else

         v_EmployeeRec.Employee_Id := EMPLOYEES_SEQ.nextval;

         DL_LOGS.SaveLogs(P_logMessage => 'Inserting record at employees table with id: '||v_EmployeeRec.Employee_Id, P_logDbmessage => Null, P_logDate => Sysdate);

         Insert Into Employees Values v_EmployeeRec;
         
         DL_LOGS.SaveLogs(P_logMessage => 'Commiting. '||Sql%Rowcount||' row(s) afcted.', P_logDbmessage => Null, P_logDate => Sysdate);
         
         Commit;

      End If;
      
      DL_LOGS.SaveLogs(P_logMessage => 'Finishing the procedure DL_EMPLOYEES.SaveEmployee', P_logDbmessage => Null, P_logDate => Sysdate);
   
   Exception
      When Others Then
         DL_LOGS.SaveLogs(P_logMessage => 'Aborting DL_EMPLOYEES.SaveEmployee, an error has occurred while procedure execution', P_logDbmessage => Sqlerrm, P_logDate => Sysdate);
         Raise_Application_Error(-20001,'An error has occurred while SaveEmployee procedure execution. Check the logs.',True);
   End SaveEmployee;


-- Procedure created in order to delete records from Employees Table by Employee Id
   Procedure DeleteEmployeeById(P_EmployeeId Number) Is
   
   Begin
   
      DL_LOGS.SaveLogs(P_logMessage => 'Starting DL_EMPLOYEES.DeleteEmployeeById procedure', P_logDbmessage => Null, P_logDate => Sysdate);

      DL_LOGS.SaveLogs(P_logMessage => 'Deleting records with employee_id: '||P_EmployeeId, P_logDbmessage => Null, P_logDate => Sysdate);
   
      Delete Employees Where Employee_id = P_EmployeeId;
      
      DL_LOGS.SaveLogs(P_logMessage => 'Commiting. '||Sql%Rowcount||' row(s) deleted.', P_logDbmessage => Null, P_logDate => Sysdate);
      
      Commit;
      
      DL_LOGS.SaveLogs(P_logMessage => 'Finishing the procedure DL_EMPLOYEES.DeleteEmployeeById', P_logDbmessage => Null, P_logDate => Sysdate);
   
   Exception
      When Others Then
         DL_LOGS.SaveLogs(P_logMessage => 'Aborting DL_EMPLOYEES.DeleteEmployeeById, an error has occurred while procedure execution', P_logDbmessage => Sqlerrm, P_logDate => Sysdate);
         Raise_Application_Error(-20001,'An error has occurred while DeleteEmployeeById procedure execution. Check the logs.',True);
   End DeleteEmployeeById;


END DL_EMPLOYEES;
/
