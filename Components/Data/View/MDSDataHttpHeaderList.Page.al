namespace mds.mds;

page 50109 "MDS Data Http Header List"
{
    ApplicationArea = All;
    Caption = 'Source Http Header List';
    PageType = List;
    SourceTable = "MDS Data Http Header";
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Data Povider No."; Rec."Data Povider No.")
                {
                    ToolTip = 'Specifies the value of the Data Povider No. field.', Comment = '%';
                }
                field("Source No."; Rec."Source No.")
                {
                    ToolTip = 'Specifies the value of the Source No. field.', Comment = '%';
                }
                field("Http Header Code"; Rec."Http Header Code")
                {
                    ToolTip = 'Specifies the value of the Http Header Code field.', Comment = '%';
                }
            }
        }
    }
}
