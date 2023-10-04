unit Controllers.Global;

interface

uses Horse,
     DataModule.Global,
     System.JSON,
     System.SysUtils;

procedure RegistrarRotas;
procedure Login(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure CriarConta(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure EditarUsuario(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure EditarSenha(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure ListarTreinos(Req: THorseRequest; Res: THorseResponse; Next: TProc);

implementation

procedure RegistrarRotas;
begin
    THorse.Post('/usuarios/login', Login);
    THorse.Post('/usuarios/registro', CriarConta);
    THorse.Put('/usuarios/senha', EditarSenha);
    THorse.Put('/usuarios', EditarUsuario);
    THorse.Get('/treinos', ListarTreinos);
end;

procedure Login(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
    DmGlobal: TDmGlobal;
    email, senha: string;
    body, json_ret: TJSONObject;
begin
    try
        try
            //sleep(3000);

            DmGlobal := TDmGlobal.Create(nil);

            body := Req.Body<TJSONObject>;
            email := body.GetValue<string>('email', '');
            senha := body.GetValue<string>('senha', '');

            json_ret := DmGlobal.Login(email, senha);  // {"id_usuario: 1, "nome": "Heber", "email": "heber@99coders.com.br"}

            if json_ret.Size = 0 then
                Res.Send('E-mail ou senha inválida.').Status(401)
            else
                Res.Send<TJSONObject>(json_ret).Status(200);

        except on ex:exception do
            Res.Send(ex.Message).Status(500);
        end;

    finally
        FreeAndNil(DmGlobal);
    end;
end;

procedure CriarConta(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
    DmGlobal: TDmGlobal;
    nome, email, senha: string;
    body, json_ret: TJSONObject;
begin
    try
        try
            DmGlobal := TDmGlobal.Create(nil);

            body := Req.Body<TJSONObject>;
            nome := body.GetValue<string>('nome', '');
            email := body.GetValue<string>('email', '');
            senha := body.GetValue<string>('senha', '');

            json_ret := DmGlobal.CriarConta(nome, email, senha);  // {"id_usuario: 1, "nome": "Heber", "email": "heber@99coders.com.br"}

            Res.Send<TJSONObject>(json_ret).Status(201);

        except on ex:exception do
            Res.Send(ex.Message).Status(500);
        end;

    finally
        FreeAndNil(DmGlobal);
    end;
end;

procedure EditarUsuario(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
    DmGlobal: TDmGlobal;
    id_usuario: integer;
    nome, email: string;
    body, json_ret: TJSONObject;
begin
    try
        try
            DmGlobal := TDmGlobal.Create(nil);

            body := Req.Body<TJSONObject>;
            id_usuario := body.GetValue<integer>('id_usuario', 0);
            nome := body.GetValue<string>('nome', '');
            email := body.GetValue<string>('email', '');

            json_ret := DmGlobal.EditarUsuario(id_usuario, nome, email);  // {"id_usuario: 1}

            Res.Send<TJSONObject>(json_ret).Status(200);

        except on ex:exception do
            Res.Send(ex.Message).Status(500);
        end;

    finally
        FreeAndNil(DmGlobal);
    end;
end;

procedure EditarSenha(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
    DmGlobal: TDmGlobal;
    id_usuario: integer;
    senha: string;
    body, json_ret: TJSONObject;
begin
    try
        try
            DmGlobal := TDmGlobal.Create(nil);

            body := Req.Body<TJSONObject>;
            id_usuario := body.GetValue<integer>('id_usuario', 0);
            senha := body.GetValue<string>('senha', '');

            json_ret := DmGlobal.EditarSenha(id_usuario, senha);  // {"id_usuario: 1}

            Res.Send<TJSONObject>(json_ret).Status(200);

        except on ex:exception do
            Res.Send(ex.Message).Status(500);
        end;

    finally
        FreeAndNil(DmGlobal);
    end;
end;

procedure ListarTreinos(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
    DmGlobal: TDmGlobal;
    id_usuario: integer;
begin
    try
        try
            DmGlobal := TDmGlobal.Create(nil);

            // GET --> http://localhost:3000/treinos?id_usuario=1&dia_semana=2

            try
                id_usuario := Req.Query['id_usuario'].ToInteger;
            except
                id_usuario := 0;
            end;

            Res.Send<TJSONArray>(DmGlobal.ListarTreinos(id_usuario)).Status(200);

        except on ex:exception do
            Res.Send(ex.Message).Status(500);
        end;

    finally
        FreeAndNil(DmGlobal);
    end;
end;

end.
