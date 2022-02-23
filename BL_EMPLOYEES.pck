CREATE OR REPLACE PACKAGE BL_EMPLOYEES IS


   

END BL_EMPLOYEES;
/
CREATE OR REPLACE PACKAGE BODY BL_EMPLOYEES IS



   Procedure CreateNewEmployee(P_FirstName employees.first_name%Type, P_LastName employees.last_name%Type, P_Email employees.email%Type
                              ,P_PhoneNumber employees.Phone_Number%Type, P_HireDate employees.hire_date%Type, P_JobId employees.job_id%Type
                              ,P_Salary employees.Salary%Type, P_ComissionPct employees.commission_pct%Type, P_ManagerId employees.manager_id%Type
                              ,P_DepartmentId employees.Department_Id%Type
                              ) Is

      
      V_Employee Employees%Rowtype;
 
      V_EmpCheck DL_EMployees.TEmployeeRec;

      Procedure BuildEmployeeRecord Is
      
      Begin
      
         V_Employee.First_Name      := P_FirstName;
         V_Employee.Last_Name       := P_LastName;
         V_Employee.Email           := P_Email;
         V_Employee.Phone_Number    := P_PhoneNumber;
         V_Employee.Hire_Date       := P_HireDate;
         V_Employee.Job_Id          := P_JobId;
         V_Employee.Salary          := P_Salary;
         V_Employee.Commission_Pct  := P_ComissionPct;
         V_Employee.Manager_id      := P_ManagerId;
         V_Employee.Department_id   := P_DepartmentId;
      
      End BuildEmployeeRecord;
           
   Begin

      BuildEmployeeRecord;
      
      V_EmpCheck := DL_EMPLOYEES.GetEmployeeByNAme(V_Employee.First_name, V_Employee.Last_name);
      
      If V_EmpCheck.EmpId Is Null Then
  
         DL_EMPLOYEES.SaveEmployee(V_Employee);

      Else
      
         dbms_output.put_line('The Employee already exists in the database.');
      
      End If;

   End CreateNewEmployee;

END BL_EMPLOYEES;
/
