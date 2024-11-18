namespace mds.mds;

page 50113 "MDS Source Request Links"
{
    ApplicationArea = All;
    Caption = 'Source Request Links';
    PageType = List;
    SourceTable = "MDS Source Request Link";
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Source No."; Rec."Source No.")
                {
                    ToolTip = 'Specifies the value of the Source No. field.', Comment = '%';
                }
                field("Link ID"; Rec."Link ID")
                {
                    ToolTip = 'Specifies the value of the Link ID field.', Comment = '%';
                }
                field("Reference No."; Rec."Reference No.")
                {
                    ToolTip = 'Specifies the value of the Reference No. field.', Comment = '%';
                }
                field(Url; Rec.Url)
                {
                    ToolTip = 'Specifies the value of the Url field.', Comment = '%';
                }
                field("Url As MD5"; Rec."Url As MD5")
                {
                    ToolTip = 'Specifies the value of the Url As MD5 field.', Comment = '%';
                }
                field(GTIN; Rec.GTIN)
                {
                    ToolTip = 'Specifies the value of the GTIN field.', Comment = '%';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                }
                field("Processing Status"; Rec."Processing Status")
                {
                    ToolTip = 'Specifies the value of the Processing Status field.', Comment = '%';
                }
            }
        }
    }
}