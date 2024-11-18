namespace mds.mds;

page 50106 "MDS Source Card"
{
    ApplicationArea = All;
    Caption = 'Source Card';
    PageType = Card;
    SourceTable = "MDS Source";
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
            part("Http Headers"; "MDS Source Http Header LPart")
            {
                Caption = 'Http Headers';
                SubPageLink = "Data Povider No." = field("Data Provider No."), "Source No." = field("No.");
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
                    sSource."Set.ByPK"(Rec."No.");
                    sSource.Call();
                end;
            }
        }
    }

    var
        sSource: Codeunit "MDS Source Service";
}
