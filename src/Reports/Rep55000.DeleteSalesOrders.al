report 55000 "HMX Delete Sales Orders"
{
    ApplicationArea = All;
    Caption = 'Delete Sales Orders Prior to Selected Date';
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = 'src/Reports/layouts/NotDeletedSalesOrders.rdl';
    dataset
    {
        dataitem(SalesHeader; "Sales Header")
        {
            RequestFilterFields = "No.";
            column(Sales_Order_No; SalesHeader."No.")
            {
            }
            column(Error_Text; ErrorText)
            {
            }
            trigger OnPreDataItem()
            begin
                SetRange("Document Type", "Document Type"::Order);
                SetFilter(SystemCreatedAt, '<%1', CreateDateTime(PriorDate, 000000T));
                DeletedCount := 0;
                Clear(ErrorText);
            end;

            trigger OnAfterGetRecord()
            begin
                if not DeleteSalesOrder(SalesHeader) then begin
                    ErrorText := GetLastErrorText();
                end else
                    DeletedCount += 1;
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
        if DeletedCount > 0 then
            Message('%1 Sales Order(s) deleted successfully.', DeletedCount);
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
