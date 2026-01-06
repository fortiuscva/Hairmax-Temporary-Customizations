report 55002 "Update GPPG On SalesShpmt Line"
{
    ApplicationArea = All;
    Caption = 'Update GPPG On Sales Shipment Line';
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;
    Permissions = tabledata "Sales Shipment Line" = rmid;

    dataset
    {
        dataitem(SalesShipmentLine; "Sales Shipment Line")
        {
            RequestFilterFields = "Document No.", "Line No.", Type, "No.";

            trigger OnPreDataItem()
            begin
                if SalesShipmentLine.Count > 1 then
                    Error(YoucanOnlyRunOneLineError);

                if SalesShipmentLine.GetFilters = '' then
                    error(ThereMustBeAtleastOneFilter);

                if NewGPPG = '' then
                    error(NewGPPGCannotbeempty);
            end;

            trigger OnAfterGetRecord()
            begin
                SalesShipmentLine."Gen. Prod. Posting Group" := NewGPPG;
                SalesShipmentLine.Modify(true);
                LinesChanged += 1;
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
                        Caption = 'New Gen. Prod. Posting Group';
                        ToolTip = 'Select the New Gen. Product Posting Group to set on the posted shipment line(s).';
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
        Message('Gen. Prod. Posting Group for %1 has been updated to "%2".', SalesShipmentLine."No.", NewGPPG);
    end;

    var
        NewGPPG: Code[20];
        DefVATProdPostingGrp: Code[20];
        LinesChanged: Integer;
        YoucanOnlyRunOneLineError: Label 'You can only process one line at a time';
        ThereMustBeAtleastOneFilter: Label 'There must be atleast one filter selected to update the lines';
        NewGPPGCannotbeempty: Label ' New Gen. Product Posting Group cannot be empty';
}

