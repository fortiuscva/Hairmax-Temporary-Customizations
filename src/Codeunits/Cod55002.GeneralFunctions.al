codeunit 55002 "HMX General Functions"
{
    procedure PreventDuplicateShopifyOrderNo(SalesHeaderpar: Record "Sales Header")
    var
        SalesHeader: Record "Sales Header";
    begin
        if SalesHeaderpar."Shpfy Order No." = '' then
            exit;

        SalesHeader.SetFilter("No.", '<>%1', SalesHeaderpar."No.");
        SalesHeader.SetRange("Shpfy Order No.", SalesHeaderpar."Shpfy Order No.");
        if SalesHeader.FindFirst() then
            Error('Shopify Order No. %1 already exists in Order %2.', SalesHeaderpar."Shpfy Order No.", SalesHeader."No.");
    end;
}
