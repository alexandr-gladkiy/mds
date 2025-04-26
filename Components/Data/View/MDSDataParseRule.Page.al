namespace mds.mds;

page 50112 "MDS Data Parse Rule"
{
    ApplicationArea = All;
    Caption = 'Data Parse Rule';
    PageType = List;
    SourceTable = "MDS Data Parse Rule";
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Exec. Step"; Rec."Exec. Step")
                {
                    ToolTip = 'Specifies the value of the Exec. Step field.', Comment = '%';
                }
                field("Data Provider No."; Rec."Data Provider No.")
                {
                    ToolTip = 'Specifies the value of the Data Provider No. field.', Comment = '%';
                }
                field("Request Config No."; Rec."Request Config No.")
                {
                    ToolTip = 'Specifies the value of the Request Config No. field.', Comment = '%';
                }
                field("Attribute Code"; Rec."Attribute Code")
                {
                    ToolTip = 'Specifies the value of the Attribute Code field.', Comment = '%';
                }
                field("Action Type"; Rec."Action Type")
                {
                    ToolTip = 'Specifies the value of the Action Type field.', Comment = '%';
                }
                field("Node Value Path"; Rec."Node Value Path")
                {
                    ToolTip = 'Specifies the value of the Node Value Path field.', Comment = '%';
                }
                field("Node Value Name"; Rec."Node Value Name")
                {
                    ToolTip = 'Specifies the value of the Node Value Name field.', Comment = '%';
                }
                field("Node Value Filter"; Rec."Node Value Filter")
                {
                    ToolTip = 'Specifies the value of the Node Value Filter field.', Comment = '%';
                }
                field("Tag Filter"; Rec."Tag Filter")
                {
                    ToolTip = 'Specifies the value of the Tag Filter field.', Comment = '%';
                }
            }
        }
    }
}
