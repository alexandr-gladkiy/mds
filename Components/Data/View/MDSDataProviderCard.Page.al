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
                    field(Type; Rec."Type")
                    {
                        ToolTip = 'Specifies the value of the Type field.', Comment = '%';
                    }
                    field(Status; Rec.Status)
                    {
                        ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                    }
                    field("Attribute Count"; Rec."Attribute Count")
                    {
                        ToolTip = 'Specifies the value of the Attribute Count field.', Comment = '%';
                    }
                }

            }
            group("Website fields")
            {
                ShowCaption = false;
                field("Web Base URL"; Rec."Base URL")
                {
                    ToolTip = 'Specifies the value of the Web Base URL field.', Comment = '%';
                }
                field("Web Sitemap Url"; Rec."Web Sitemap Url")
                {
                    ToolTip = 'Specifies the value of the Web Sitemap Url field.', Comment = '%';
                }
            }
            group(Authorization)
            {
                field("Authorization Type"; Rec."Authorization Type")
                {
                    ToolTip = 'Specifies the value of the Authorization Type field.', Comment = '%';
                }
                field(Login; Rec.Login)
                {
                    ToolTip = 'Specifies the value of the Login field.', Comment = '%';
                }
                field(Password; Rec.Password)
                {
                    ToolTip = 'Specifies the value of the Password field.', Comment = '%';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Test Connection")
            {
                trigger OnAction()
                begin
                    sDataProvider."Set.ByPK"(Rec."No.");
                    sDataProvider."Impl.TestConnect"(true);
                end;
            }
        }
    }

    var
        sDataProvider: Codeunit "MDS Data Provider Service";
}
