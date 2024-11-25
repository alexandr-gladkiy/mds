namespace mds.mds;

page 50108 "MDS Setup Card"
{
    ApplicationArea = All;
    Caption = 'Master Data Service Setup';
    PageType = Card;
    SourceTable = "MDS Setup";
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("No. Series Data Provider"; Rec."Data Provider Serial No.")
                {
                    ToolTip = 'Specifies the value of the No. Series Data Provider field.', Comment = '%';
                }
                field("No. Series Source"; Rec."Data Config Serial No.")
                {
                    ToolTip = 'Specifies the value of the No. Series Source field.', Comment = '%';
                }
            }
        }
    }
}
