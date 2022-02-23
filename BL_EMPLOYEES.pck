CREATE OR REPLACE PACKAGE BL_EMPLOYEES IS

   Procedure CreateNewEmployee(P_FirstName employees.first_name%Type, P_LastName employees.last_name%Type, P_Email employees.email%Type
                              ,P_PhoneNumber employees.Phone_Number%Type, P_HireDate employees.hire_date%Type, P_JobId employees.job_id%Type
                              ,P_Salary employees.Salary%Type, P_ComissionPct employees.commission_pct%Type, P_ManagerId employees.manager_id%Type
                              ,P_DepartmentId employees.Department_Id%Type
                              );

   Procedure UpdateEmployee(P_FirstName employees.first_name%Type, P_LastName employees.last_name%Type, P_Email employees.email%Type
                           ,P_PhoneNumber employees.Phone_Number%Type, P_HireDate employees.hire_date%Type, P_JobId employees.job_id%Type
                           ,P_Salary employees.Salary%Type, P_ComissionPct employees.commission_pct%Type, P_ManagerId employees.manager_id%Type
                           ,P_DepartmentId employees.Department_Id%Type
                           );

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

      DL_LOGS.SaveLogs(P_logMessage => 'Starting procedure BL_EMPLOYEES.CreateNewEmployee',P_logDbmessage => Null,P_logDate => Sysdate);

      DL_PROCESS.StartProcess(process_seq.nextval, 'Starting process to create new employee (BL_EMPLOYEES.CreateNewEmployee)');

      DL_LOGS.SaveLogs(P_logMessage => 'Building employee record',P_logDbmessage => Null,P_logDate => Sysdate);

      BuildEmployeeRecord;
      
      DL_LOGS.SaveLogs(P_logMessage => 'Checkin if the employee already exists',P_logDbmessage => Null,P_logDate => Sysdate);
      
      V_EmpCheck := DL_EMPLOYEES.GetEmployeeByNAme(V_Employee.First_name, V_Employee.Last_name);
      
      If V_EmpCheck.EmpId Is Null Then
  
         DL_LOGS.SaveLogs(P_logMessage => 'Employee not found',P_logDbmessage => Null,P_logDate => Sysdate);

         DL_LOGS.SaveLogs(P_logMessage => 'Saving employee',P_logDbmessage => Null,P_logDate => Sysdate);

         DL_EMPLOYEES.SaveEmployee(V_Employee);

      Else
      
         DL_LOGS.SaveLogs(P_logMessage => 'Employee already exists', P_logDbmessage => Null, P_logDate => Sysdate);
      
         dbms_output.put_line('The Employee already exists in the database.');
      
      End If;
      
      DL_LOGS.SaveLogs(P_logMessage => 'Finishing procedure BL_EMPLOYEES.CreateNewEmployee', P_logDbmessage => Null,P_logDate => Sysdate);
      

   Exception
      When Others Then
         DL_LOGS.SaveLogs(P_logMessage   => 'Aborting BL_EMPLOYEES.CreateNewEmployee, an error has occurred while procedure execution',
                          P_logDbmessage => Sqlerrm,
                          P_logDate      => Sysdate);
         Raise_Application_Error(-20001,'An error has occurred while CreateNewEmployee procedure execution. Check the logs.',True);
   End CreateNewEmployee;

   Procedure UpdateEmployee(P_FirstName employees.first_name%Type, P_LastName employees.last_name%Type, P_Email employees.email%Type
                           ,P_PhoneNumber employees.Phone_Number%Type, P_HireDate employees.hire_date%Type, P_JobId employees.job_id%Type
                           ,P_Salary employees.Salary%Type, P_ComissionPct employees.commission_pct%Type, P_ManagerId employees.manager_id%Type
                           ,P_DepartmentId employees.Department_Id%Type
                           ) Is
   
      V_Employee Employees%Rowtype;
      
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
   
      DL_LOGS.SaveLogs(P_logMessage => 'Starting procedure BL_EMPLOYEES.UpdateEmployee',P_logDbmessage => Null,P_logDate => Sysdate);

      DL_PROCESS.StartProcess(process_seq.nextval, 'Starting process to update an employee (BL_EMPLOYEES.UpdateEmployee)');

      DL_LOGS.SaveLogs(P_logMessage => 'Building employee record',P_logDbmessage => Null,P_logDate => Sysdate);

      BuildEmployeeRecord;
      
      DL_LOGS.SaveLogs(P_logMessage => 'Updating the employee(s)',P_logDbmessage => Null,P_logDate => Sysdate);
      
      DL_EMPLOYEES.SaveEmployee(V_Employee);
   
      DL_LOGS.SaveLogs(P_logMessage => 'Finishing procedure BL_EMPLOYEES.UpdateEmployee', P_logDbmessage => Null,P_logDate => Sysdate);
      

   Exception
      When Others Then
         DL_LOGS.SaveLogs(P_logMessage   => 'Aborting BL_EMPLOYEES.UpdateEmployee, an error has occurred while procedure execution',
                          P_logDbmessage => Sqlerrm,
                          P_logDate      => Sysdate);
         Raise_Application_Error(-20001,'An error has occurred while UpdateEmployee procedure execution. Check the logs.',True);
   End UpdateEmployee;

   

END BL_EMPLOYEES;
/
