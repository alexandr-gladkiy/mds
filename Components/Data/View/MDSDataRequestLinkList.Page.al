namespace mds.mds;

page 50113 "MDS Data Request Link List"
{
    ApplicationArea = All;
    Caption = 'Source Request Links';
    PageType = List;
    SourceTable = "MDS Data Request Link";
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Source No."; Rec."Config No.")
                {
                    ToolTip = 'Specifies the value of the Source No. field.', Comment = '%';
                    Visible = false;
                }
                field("Link ID"; Rec."Link ID")
                {
                    ToolTip = 'Specifies the value of the Link ID field.', Comment = '%';
                }
                field(Url; Rec."Link Path")
                {
                    ToolTip = 'Specifies the value of the Url field.', Comment = '%';
                }
                field("Url As MD5"; Rec."Link Path As MD5")
                {
                    ToolTip = 'Specifies the value of the Url As MD5 field.', Comment = '%';
                    Visible = false;
                }
                field("Reference No."; Rec."Reference No.")
                {
                    ToolTip = 'Specifies the value of the Reference No. field.', Comment = '%';
                }
                field(GTIN; Rec.GTIN)
                {
                    ToolTip = 'Specifies the value of the GTIN field.', Comment = '%';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                }
                field("Processing Status"; Rec."Process Status")
                {
                    ToolTip = 'Specifies the value of the Processing Status field.', Comment = '%';
                }
            }
        }
    }
}
