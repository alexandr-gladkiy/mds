page 50100 "MDS Attribute List"
{
    ApplicationArea = All;
    Caption = 'MDS Attribute List';
    PageType = List;
    SourceTable = "MDS Attribute";
    UsageCategory = Lists;
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Group Code"; Rec."Group Code")
                {
                    ToolTip = 'Specifies the value of the Group Code field.', Comment = '%';
                }
                field("Parent Code"; Rec."Parent Code")
                {
                    ToolTip = 'Specifies the value of the Parent Code field.', Comment = '%';
                }
                field("Code"; Rec."Code")
                {
                    ToolTip = 'Specifies the value of the Code field.', Comment = '%';
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field.', Comment = '%';
                }
                field("Type"; Rec."Type")
                {
                    ToolTip = 'Specifies the value of the Type field.', Comment = '%';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                }
                field("Indent Level"; Rec."Indent Level")
                {
                    ToolTip = 'Specifies the value of the Indent Level field.', Comment = '%';
                    Visible = false;
                }
            }
        }
    }
}
