namespace mds.mds;

page 50107 "MDS Data Provider Card"
{
    ApplicationArea = All;
    Caption = 'Data Provider Card';
    PageType = Card;
    SourceTable = "MDS Data Provider";
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                group("General Left")
                {
                    field("No."; Rec."No.")
                    {
                        ToolTip = 'Specifies the value of the Code field.', Comment = '%';
                    }
                    field(Name; Rec.Name)
                    {
                        ToolTip = 'Specifies the value of the Name field.', Comment = '%';
                    }
                    field(Description; Rec.Description)
                    {
                        ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                    }
                }
                group("General Right")
                {
                    field("Type"; Rec."Type")
                    {
                        ToolTip = 'Specifies the value of the Type field.', Comment = '%';
                    }
                    field(Status; Rec.Status)
                    {
                        ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                    }
                }

            }
            group("Website fields")
            {
                ShowCaption = false;
                field("Web Base URL"; Rec."Web Base URL")
                {
                    ToolTip = 'Specifies the value of the Web Base URL field.', Comment = '%';
                }
                field("Web Sitemap Url"; Rec."Web Sitemap Url")
                {
                    ToolTip = 'Specifies the value of the Web Sitemap Url field.', Comment = '%';
                }
            }
        }
    }
}
