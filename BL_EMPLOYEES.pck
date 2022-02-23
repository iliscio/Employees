CREATE OR REPLACE PACKAGE BL_EMPLOYEES IS

   Procedure CreateNewEmployee(P_EmployeeRec Employees%Rowtype, P_ProcessResponse Out Pls_Integer, P_ResponseMessage Out Varchar2);

   Procedure UpdateEmployee(P_EmployeeRec Employees%Rowtype, P_ProcessResponse Out Pls_Integer, P_ResponseMessage Out Varchar2);

END BL_EMPLOYEES;
/
CREATE OR REPLACE PACKAGE BODY BL_EMPLOYEES IS

   Procedure CreateNewEmployee(P_EmployeeRec Employees%Rowtype, P_ProcessResponse Out Pls_Integer, P_ResponseMessage Out Varchar2) Is

      
      V_Employee Employees%Rowtype Default P_EmployeeRec;
 
      V_EmpCheck DL_EMployees.TEmployeeRec;

   Begin

      DL_LOGS.SaveLogs(P_logMessage => 'Starting procedure BL_EMPLOYEES.CreateNewEmployee',P_logDbmessage => Null,P_logDate => Sysdate);

      DL_PROCESS.StartProcess(process_seq.nextval, 'Starting process to create new employee (BL_EMPLOYEES.CreateNewEmployee)');
      
      DL_LOGS.SaveLogs(P_logMessage => 'Calling procedure DL_EMPLOYEES.GetEmployeeByNAme to check
                 if the employee already exists',P_logDbmessage => Null,P_logDate => Sysdate);
      
      V_EmpCheck := DL_EMPLOYEES.GetEmployeeByNAme(V_Employee.First_name, V_Employee.Last_name);
      
      If V_EmpCheck.EmpId Is Null Then
  
         DL_LOGS.SaveLogs(P_logMessage => 'Employee not found',P_logDbmessage => Null,P_logDate => Sysdate);

         DL_LOGS.SaveLogs(P_logMessage => 'Calling procedure DL_EMPLOYEES.SaveEmployee',P_logDbmessage => Null,P_logDate => Sysdate);

         DL_EMPLOYEES.SaveEmployee(V_Employee);

      Else
      
         DL_LOGS.SaveLogs(P_logMessage => 'Employee already exists', P_logDbmessage => Null, P_logDate => Sysdate);
      
         dbms_output.put_line('The Employee already exists in the database.');
      
      End If;
      
      DL_LOGS.SaveLogs(P_logMessage => 'Finishing procedure BL_EMPLOYEES.CreateNewEmployee', P_logDbmessage => Null,P_logDate => Sysdate);
      
      P_ProcessResponse := 1;

   Exception
      When Others Then
         P_ProcessResponse := 0;
         DL_LOGS.SaveLogs(P_logMessage   => 'Aborting BL_EMPLOYEES.CreateNewEmployee, an error has occurred while procedure execution',
                          P_logDbmessage => Sqlerrm,
                          P_logDate      => Sysdate);
         Raise_Application_Error(-20001,'An error has occurred while CreateNewEmployee procedure execution. Check the logs.',True);
   End CreateNewEmployee;

   Procedure UpdateEmployee(P_EmployeeRec Employees%Rowtype, P_ProcessResponse Out Pls_Integer, P_ResponseMessage Out Varchar2) Is
   
      V_Employee Employees%Rowtype Default P_EmployeeRec;
      
    Begin
   
      DL_LOGS.SaveLogs(P_logMessage => 'Starting procedure BL_EMPLOYEES.UpdateEmployee',P_logDbmessage => Null,P_logDate => Sysdate);

      DL_PROCESS.StartProcess(process_seq.nextval, 'Starting process to update an employee (BL_EMPLOYEES.UpdateEmployee)');

      DL_LOGS.SaveLogs(P_logMessage => 'Calling Procedure DL_EMPLOYEES.SaveEmployee',P_logDbmessage => Null,P_logDate => Sysdate);
      
      DL_EMPLOYEES.SaveEmployee(V_Employee);
   
      DL_LOGS.SaveLogs(P_logMessage => 'Finishing procedure BL_EMPLOYEES.UpdateEmployee', P_logDbmessage => Null,P_logDate => Sysdate);
      
      P_ProcessResponse := 1;
   Exception
      When Others Then
         P_ProcessResponse := 0;
         DL_LOGS.SaveLogs(P_logMessage   => 'Aborting BL_EMPLOYEES.UpdateEmployee, an error has occurred while procedure execution',
                          P_logDbmessage => Sqlerrm,
                          P_logDate      => Sysdate);
         Raise_Application_Error(-20001,'An error has occurred while UpdateEmployee procedure execution. Check the logs.',True);
   End UpdateEmployee;

   

END BL_EMPLOYEES;
/
