report 55001 "HMX Update Shopify Order No."
{
    ApplicationArea = All;
    Caption = 'Update Shopify Order No.';
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;

    dataset
    {
        dataitem(SalesHeader; "Sales Header")
        {

            trigger OnAfterGetRecord()
            begin
                "Shpfy Order No." := '0120';
                Modify();
            end;
        }
    }

}
