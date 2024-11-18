namespace mds.mds;

page 50106 "MDS Data Request Config Card"
{
    ApplicationArea = All;
    Caption = 'Data Request Config Card';
    PageType = Card;
    SourceTable = "MDS Data Request Config";
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

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
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Call")
            {
                trigger OnAction()
                begin
                    sSource.Call(Rec);
                end;
            }
        }
    }

    var
        sSource: Codeunit "MDS Source Service";
}
