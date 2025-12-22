codeunit 55000 "HMX Event Subscribers"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Reservation Management", OnBeforeDeleteDocumentReservation, '', false, false)]
    local procedure "Reservation Management_OnBeforeDeleteDocumentReservation"(TableID: Integer; DocType: Option; DocNo: Code[20]; var HideValidationDialog: Boolean)
    begin
        if HairmaxSingleInstance.GetHideDeleteSOReservationConfirm() then
            HideValidationDialog := true;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeModifyEvent', '', true, true)]
    local procedure SalesHeader_OnBeforeModify(var Rec: Record "Sales Header"; xRec: Record "Sales Header")
    begin
        GeneralFunctionsCU.PreventDuplicateShopifyOrderNo(Rec);
    end;


    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterValidateEvent', 'Shpfy Order No.', true, true)]
    local procedure SalesHeader_OnAfterValidate(var Rec: Record "Sales Header"; var xRec: Record "Sales Header"; CurrFieldNo: Integer)
    begin
        GeneralFunctionsCU.PreventDuplicateShopifyOrderNo(Rec);
    end;


    var
        HairmaxSingleInstance: Codeunit "HMX HairMax Single Instance";
        GeneralFunctionsCU: Codeunit "HMX General Functions";
}