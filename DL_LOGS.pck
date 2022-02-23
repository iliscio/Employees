CREATE OR REPLACE Package DL_LOGS Is

   Procedure SaveLogs(P_logMessage Varchar2, P_logDbmessage Varchar2, P_logDate Date);

End DL_LOGS;
/
CREATE OR REPLACE Package Body DL_LOGS Is

   Procedure SaveLogs(P_logMessage Varchar2, P_logDbmessage Varchar2, P_logDate Date) Is

   Begin

      Insert Into Logs(Log_Id,
                       Process_id,
                       Log_Message,
                       Log_Dbmessage,
                       Log_Date) Values (logs_seq.nextval, DL_PROCESS.SESSION_PROCESS_ID, P_logMessage, P_logDbmessage, P_logDate);

   End SaveLogs;

End DL_LOGS;
/
