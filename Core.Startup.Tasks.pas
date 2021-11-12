unit Core.Startup.Tasks;

interface

type
  TTasks = class
  public const
    ERROR_Ok = $0000;
    ERROR_Autorun = $0001;
    ERROR_DelAutorun = $0002;
    ERROR_Mutex = $0003;
  public type
    TTaskType = (Autorun, DelAutorun);
    TTaskArray = array [TTaskType] of string;
  public const
    TaskNames: TTaskArray = ('-Autorun', '-DelAutorun');
  private
    class function AddAutorun(var CallExit: Boolean): Cardinal;
    class function DelAutorun(var CallExit: Boolean): Cardinal;
  public
    class function Perform(Task: string; var CallExit: Boolean): Cardinal;
  end;

implementation

uses
  Autorun.Manager;

{ TTasks }

class function TTasks.AddAutorun(var CallExit: Boolean): Cardinal;
begin
  if AutorunManager.Autorun then
    Result:= ERROR_Ok
  else
    Result:= ERROR_Autorun;
  CallExit:= True;
end;

class function TTasks.DelAutorun(var CallExit: Boolean): Cardinal;
begin
  if AutorunManager.DeleteAutorun then
    Result:= ERROR_Ok
  else
    Result:= ERROR_DelAutorun;
  CallExit:= True;
end;

class function TTasks.Perform(Task: string; var CallExit: Boolean): Cardinal;
begin
  Result:= ERROR_Ok;
  if Task = TaskNames[TTaskType.Autorun] then
    Exit(AddAutorun(CallExit));

  if Task = TaskNames[TTaskType.DelAutorun] then
    Exit(DelAutorun(CallExit));
end;

end.
