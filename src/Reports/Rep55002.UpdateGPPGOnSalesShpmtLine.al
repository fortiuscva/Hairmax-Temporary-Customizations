report 55002 "Update GPPG On SalesShpmt Line"
{
    ApplicationArea = All;
    Caption = 'Update GPPG On Sales Shipment Line';
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;
    Permissions = tabledata "Sales Shipment Line" = rm,
                  tabledata "Gen. Product Posting Group" = r;
    dataset
    {
        dataitem(SalesShipmentLine; "Sales Shipment Line")
        {
            RequestFilterFields = "Document No.", Type, "No.";

            trigger OnAfterGetRecord()
            var
                GLAccountRec: Record "G/L Account";
            begin
                if SalesShipmentLine."Gen. Prod. Posting Group" = '' then begin
                    if SalesShipmentLine.Type = SalesShipmentLine.Type::"G/L Account" then begin
                        GLAccountRec.Get(SalesShipmentLine."No.");
                        if (GLAccountRec."Gen. Prod. Posting Group" <> '') or (GLAccountRec."Gen. Prod. Posting Group" = NewGPPG) then begin
                            SalesShipmentLine."Gen. Prod. Posting Group" := NewGPPG;
                            SalesShipmentLine.Modify(true);
                            LinesChanged += 1;
                        end;
                    end;
                end;
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Options)
                {
                    Caption = 'Options';

                    field(NewGPPG; NewGPPG)
                    {
                        ApplicationArea = All;
                        Caption = 'Gen. Prod. Posting Group';
                        ToolTip = 'Select the Gen. Product Posting Group to set on the posted shipment line(s).';
                        TableRelation = "Gen. Product Posting Group".Code;
                    }
                }

            }
        }
    }
    trigger OnPreReport()
    begin
        LinesChanged := 0;
    end;

    trigger OnPostReport()
    begin
        Message('%1 line(s) updated to Gen. Prod. Posting Group "%2".', LinesChanged, NewGPPG);
    end;

    var
        NewGPPG: Code[20];
        DefVATProdPostingGrp: Code[20];
        LinesChanged: Integer;
}

