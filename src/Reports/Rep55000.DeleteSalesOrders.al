report 55000 "HMX Delete Sales Orders"
{
    ApplicationArea = All;
    Caption = 'Delete Sales Orders Prior to Selected Date';
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;
    dataset
    {
        dataitem(SalesHeader; "Sales Header")
        {
            RequestFilterFields = "No.";
            trigger OnPreDataItem()
            begin
                SetRange("Document Type", "Document Type"::Order);
                SetFilter(SystemCreatedAt, '..%1', CreateDateTime(PriorDate, 000000T));
                DeletedCount := 0;
                Clear(ErrorText);
            end;

            trigger OnAfterGetRecord()

            begin
                if not DeleteSalesOrder(SalesHeader) then begin
                    ErrorText += SalesHeader."No." + ' - ' + GetLastErrorText();
                    CurrReport.Skip();
                end;
                DeletedCount += 1;
            end;

            trigger OnPostDataItem()
            begin
                if DeletedCount > 0 then
                    Message('%1 Sales Order(s) deleted successfully.', DeletedCount);
                if ErrorText <> '' then
                    Message('Sales Order(s) that are not deleted: %1', ErrorText);
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(PriorDate; PriorDate)
                    {
                        ApplicationArea = All;
                        Caption = 'Delete Orders Before Date';
                        ToolTip = 'All sales orders with Document Date before this date will be deleted.';
                    }
                }
            }
        }
    }
    trigger OnPreReport()
    begin
        HairmaxSingleInstance.SetHideDeleteSOReservationConfirm(true);
    end;

    trigger OnPostReport()
    begin
        HairmaxSingleInstance.SetHideDeleteSOReservationConfirm(false);
    end;

    var
        ErrorText: Text;
        PriorDate: Date;
        DeletedCount: Integer;
        HairmaxSingleInstance: Codeunit "HMX HairMax Single Instance";

    [TryFunction]
    local procedure DeleteSalesOrder(var SalesHeader: Record "Sales Header")
    begin
        SalesHeader.Delete(true);
    end;

}
