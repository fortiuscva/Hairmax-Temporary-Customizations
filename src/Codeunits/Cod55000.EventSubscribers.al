codeunit 55000 "HMX Event Subscribers"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Reservation Management", OnBeforeDeleteDocumentReservation, '', false, false)]
    local procedure "Reservation Management_OnBeforeDeleteDocumentReservation"(TableID: Integer; DocType: Option; DocNo: Code[20]; var HideValidationDialog: Boolean)
    begin
        if HairmaxSingleInstance.GetHideDeleteSOReservationConfirm() then
            HideValidationDialog := true;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeValidateEvent', 'Shpfy Order No.', false, false)]
    local procedure PreventDuplicateShopifyOrderNo(var Rec: Record "Sales Header"; var xRec: Record "Sales Header"; CurrFieldNo: Integer)
    var
        SalesHeader: Record "Sales Header";
    begin
        if Rec."Shpfy Order No." = xRec."Shpfy Order No." then
            exit;

        if Rec."Shpfy Order No." = '' then
            exit;

        SalesHeader.Reset();
        SalesHeader.SetRange("Shpfy Order No.", Rec."Shpfy Order No.");

        if SalesHeader.FindFirst() then begin
            if SalesHeader."No." <> Rec."No." then
                Error(
                    'Shopify Order No. %1 already exists in Order %2.',
                    Rec."Shpfy Order No.",
                    SalesHeader."No."
                );
        end;
    end;

    var
        HairmaxSingleInstance: Codeunit "HMX HairMax Single Instance";
}