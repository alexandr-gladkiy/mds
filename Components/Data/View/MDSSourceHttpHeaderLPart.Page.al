namespace mds.mds;

page 50110 "MDS Source Http Header LPart"
{
    ApplicationArea = All;
    Caption = 'Source Http Header LPart';
    PageType = ListPart;
    SourceTable = "MDS Source Http Header";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Http Header Code"; Rec."Http Header Code")
                {
                    ToolTip = 'Specifies the value of the Http Header Code field.', Comment = '%';
                }
            }
        }
    }
}
