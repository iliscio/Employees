CREATE OR REPLACE Package DL_PROCESS
As

   SESSION_PROCESS_ID Pls_Integer Default Null;
   SESSION_PROCESS_DESC Varchar2(4000) Default Null;

   Procedure StartProcess(P_ProcessId Number, P_ProcessDescription Varchar2);

End DL_PROCESS;
/
Create or Replace Package Body DL_PROCESS
As

   Procedure StartProcess(P_ProcessId Number, P_ProcessDescription Varchar2) is
 
   Begin

      Insert Into PROCESS(PREVIOUS_PROCESS_ID,
                          PROCESS_ID,
                          PROCESS_DESCRIPTION,
                          START_DATE) Values (SESSION_PROCESS_ID, P_ProcessId, P_ProcessDescription, Sysdate);

      SESSION_PROCESS_ID   := P_ProcessId;
      SESSION_PROCESS_DESC := P_ProcessDescription;

      Commit;

   End StartProcess;


end DL_PROCESS;
/
