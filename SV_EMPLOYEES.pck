CREATE OR REPLACE PACKAGE SV_EMPLOYEES IS


END SV_EMPLOYEES;
/
CREATE OR REPLACE PACKAGE BODY SV_EMPLOYEES IS


--    P_ResponseMessage will return "Success" whether it's true
-- Otherwise it will return the error message.
   Procedure WSCreateNewEmp(P_FirstName employees.first_name%Type, P_LastName employees.last_name%Type, P_Email employees.email%Type
                           ,P_PhoneNumber employees.Phone_Number%Type, P_HireDate employees.hire_date%Type, P_JobId employees.job_id%Type
                           ,P_Salary employees.Salary%Type, P_ComissionPct employees.commission_pct%Type, P_ManagerId employees.manager_id%Type
                           ,P_DepartmentId employees.Department_Id%Type, P_ResponseMessage Out Varchar2
                           ) Is

      V_Employee Employees%Rowtype;
      v_ResponseCode Pls_Integer;
      v_ResponseMessage Varchar2(8000);
      
      v_LocalResponseMsg Varchar2(8000);

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

      DL_LOGS.SaveLogs(P_logMessage => 'Starting procedure SV_EMPLOYEES.WSCreateNewEmp',P_logDbmessage => Null,P_logDate => Sysdate);

      DL_PROCESS.StartProcess(process_seq.nextval, 'Starting process to create an employee (SV_EMPLOYEES.WSCreateNewEmp)');

      DL_LOGS.SaveLogs(P_logMessage => 'Building employee record',P_logDbmessage => Null,P_logDate => Sysdate);

      BuildEmployeeRecord;
      
      DL_LOGS.SaveLogs(P_logMessage => 'Calling procedure BL_EMPLOYEES.CreateNewEmployee',P_logDbmessage => Null,P_logDate => Sysdate);
      
      BL_EMPLOYEES.CreateNewEmployee(V_Employee, v_ResponseCode, v_LocalResponseMsg);
      
      DL_LOGS.SaveLogs(P_logMessage => 'Checking answer of BL_EMPLOYEES.CreateNewEmployee',P_logDbmessage => Null,P_logDate => Sysdate);
      
      If v_ResponseCode = 0 Then
      
         DL_LOGS.SaveLogs(P_logMessage => 'The Employee could not be created',P_logDbmessage => Null,P_logDate => Sysdate);
         v_ResponseMessage := 'An error has occurred while trying to create the employee: '||v_LocalResponseMsg;
      
      Else

         DL_LOGS.SaveLogs(P_logMessage => 'Success in the Employee Creation',P_logDbmessage => Null,P_logDate => Sysdate);
         v_ResponseMessage := 'Success';

      End If;

      DL_LOGS.SaveLogs(P_logMessage => 'Finishing procedure SV_EMPLOYEES.WSCreateNewEmp',P_logDbmessage => Null,P_logDate => Sysdate);
      P_ResponseMessage := v_ResponseMessage;
   
   Exception
      When Others Then
         P_ResponseMessage := 'An unexpected error has occurred while the API execution.';
         DL_LOGS.SaveLogs(P_logMessage   => 'Aborting SV_EMPLOYEES.WSCreateNewEmp, an error has occurred while procedure execution',
                          P_logDbmessage => Sqlerrm,
                          P_logDate      => Sysdate);
         Raise_Application_Error(-20001,'An error has occurred while WSCreateNewEmp procedure execution. Check the logs.',True);
   End WSCreateNewEmp;


End SV_EMPLOYEES;
/
