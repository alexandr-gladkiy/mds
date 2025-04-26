namespace mds.mds;

page 50110 "MDS Data Request Attr. List"
{
    ApplicationArea = All;
    Caption = 'Data Attribute List';
    PageType = List;
    SourceTable = "MDS Data Request Attribute";
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Data Provider No"; Rec."Data Provider No.")
                {
                    ToolTip = 'Specifies the value of the Data Provider No. field.', Comment = '%';
                    Visible = false;
                }
                field("Data Request Config No"; Rec."Request Config No")
                {
                    ToolTip = 'Specifies the value of the Data Request Config No field.', Comment = '%';
                    Visible = false;
                }
                field("Data Request Config Name"; Rec."Data Request Config Name")
                {
                    ToolTip = 'Specifies the value of the Data Request Config Name field.', Comment = '%';
                    Visible = false;
                }
                field("Attribute Code"; Rec."Attribute Code")
                {
                    ToolTip = 'Specifies the value of the Attribute Code field.', Comment = '%';
                }
                field("Attribute Name"; Rec."Attribute Name")
                {
                    ToolTip = 'Specifies the value of the Attribute Name field.', Comment = '%';
                }
                field("Attribute Type"; Rec."Attribute Type")
                {
                    ToolTip = 'Specifies the value of the Attribute Type field.', Comment = '%';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                }
                field("Attribute Rules"; Rec."Attribute Rules")
                {
                    ToolTip = 'Specifies the value of the Attribute Rules field.', Comment = '%';
                }
            }
        }
    }
}
