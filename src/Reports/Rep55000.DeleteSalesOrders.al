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
            end;

            trigger OnAfterGetRecord()
            var
                ErrText: Text;
            begin
                ClearLastError();
                if not DeleteSalesOrder(SalesHeader) then begin
                    ErrText := GetLastErrorText();
                    CurrReport.Skip();
                end;
                DeletedCount += 1;
            end;

            trigger OnPostDataItem()
            begin
                Message('%1 Sales Order(s) deleted successfully.', DeletedCount);
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
        PriorDate: Date;
        DeletedCount: Integer;
        HairmaxSingleInstance: Codeunit "HMX HairMax Single Instance";

    [TryFunction]
    local procedure DeleteSalesOrder(var SalesHeader: Record "Sales Header")
    begin
        SalesHeader.Delete(true);
    end;

}
