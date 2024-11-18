namespace mds.mds;

page 50112 "MDS Source Request Params Part"
{
    ApplicationArea = All;
    Caption = 'Source Request Params Part';
    PageType = CardPart;
    SourceTable = "MDS Source Request Params";

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field(Method; Rec.Method)
                {
                    ToolTip = 'Specifies the value of the Method field.', Comment = '%';
                }
                field("Query String"; Rec."Query String")
                {
                    ToolTip = 'Specifies the value of the Query String field.', Comment = '%';
                }
                field("Next Page URL"; Rec."Next Page URL")
                {
                    ToolTip = 'Specifies the value of the Next Page URL field.', Comment = '%';
                }
                field("Last Query Datetime"; Rec."Last Query Datetime")
                {
                    ToolTip = 'Specifies the value of the Last Query Datetime field.', Comment = '%';
                }
            }
        }
    }
}
