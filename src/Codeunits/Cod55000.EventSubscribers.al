codeunit 55000 "HMX Event Subscribers"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Reservation Management", OnBeforeDeleteDocumentReservation, '', false, false)]
    local procedure "Reservation Management_OnBeforeDeleteDocumentReservation"(TableID: Integer; DocType: Option; DocNo: Code[20]; var HideValidationDialog: Boolean)
    begin
        if HairmaxSingleInstance.GetHideDeleteSOReservationConfirm() then
            HideValidationDialog := true;
    end;

    var
        HairmaxSingleInstance: Codeunit "HMX HairMax Single Instance";
}