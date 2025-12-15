codeunit 55001 "HMX HairMax Single Instance"
{
    SingleInstance = true;
    procedure SetHideDeleteSOReservationConfirm(SuppressVar: Boolean)
    begin
        HideDeleteSOReservationConfirm := SuppressVar;
    end;

    procedure GetHideDeleteSOReservationConfirm(): Boolean
    begin
        exit(HideDeleteSOReservationConfirm);
    end;

    Var
        HideDeleteSOReservationConfirm: Boolean;
}
