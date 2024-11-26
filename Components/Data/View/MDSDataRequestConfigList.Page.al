namespace mds.mds;

page 50105 "MDS Data Request Config List"
{
    ApplicationArea = All;
    Caption = 'Source List';
    PageType = List;
    SourceTable = "MDS Data Request Config";
    UsageCategory = Lists;
    DelayedInsert = true;
    CardPageId = "MDS Data Request Config Card";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.', Comment = '%';
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field.', Comment = '%';
                }
                field("Data Provider No."; Rec."Data Provider No.")
                {
                    ToolTip = 'Specifies the value of the Data Provider No. field.', Comment = '%';
                }
                field("Data Provider Name"; Rec."Data Provider Name")
                {
                    ToolTip = 'Specifies the value of the Data Provider Name field.', Comment = '%';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                }
            }
        }
    }
}
