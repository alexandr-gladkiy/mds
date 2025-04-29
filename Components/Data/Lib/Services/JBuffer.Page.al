namespace mds.mds;

using System.IO;

page 50114 JBuffer
{
    ApplicationArea = All;
    Caption = 'JBuffer';
    PageType = List;
    SourceTable = "JSON Buffer";
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the Entry No. field.', Comment = '%';
                }
                field(Depth; Rec.Depth)
                {
                    ToolTip = 'Specifies the value of the Depth field.', Comment = '%';
                }
                field("Token type"; Rec."Token type")
                {
                    ToolTip = 'Specifies the value of the Token type field.', Comment = '%';
                }
                field(Value; Rec."Value")
                {
                    ToolTip = 'Specifies the value of the Value field.', Comment = '%';
                }
                field("Value Type"; Rec."Value Type")
                {
                    ToolTip = 'Specifies the value of the Value Type field.', Comment = '%';
                }
                field(Path; Rec.Path)
                {
                    ToolTip = 'Specifies the value of the Path field.', Comment = '%';
                }
                field("Value BLOB"; Rec."Value BLOB")
                {
                    ToolTip = 'Specifies the value of the Value BLOB field.', Comment = '%';
                }
            }
        }
    }
}
